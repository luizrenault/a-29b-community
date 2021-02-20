dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."Systems/weapon_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")

startup_print("weapon: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local sms_search_sequence = {
    {1, 5, 2, 4, 3},
    {5, 2, 4, 3, 1},
    {4, 3, 1, 5, 2},
    {1, 5, 2, 4, 3},
    {3, 1, 5, 2, 4},
    {2, 4, 3, 1, 5}
}

local ir_missile_lock_param = get_param_handle("WS_IR_MISSILE_LOCK")
local ir_missile_az_param = get_param_handle("WS_IR_MISSILE_TARGET_AZIMUTH")
local ir_missile_el_param = get_param_handle("WS_IR_MISSILE_TARGET_ELEVATION")
local ir_missile_des_az_param = get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_AZIMUTH")
local ir_missile_des_el_param = get_param_handle("WS_IR_MISSILE_SEEKER_DESIRED_ELEVATION")

local gar8_elevation_adjust_deg=0    -- adjust seeker 3deg down (might need to remove this if missile pylon is adjusted 3deg down)
local min_gar8_snd_pitch=0.9   -- seek tone pitch adjustment when "bad lock"
local max_gar8_snd_pitch=1.1   -- seek tone pitch adjustment when "good lock"
local gar8_snd_pitch_delta=(max_gar8_snd_pitch-min_gar8_snd_pitch)

local station_count = 6
local wpn_sto_name = {}
local wpn_sto_count = {}
local wpn_sto_total_count = {}
local wpn_sto_type = {}
local wpn_guns_l = 250
local wpn_guns_r = 250

local WPN_AA_SIGHT = get_param_handle("WPN_AA_SIGHT")
local WPN_AA_QTY = get_param_handle("WPN_AA_QTY")
local WPN_AA_NAME = get_param_handle("WPN_AA_NAME")
local WPN_AA_INTRG_QTY = get_param_handle("WPN_AA_INTRG_QTY")
local WPN_AA_RR = get_param_handle("WPN_AA_RR")
local WPN_AA_RR_SRC = get_param_handle("WPN_AA_RR_SRC")
local WPN_AA_SLV_SRC = get_param_handle("WPN_AA_SLV_SRC")
local WPN_AA_COOL = get_param_handle("WPN_AA_COOL")
local WPN_AA_SCAN = get_param_handle("WPN_AA_SCAN")
local WPN_AA_LIMIT = get_param_handle("WPN_AA_LIMIT")

local WPN_AG_QTY = get_param_handle("WPN_AG_QTY")
local WPN_AG_NAME = get_param_handle("WPN_AG_NAME")


local wpn_aa_sel = 0
local wpn_aa_sight = WPN_AA_SIGHT_IDS.LCOS
local wpn_aa_qty = 0
local wpn_aa_name = ""
local wpn_aa_intgr_qty = 0
local wpn_aa_rr = 100
local wpn_aa_rr_src = WPN_AA_RR_SRC_IDS.MAN
local wpn_aa_slv_src = WPN_AA_SLV_SRC_IDS.BST
local wpn_aa_cool = WPN_AA_COOL_IDS.COOL
local wpn_aa_scan = WPN_AA_SCAN_IDS.SPOT
local wpn_aa_limit = 0
local wpn_aa_locked = false
local wpn_guns_on = false
local wpn_guns_rate = 60/1025
local wpn_guns_elapsed = 0
local wpn_release = false
local wpn_release_elapsed = -1

local wpn_ag_sel = 0
local wpn_ag_qty = 0
local wpn_ag_name = ""


local iCommandPlaneFire = 84
local iCommandPlaneFireOff = 85

local function update_storages()
    wpn_sto_total_count = {}
    for i = 0, station_count-1 do
        local station_info = dev:get_station_info(i)
        local wname = get_wpn_weapon_name(station_info["CLSID"])
        wpn_sto_name[i+1] = wname
        wpn_sto_count[i+1] = station_info["count"]
        if wname ~= nil then 
            wpn_sto_total_count[wname] = (wpn_sto_total_count[wname] or 0) + station_info["count"]
        end
        wpn_sto_type[i+1] = station_info.weapon.level3

        if station_info["count"] > 1 then
            wname = tostring(station_info["count"]) .. wname
        elseif station_info["count"] > 0 then
        else
            wname = ""
        end
        --------------- mixed with CMFD SMS
        local param = get_param_handle("SMS_POS_"..tostring(i+1).."_TEXT")
        param:set(wname)
        -----------------------------------
    end
    WPN_GUNS_L:set(wpn_guns_l)
    WPN_GUNS_R:set(wpn_guns_r)
end

local function update_aa_sel_next(byname)
    local name = ""
    if wpn_aa_sel ~= 0  then 
        local station = dev:get_station_info(wpn_aa_sel - 1)
        name = station["CLSID"]
    end
    local sequence = sms_search_sequence[wpn_aa_sel + 1]
    for k, pos in pairs(sequence) do
        station = dev:get_station_info(pos - 1)
        if station.weapon.level3 == wsType_AA_Missile and station["count"] > 0 then
            -- log.info("name=".. (get_wpn_weapon_name(name) or " ") .." sms_name=" .. (get_wpn_weapon_name(station["CLSID"]) or " ") .. " "..tostring(byname).." "..tostring(not byname))
            if (not byname) or name == station["CLSID"] then
                wpn_aa_sel = pos
                set_wpn_aa_sel(wpn_aa_sel)
                wpn_aa_name = get_wpn_weapon_name(station["CLSID"]) or "NONAME"
                wpn_aa_qty = wpn_sto_total_count[wpn_aa_name] or 0
                dev:select_station(wpn_aa_sel-1)
                aim9lock:stop()
                aim9seek:play_continue()
                wpn_aa_locked = false
                return 0
            end
        end
    end
    if wpn_aa_sel ~= 0 then 
        wpn_aa_sel = 0
        set_wpn_aa_sel(wpn_aa_sel)
        wpn_aa_name = ""
        wpn_aa_qty = -1
        dev:select_station(wpn_aa_sel-1)
        aim9lock:stop()
        aim9seek:stop()
    end
end

function check_sidewinder() 
    if wpn_aa_sel == 0 or (wpn_aa_sel ~= 0 and (wpn_sto_count[wpn_aa_sel] == 0 or wpn_sto_type[wpn_aa_sel] ~= wsType_AA_Missile)) then update_aa_sel_next(wpn_aa_sel ~= 0) end
end

function update_sidewinder()
    check_sidewinder()
    if not wpn_aa_locked then
        if ir_missile_lock_param:get() == 1 then
            -- acquired lock
            wpn_aa_locked = true
            aim9seek:stop()
            aim9lock:play_continue()
        end
    else
        if ir_missile_lock_param:get() == 0 then
            -- lost lock
            wpn_aa_locked = false
            aim9lock:stop()
            check_sidewinder() -- in case we lost lock due to having fired a missile
            if wpn_aa_sel > 0 then aim9seek:play_continue() end
            -- check_sidewinder(_master_arm) -- in case we lost lock due to having fired a missile
        else
            -- still locked
            local az=ir_missile_az_param:get()
            local el=ir_missile_el_param:get()
            az=math.deg(az)
            el=math.deg(el)-gar8_elevation_adjust_deg
            local ofs=math.sqrt(az*az+el*el)
            local snd_pitch
            local max_dist=1.0
            if ofs>max_dist then
                snd_pitch = min_gar8_snd_pitch
            else
                ofs=ofs/max_dist -- normalize
                snd_pitch = (1-ofs)*(gar8_snd_pitch_delta)+min_gar8_snd_pitch
            end
            aim9lock:update(snd_pitch, nil, nil)
        end
        -- print_message_to_user("lock az:"..tostring(ir_missile_az_param:get())..",el:"..tostring(ir_missile_el_param:get()))
    end
end

local master_mode = -1
local master_mode_last = -1

local function update_master_mode_changed()
    master_mode = get_avionics_master_mode()
    if master_mode == master_mode_last then return 0 end
    if get_avionics_master_mode_aa(master_mode_last) then
        aim9seek:stop()
        aim9lock:stop()
        wpn_aa_locked = false
    end
    if get_avionics_master_mode_aa(master_mode) then
        check_sidewinder()
        if wpn_aa_sel > 0 then
            aim9seek:play_continue()
        end
    end
    master_mode_last = master_mode
end

local function update_ag_sel_next(byname)
    local name = ""
    if wpn_ag_sel ~= 0  then 
        local station = dev:get_station_info(wpn_ag_sel - 1)
        name = station["CLSID"]
    end
    local sequence = sms_search_sequence[wpn_ag_sel + 1]
    for k, pos in pairs(sequence) do
        station = dev:get_station_info(pos - 1)
        if (station.weapon.level2 == wsType_Bomb or station.weapon.level2 == wsType_NURS)  and station["count"] > 0 then
            -- log.info("name=".. (get_wpn_weapon_name(name) or " ") .." sms_name=" .. (get_wpn_weapon_name(station["CLSID"]) or " ") .. " "..tostring(byname).." "..tostring(not byname))
            if (not byname) or name == station["CLSID"] then
                wpn_ag_sel = pos
                set_wpn_ag_sel(wpn_ag_sel)
                wpn_ag_name = get_wpn_weapon_name(station["CLSID"])
                wpn_ag_qty = wpn_sto_total_count[wpn_ag_name] or 0
                dev:select_station(wpn_ag_sel-1)
                return 0
            end
        end
    end
    if wpn_ag_sel ~= 0 then 
        wpn_ag_sel = 0
        set_wpn_ag_sel(wpn_ag_sel)
        wpn_ag_name = ""
        wpn_ag_qty = -1
        dev:select_station(wpn_ag_sel-1)
    end
end


local function update_ag()
    if wpn_ag_sel == 0 or (wpn_ag_sel ~= 0 and (wpn_sto_count[wpn_ag_sel] == 0 or (wpn_sto_type[wpn_ag_sel] == wsType_FuelTank or wpn_sto_type[wpn_ag_sel] == wsType_AA_Missile))) then update_ag_sel_next(wpn_ag_sel ~= 0) end
    if get_wpn_ag_ready() then 
        WPN_READY:set(1)
    else 
        WPN_READY:set(0)
    end
    WPN_AG_QTY:set(wpn_ag_qty)
    WPN_AG_NAME:set(wpn_ag_name)
end

local function update_aa()
    update_sidewinder()

    if get_wpn_aa_msl_ready() or get_wpn_guns_ready() then 
        WPN_READY:set(1)
    else 
        WPN_READY:set(0)
    end

    WPN_AA_SIGHT:set(wpn_aa_sight)
    WPN_AA_QTY:set(wpn_aa_qty)
    WPN_AA_NAME:set(wpn_aa_name)
    WPN_AA_INTRG_QTY:set(wpn_guns_l + wpn_guns_r)
    WPN_AA_RR:set(wpn_aa_rr)
    WPN_AA_RR_SRC:set(wpn_aa_rr_src)
    WPN_AA_SLV_SRC:set(wpn_aa_slv_src)
    WPN_AA_COOL:set(wpn_aa_cool)
    WPN_AA_SCAN:set(wpn_aa_scan)
    WPN_AA_LIMIT:set(wpn_aa_limit)
    WPN_AA_NAME:set(wpn_aa_name)
end

local wpn_ej_timeout = -3
local function update_ej()
    -- E-J
    if wpn_ej_timeout ~= -3 then
        wpn_ej_timeout = wpn_ej_timeout - update_time_step
        if wpn_ej_timeout <= 0 then 
            if wpn_ej_timeout <= -2.9 then
                wpn_ej_timeout = -3
                set_avionics_master_mode(get_avionics_master_mode_last())
                for i=1,5 do
                    set_wpn_sto_jet(i-1,0)
                end
            elseif wpn_ej_timeout <= -0.5 then
            elseif wpn_ej_timeout <= -0.4 then
                if get_wpn_sto_jet(4) == 1 then 
                    set_wpn_sto_jet(4,0)
                    dev:emergency_jettison(3)
                    dev:emergency_jettison_rack(3)
                end
            elseif wpn_ej_timeout <= -0.3 then
                if get_wpn_sto_jet(2) == 1 then 
                    set_wpn_sto_jet(2,0)
                    dev:emergency_jettison(1)
                    dev:emergency_jettison_rack(1)
                end
            elseif wpn_ej_timeout <= -0.2 then
                if get_wpn_sto_jet(3) == 1 then 
                    set_wpn_sto_jet(3,0)
                    dev:emergency_jettison(2)
                    dev:emergency_jettison_rack(2)
                end
            elseif wpn_ej_timeout <= -0.1 then
                if get_wpn_sto_jet(5) == 1 then 
                    set_wpn_sto_jet(5,0)
                    dev:emergency_jettison(4)
                    dev:emergency_jettison_rack(4)
                end
            elseif wpn_ej_timeout <= 0.0 then
                if get_wpn_sto_jet(1) == 1 then 
                    set_wpn_sto_jet(1,0)
                    dev:emergency_jettison(0)
                    dev:emergency_jettison_rack(0)
                end
            end
        end
    end
end    

local function update_sj()
    for i=1,5 do
        local wpn_sj_sel = get_param_handle("WPN_SJ_STO"..tostring(i).."_SEL")
        if wpn_sto_count[i] == 0 then wpn_sj_sel:set(0) end
    end
end

function update()
    update_storages()
    update_master_mode_changed()
    if get_avionics_master_mode_aa() then 
        update_aa()
    elseif get_avionics_master_mode_ag() then 
        update_ag()
    else
        WPN_READY:set(0)
    end
    
    if master_mode == AVIONICS_MASTER_MODE_ID.SJ then 
        update_sj()
    elseif master_mode == AVIONICS_MASTER_MODE_ID.EJ then 
        update_ej()
    end

    if wpn_guns_on then
        wpn_guns_elapsed = wpn_guns_elapsed + update_time_step
        if wpn_guns_elapsed > wpn_guns_rate then
            local guns_qty = math.floor (wpn_guns_elapsed/wpn_guns_rate)
            wpn_guns_elapsed = wpn_guns_elapsed - guns_qty * wpn_guns_rate
            if wpn_guns_l >= guns_qty then  wpn_guns_l = wpn_guns_l -  guns_qty end
            if wpn_guns_r >= guns_qty then  wpn_guns_r = wpn_guns_r -  guns_qty end
        end
        if not get_wpn_guns_ready() then 
            dispatch_action(nil,iCommandPlaneFireOff)
            wpn_guns_on = false
        end
    end
    if wpn_release_elapsed ~= -1 then
        wpn_release_elapsed = wpn_release_elapsed - update_time_step
        if wpn_release_elapsed <= 0 then
            wpn_release_elapsed = -1
            if not wpn_release then
                WPN_RELEASE:set(0)
            end
        end
    end
end

function post_initialize()
    startup_print("weapon: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end
    dev:performClickableAction(device_commands.Mass, 0, true)
    dev:performClickableAction(device_commands.LateArm, -1, true)

    sndhost = create_sound_host("COCKPIT_ARMS","HEADPHONES",0,0,0)
    aim9seek = sndhost:create_sound("Aircrafts/Cockpits/AIM9")
    aim9lock = sndhost:create_sound("Aircrafts/Cockpits/SidewinderLow")

    startup_print("weapon: postinit end")
end


dev:listen_command(device_commands.Mass)
dev:listen_command(device_commands.LateArm)
dev:listen_command(device_commands.Salvo)
dev:listen_command(device_commands.WPN_SELECT_STO)
dev:listen_command(Keys.WeaponRelease)
dev:listen_command(Keys.Trigger)
dev:listen_command(Keys.StickStep)

dev:listen_command(74)


local station = 0
function SetCommand(command,value)
    debug_message_to_user("weapon: command "..tostring(command).." = "..tostring(value))
    if command == device_commands.WPN_AA_STEP then
        update_aa_sel_next()
    elseif command == device_commands.WPN_SELECT_STO then
        dev:select_station(value-1)
    elseif command == device_commands.WPN_AA_SIGHT_STEP then 
        wpn_aa_sight = (wpn_aa_sight + 1) % 3
    elseif command == device_commands.WPN_AA_RR_SRC_STEP then 
        wpn_aa_rr_src = (wpn_aa_rr_src + 1) % 2
    elseif command == device_commands.WPN_AA_SLV_SRC_STEP then 
        wpn_aa_slv_src = (wpn_aa_slv_src + 1) % 2
    elseif command == device_commands.WPN_AA_COOL_STEP then 
        wpn_aa_cool = (wpn_aa_cool + 1) % 2
    elseif command == device_commands.WPN_AA_SCAN_STEP then 
        wpn_aa_scan = (wpn_aa_scan + 1) % 2
    elseif command == device_commands.WPN_AA_LIMIT_STEP then 
        wpn_aa_limit = (wpn_aa_limit + 1) % 2
    elseif command == device_commands.Mass then
        WPN_MASS:set(value)
    elseif command == device_commands.LateArm then
        WPN_LATEARM:set(value)
    elseif command == device_commands.Salvo then
        if value == 1 and not get_avionics_onground() then
            wpn_ej_timeout = 0.5;
            for i=1,5 do
                local param = get_param_handle("SMS_POS_"..tostring(i).."_SEL")
                local station = dev:get_station_info(i-1)
                if station.weapon.level3 ~= wsType_AA_Missile and station.count > 0 then
                    set_wpn_sto_jet(i,1)
                    param:set(1)
                else
                    set_wpn_sto_jet(i,0)
                    param:set(0)
                end
            end
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.EJ)
        elseif value == 0 then
            if wpn_ej_timeout > 0 then 
                wpn_ej_timeout = -0.5  -- abort E-J
            end
        end
    elseif command == Keys.WeaponRelease then
        if get_wpn_aa_msl_ready() and value == 1 then 
            dev:launch_station(wpn_aa_sel-1)
            WPN_RELEASE:set(1)
            wpn_release = true
            wpn_release_elapsed = 0.5
        end
        if get_wpn_ag_ready() and value == 1 then 
            dev:launch_station(wpn_ag_sel-1)
            update_ag_sel_next(true)
            WPN_RELEASE:set(1)
            wpn_release = true
            wpn_release_elapsed = 0.5
        end
        if value == 0 and wpn_release  then
            if wpn_release_elapsed == -1 then WPN_RELEASE:set(0) end
            wpn_release = false
        end
        if master_mode == AVIONICS_MASTER_MODE_ID.SJ and get_wpn_mass() == WPN_MASS_IDS.LIVE and get_wpn_latearm() == WPN_LATEARM_IDS.ON and not get_avionics_onground() and value == 1 then
            local wpn_sj_sel = {}
            for i=1,5 do
                wpn_sj_sel[i] = get_param_handle("WPN_SJ_STO"..tostring(i).."_SEL"):get() == 1
            end
            if wpn_sj_sel[1] or wpn_sj_sel[5] then
                if wpn_sj_sel[1] then dev:emergency_jettison(0) end
                if wpn_sj_sel[5] then dev:emergency_jettison(4) end
            elseif wpn_sj_sel[2] or wpn_sj_sel[4] then
                if wpn_sj_sel[2] then dev:emergency_jettison(1) end
                if wpn_sj_sel[4] then dev:emergency_jettison(3) end
            elseif wpn_sj_sel[3] then
                dev:emergency_jettison(2)
            end
        end

    elseif command == Keys.Trigger then
        if value == 2 and get_wpn_guns_ready() then 
            dispatch_action(nil,iCommandPlaneFire)
            wpn_guns_on = true
        elseif value == 0 then
            dispatch_action(nil,iCommandPlaneFireOff)
            wpn_guns_on = false
        end
    elseif command == Keys.StickStep then
        if get_avionics_master_mode_aa() and value == 1 then 
            update_aa_sel_next()
        end

        if get_avionics_master_mode_ag() and value == 1 then 
            update_ag_sel_next()
        end








    elseif command==74 then

    elseif command == 136 then
        dev:drop_flare()
    elseif command == 79 then
        dev:drop_chaff()
    end
end


startup_print("weapon: load end")
need_to_be_closed = false -- close lua state after initialization


-- WS_GUN_PIPER_SPAN:0.015000
-- WS_DLZ_MAX:-1.000000
-- WS_IR_MISSILE_TARGET_ELEVATION:0.000000
-- WS_IR_MISSILE_SEEKER_DESIRED_ELEVATION:0.00000
-- WS_IR_MISSILE_LOCK:0.000000
-- WS_IR_MISSILE_TARGET_AZIMUTH:0.000000
-- WS_IR_MISSILE_SEEKER_DESIRED_AZIMUTH:0.000000
-- WS_GUN_PIPER_AVAILABLE:0.000000
-- WS_GUN_PIPER_AZIMUTH:0.000000
-- WS_GUN_PIPER_ELEVATION:0.000000
-- WS_TARGET_RANGE:1000.000000
-- WS_TARGET_SPAN:15.000000
-- WS_ROCKET_PIPER_AVAILABLE:0.000000
-- WS_ROCKET_PIPER_AZIMUTH:0.000000
-- WS_ROCKET_PIPER_ELEVATION:0.000000
-- WS_DLZ_MIN:-1.000000

-- wpn = {}
-- wpn["__index"] = {}
-- wpn["__index"]["get_station_info"] = function: 0000023264DB7B50
-- wpn["__index"]["listen_event"] = function: 0000023264DB6C80
-- wpn["__index"]["drop_flare"] = function: 0000023264DB7BE0
-- wpn["__index"]["set_ECM_status"] = function: 0000023264DB7CA0
-- wpn["__index"]["performClickableAction"] = function: 0000023264DB6F80
-- wpn["__index"]["get_ECM_status"] = function: 0000023264DB77F0
-- wpn["__index"]["launch_station"] = function: 0000023264DB6D40
-- wpn["__index"]["SetCommand"] = function: 0000023264DB71F0
-- wpn["__index"]["get_chaff_count"] = function: 0000023264DB7DF0
-- wpn["__index"]["emergency_jettison"] = function: 0000023264DB7970
-- wpn["__index"]["set_target_range"] = function: 0000023264DB7370
-- wpn["__index"]["set_target_span"] = function: 0000023264DB7220
-- wpn["__index"]["get_flare_count"] = function: 0000023264DB7EE0
-- wpn["__index"]["get_target_range"] = function: 0000023264DB7400
-- wpn["__index"]["get_target_span"] = function: 0000023264DB7340
-- wpn["__index"]["SetDamage"] = function: 0000023264DB6CE0
-- wpn["__index"]["drop_chaff"] = function: 0000023264DB7AF0
-- wpn["__index"]["select_station"] = function: 0000023264DB7250
-- wpn["__index"]["listen_command"] = function: 0000023264DB6C20
-- wpn["__index"]["emergency_jettison_rack"] = function: 0000023264DB78E0

-- wpn0 = {}
-- wpn0["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}"
-- wpn0["container"] = false
-- wpn0["count"] = 1
-- wpn0["weapon"] = {}
-- wpn0["weapon"]["level3"] = 7
-- wpn0["weapon"]["level1"] = 4
-- wpn0["weapon"]["level4"] = 22
-- wpn0["weapon"]["level2"] = 4
-- wpn1 = {}
-- wpn1["CLSID"] = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}"
-- wpn1["container"] = false
-- wpn1["count"] = 1
-- wpn1["weapon"] = {}
-- wpn1["weapon"]["level3"] = 36
-- wpn1["weapon"]["level1"] = 4
-- wpn1["weapon"]["level4"] = 38
-- wpn1["weapon"]["level2"] = 5
-- wpn2 = {}
-- wpn2["CLSID"] = "{A-29B TANK}"
-- wpn2["container"] = false
-- wpn2["count"] = 1
-- wpn2["weapon"] = {}
-- wpn2["weapon"]["level3"] = 43
-- wpn2["weapon"]["level1"] = 1
-- wpn2["weapon"]["level4"] = 680
-- wpn2["weapon"]["level2"] = 3
-- wpn3 = {}
-- wpn3["CLSID"] = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}"
-- wpn3["container"] = false
-- wpn3["count"] = 1
-- wpn3["weapon"] = {}
-- wpn3["weapon"]["level3"] = 36
-- wpn3["weapon"]["level1"] = 4
-- wpn3["weapon"]["level4"] = 38
-- wpn3["weapon"]["level2"] = 5
-- wpn4 = {}
-- wpn4["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}"
-- wpn4["container"] = false
-- wpn4["count"] = 1
-- wpn4["weapon"] = {}
-- wpn4["weapon"]["level3"] = 7
-- wpn4["weapon"]["level1"] = 4
-- wpn4["weapon"]["level4"] = 22
-- wpn4["weapon"]["level2"] = 4
-- wpn5 = {}
-- wpn5["CLSID"] = "{SMOKE-WHITE-A29B}"
-- wpn5["container"] = false
-- wpn5["count"] = 1
-- wpn5["weapon"] = {}
-- wpn5["weapon"]["level3"] = 50
-- wpn5["weapon"]["level1"] = 4
-- wpn5["weapon"]["level4"] = 681
-- wpn5["weapon"]["level2"] = 15

