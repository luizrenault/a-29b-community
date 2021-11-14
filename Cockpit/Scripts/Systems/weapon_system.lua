dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."Systems/weapon_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")

startup_print("weapon: load")

package.cpath 			= package.cpath..";".. LockOn_Options.script_path.. "..\\..\\bin\\?.dll"
require('avSimplestWeaponSystem')


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
    {2, 4, 3, 1, 5},
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

local CMFD_NAV_FYT_DTK_ELV = get_param_handle("CMFD_NAV_FYT_DTK_ELV")

local WPN = {
    TD_AZIMUTH = get_param_handle("WPN_TD_AZIMUTH"),
    TD_ELEVATION = get_param_handle("WPN_TD_ELEVATION"),
    TD_AVAILABLE = get_param_handle("WPN_TD_AVAILABLE"),
    CCRP_TIME = get_param_handle("WPN_CCRP_TIME"),
    TIME_MAX_RANGE = get_param_handle("WPN_TIME_MAX_RANGE"),
    WEAPON_RELEASE = get_param_handle("WPN_WEAPON_RELEASE"),
    CCIP_DELAYED_TIME = get_param_handle("WPN_CCIP_DELAYED_TIME"),
    CCIP_DELAYED = get_param_handle("WPN_CCIP_DELAYED"),
    TIME_TO_IMPACT = get_param_handle("WPN_TIME_TO_IMPACT"),
}

local HUD = {
    CCIP_PIPER_AZIMUTH = get_param_handle("HUD_CCIP_PIPER_AZIMUTH"),
    CCIP_PIPER_ELEVATION = get_param_handle("HUD_CCIP_PIPER_ELEVATION"),
    FPM_SLIDE = get_param_handle("HUD_FPM_SLIDE"),
    FPM_VERT = get_param_handle("HUD_FPM_VERT"),
    TIME_TO_IMPACT = get_param_handle("HUD_TIME_TO_IMPACT"),
}

local CMFD = {
    NAV_FYT_LAT_M = get_param_handle("CMFD_NAV_FYT_LAT_M"),
    NAV_FYT_LON_M = get_param_handle("CMFD_NAV_FYT_LON_M"),
    NAV_FYT_ALT_M = get_param_handle("CMFD_NAV_FYT_ALT_M"),

    NAV_FYT_DTK_AZIMUTH = get_param_handle("CMFD_NAV_FYT_DTK_AZIMUTH"),
    NAV_FYT_DTK_ELEVATION = get_param_handle("CMFD_NAV_FYT_DTK_ELEVATION"),
    NAV_FYT_DTK_DIST = get_param_handle("CMFD_NAV_FYT_DTK_DIST"),

    NAV_OAP_LAT_M = get_param_handle("CMFD_NAV_OAP_LAT_M"),
    NAV_OAP_LON_M = get_param_handle("CMFD_NAV_OAP_LON_M"),
    NAV_OAP_ALT_M = get_param_handle("CMFD_NAV_OAP_ALT_M"),
    NAV_OAP_AZIMUTH = get_param_handle("CMFD_NAV_OAP_AZIMUTH"),
    NAV_OAP_ELEVATION = get_param_handle("CMFD_NAV_OAP_ELEVATION"),

}

local UFCP = {
    OAP_ENABLED = get_param_handle("UFCP_OAP") -- 0disabled 1enabled
}

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
WPN_RP:set(1)
WPN_IS_M:set(12)

function wpn_get_weapon_type(station)

end

function launch_station(station)
    if WPN_SELECTED_WEAPON_TYPE:get() == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then
        avSimplestWeaponSystem.LaunchGBU(station, 1688)
    else
        dev:launch_station(station)
    end

end

local function update_storages()
    wpn_sto_total_count = {}
    for i = 0, station_count-1 do
        local station_info = dev:get_station_info(i)
        local wname = get_wpn_weapon_name(station_info["CLSID"])
        wpn_sto_name[i+1] = wname
        wpn_sto_count[i+1] = station_info["count"]
        
        if i==2 then WPN_VENTRAL_FREE:set(station_info["count"] == 0 and 1 or 0) end
        
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
        local param = get_param_handle("WPN_POS_"..tostring(i+1).."_TEXT")
        param:set(wname)
        -----------------------------------
    end
    if wpn_ag_sel > 0 then 
        wpn_ag_name = wpn_sto_name[wpn_ag_sel] or ""
        wpn_ag_qty = wpn_sto_total_count[wpn_ag_name] or 0
    end
    WPN_GUNS_L:set(wpn_guns_l)
    WPN_GUNS_R:set(wpn_guns_r)
end

local function update_ag_sel_next(byname)
    local master_mode = get_avionics_master_mode()
    local name = ""
    local lauch_op = WPN_LAUNCH_OP:get()

    if wpn_ag_sel ~= 0  then 
        name = wpn_sto_name[wpn_ag_sel]
    else 
        name = wpn_ag_name
    end
    if byname and name == "" then return 0 end
    if not byname then
        local sequence = sms_search_sequence[wpn_ag_sel + 1]
        for k, pos in pairs(sequence) do
            if wpn_sto_name[pos] ~= name and wpn_sto_type[pos] >= WPN_WEAPON_TYPE_IDS.AG_WEAPON_BEG and wpn_sto_type[pos] <= WPN_WEAPON_TYPE_IDS.AG_WEAPON_END and wpn_sto_count[pos] > 0 then
                name = wpn_sto_name[pos]
                break
            end
        end
    end

    local pos = 0
    for i=1, 5 do
        if wpn_sto_name[i] == name then
            if wpn_sto_name[6-i] == name and wpn_sto_count[6-i] > wpn_sto_count[i] then
                pos = 6-i
            elseif wpn_sto_count[i] > 0 then
                pos = i
            end
            if pos > 0 then break end
        end
    end
    if pos > 0 then
        wpn_ag_sel = pos
        set_wpn_ag_sel(wpn_ag_sel)
        wpn_ag_name = wpn_sto_name[wpn_ag_sel]
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
    else
        if wpn_ag_sel ~= 0 then 
            wpn_ag_sel = 0
            set_wpn_ag_sel(wpn_ag_sel)
            -- wpn_ag_name = ""
            -- wpn_ag_qty = -1
            WPN_SELECTED_WEAPON_TYPE:set(WPN_WEAPON_TYPE_IDS.NO_WEAPON)
            dev:select_station(wpn_ag_sel-1)
        end
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
local master_mode_a_g_last = -1

local function update_master_mode_changed()
    master_mode = get_avionics_master_mode()

    if master_mode == AVIONICS_MASTER_MODE_ID.A_G then
        if master_mode_a_g_last == -1 then master_mode_a_g_last = AVIONICS_MASTER_MODE_ID.CCIP end
        master_mode = master_mode_a_g_last
        set_avionics_master_mode(master_mode)
    end

    if master_mode == AVIONICS_MASTER_MODE_ID.GUN and WPN_RALT:get() == 1 then master_mode = AVIONICS_MASTER_MODE_ID.GUN_R
    elseif master_mode == AVIONICS_MASTER_MODE_ID.GUN_R and WPN_RALT:get() == 0 then master_mode = AVIONICS_MASTER_MODE_ID.GUN
    elseif master_mode == AVIONICS_MASTER_MODE_ID.CCIP and WPN_RALT:get() == 1 then master_mode = AVIONICS_MASTER_MODE_ID.CCIP_R
    elseif master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R and WPN_RALT:get() == 0 then master_mode = AVIONICS_MASTER_MODE_ID.CCIP
    elseif master_mode == AVIONICS_MASTER_MODE_ID.DTOS and WPN_RALT:get() == 1 then master_mode = AVIONICS_MASTER_MODE_ID.DTOS_R
    elseif master_mode == AVIONICS_MASTER_MODE_ID.DTOS_R and WPN_RALT:get() == 0 then master_mode = AVIONICS_MASTER_MODE_ID.DTOS
    elseif master_mode == AVIONICS_MASTER_MODE_ID.FIX and WPN_RALT:get() == 1 then master_mode = AVIONICS_MASTER_MODE_ID.FIX_R
    elseif master_mode == AVIONICS_MASTER_MODE_ID.FIX_R and WPN_RALT:get() == 0 then master_mode = AVIONICS_MASTER_MODE_ID.FIX
    elseif master_mode == AVIONICS_MASTER_MODE_ID.MARK and WPN_RALT:get() == 1 then master_mode = AVIONICS_MASTER_MODE_ID.MARK_R
    elseif master_mode == AVIONICS_MASTER_MODE_ID.MARK_R and WPN_RALT:get() == 0 then master_mode = AVIONICS_MASTER_MODE_ID.MARK
    end

    if master_mode >= AVIONICS_MASTER_MODE_ID.GUN and master_mode <= AVIONICS_MASTER_MODE_ID.MAN then
        master_mode_a_g_last = master_mode
    end

    if master_mode ~= master_mode_last then
        set_avionics_master_mode(master_mode)
    end

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

local wpn_target


local function calculate_ccip_max_range(h0)
    local fly_time, Vx0, Vy0, Vz0, g
    local pitch = sensor_data.getPitch()
    g = -9.82 -- m/s2

    Vx0, Vy0, Vz0 = sensor_data.getSelfVelocity()
    local vel_temp = math.sqrt(Vx0 * Vx0 + Vy0 * Vy0 + Vz0 * Vz0)
    Vy0 = vel_temp / math.sqrt(2)

    local delta = Vy0 * Vy0 - 2 * g * (math.abs(h0))
    fly_time = (-Vy0  - math.sqrt(delta))/g                -- time to impact

    local Vx = Vy0                                  -- horizontal weapon velocity
    local Sx = Vx * fly_time                               -- horizontal distance travelled by weapon
    return Sx, fly_time, h0
end

local function  update_ccrp()
    if master_mode == AVIONICS_MASTER_MODE_ID.CCRP and wpn_ag_sel > 0 and wpn_sto_count[wpn_ag_sel]>0  then
        wpn_target = {}
        if UFCP.OAP_ENABLED:get() == 1 then
            wpn_target.lat_m = CMFD.NAV_OAP_LAT_M:get()
            wpn_target.lon_m = CMFD.NAV_OAP_LON_M:get()
            wpn_target.alt_m = CMFD.NAV_OAP_ALT_M:get()
        else
            wpn_target.lat_m = CMFD.NAV_FYT_LAT_M:get()
            wpn_target.lon_m = CMFD.NAV_FYT_LON_M:get()
            wpn_target.alt_m = CMFD.NAV_FYT_ALT_M:get()
        end
        local x, y, z = sensor_data.getSelfCoordinates()
        local dx = wpn_target.lat_m - x
        local dy = wpn_target.alt_m - y
        local dz = wpn_target.lon_m - z

        local max_range = calculate_ccip_max_range(dy)

        local valid, az, el, travel_dist = avSimplestWeaponSystem.Calculate()
        local vx, vy, vz = sensor_data.getSelfVelocity()
        local gs = math.sqrt(vx*vx + vz*vz)
        fly_time=travel_dist/gs

        local target_dist = math.sqrt(dx * dx + dy * dy +  dz * dz)
        local target_horiz_dist = math.sqrt(dx * dx +  dz * dz)

        local ccrp_dif = target_dist - travel_dist
        local ccrp_time = 0
        if ccrp_dif >= 0 then 
            ccrp_time = ccrp_dif / gs
        end

        local time_to_max_range = (target_horiz_dist - max_range) / gs

        WPN.CCRP_TIME:set(ccrp_time)
        WPN.TIME_MAX_RANGE:set(time_to_max_range)
        WPN.TIME_TO_IMPACT:set(fly_time)

        WPN.TD_AVAILABLE:set(1)
        if UFCP.OAP_ENABLED:get() == 1 then
            WPN.TD_AZIMUTH:set(CMFD.NAV_OAP_AZIMUTH:get())
            WPN.TD_ELEVATION:set(CMFD.NAV_OAP_ELEVATION:get())
        else
            WPN.TD_AZIMUTH:set(CMFD.NAV_FYT_DTK_AZIMUTH:get())
            WPN.TD_ELEVATION:set(CMFD.NAV_FYT_DTK_ELEVATION:get())
        end
    else 
        WPN.CCRP_TIME:set(-1)
    end
end

wpn_ccip_delayed_target = {}
wpn_ccip_delayed_target.lat_m = 0
wpn_ccip_delayed_target.lon_m = 0
wpn_ccip_delayed_target.alt_m = 0

local function  update_ccip_delayed()
    if ((master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R) and wpn_ag_sel > 0 and wpn_sto_count[wpn_ag_sel]>0 and wpn_sto_type[wpn_ag_sel] == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB and WPN.CCIP_DELAYED:get() == 1)  then
        
        local x, y, z = sensor_data.getSelfCoordinates()
        local dx = wpn_ccip_delayed_target.lat_m - x
        local dy = wpn_ccip_delayed_target.alt_m - y
        local dz = wpn_ccip_delayed_target.lon_m - z
        local p_hdg = 2*math.pi - sensor_data:getHeading()
        local p_roll = sensor_data:getRoll()
        local p_pitch = sensor_data:getPitch()

        local dif_hdg = (math.atan2(dz, dx) - p_hdg) % (2*math.pi)
        if dif_hdg > math.pi then dif_hdg = dif_hdg - 2 * math.pi end


        local target_dist = math.sqrt(dx * dx + dy * dy +  dz * dz)
        local target_horiz_dist = math.sqrt(dx * dx +  dz * dz)
        local target_elevation  = math.atan2(dy, target_horiz_dist)

        local s = math.sin(p_roll)
        local c = math.cos(p_roll)

        local new_azimuth = dif_hdg * c - target_elevation * s
        local new_elevation = dif_hdg * s + target_elevation * c
        dif_hdg = new_azimuth + p_pitch * s
        target_elevation = new_elevation - p_pitch * c


        local valid, az, el, travel_dist = avSimplestWeaponSystem.Calculate()
        local vx, vy, vz = sensor_data.getSelfVelocity()
        local gs = math.sqrt(vx*vx + vz*vz)
        fly_time=travel_dist/gs

        local ccrp_dif = target_dist - travel_dist
        local ccrp_time = 0
        if ccrp_dif >= 0 then 
            ccrp_time = ccrp_dif / gs
        end

        local max_range = calculate_ccip_max_range(dy)
        local time_to_max_range = (target_horiz_dist - max_range) / gs

        WPN.CCIP_DELAYED_TIME:set(ccrp_time)
        WPN.TIME_MAX_RANGE:set(time_to_max_range)
        WPN.TIME_TO_IMPACT:set(fly_time)

        WPN.TD_AVAILABLE:set(1)
        WPN.TD_AZIMUTH:set(dif_hdg)
        WPN.TD_ELEVATION:set(target_elevation)
    else 
        WPN.CCIP_DELAYED_TIME:set(-1)
    end
end

local function  update_ccip()
    local valid = 0
    local az = 0
    local el = 0
    local travel_dist = -1
    local fly_time = -1
    local breakaway = 0

    local master_mode = get_avionics_master_mode()
    if ((master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R) and wpn_ag_sel > 0 and wpn_sto_count[wpn_ag_sel]>0) or (master_mode == AVIONICS_MASTER_MODE_ID.GUN or master_mode == AVIONICS_MASTER_MODE_ID.GUN_R)  then
        local x, y, z = sensor_data.getSelfCoordinates()
        local p_roll = sensor_data:getRoll()
        local p_pitch = sensor_data:getPitch()
        local Ralt = sensor_data.getRadarAltitude()
        local Balt = sensor_data.getBarometricAltitude()
        local Vx0, Vy0, Vz0 = sensor_data.getSelfVelocity()
        local V0 = math.sqrt(Vx0 * Vx0 + Vy0 * Vy0 + Vz0 * Vz0)
        local gs = get_avionics_gs()
        local h0 = 0


        if Ralt < 1600 then 
            Ralt_last = Ralt
            Balt_last = Balt
        else
        end
        h0 = y - (Ralt_last + Balt - Balt_last) * math.cos(math.abs(p_pitch)) * math.cos(math.abs(p_roll))
        if master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.GUN then
            if UFCP.OAP_ENABLED:get() == 1 then
                h0 = CMFD.NAV_OAP_ALT_M:get()
            else 
                h0 = CMFD.NAV_FYT_ALT_M:get()
            end
        end
 
        avSimplestWeaponSystem.set_target_level(h0)

        if master_mode == AVIONICS_MASTER_MODE_ID.GUN or master_mode == AVIONICS_MASTER_MODE_ID.GUN_R then
            local _valid, tx, ty, tz, fly_time, breakaway = avSimplestWeaponSystem.CalculateGunA2G(V0)
            valid = _valid
            if _valid then
                local dx = -x + tx
                local dy = -y + ty 
                local dz = -z + tz
                local p_hdg = 2*math.pi - sensor_data:getHeading()
        
                local dif_hdg = (math.atan2(dz, dx) - p_hdg) % (2*math.pi)
                if dif_hdg > math.pi then dif_hdg = dif_hdg - 2 * math.pi end
        
                local target_horiz_dist = math.sqrt(dx * dx +  dz * dz)
                local target_elevation  = math.atan2(-math.abs(dy), target_horiz_dist)
        
                local s = math.sin(p_roll)
                local c = math.cos(p_roll)
        
                local new_azimuth = dif_hdg * c - target_elevation * s
                local new_elevation = target_elevation * c + dif_hdg * s 

                dif_hdg = new_azimuth + p_pitch * s
                target_elevation = new_elevation - p_pitch * c
        
                local dist = 0;

                valid = valid and dy < 0
                az = dif_hdg
                el = target_elevation
            end
        elseif wpn_sto_type[wpn_ag_sel] == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then
            valid, az, el, travel_dist = avSimplestWeaponSystem.Calculate()
            fly_time=travel_dist / gs
        elseif wpn_sto_type[wpn_ag_sel] == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_ROCKET then
            valid, az, el, travel_dist = avSimplestWeaponSystem.CalculateRocket()
            fly_time=travel_dist / gs
        end
    end
    if valid == 0 then
        az=0
        el=0
        fly_time=-1
        range=-1
        breakaway = 0
    end
    WPN_CCIP_PIPER_AVAILABLE:set(valid)
    WPN_CCIP_PIPER_AZIMUTH:set(az)
    WPN_CCIP_PIPER_ELEVATION:set(el)
    WPN.TIME_TO_IMPACT:set(fly_time)
    return valid, az, el, travel_dist, fly_time, breakaway
end



local wpn_is_m_last
local wpn_is_time_last
local function update_ag_sel_wpn()
    if wpn_ag_sel == 0 or (wpn_ag_sel ~= 0 and ((wpn_sto_count[wpn_ag_sel] <=0 or wpn_sto_type[wpn_ag_sel] < WPN_WEAPON_TYPE_IDS.AG_WEAPON_BEG or wpn_sto_type[wpn_ag_sel] > WPN_WEAPON_TYPE_IDS.AG_WEAPON_END))) then 
        update_ag_sel_next(true)
    end
    if get_wpn_ag_ready() or get_wpn_guns_ready() then  WPN_READY:set(1) else  WPN_READY:set(0) end
    if get_wpn_ag_sim_ready() or get_wpn_guns_sim_ready() then WPN_SIM_READY:set(1) else WPN_SIM_READY:set(0) end
    if WPN_LAUNCH_OP:get() == WPN_LAUNCH_OP_IDS.SALVO and wpn_ag_sel > 0 and wpn_sto_type[wpn_ag_sel] == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then WPN_LAUNCH_OP:set(0) end
    for i=1, 5 do
        local param = get_param_handle("WPN_POS_"..tostring(i).."_SEL")
        local lauch_op = WPN_LAUNCH_OP:get()

        if not get_avionics_master_mode_ag_gun() and (wpn_ag_sel == i or 
        (lauch_op == WPN_LAUNCH_OP_IDS.PAIR and (6-wpn_ag_sel) == i and wpn_sto_name[i] == wpn_sto_name[wpn_ag_sel] and wpn_sto_count[i] > 0) or 
        (lauch_op == WPN_LAUNCH_OP_IDS.SALVO and wpn_sto_name[i] == wpn_sto_name[wpn_ag_sel] and wpn_sto_count[i] > 0)) then
            if get_wpn_ag_ready() then
                param:set(1)
            else 
                param:set(2)
            end
        else
            param:set(0)
        end
    end
    if get_avionics_master_mode_ag_gun() then
        if get_wpn_guns_ready() then
            WPN_GUNS_L_SEL:set(1)
            WPN_GUNS_R_SEL:set(1)
        else
            WPN_GUNS_L_SEL:set(2)
            WPN_GUNS_R_SEL:set(2)
        end
    else
        WPN_GUNS_L_SEL:set(0)
        WPN_GUNS_R_SEL:set(0)
    end
    if wpn_ag_sel > 0 then 
        WPN_SELECTED_WEAPON_TYPE:set(wpn_sto_type[wpn_ag_sel])
    else
        WPN_SELECTED_WEAPON_TYPE:set(WPN_WEAPON_TYPE_IDS.NO_WEAPON)
    end
    local wpn_rp = WPN_RP:get()
    local wpn_rp_total = wpn_rp
    local sel_qty = 0
    for i=1,5 do
        local param = get_param_handle("WPN_POS_"..tostring(i).."_SEL")
        if param:get() > 0 then sel_qty = sel_qty + 1 end
    end
    wpn_rp_total = wpn_rp * sel_qty
    if wpn_ag_name ~= "" and wpn_rp_total > wpn_sto_total_count[wpn_ag_name] then wpn_rp_total = wpn_sto_total_count[wpn_ag_name] end

    WPN_RP_TOTAL:set(wpn_rp_total)

    local wpn_is_m = WPN_IS_M:get()
    local wpn_is_time = WPN_IS_TIME:get()
    if WPN_SELECTED_WEAPON_TYPE:get() == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then
        if wpn_is_m < 12 then wpn_is_m = 12
        elseif wpn_is_m > 999 then wpn_is_m = 999 
        end
    elseif WPN_SELECTED_WEAPON_TYPE:get() == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_ROCKET then
        if wpn_is_time < 0 then wpn_is_time = 0
        elseif wpn_is_time > 9999 then wpn_is_time = 9999
        end
    end

    if wpn_is_m_last ~= wpn_is_m then
        wpn_is_m_last = wpn_is_m
        WPN_IS_M:set(wpn_is_m)
    elseif wpn_is_time_last ~= wpn_is_time then
        wpn_is_time_last = wpn_is_time
        WPN_IS_TIME:set(wpn_is_time)
    end
    WPN_AG_QTY:set(wpn_ag_qty)
    WPN_AG_NAME:set(wpn_ag_name)
    WPN_AA_INTRG_QTY:set(wpn_guns_l + wpn_guns_r)

end

local function update_ag()
    update_ag_sel_wpn()
    update_ccip()
    update_ccip_delayed()
    update_ccrp()
end

local function update_aa_sel_wpn()
    for i=1, 5 do
        local param = get_param_handle("WPN_POS_"..tostring(i).."_SEL")
        if wpn_aa_sel == i then
            if get_wpn_aa_msl_ready() then
                param:set(1)
            else 
                param:set(2)
            end
        else
            param:set(0)
        end
    end
    if master_mode == AVIONICS_MASTER_MODE_ID.DGFT_B or master_mode == AVIONICS_MASTER_MODE_ID.DGFT_L then
        if get_wpn_guns_ready() then
            WPN_GUNS_L_SEL:set(1)
            WPN_GUNS_R_SEL:set(1)
        else
            WPN_GUNS_L_SEL:set(2)
            WPN_GUNS_R_SEL:set(2)
        end
    else
        WPN_GUNS_L_SEL:set(0)
        WPN_GUNS_R_SEL:set(0)
    end
end


local function update_aa()
    check_sidewinder()

    if get_wpn_aa_msl_ready() or get_wpn_guns_ready() then WPN_READY:set(1) else WPN_READY:set(0) end
    if get_wpn_aa_msl_sim_ready() or get_wpn_guns_sim_ready() then WPN_SIM_READY:set(1) else WPN_SIM_READY:set(0) end

    update_aa_sel_wpn()

    if get_avionics_master_mode() == AVIONICS_MASTER_MODE_ID.DGFT_B then
        local travel_dist = WS_TARGET_RANGE:get()
        if travel_dist ~= 300 and travel_dist ~= 400 and travel_dist ~= 500 then
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
    WPN_READY:set(0)
    WPN_GUNS_L_SEL:set(0)
    WPN_GUNS_R_SEL:set(0)
end    

local function update_sj()
    for i=1,5 do
        local wpn_sj_sel = get_param_handle("WPN_SJ_STO"..tostring(i).."_SEL")
        if wpn_sto_count[i] == 0 and not wpn_sto_container[i] then wpn_sj_sel:set(0) end
        param = get_param_handle("WPN_POS_"..tostring(i).."_SEL")
        if wpn_sj_sel:get() == 1 then
            if get_wpn_mass() ~= WPN_MASS_IDS.LIVE or get_wpn_latearm() ~= WPN_LATEARM_IDS.ON or get_avionics_onground() then
                param:set(2)
            else 
                param:set(1)
            end
        else
            param:set(0)
        end
    end
    WPN_GUNS_L_SEL:set(0)
    WPN_GUNS_R_SEL:set(0)
    WPN_READY:set(0)
end

local wpn_ripple_count = 0
local wpn_ripple_interval = 0
local wpn_ripple_elapsed = 0

local time_elapsed = 0

function update()
    time_elapsed = time_elapsed + update_time_step
    update_storages()
    update_master_mode_changed()
    if get_avionics_master_mode_aa() then update_aa()
    elseif get_avionics_master_mode_ag() then update_ag()
    elseif master_mode == AVIONICS_MASTER_MODE_ID.SJ then  update_sj()
    elseif master_mode == AVIONICS_MASTER_MODE_ID.EJ then  update_ej()
    else
        WPN_READY:set(0)
        WPN_SELECTED_WEAPON_TYPE:set(WPN_WEAPON_TYPE_IDS.NO_WEAPON)
        for i=1,5 do
            param = get_param_handle("WPN_POS_"..tostring(i).."_SEL")
            param:set(0)
        end
        WPN_GUNS_L_SEL:set(0)
        WPN_GUNS_R_SEL:set(0)
    end


    if wpn_ripple_count > 0 then
        if (master_mode == AVIONICS_MASTER_MODE_ID.CCRP and WPN.CCRP_TIME:get() > 0) then
        elseif ((master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R) and WPN.CCIP_DELAYED:get() == 1 and WPN.CCIP_DELAYED_TIME:get() > 0) then
        else
            wpn_ripple_elapsed = wpn_ripple_elapsed + update_time_step
            while wpn_ripple_elapsed >= wpn_ripple_interval and wpn_ripple_count > 0 do
                wpn_ripple_elapsed = wpn_ripple_elapsed - wpn_ripple_interval
                wpn_ripple_count = wpn_ripple_count - 1
                if WPN.CCIP_DELAYED:get() == 1 and wpn_ripple_count == 0 then
                    WPN.CCIP_DELAYED:set(0)
                end
                if (master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R or master_mode == AVIONICS_MASTER_MODE_ID.CCRP) and WPN_SELECTED_WEAPON_TYPE:get() == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then
                    HUD.TIME_TO_IMPACT:set(WPN.TIME_TO_IMPACT:get())
                end

                local lauch_op = WPN_LAUNCH_OP:get()
                if lauch_op == WPN_LAUNCH_OP_IDS.SALVO or lauch_op == WPN_LAUNCH_OP_IDS.PAIR then
                    for i=1,5 do
                        local param = get_param_handle("WPN_POS_"..i.."_SEL")
                        if param:get() == 1 then
                            launch_station(i-1)
                        end
                    end
                else 
                    launch_station(wpn_ag_sel-1)
                end
                update_storages()
                update_ag_sel_next(true)
            end
        end
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

    WPN.CCIP_DELAYED:set(0);
    avSimplestWeaponSystem.Setup()

    startup_print("weapon: postinit end")
end



local iCommandPlaneDropFlareOnce = 357
local iCommandPlaneDropChaffOnce = 358

dev:listen_command(iCommandPlaneDropFlareOnce)
dev:listen_command(iCommandPlaneDropChaffOnce)

dev:listen_command(Keys.iCommandPlanePickleOn)
dev:listen_command(Keys.iCommandPlanePickleOff)

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
dev:listen_command(Keys.JettisonWeapons)

local step_time_elapsed = -1;

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
    elseif command == Keys.JettisonWeapons then
        dev:performClickableAction(device_commands.Salvo, value, true)
    elseif command == device_commands.Salvo then
        if value == 1 and not get_avionics_onground() then
            wpn_ej_timeout = 0.5;
            for i=1,5 do
                local param = get_param_handle("WPN_POS_"..tostring(i).."_SEL")
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
        if value == 1 then
            WPN.WEAPON_RELEASE:set(1)
        elseif value == 0 then 
            WPN.WEAPON_RELEASE:set(0)
        end
        if get_wpn_aa_msl_ready() and value == 1 then 
            launch_station(wpn_aa_sel-1)
            WPN_RELEASE:set(1)
            wpn_release = true
            wpn_release_elapsed = 0.5
        end
        if get_wpn_ag_ready() and not get_avionics_master_mode_ag_gun() and value == 1 then
            wpn_ripple_count = WPN_RP:get()-1
            if wpn_sto_type[wpn_ag_sel] == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_ROCKET or (wpn_sto_type[wpn_ag_sel] == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB and get_avionics_master_mode() == AVIONICS_MASTER_MODE_ID.MAN) then
                wpn_ripple_interval = WPN_IS_TIME:get() / 1000
            elseif wpn_sto_type[wpn_ag_sel] == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then
                wpn_ripple_interval = WPN_IS_M:get() / (get_avionics_gs() or 100)
            end
            wpn_ripple_elapsed = 0
            if master_mode == AVIONICS_MASTER_MODE_ID.CCRP then
                wpn_ripple_count = wpn_ripple_count + 1
            elseif ((master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R) and get_param_handle("HUD_CCIP_PIPER_HIDDEN"):get() == 1) then
                local slide = HUD.FPM_SLIDE:get()
                local vert = HUD.FPM_VERT:get()
            
                local ccip_az = HUD.CCIP_PIPER_AZIMUTH:get()
                local ccip_el = HUD.CCIP_PIPER_ELEVATION:get()
                
                local p_hdg = sensor_data:getHeading()
                local p_pitch = sensor_data:getPitch()
                local p_roll = sensor_data:getRoll()

                local s = math.sin(p_roll)
                local c = math.cos(p_roll)

                local new_ccip_az = ccip_az --- slide
                local new_ccip_el = ccip_el --- vert
                
                ccip_az = new_ccip_az * c + new_ccip_el * s
                ccip_el = new_ccip_el * c - new_ccip_az * s

                local t_hdg = p_hdg - ccip_az
                local t_pitch = ccip_el + p_pitch

                local x, y, z = sensor_data.getSelfCoordinates()

                wpn_ccip_delayed_target = {}

                local Ralt = sensor_data.getRadarAltitude()
                local Balt = sensor_data.getBarometricAltitude()

                if Ralt < 1600 then 
                    Ralt_last = Ralt
                    Balt_last = Balt
                else
                end
                local h0 = y - (Ralt_last + Balt - Balt_last) * math.cos(math.abs(p_pitch)) * math.cos(math.abs(p_roll))
                if master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.GUN then
                    if UFCP.OAP_ENABLED:get() == 1 then
                        h0 = CMFD.NAV_OAP_ALT_M:get()
                    else 
                        h0 = CMFD.NAV_FYT_ALT_M:get()
                    end
                end
        
                local t_dist = (h0-y) / math.tan (t_pitch);
                
                wpn_ccip_delayed_target.lat_m = x + t_dist * math.sin(t_hdg + math.pi/2)
                wpn_ccip_delayed_target.lon_m = z + t_dist * math.cos(t_hdg + math.pi/2)
                wpn_ccip_delayed_target.alt_m = h0 

                wpn_ripple_count = wpn_ripple_count + 1
                WPN.CCIP_DELAYED:set(1);
            else
                if (master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R or master_mode == AVIONICS_MASTER_MODE_ID.CCRP) and WPN_SELECTED_WEAPON_TYPE:get() == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then
                    HUD.TIME_TO_IMPACT:set(WPN.TIME_TO_IMPACT:get())
                end

                local lauch_op = WPN_LAUNCH_OP:get()
                if lauch_op == WPN_LAUNCH_OP_IDS.SALVO or lauch_op == WPN_LAUNCH_OP_IDS.PAIR then
                    for i=1,5 do
                        local param = get_param_handle("WPN_POS_"..i.."_SEL")
                        if param:get() == 1 then
                            launch_station(i-1)
                        end
                    end
                else 
                    launch_station(wpn_ag_sel-1)
                end
                update_storages()
                update_ag_sel_next(true)
            end
            WPN_RELEASE:set(1)
            wpn_release = true
            wpn_release_elapsed = 0.5
        elseif wpn_ripple_count > 0 and get_wpn_ag_ready() and not get_avionics_master_mode_ag_gun() and value == 0 then
            wpn_ripple_count = 0
        end
        if value == 0 and wpn_release  then
            if wpn_release_elapsed == -1 then WPN_RELEASE:set(0) end
            wpn_release = false
            WPN.CCIP_DELAYED:set(0);
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
        if value == 1 then
            step_time_elapsed = time_elapsed + 0.5
        end
        if get_avionics_master_mode_aa() and value == 1 then 
            update_aa_sel_next()
        elseif get_avionics_master_mode_ag() and value == 1 then
            if WPN_SELECTED_WEAPON_TYPE:get() == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then
                if master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R then
                    set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DTOS)
                elseif master_mode == AVIONICS_MASTER_MODE_ID.DTOS or master_mode == AVIONICS_MASTER_MODE_ID.DTOS_R then
                    set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCRP)
                elseif master_mode == AVIONICS_MASTER_MODE_ID.CCRP or master_mode == AVIONICS_MASTER_MODE_ID.CCRP_R then
                    set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP)
                elseif master_mode == AVIONICS_MASTER_MODE_ID.MAN then
                    set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP)
                elseif master_mode == AVIONICS_MASTER_MODE_ID.GUN_M then
                    set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.GUN)
                end
            else
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP)
            end
        elseif value == 1 then
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP)
        elseif value == 0 then
            if time_elapsed>= step_time_elapsed and get_avionics_master_mode_ag() then
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.MAN)
            end
        end

    elseif command == Keys.GunSelDist and value == 1 then
        local param = get_param_handle("WS_TARGET_RANGE")
        local travel_dist = param:get()
        if get_avionics_master_mode() == AVIONICS_MASTER_MODE_ID.DGFT_B then
            if travel_dist == 300 then travel_dist = 400
            elseif travel_dist == 400 then travel_dist = 500
            else travel_dist = 300
            end
            dev:set_target_range(travel_dist)
        end
    elseif command == iCommandPlaneDropFlareOnce then
        avSimplestWeaponSystem.Setup()
        if dev:get_flare_count() > 1 then 
            dev:drop_flare()
        end
    elseif command == iCommandPlaneDropChaffOnce then
        if dev:get_chaff_count() > 1 then 
            dev:drop_chaff()
        end
    end
end

dev:listen_event("WeaponRearmComplete")
function CockpitEvent(command, val)
    if command == "WeaponRearmComplete" then
        wpn_guns_l = 250
        wpn_guns_r = 250
    end
end

function on_launch(var)
    print_message_to_user("on_launch: " .. tostring(var) ..".")
end

startup_print("weapon: load end")
need_to_be_closed = false -- close lua state after initialization



-- WS_DLZ_MAX:-1.000000
-- WS_IR_MISSILE_TARGET_ELEVATION:0.000000
-- WS_IR_MISSILE_SEEKER_DESIRED_ELEVATION:0.00000
-- WS_IR_MISSILE_LOCK:0.000000
-- WS_IR_MISSILE_TARGET_AZIMUTH:0.000000
-- WS_IR_MISSILE_SEEKER_DESIRED_AZIMUTH:0.000000

-- WS_GUN_PIPER_AVAILABLE:0.000000
-- WS_GUN_PIPER_AZIMUTH:0.000000
-- WS_GUN_PIPER_ELEVATION:0.000000
-- WS_GUN_PIPER_SPAN:0.015000

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




-- //type of GOS homing head:
-- const int InfraredSeeker = 1; / / thermal IR (infrared finder)
-- const int ActiveRadar = 2; / / active-radar (active radar (AR) (+ins))
-- const int AntiRadar = 3; / / antiradar (passive radar +ins)
-- const int Laserhooming = 4; / / laser illumination (+ins)
-- const int Autopilot = 5; / / Autonomous (ins + map, GPS, TV, IIR...)
-- constant int SemiActiveRadar = 6; / / semi-active-radar semi-active radar (SAR) - radio light
-- const int SemiAutoAT = 7; / / semi-automatic control from the platform for ATGM, fly to wopoint, wopoint coordinates are changed by the platform.

-- struct WEAPONS_API Rocket_Const // Rocket constants and settings for control laws.
-- // Characteristics of the missile
-- unsigned char Name_; // name of the rocket
-- int Escort_; / / escort: 0-No, 1-La launch, 2-other La, 3-C ground
-- int Head_Type_; / / type of homing head (GOS) (CM above)
-- Sigma = {x, y, z}, maximum aiming error in meters, in target coordinates. X-longitudinal axis of the target, y-axis virtualna purpose, Z - axis, transverse target
-- float M_; / / gross weight in kg
-- float H_max_; / / maximum flight altitude.
-- float H_min_; / / minimum flight height.
-- float Diam_; / / case Diameter in mm
-- int Cx_pil; / / Cx as suspension
-- float D_max_; / / maximum launch travel_dist at low altitude
-- float D_min_; / / minimum launch travel_dist
-- bool Head_Form_;/ / false - hemispherical head shape,
-- //True-animate (~conic)
-- float Life_time;// lifetime (self-destruct timer), sec
-- double Nr_max_; / / Maximum overload during u
--turns -- float v_min_; / / Minimum speed.
-- float v_mid_; / / Average speed
-- float Mach_max_; / / Maximum Mach number.
-- float t_b_; / / engine start time
-- t_acc_ float; // time of operation of the accelerator
-- float t_marsh_; / / operating time in marching mode
-- float Range_max_;/ / maximum launch travel_dist at maximum altitude
-- float H_min_t_; / / minimum height of the target above the terrain, m.
-- float Fi_start_; / / angle of tracking and sighting at launch
-- float Fi_rak_; / / acceptable angle of view of the target (rad)
-- float Fi_excort_; / / angle of tracking (sight) of the target by the missile.
-- float Fi_search_;// limit angle of free search
-- float OmViz_max_;// maximum line-of-sight speed
-- float Damage_;/ / damage caused by a direct hit
-- / * int Engine_Type_; / / engine type: 1-solid fuel;
-- // 2 - Liquid Rocket engine(RD) (LRE);
-- // 3 - Ramjet air RD ;
-- // 4 - accelerator-1 + LRE.
-- // 5 - turbojet
-- // 6 - turbojet + accelerator
-- int Stage_; / / number of steps.* /
-- float X_back_; / / coordinates of the nozzle center in the rocket axes
-- y_back float_;
-- z_back float_;
-- float X_back_acc_; / / coordinates of the accelerator nozzle center in the rocket axes
-- float Y_back_acc_;
-- float Z_back_acc_;
-- float reflection; / / effective radio reflection surface, square meters

-- //Kill distances - this distance is used to start the fuse
-- double the distance of murder;

-- // These are warheads used to simulate explosions
-- // Due to the blocksim architecture, we have to use two schemes -
-- //one for the server object (which actually does damage), and the other for
-- //client object (which does not cause any damage)

-- Instantaneous angle of view of missiles:
-- IR GOS + - 1 degree



-- Fzu39 (fusível de proximidade) - yes\no
-- Fnc time (tempo de funcionamento) - .63; .95; 1.28; 1.60; 1.92; 2.23
-- HOF (height of function) - 300; 500; 700; 900; 1200; 1500; 1800; 2200; 2600; 3000
-- DES TOF (desired time of function) - qualquer valor
-- Min alt - qualquer valor
-- Esses são para CBU 97, 103 E 105