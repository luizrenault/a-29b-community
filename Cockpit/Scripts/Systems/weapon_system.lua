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
local wpn_sto_container = {}
local wpn_sto_total_count = {}
local wpn_sto_type = {}
local wpn_guns_l = 250
local wpn_guns_r = 250

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
local WS_TARGET_RANGE = get_param_handle("WS_TARGET_RANGE")

local CMFD_NAV_FYT_OAP_ELV = get_param_handle("CMFD_NAV_FYT_OAP_ELV")

local wpn_aa_sel = 0
local wpn_aa_sight = WPN_AA_SIGHT_IDS.LCOS
local wpn_aa_qty = 0
local wpn_aa_name = ""
local wpn_aa_rr = 100
local wpn_aa_rr_src = WPN_AA_RR_SRC_IDS.MAN
local wpn_aa_slv_src = WPN_AA_SLV_SRC_IDS.BST
local wpn_aa_cool = WPN_AA_COOL_IDS.COOL
local wpn_aa_scan = WPN_AA_SCAN_IDS.SPOT
local wpn_aa_limit = 0
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

WPN_MSL_CAGED:set(2)

function wpn_get_weapon_type(station)

end

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
        
        if station_info.weapon.level2 == wsType_NURS then 
            wpn_sto_type[i+1] = WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_ROCKET
        elseif station_info.weapon.level2 == wsType_Bomb then
            wpn_sto_type[i+1] = WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB
        elseif station_info.weapon.level3 == wsType_AA_Missile then
            wpn_sto_type[i+1] = WPN_WEAPON_TYPE_IDS.AA_IR_MISSILE
        elseif station_info.weapon.level2 == wsType_GContainer then
            wpn_sto_type[i+1] = WPN_WEAPON_TYPE_IDS.NO_WEAPON
        else
            -- print_message_to_user("Damn! " .. station_info.weapon.level2 .. ", " ..station_info.weapon.level3 )
            wpn_sto_type[i+1] = WPN_WEAPON_TYPE_IDS.NO_WEAPON
        end

        wpn_sto_container[i+1] = station_info.container
        if station_info["count"] > 1  or station_info.container then
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

local function update_ag_sel_next(byname)
    local master_mode = get_avionics_master_mode()
    local name = ""
    if wpn_ag_sel ~= 0  then 
        local station = dev:get_station_info(wpn_ag_sel - 1)
        name = station["CLSID"]
    end
    local sequence = sms_search_sequence[wpn_ag_sel + 1]
    for k, pos in pairs(sequence) do
        local station = dev:get_station_info(pos - 1)
        if (station.weapon.level2 == wsType_Bomb or station.weapon.level2 == wsType_NURS or station.weapon.level3 == wsType_AS_Missile)  and (station["count"] > 0) then
            -- log.info("name=".. (get_wpn_weapon_name(name) or " ") .." sms_name=" .. (get_wpn_weapon_name(station["CLSID"]) or " ") .. " "..tostring(byname).." "..tostring(not byname))
            if (not byname) or name == station["CLSID"] or (byname and name == "" and wpn_ag_name ~= "" and wpn_ag_name == get_wpn_weapon_name(station["CLSID"])) then
                wpn_ag_sel = pos
                set_wpn_ag_sel(wpn_ag_sel)
                wpn_ag_name = get_wpn_weapon_name(station["CLSID"])
                wpn_ag_qty = wpn_sto_total_count[wpn_ag_name] or 0
                dev:select_station(wpn_ag_sel-1)
                WPN_SELECTED_WEAPON_TYPE:set(wpn_sto_type[wpn_ag_sel])
                if  wpn_sto_type[wpn_ag_sel] == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_ROCKET and (master_mode == AVIONICS_MASTER_MODE_ID.DTOS or master_mode == AVIONICS_MASTER_MODE_ID.DTOS_R or master_mode == AVIONICS_MASTER_MODE_ID.CCRP) then
                    if master_mode == AVIONICS_MASTER_MODE_ID.DTOS_R then 
                        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP_R)
                    else
                        set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP)
                    end
                end
                return 0
            end
        elseif (station.weapon.level2 == wsType_Bomb or station.weapon.level2 == wsType_NURS or station.weapon.level3 == wsType_AS_Missile)  and (byname and station["count"] == 0) then
            wpn_ag_sel = 0
            set_wpn_ag_sel(wpn_ag_sel)
            wpn_ag_qty = 0
            dev:select_station(wpn_ag_sel-1)
            WPN_SELECTED_WEAPON_TYPE:set(WPN_WEAPON_TYPE_IDS.NO_WEAPON)
            return 0
        end
    end
    if wpn_ag_sel ~= 0 then 
        wpn_ag_sel = 0
        set_wpn_ag_sel(wpn_ag_sel)
        wpn_ag_name = ""
        wpn_ag_qty = -1
        WPN_SELECTED_WEAPON_TYPE:set(WPN_WEAPON_TYPE_IDS.NO_WEAPON)
        dev:select_station(wpn_ag_sel-1)
    end
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
    end
end


local WPN_SIDEWINDER_STATUS_IDS = {
    STOPPED = 0,
    SEEKING = 1,
    LOCKED = 2,
}
local sidewinder_status = WPN_SIDEWINDER_STATUS_IDS.STOPPED

function check_sidewinder() 
    if wpn_aa_sel == 0 or (wpn_aa_sel ~= 0 and (wpn_sto_count[wpn_aa_sel] == 0 or wpn_sto_type[wpn_aa_sel] ~= WPN_WEAPON_TYPE_IDS.AA_IR_MISSILE)) then update_aa_sel_next(wpn_aa_sel ~= 0) end
    if (get_wpn_aa_msl_ready() or get_wpn_aa_msl_sim_ready()) and sidewinder_status == WPN_SIDEWINDER_STATUS_IDS.STOPPED then 
        sidewinder_status = WPN_SIDEWINDER_STATUS_IDS.SEEKING
        aim9lock:stop()
        aim9seek:play_continue()
    elseif not (get_wpn_aa_msl_ready() or get_wpn_aa_msl_sim_ready()) and sidewinder_status ~= WPN_SIDEWINDER_STATUS_IDS.STOPPED then
        sidewinder_status = WPN_SIDEWINDER_STATUS_IDS.STOPPED
        aim9lock:stop()
        aim9seek:stop()
    elseif (get_wpn_aa_msl_ready() or get_wpn_aa_msl_sim_ready()) and sidewinder_status == WPN_SIDEWINDER_STATUS_IDS.SEEKING then
        if ir_missile_lock_param:get() == 1 then
            -- acquired lock
            sidewinder_status = WPN_SIDEWINDER_STATUS_IDS.LOCKED
            aim9seek:stop()
            aim9lock:play_continue()
        end
    elseif (get_wpn_aa_msl_ready() or get_wpn_aa_msl_sim_ready()) and sidewinder_status == WPN_SIDEWINDER_STATUS_IDS.LOCKED then
        if ir_missile_lock_param:get() == 0 then
            -- lost lock
            sidewinder_status = WPN_SIDEWINDER_STATUS_IDS.STOPPED
            aim9lock:stop()
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
    end
end

local master_mode = -1
local master_mode_last = -1

local function update_master_mode_changed()
    master_mode = get_avionics_master_mode()
    if master_mode == master_mode_last then return 0 end
    if get_avionics_master_mode_aa(master_mode_last) then
        check_sidewinder()
    end
    if get_avionics_master_mode_aa(master_mode) then
        check_sidewinder()
    end
    master_mode_last = master_mode
end




local Ralt_last = 1600
local Balt_last = 1600
local function  update_ccip()
    local master_mode = get_avionics_master_mode()
    if ((master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R) and wpn_ag_sel > 0 and wpn_sto_count[wpn_ag_sel]>0) or (master_mode == AVIONICS_MASTER_MODE_ID.GUN or master_mode == AVIONICS_MASTER_MODE_ID.GUN_R)  then
        local t, Vx0, Vy0, Vz0, g, h0
        local pitch = sensor_data.getPitch()
        g = -9.82 -- m/s2
        local Ralt = sensor_data.getRadarAltitude()
        local Balt = sensor_data.getBarometricAltitude()
        if Ralt < 1600 then 
            Ralt_last = Ralt
            Balt_last = Balt
        else
        end
        h0 = (Ralt_last + Balt - Balt_last) * math.cos(math.abs(pitch)) * math.cos(math.abs(sensor_data.getRoll()))
        if master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.GUN then
            h0 = CMFD_NAV_FYT_OAP_ELV:get() / 3.28084
        end
        Vx0, Vy0, Vz0 = sensor_data.getSelfVelocity()

        if master_mode == AVIONICS_MASTER_MODE_ID.GUN or master_mode == AVIONICS_MASTER_MODE_ID.GUN_R then
            local vel_temp = math.sqrt(Vx0 * Vx0 + Vy0 * Vy0 + Vz0 * Vz0)
            Vx0 = Vx0 + 890 * Vx0 / vel_temp
            Vy0 = Vy0 + 890 * Vy0 / vel_temp
            Vz0 = Vz0 + 890 * Vz0 / vel_temp
        elseif wpn_sto_type[wpn_ag_sel] == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then
        elseif wpn_sto_type[wpn_ag_sel] == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_ROCKET then
            g=-0.1
        end
        local delta = Vy0 * Vy0 - 2 * g * h0
        t = (-Vy0  - math.sqrt(delta))/g

        local Vx = math.sqrt(Vx0*Vx0 + Vz0 * Vz0)
        local Sx = Vx * t

        local angle = math.atan(h0/Sx) + pitch

        WPN_CCIP_PIPER_AVAILABLE:set(1)
        local roll = sensor_data.getRoll()

        WPN_CCIP_PIPER_AZIMUTH:set(angle * math.sin(roll))
        WPN_CCIP_PIPER_ELEVATION:set(-angle * math.cos(roll))
        return h0, Vy0, Vx, Sx, angle
    else 
        WPN_CCIP_PIPER_AVAILABLE:set(0)
        WPN_CCIP_PIPER_AZIMUTH:set(0)
        WPN_CCIP_PIPER_ELEVATION:set(0)
    end
    return 0, 0, 0, 0, 0
end

local function update_ag()
    if wpn_ag_sel == 0 or (wpn_ag_sel ~= 0 and ((wpn_sto_count[wpn_ag_sel] <=0 or wpn_sto_type[wpn_ag_sel] < WPN_WEAPON_TYPE_IDS.AG_WEAPON_BEG or wpn_sto_type[wpn_ag_sel] > WPN_WEAPON_TYPE_IDS.AG_WEAPON_END))) then 
        update_ag_sel_next(true)
    end

    if get_wpn_ag_ready() or get_wpn_guns_ready() then  WPN_READY:set(1) else  WPN_READY:set(0) end
    if get_wpn_ag_sim_ready() or get_wpn_guns_sim_ready() then WPN_SIM_READY:set(1) else WPN_SIM_READY:set(0) end
    if WPN_LAUNCH_OP:get() == WPN_LAUNCH_OP_IDS.SALVO and wpn_ag_sel > 0 and wpn_sto_type[wpn_ag_sel] == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then WPN_LAUNCH_OP:set(0) end

    if wpn_ag_sel > 0 then 
        WPN_SELECTED_WEAPON_TYPE:set(wpn_sto_type[wpn_ag_sel])
    else
        WPN_SELECTED_WEAPON_TYPE:set(WPN_WEAPON_TYPE_IDS.NO_WEAPON)
    end


    update_ccip()

    WPN_AG_QTY:set(wpn_ag_qty)
    WPN_AG_NAME:set(wpn_ag_name)
    WPN_AA_INTRG_QTY:set(wpn_guns_l + wpn_guns_r)
end

local function update_aa()
    check_sidewinder()

    if get_wpn_aa_msl_ready() or get_wpn_guns_ready() then WPN_READY:set(1) else WPN_READY:set(0) end
    if get_wpn_aa_msl_sim_ready() or get_wpn_guns_sim_ready() then WPN_SIM_READY:set(1) else WPN_SIM_READY:set(0) end



    if get_avionics_master_mode() == AVIONICS_MASTER_MODE_ID.DGFT_B then
        local range = WS_TARGET_RANGE:get()
        if range ~= 300 and range ~= 400 and range ~= 500 then
            dev:set_target_range(500)
        end
    end

    if get_avionics_master_mode_aa() and get_wpn_aa_sel() > 0 and (get_wpn_mass() == WPN_MASS_IDS.LIVE or get_wpn_mass() == WPN_MASS_IDS.SIM) and not get_avionics_onground() then
        if WS_IR_MISSILE_LOCK:get() == 1 then
            WPN_MSL_CAGED:set(0)
        else 
            WPN_MSL_CAGED:set(1)
        end
    else
        WPN_MSL_CAGED:set(-1)
    end

    if wpn_aa_sel > 0 then 
        WPN_SELECTED_WEAPON_TYPE:set(wpn_sto_type[wpn_aa_sel])
    else
        WPN_SELECTED_WEAPON_TYPE:set(WPN_WEAPON_TYPE_IDS.NO_WEAPON)
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
        if wpn_sto_count[i] == 0 and not wpn_sto_container[i] then wpn_sj_sel:set(0) end
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
        WPN_SELECTED_WEAPON_TYPE:set(WPN_WEAPON_TYPE_IDS.NO_WEAPON)
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
    update_storages()
    update_ag_sel_next(false)


    startup_print("weapon: postinit end")
end


dev:listen_command(device_commands.Mass)
dev:listen_command(device_commands.LateArm)
dev:listen_command(device_commands.Salvo)
dev:listen_command(device_commands.WPN_SELECT_STO)
dev:listen_command(device_commands.WPN_AG_LAUNCH_OP_STEP)
dev:listen_command(Keys.WeaponRelease)
dev:listen_command(Keys.Trigger)
dev:listen_command(Keys.StickStep)
dev:listen_command(Keys.GunSelDist)
dev:listen_command(Keys.GunRearm)
dev:listen_command(Keys.Cage)
dev:listen_command(Keys.TDCX)
dev:listen_command(Keys.TDCY)

dev:listen_command(74)


function SetCommand(command,value)
    debug_message_to_user("weapon: command "..tostring(command).." = "..tostring(value))
    if command == device_commands.WPN_AA_STEP then
        update_aa_sel_next()
    elseif command == device_commands.WPN_AG_STEP then
        update_storages()
        update_ag_sel_next()
    elseif command == device_commands.WPN_AG_LAUNCH_OP_STEP then
        WPN_LAUNCH_OP:set((WPN_LAUNCH_OP:get() + 1)% 3)
    elseif command == device_commands.WPN_SELECT_STO then
        dev:select_station(value-1)
    elseif command == device_commands.WPN_AA_SIGHT_STEP then 
        wpn_aa_sight = (wpn_aa_sight + 1) % 3
    elseif command == device_commands.WPN_AA_RR_SRC_STEP then 
        wpn_aa_rr_src = (wpn_aa_rr_src + 1) % 2
    elseif command == device_commands.WPN_AA_SLV_SRC_STEP then 
        local master_mode = get_avionics_master_mode()
        wpn_aa_slv_src = (wpn_aa_slv_src + 1) % 2
        if wpn_aa_slv_src == WPN_AA_SLV_SRC_IDS.BST then
            if master_mode == AVIONICS_MASTER_MODE_ID.DGFT_L then
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DGFT_B)
            elseif master_mode == AVIONICS_MASTER_MODE_ID.INT_L then 
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.INT_B)
            end
        elseif wpn_aa_slv_src == WPN_AA_SLV_SRC_IDS.DL then
            if master_mode == AVIONICS_MASTER_MODE_ID.DGFT_B then
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DGFT_L)
            elseif master_mode == AVIONICS_MASTER_MODE_ID.INT_B then 
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.INT_L)
            end
        end
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
                if station.weapon.level3 ~= wsType_AA_Missile and (station.count > 0 or station.container) then
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
        if get_wpn_ag_ready() and not get_avionics_master_mode_ag_gun() and value == 1 then
            local lauch_op = WPN_LAUNCH_OP:get()
            if lauch_op == WPN_LAUNCH_OP_IDS.SALVO then
                for i=1, wpn_sto_count[wpn_ag_sel] do
                    dev:launch_station(wpn_ag_sel-1)
                end
            elseif lauch_op == WPN_LAUNCH_OP_IDS.PAIR then
                dev:launch_station(wpn_ag_sel-1)
                if wpn_sto_name[wpn_ag_sel] == wpn_sto_name[6-wpn_ag_sel] then 
                    dev:launch_station(4-(wpn_ag_sel-1))
                end
            else 
                dev:launch_station(wpn_ag_sel-1)
            end
            update_storages()
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
    elseif command == Keys.GunSelDist and value == 1 then
        local param = get_param_handle("WS_TARGET_RANGE")
        local range = param:get()
        if get_avionics_master_mode() == AVIONICS_MASTER_MODE_ID.DGFT_B then
            if range == 300 then range = 400
            elseif range == 400 then range = 500
            else range = 300
            end
            dev:set_target_range(range)
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



-- STO1["wstype"] = {}
-- STO1["wstype"]["level3"] = 32
-- STO1["wstype"]["level1"] = 4
-- STO1["wstype"]["level4"] = 119
-- STO1["wstype"]["level2"] = 4
-- STO1["count"] = 2
-- STO1["CLSID"] = "AGM114x2_OH_58"
-- STO1["adapter"] = {}
-- STO1["adapter"]["level3"] = 0
-- STO1["adapter"]["level1"] = 0
-- STO1["adapter"]["level4"] = 0
-- STO1["adapter"]["level2"] = 0
-- STO1["container"] = true
-- STO1["weapon"] = {}
-- STO1["weapon"]["level3"] = 8
-- STO1["weapon"]["level1"] = 4
-- STO1["weapon"]["level4"] = 59
-- STO1["weapon"]["level2"] = 4
-- STO2 = {}
-- STO2["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}" -- MK82
-- STO2["container"] = false
-- STO2["count"] = 1
-- STO2["weapon"] = {}
-- STO2["weapon"]["level3"] = 9
-- STO2["weapon"]["level1"] = 4
-- STO2["weapon"]["level4"] = 31
-- STO2["weapon"]["level2"] = 5
-- STO3 = {}
-- STO3["CLSID"] = "{A-29B TANK}"
-- STO3["container"] = false
-- STO3["count"] = 1
-- STO3["weapon"] = {}
-- STO3["weapon"]["level3"] = 43
-- STO3["weapon"]["level1"] = 1
-- STO3["weapon"]["level4"] = 680
-- STO3["weapon"]["level2"] = 3
-- STO4 = {}
-- STO4["wstype"] = {}
-- STO4["wstype"]["level3"] = 32
-- STO4["wstype"]["level1"] = 4
-- STO4["wstype"]["level4"] = 109
-- STO4["wstype"]["level2"] = 7
-- STO4["count"] = 7
-- STO4["CLSID"] = "{4F977A2A-CD25-44df-90EF-164BFA2AE72F}" LAU
-- STO4["adapter"] = {}
-- STO4["adapter"]["level3"] = 0
-- STO4["adapter"]["level1"] = 0
-- STO4["adapter"]["level4"] = 0
-- STO4["adapter"]["level2"] = 0
-- STO4["container"] = true
-- STO4["weapon"] = {}
-- STO4["weapon"]["level3"] = 33
-- STO4["weapon"]["level1"] = 4
-- STO4["weapon"]["level4"] = 148
-- STO4["weapon"]["level2"] = 7
-- STO5 = {}
-- STO5["wstype"] = {}
-- STO5["wstype"]["level3"] = 32
-- STO5["wstype"]["level1"] = 4
-- STO5["wstype"]["level4"] = 9
-- STO5["wstype"]["level2"] = 7
-- STO5["count"] = 19
-- STO5["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}"
-- STO5["adapter"] = {}
-- STO5["adapter"]["level3"] = 0
-- STO5["adapter"]["level1"] = 0
-- STO5["adapter"]["level4"] = 0
-- STO5["adapter"]["level2"] = 0
-- STO5["container"] = true
-- STO5["weapon"] = {}
-- STO5["weapon"]["level3"] = 33
-- STO5["weapon"]["level1"] = 4
-- STO5["weapon"]["level4"] = 145
-- STO5["weapon"]["level2"] = 7
