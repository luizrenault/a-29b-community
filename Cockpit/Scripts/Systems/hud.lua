dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."HUD/HUD_ID_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."Systems/weapon_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")

startup_print("hud: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

-- local function round_to(value, roundto)
--     value = value + roundto/2
--     return value - value % roundto
-- end


local HUD_PITCH = get_param_handle("HUD_PITCH")
local HUD_ROLL = get_param_handle("HUD_ROLL")
local HUD_PL_GHOST = get_param_handle("HUD_PL_GHOST")
local HUD_IAS = get_param_handle("HUD_IAS")
local HUD_HDG = get_param_handle("HUD_HDG")
local HUD_ALT_K = get_param_handle("HUD_ALT_K")
local HUD_ALT_N = get_param_handle("HUD_ALT_N")
local HUD_ALT_SCALE_MOVE = get_param_handle("HUD_ALT_SCALE_MOVE")
local HUD_ALT_CUE_MOVE = get_param_handle("HUD_ALT_CUE_MOVE")
local HUD_ALT_CUE_VALUE = get_param_handle("HUD_ALT_CUE_VALUE")
local HUD_VEL_SCALE_MOVE = get_param_handle("HUD_VEL_SCALE_MOVE")
local HUD_VEL_CUE_MOVE = get_param_handle("HUD_VEL_CUE_MOVE")
local HUD_VEL_CUE_VALUE = get_param_handle("HUD_VEL_CUE_VALUE")
local HUD_HDG_SCALE_MOVE = get_param_handle("HUD_HDG_SCALE_MOVE")
local HUD_HDG_CUE_MOVE = get_param_handle("HUD_HDG_CUE_MOVE")
local HUD_HDG_CUE_VALUE = get_param_handle("HUD_HDG_CUE_VALUE")
local HUD_VS_CUE_MOVE = get_param_handle("HUD_VS_CUE_MOVE")
local HUD_FPM_SLIDE = get_param_handle("HUD_FPM_SLIDE")
local HUD_FPM_VERT = get_param_handle("HUD_FPM_VERT")
local HUD_PL_SLIDE = get_param_handle("HUD_PL_SLIDE")
local HUD_RI_ROLL = get_param_handle("HUD_RI_ROLL")

local UFCP_RALT_SWITCH_STATE = get_param_handle("UFCP_RALT_SWITCH_STATE")

local HUD = {
    CCRP = get_param_handle("HUD_CCRP"),
    FYT_AZIMUTH = get_param_handle("HUD_FYT_AZIMUTH"),
    FYT_ELEVATION = get_param_handle("HUD_FYT_ELEVATION"),
    FYT_OS = get_param_handle("HUD_FYT_OS"),
    FYT_HIDE = get_param_handle("HUD_FYT_HIDE"),
    TD_AZIMUTH = get_param_handle("HUD_TD_AZIMUTH"),
    TD_ELEVATION = get_param_handle("HUD_TD_ELEVATION"),
    TD_OS = get_param_handle("HUD_TD_OS"),
    TD_HIDE = get_param_handle("HUD_TD_HIDE"),
    TD_ANGLE = get_param_handle("HUD_TD_ANGLE"),
    MAX_RANGE = get_param_handle("HUD_MAX_RANGE"),
    SL_AZIMUTH = get_param_handle("HUD_SL_AZIMUTH"),
    SI_ELEVATION = get_param_handle("HUD_SI_ELEVATION"),
    SI_HIDE = get_param_handle("HUD_SI_HIDE"),
    EGIR = get_param_handle("HUD_EGIR"),
    CCIP_DELAYED_AZIMUTH = get_param_handle("HUD_CCIP_DELAYED_AZIMUTH"),
    CCIP_DELAYED_ELEVATION = get_param_handle("HUD_CCIP_DELAYED_ELEVATION"),
    TIME_TO_IMPACT = get_param_handle("HUD_TIME_TO_IMPACT"),

    OAP_HIDE = get_param_handle("HUD_OAP_HIDE"),
    OAP_OS = get_param_handle("HUD_OAP_OS"),
    OAP_AZIMUTH = get_param_handle("HUD_OAP_AZIMUTH"),
    OAP_ELEVATION = get_param_handle("HUD_OAP_ELEVATION"),

}
local WPN = {
    TD_AZIMUTH = get_param_handle("WPN_TD_AZIMUTH"),
    TD_ELEVATION = get_param_handle("WPN_TD_ELEVATION"),
    CCRP_TIME = get_param_handle("WPN_CCRP_TIME"),
    TIME_MAX_RANGE = get_param_handle("WPN_TIME_MAX_RANGE"),
    WEAPON_RELEASE = get_param_handle("WPN_WEAPON_RELEASE"),
    CCIP_DELAYED_TIME = get_param_handle("WPN_CCIP_DELAYED_TIME"),
    CCIP_DELAYED = get_param_handle("WPN_CCIP_DELAYED"),
    TIME_TO_IMPACT = get_param_handle("WPN_TIME_TO_IMPACT"),
}

local CMFD = {
    NAV_OAP_AZIMUTH = get_param_handle("CMFD_NAV_OAP_AZIMUTH"),
    NAV_OAP_ELEVATION = get_param_handle("CMFD_NAV_OAP_ELEVATION"),
}

local UFCP = {
    OAP_ENABLED = get_param_handle("UFCP_OAP") -- 0disabled 1enabled
}

-- Visuals
local HUD_DRIFT_CO = get_param_handle("HUD_DRIFT_CO")
local HUD_DCLT = get_param_handle("HUD_DCLT")
local HUD_FPM_CROSS = get_param_handle("HUD_FPM_CROSS")

local HUD_NORMAL_ACCEL = get_param_handle("HUD_NORMAL_ACCEL")
local HUD_MAX_ACCEL = get_param_handle("HUD_MAX_ACCEL")
local HUD_RDY = get_param_handle("HUD_RDY")
local HUD_DOI = get_param_handle("HUD_DOI")
local HUD_RADAR_ALT = get_param_handle("HUD_RADAR_ALT")
local HUD_RANGE = get_param_handle("HUD_RANGE")
local HUD_TIME = get_param_handle("HUD_TIME")
local HUD_FTI_DIST = get_param_handle("HUD_FTI_DIST")
local HUD_FTI_NUM = get_param_handle("HUD_FTI_NUM")
local HUD_VOR_DIST = get_param_handle("HUD_VOR_DIST")
local HUD_VOR_MAG = get_param_handle("HUD_VOR_MAG")
local HUD_MACH = get_param_handle("HUD_MACH")


local HUD_AOA = get_param_handle("HUD_AOA")
local HUD_AOA_DELTA = get_param_handle("HUD_AOA_DELTA")
local HUD_PL = get_param_handle("HUD_PL")

local HUD_ON = get_param_handle("HUD_ON")

local HUD_BRIGHT = get_param_handle("HUD_BRIGHT")

local CMFDDoi = get_param_handle("CMFDDoi")

local hud_piper_diameter = math.rad(1.8)
local hud_limit = {
    x= math.rad(6),
    y = math.rad(6)
}

local HUD_PIPER_LINE_A_X = get_param_handle("HUD_PIPER_LINE_A_X")
local HUD_PIPER_LINE_A_Y = get_param_handle("HUD_PIPER_LINE_A_Y")
local HUD_PIPER_LINE_B_X = get_param_handle("HUD_PIPER_LINE_B_X")
local HUD_PIPER_LINE_B_Y = get_param_handle("HUD_PIPER_LINE_B_Y")
local HUD_PIPER_LINE_C_X = get_param_handle("HUD_PIPER_LINE_C_X")
local HUD_PIPER_LINE_C_Y = get_param_handle("HUD_PIPER_LINE_C_Y")
local HUD_PIPER_X = get_param_handle("HUD_PIPER_X")
local HUD_PIPER_Y = get_param_handle("HUD_PIPER_Y")
local HUD_PIPER_HIDDEN = get_param_handle("HUD_PIPER_HIDDEN")
local HUD_IR_MISSILE_TARGET_AZIMUTH = get_param_handle("HUD_IR_MISSILE_TARGET_AZIMUTH")
local HUD_IR_MISSILE_TARGET_ELEVATION = get_param_handle("HUD_IR_MISSILE_TARGET_ELEVATION")
local HUD_MSL_HIDDEN = get_param_handle("HUD_MSL_HIDDEN")

local HUD_CCIP_PIPER_AZIMUTH = get_param_handle("HUD_CCIP_PIPER_AZIMUTH")
local HUD_CCIP_PIPER_ELEVATION = get_param_handle("HUD_CCIP_PIPER_ELEVATION")
local HUD_CCIP_PIPER_HIDDEN = get_param_handle("HUD_CCIP_PIPER_HIDDEN")
local HUD_CCIP_DELAYED = get_param_handle("HUD_CCIP_DELAYED")

local WS_GUN_PIPER_AZIMUTH = get_param_handle("WS_GUN_PIPER_AZIMUTH")
local WS_GUN_PIPER_ELEVATION = get_param_handle("WS_GUN_PIPER_ELEVATION")
-- local WS_GUN_PIPER_SPAN = get_param_handle("WS_GUN_PIPER_SPAN")
local WS_TARGET_RANGE = get_param_handle("WS_TARGET_RANGE")
local CMFD_NAV_FYT_DTK_BRG = get_param_handle("CMFD_NAV_FYT_DTK_BRG")
local CMFD_NAV_FYT_DTK_AZIMUTH = get_param_handle("CMFD_NAV_FYT_DTK_AZIMUTH")
local CMFD_NAV_FYT_DTK_ELEVATION = get_param_handle("CMFD_NAV_FYT_DTK_ELEVATION")
local CMFD_NAV_FYT_DTK_STT = get_param_handle("CMFD_NAV_FYT_DTK_STT")
local CMFD_NAV_FYT_DTK_TTD = get_param_handle("CMFD_NAV_FYT_DTK_TTD")
local CMFD_NAV_FYT_DTK_DT = get_param_handle("CMFD_NAV_FYT_DTK_DT")

local function limit_xy(x, y, limit_x, limit_y, limit_x_down, limit_y_down) 
    limit_x_down = limit_x_down or -limit_x
    limit_y_down = limit_y_down or -limit_y

    local limited_x = false
    local limited_y = false

    if (x > limit_x) and (y <= limit_y / limit_x * x) and (y >= limit_y_down / limit_x * x) then 
        y = y * limit_x / x
        x = limit_x
        limited_x = true
    end
    
    if (x < limit_x_down)  and (y <= limit_y / limit_x_down * x) and (y >= limit_y_down / limit_x_down * x) then 
        y = y * limit_x_down / x
        x = limit_x_down 
        limited_x = true
    end

    if (y > limit_y) and (x < limit_x / limit_y * y) and (x > limit_x_down / limit_y * y) then 
        x = x * limit_y / y
        y = limit_y 
        limited_y = true
    end
    
    if (y < limit_y_down) and (x < limit_x / limit_y_down * y) and (x > limit_x_down / limit_y_down * y) then 
        x = x * limit_y_down / y
        y = limit_y_down 
        limited_y = true
    end
    
    local limited = (limited_x or limited_y) and 1 or 0
    return x, y, limited, limited_x, limited_y
end

local function update_piper_ccip()
    local slide = HUD_FPM_SLIDE:get()
    local vert = HUD_FPM_VERT:get()

    local az = WPN_CCIP_PIPER_AZIMUTH:get() 
    local el = WPN_CCIP_PIPER_ELEVATION:get()
    local limited

    --if WPN_SELECTED_WEAPON_TYPE:get() == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then az = az + slide end
    local roll = sensor_data:getRoll()
    local s=math.sin(roll)
    local c=math.cos(roll)

    local az1 = az-- * c - el * s
    local el1 = el-- * c + az * s
    az1 = az1 - slide
    el1 = el1 - vert
    
    local size = math.sqrt(az1 * az1 + el1 * el1)
    az1, el1, limited = limit_xy(az1, el1, hud_limit.x - slide, hud_limit.y - vert, -hud_limit.x - slide, -hud_limit.y * 1.3 - vert)

    az = az1 + slide
    el = el1 + vert

    HUD_CCIP_PIPER_AZIMUTH:set(az)
    HUD_CCIP_PIPER_ELEVATION:set(el)
    HUD_CCIP_PIPER_HIDDEN:set(limited)

    HUD_CCIP_DELAYED:set(WPN.CCIP_DELAYED:get())

    roll = math.atan2(-az1 , -el1)
    s=math.sin(roll)
    c=math.cos(roll)
    
    HUD_PIPER_LINE_A_X:set(slide - 0.004 * s)
    HUD_PIPER_LINE_A_Y:set(vert  - 0.004 * c)

    HUD_PIPER_LINE_B_X:set(az + 0.005 * s)
    HUD_PIPER_LINE_B_Y:set(el + 0.005 * c)

    HUD.CCIP_DELAYED_AZIMUTH:set(az + 0.015 * s )
    HUD.CCIP_DELAYED_ELEVATION:set(el + 0.015 * c )
end

local function global_az_el_to_cockpit(az, el)
    local p_roll = sensor_data.getRoll()
    local s = math.sin(p_roll)
    local c = math.sin(p_roll)

    local az1 = az * c - el * s
    local el1 = az * s + el * c
    return az1, el1
end

local function update_piper_lcos()
    
    local piper_x = WS_GUN_PIPER_AZIMUTH:get()
    local piper_y = WS_GUN_PIPER_ELEVATION:get() 

    piper_y = piper_y - math.rad(1)*1.2

    piper_x = piper_x * 0.75
    piper_y = piper_y * 0.75

    local limited = false
    piper_x, piper_y, limited = limit_xy(piper_x, piper_y, hud_limit.x, hud_limit.y)
    local piper_dist = math.sqrt(piper_x*piper_x + piper_y*piper_y)
    local piper_line_x, piper_line_y

    if piper_dist ~= 0 then 
        if  piper_dist > hud_piper_diameter/2 then
            piper_line_x = piper_x - hud_piper_diameter/2*piper_x/piper_dist
            piper_line_y = piper_y - hud_piper_diameter/2*piper_y/piper_dist
            HUD_PIPER_LINE_A_X:set(piper_line_x)
            HUD_PIPER_LINE_A_Y:set(piper_line_y)
        else 
            HUD_PIPER_LINE_A_X:set(0)
            HUD_PIPER_LINE_A_Y:set(0)
        end
        piper_line_x = piper_x + hud_piper_diameter/2*piper_x/piper_dist
        piper_line_y = piper_y + hud_piper_diameter/2*piper_y/piper_dist
        HUD_PIPER_LINE_B_X:set(piper_line_x)
        HUD_PIPER_LINE_B_Y:set(piper_line_y)
        piper_line_x = piper_x + hud_piper_diameter*piper_x/piper_dist
        piper_line_y = piper_y + hud_piper_diameter*piper_y/piper_dist
        HUD_PIPER_LINE_C_X:set(piper_line_x)
        HUD_PIPER_LINE_C_Y:set(piper_line_y)
    else 
        HUD_PIPER_LINE_A_X:set(0)
        HUD_PIPER_LINE_A_Y:set(0)
        HUD_PIPER_LINE_B_X:set(0)
        HUD_PIPER_LINE_B_Y:set(0)
        HUD_PIPER_LINE_C_X:set(0)
        HUD_PIPER_LINE_C_Y:set(0)
    end

    HUD_PIPER_X:set(piper_x)
    HUD_PIPER_Y:set(piper_y)
    HUD_PIPER_HIDDEN:set(limited)
end

local function update_piper_snap()
    local bullet_speed = 1000 -- m/s
    local piper_x = WS_GUN_PIPER_AZIMUTH:get()
    local piper_y = WS_GUN_PIPER_ELEVATION:get()
    local limited = false
    local time_to_piper = WS_TARGET_RANGE:get() / bullet_speed

    -- piper_x, piper_y, limited = limit_xy(piper_x, piper_y, hud_limit.x, hud_limit.y)

    local piper_dist = math.sqrt(piper_x*piper_x + piper_y*piper_y)
    local piper_line_x = 0
    local piper_line_y = 0

    if time_to_piper ~= 0 then 
        piper_line_x = piper_x * 0.5 / time_to_piper
        piper_line_y = piper_y * 0.5 / time_to_piper
        HUD_PIPER_LINE_A_X:set(piper_line_x)
        HUD_PIPER_LINE_A_Y:set(piper_line_y)
        piper_line_x = piper_x * 0.5 / time_to_piper
        piper_line_y = piper_y * 0.5 / time_to_piper
        HUD_PIPER_LINE_B_X:set(piper_line_x)
        HUD_PIPER_LINE_B_Y:set(piper_line_y)
        piper_line_x = piper_x * 0.5 / time_to_piper
        piper_line_y = piper_y * 0.5 / time_to_piper
        HUD_PIPER_LINE_C_X:set(piper_line_x)
        HUD_PIPER_LINE_C_Y:set(piper_line_y)
    else 
        HUD_PIPER_LINE_A_X:set(0)
        HUD_PIPER_LINE_A_Y:set(0)
        HUD_PIPER_LINE_B_X:set(0)
        HUD_PIPER_LINE_B_Y:set(0)
        HUD_PIPER_LINE_C_X:set(0)
        HUD_PIPER_LINE_C_Y:set(0)
    end

    if time_to_piper > 1.5 then 
        piper_x = piper_x * 1.5 / time_to_piper
        piper_y = piper_y * 1.5 / time_to_piper
    end

    HUD_PIPER_X:set(piper_x)
    HUD_PIPER_Y:set(piper_y)
    HUD_PIPER_HIDDEN:set(limited)
end


local function update_aa()
    local wpn_aa_sight = WPN_AA_SIGHT:get()
    if  wpn_aa_sight == WPN_AA_SIGHT_IDS.LCOS or wpn_aa_sight == WPN_AA_SIGHT_IDS.SSLC then update_piper_lcos() end
    if  wpn_aa_sight == WPN_AA_SIGHT_IDS.SNAP or wpn_aa_sight == WPN_AA_SIGHT_IDS.SSLC then update_piper_snap() end
    local master_mode = get_avionics_master_mode()

    local msl_az = WS_IR_MISSILE_TARGET_AZIMUTH:get()
    local msl_el = WS_IR_MISSILE_TARGET_ELEVATION:get()
    local msl_hidden
    msl_az, msl_el, msl_hidden = limit_xy(msl_az, msl_el, hud_limit.x, hud_limit.y)
    HUD_IR_MISSILE_TARGET_AZIMUTH:set(msl_az)
    HUD_IR_MISSILE_TARGET_ELEVATION:set(msl_el)
    HUD_MSL_HIDDEN:set(msl_hidden)


    if master_mode == AVIONICS_MASTER_MODE_ID.DGFT_L or master_mode == AVIONICS_MASTER_MODE_ID.DGFT_B then
        HUD_RANGE:set(WS_TARGET_RANGE:get())
        if get_wpn_aa_msl_ready() then
        end
    else 
        HUD_RANGE:set(-1)
    end
    
end

local function update_ag()
    local master_mode = get_avionics_master_mode()
    if master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R or get_avionics_master_mode_ag_gun(master_mode) then 
        update_piper_ccip() 
    end
    if get_avionics_master_mode_ag_gun() then
        HUD_RANGE:set(WS_TARGET_RANGE:get())
    else 
        HUD_RANGE:set(-1)
    end
    
end

local function update_oap()
    if (UFCP.OAP_ENABLED:get() == 1) and (HUD.FYT_HIDE:get() == 0 or HUD.TD_HIDE:get() == 0) then
        local oap_azimuth = CMFD.NAV_OAP_AZIMUTH:get()
        local oap_elevation = CMFD.NAV_OAP_ELEVATION:get()
        local oap_angle = math.atan2(oap_elevation - math.rad(1.2), oap_azimuth)
        
        local hud_oap_azimuth, hud_oap_elevation, hud_oap_os = limit_xy(CMFD.NAV_OAP_AZIMUTH:get(), CMFD.NAV_OAP_ELEVATION:get(), hud_limit.x, hud_limit.y, -hud_limit.x, -hud_limit.y * 1.3)
        HUD.OAP_AZIMUTH:set(hud_oap_azimuth)
        HUD.OAP_ELEVATION:set(hud_oap_elevation)
        HUD.OAP_OS:set(hud_oap_os)
        HUD.OAP_HIDE:set(0)
    else
        HUD.OAP_HIDE:set(1)
    end
end

local function update_td()
    local master_mode = get_avionics_master_mode()

    local td_azimuth = WPN.TD_AZIMUTH:get()
    local td_elevation = WPN.TD_ELEVATION:get()
    local td_angle = math.atan2(td_elevation - math.rad(1.2), td_azimuth)
    
    local hud_fyt_azimuth, hud_fyt_elevation, hud_fyt_os, hud_fyt_lim_x, hud_fyt_lim_y = limit_xy(CMFD_NAV_FYT_DTK_AZIMUTH:get(), CMFD_NAV_FYT_DTK_ELEVATION:get(), hud_limit.x, hud_limit.y, -hud_limit.x, -hud_limit.y * 1.3)
    HUD.FYT_AZIMUTH:set(hud_fyt_azimuth)
    HUD.FYT_ELEVATION:set(hud_fyt_elevation)
    HUD.FYT_OS:set(hud_fyt_os)
    HUD.FYT_HIDE:set(0)

    local time_to_impact = WPN.CCRP_TIME:get()

    if master_mode == AVIONICS_MASTER_MODE_ID.CCRP and (get_wpn_mass() == WPN_MASS_IDS.SAFE or get_avionics_onground() or (get_wpn_mass() == WPN_MASS_IDS.LIVE and WPN_AG_SEL:get() == 0) or (get_wpn_mass() == WPN_MASS_IDS.SIM and WPN_AG_SEL:get() == 0) ) then
        HUD.CCRP:set(0)
    elseif master_mode == AVIONICS_MASTER_MODE_ID.CCRP then
        HUD.CCRP:set(1)
        HUD.TD_HIDE:set(0)
        HUD.FYT_HIDE:set(1)
    elseif (master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R) and WPN.CCIP_DELAYED:get() == 1 then
        HUD.CCRP:set(1)
        time_to_impact = WPN.CCIP_DELAYED_TIME:get()
        HUD.TD_HIDE:set(0)
    elseif get_avionics_master_mode_aa() then
        HUD.CCRP:set(0)
        HUD.FYT_HIDE:set(1)
    else
        HUD.CCRP:set(0)
    end

    local hud_td_azimuth, hud_td_elevation, hud_td_lim, hud_td_lim_x, hud_td_lim_y = limit_xy(td_azimuth, td_elevation, hud_limit.x, hud_limit.y, -hud_limit.x, -hud_limit.y * 1.3)
   
    HUD.TD_AZIMUTH:set(hud_td_azimuth)
    HUD.TD_ELEVATION:set(hud_td_elevation)
    HUD.TD_OS:set(hud_td_lim_y and 1 or 0)
    HUD.TD_ANGLE:set(td_angle)
    HUD.TD_HIDE:set(hud_td_lim_x and 1 or 0) 
    HUD.SL_AZIMUTH:set(td_azimuth + td_elevation * math.sin(sensor_data.getRoll()))

    local time_to_max_range = WPN.TIME_MAX_RANGE:get()
    if time_to_max_range > 0 and time_to_max_range < 2 then
        HUD.MAX_RANGE:set(1)
    elseif time_to_max_range > -2 and time_to_max_range < 0 then
        local blink_time = math.floor(-time_to_max_range * 10)
        if blink_time % 2 == 0 then HUD.MAX_RANGE:set(1) else HUD.MAX_RANGE:set(0) end
    else 
        HUD.MAX_RANGE:set(0)
    end

    if time_to_impact > 5 then time_to_impact = 5 end

    if WPN.WEAPON_RELEASE:get() == 1 or time_to_max_range <= 2 then
        HUD.SI_HIDE:set(0)
    elseif time_to_max_range > 2 then 
        HUD.SI_HIDE:set(1)
    end
    HUD.SI_ELEVATION:set(HUD_FPM_VERT:get() - 0.0025 + time_to_impact/100)
end


HUD_DCLT:set(0)
HUD_DRIFT_CO:set(0)
UFCP_VAH:set(0)

local max_accel = 0

local hud_warning = get_param_handle("HUD_WARNING")

local time_elapsed = 0
local function blinking(period, duty_cycle, offset)
    period = period or 0.5
    duty_cycle = duty_cycle or 0.5
    offset = offset or 0

    local period_elapsed = ((time_elapsed + offset) % period) / period
    if period_elapsed > duty_cycle then return false
    else return true end
end

function update()
    time_elapsed = (time_elapsed + update_time_step) % 3600

    local master_mode = get_avionics_master_mode()
    local hud_on = get_elec_avionics_ok() and 1 or 0
    local hud_bright = 1-get_cockpit_draw_argument_value(483)
    if get_cockpit_draw_argument_value(476) == -1 then hud_bright = hud_bright * 0.5 end

    if (get_avionics_master_mode_ag() or get_avionics_master_mode_aa()) and WPN_READY:get() == 1 then HUD_RDY:set(1) 
    elseif (get_avionics_master_mode_ag() or get_avionics_master_mode_aa()) and WPN_SIM_READY:get() == 1 then HUD_RDY:set(2)
    else HUD_RDY:set(0) end

    update_td()
    update_oap()

    hud_warning:set((get_hud_warning() == 1 and blinking(0.2, 0.5)) and 1 or 0)


    local hdg = get_avionics_hdg()

    local hdg_des = CMFD_NAV_FYT_DTK_BRG:get()

    if get_avionics_master_mode_aa() then hdg_des = -1 end
    local hdg_dif = (hdg_des - hdg)
    if hdg_dif > 180 then hdg_dif = -360 + hdg_dif end
    if hdg_dif < -180 then hdg_dif = 360 + hdg_dif end 
    if hdg_dif > 15 then hdg_dif = 15 end
    if hdg_dif < -15 then hdg_dif = -15 end
    
    HUD_HDG_CUE_MOVE:set(hdg_dif)
    HUD_HDG_CUE_VALUE:set(round_to(hdg_des, 1))
    HUD_HDG_SCALE_MOVE:set(hdg % 10)
    for i = 1,4 do
        local param = get_param_handle("HUD_HDG_SCALE_NUM_"..i)
        local value = round_to(hdg/10 - 1*(2.5-i), 1)%36
        if value < 0 then value = 35 end
        param:set(value)
    end

    hdg = round_to(hdg,1)

    local altitude =sensor_data.getBarometricAltitude()*3.2808399

    local altitude_des = -1000

    if master_mode == AVIONICS_MASTER_MODE_ID.LANDING then altitude_des = -1000 end
    local altitude_dif = altitude_des - altitude
    if altitude_dif > 800 then altitude_dif = 800 end
    if altitude_dif < -800 then altitude_dif = -800 end
    HUD_ALT_CUE_MOVE:set(altitude_dif)
    HUD_ALT_CUE_VALUE:set(round_to(altitude_des/1000, 0.1))
    if master_mode == AVIONICS_MASTER_MODE_ID.LANDING then
        HUD_ALT_SCALE_MOVE:set((altitude*5 - 250) % 500)
        for i = 1,4 do
            local param = get_param_handle("HUD_ALT_SCALE_NUM_"..i)
            param:set(round_to(altitude/1000 - 0.1*(3-i), 0.1))
        end
    else
        HUD_ALT_SCALE_MOVE:set((altitude - 250) % 500)
        for i = 1,4 do
            local param = get_param_handle("HUD_ALT_SCALE_NUM_"..i)
            param:set(round_to(altitude/1000 - 0.5*(3-i), 0.5))
        end
    end


    local pitch = math.deg(sensor_data.getPitch())
    if pitch > 10 then pl_ghost = 1
    elseif pitch < -10 then pl_ghost = -1
    else pl_ghost = 0 end

    if master_mode == AVIONICS_MASTER_MODE_ID.DGFT_B or master_mode == AVIONICS_MASTER_MODE_ID.DGFT_L then 
        HUD_PL:set(0)
    else
        HUD_PL:set(1)
    end

    local vs = get_avionics_vv()
    if vs > 2000 then vs = 2000 end 
    if vs < -2000 then vs = -2000 end 
    HUD_VS_CUE_MOVE:set(vs)


    altitude = round_to(altitude,10)
    local alt_k = math.floor(altitude/1000)
    local alt_n = altitude%1000

    -----------------------------------------------------
    local v_x, v_y, v_z = sensor_data:getSelfVelocity()

    local v = math.sqrt( v_x * v_x + v_y * v_y + v_z * v_z)

    local v_hdg = math.atan2(v_z, v_x)
    
    local v_pitch = 0

    if v ~= 0 then
        v_pitch = math.asin(v_y / v)
    end

    local p_pitch, p_roll, p_hdg
    p_pitch = sensor_data:getPitch()
    p_roll = sensor_data:getRoll()
    p_hdg = 2*math.pi - sensor_data:getHeading()
    local dif_hdg = (v_hdg - p_hdg) % (2*math.pi)
    if dif_hdg > math.pi then dif_hdg = dif_hdg - 2 * math.pi end

    local fpm_x = (dif_hdg) * math.cos(p_roll) - (-p_pitch + v_pitch) * math.sin(p_roll)
    local fpm_y = (-p_pitch + v_pitch) * math.cos(p_roll) + (dif_hdg) * math.sin(p_roll)


    if UFCP_DRIFT_CO:get() == 1 then 
        fpm_x = 0
    end

    local fpm_cross = 0        
    fpm_x, fpm_y, fpm_cross = limit_xy(fpm_x, fpm_y, hud_limit.x, hud_limit.y*1.3)

    local pl_slide = fpm_x + fpm_y * math.tan(p_roll)
    -----------------------------------------------------
    
    local ias = get_avionics_ias()
    if ias == 0 and sensor_data.getWOW_LeftMainLandingGear() > 0 then 
            fpm_x = 0
            fpm_y = 0
            pl_slide = 0
    end

    local ias_des = -1
    local nav_time = UFCP_NAV_TIME:get()
    if nav_time == UFCP_NAV_TIME_IDS.DT or nav_time == UFCP_NAV_TIME_IDS.ETA then ias_des = CMFD_NAV_FYT_DTK_STT:get() end
    if ias_des > 990 then ias_des = 990 end

    if master_mode == AVIONICS_MASTER_MODE_ID.LANDING then ias_des = -1 end

    local ias_dif = ias_des - ias
    if ias_dif > 30 then ias_dif = 30 end
    if ias_dif < -30 then ias_dif = -30 end
    HUD_VEL_CUE_MOVE:set(ias_dif)
    HUD_VEL_CUE_VALUE:set(round_to(ias_des/10, 1))
    
    HUD_VEL_SCALE_MOVE:set((ias - 10) % 20)
    for i = 1,4 do
        local param = get_param_handle("HUD_VEL_SCALE_NUM_"..i)
        param:set(round_to(ias/10 - 2*(3-i), 2))
    end

    ri_roll = p_roll
    if ri_roll > math.rad(50) then 
        ri_roll = math.rad(50)
    elseif ri_roll < math.rad(-50) then
        ri_roll = math.rad(-50)
    end

    local normal_accel = sensor_data.getVerticalAcceleration()
    if normal_accel > max_accel then max_accel = normal_accel end
    local max_accel_val = max_accel

    if CMFDDoi:get() == 0 then hud_doi = 1 else hud_doi = 0 end

    local radar_alt = get_avionics_ralt()
    if UFCP_RALT_SWITCH_STATE:get() == 0 then radar_alt = -1 end
    local time_text = ""
    local ttd = CMFD_NAV_FYT_DTK_TTD:get()
    local dt = CMFD_NAV_FYT_DTK_DT:get()
    local tti = HUD.TIME_TO_IMPACT:get()
    local ccrp_time = WPN.CCRP_TIME:get()
    
    if (master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R or master_mode == AVIONICS_MASTER_MODE_ID.CCRP) and tti >= 0 then
        time_text = time_text .. string.format("¨\t %2.0f", math.floor(tti))
        HUD.TIME_TO_IMPACT:set(tti - update_time_step)
    elseif  master_mode == AVIONICS_MASTER_MODE_ID.CCRP then
        time_text = time_text .. string.format("%02.0f:%02.0f ", math.floor(ccrp_time / 60), math.floor(ccrp_time % 60) )
    elseif (master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R) and WPN.CCIP_DELAYED:get() == 1 then
        ccrp_time = WPN.CCIP_DELAYED_TIME:get()
        time_text = time_text .. string.format("%02.0f:%02.0f ", math.floor(ccrp_time / 60), math.floor(ccrp_time % 60) )
    elseif (master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R) then
    elseif nav_time == UFCP_NAV_TIME_IDS.DT then
        if dt >= 0 then time_text = "A" else time_text = "D" end
        dt = math.abs(dt)
        if dt >= 100*60 then dt = 100*60-1 end
        time_text = time_text .. string.format("%02.0f:%02.0f ", math.floor(dt / 60), math.floor(dt % 60) )
    elseif nav_time == UFCP_NAV_TIME_IDS.TTD then
        if ttd >= 100*60 then ttd = 100*60-1 end
        time_text = string.format("%02.0f:%02.0f", math.floor(ttd / 60), math.floor(ttd % 60) )
    elseif nav_time == UFCP_NAV_TIME_IDS.ETA then
        local tot = get_absolute_model_time() + ttd
        if tot > 24*3600 then tot=24*3600-1 end
        time_text = string.format("%02.0f:%02.0f:%02.0f", math.floor(tot / 3600), math.floor((tot % 3600) / 60), math.floor(tot % 60) )
    end
    
    local fti_dist = -1
    local fti_num = 0
    fti_dist = round_to(fti_dist, 0.1)

    local vor_dist = -1
    local vor_mag = 270

    local mach = round_to(sensor_data.getMachNumber(), 0.01)
    if master_mode == AVIONICS_MASTER_MODE_ID.LANDING and not get_avionics_onground() then 
        mach = -1 
        max_accel_val = -1
    end

    local aoa = math.deg(sensor_data.getAngleOfAttack())
    if aoa < -9 then aoa = -9 end
    if aoa > 40 then aoa = 40 end
    local aoa_delta = aoa - 4.5
    
    local egi_state = UFCP_EGI.EGI_STATE:get()
    if egi_state == UFCP_EGI_STATE_IDS.OFF then HUD.EGIR:set(0)
    elseif egi_state == UFCP_EGI_STATE_IDS.ALIGNING then HUD.EGIR:set(-1)
    elseif egi_state == UFCP_EGI_STATE_IDS.ALIGNED_COARSE then HUD.EGIR:set(1)
    elseif egi_state == UFCP_EGI_STATE_IDS.ALIGNED then HUD.EGIR:set(blinking() and 1 or -1)
    elseif egi_state == UFCP_EGI_STATE_IDS.NAV or egi_state == UFCP_EGI_STATE_IDS.NAV_COARSE then HUD.EGIR:set(-1)
    end

    HUD_PITCH:set(p_pitch - pl_slide*math.sin(p_roll))
    HUD_ROLL:set(p_roll)
    HUD_HDG:set(math.deg(p_hdg))
    HUD_IAS:set(ias)
    HUD_ALT_K:set(alt_k)
    HUD_ALT_N:set(alt_n)
    HUD_FPM_VERT:set(fpm_y)
    HUD_FPM_SLIDE:set(fpm_x)
    HUD_FPM_CROSS:set(fpm_cross)
    HUD_PL_SLIDE:set(pl_slide)
    HUD_PL_GHOST:set(pl_ghost) 
    HUD_RI_ROLL:set(ri_roll) 

    HUD_NORMAL_ACCEL:set(normal_accel)
    HUD_MAX_ACCEL:set(max_accel_val)
    
    HUD_DOI:set(hud_doi)

    HUD_RADAR_ALT:set(radar_alt) 
    
    HUD_TIME:set(time_text) 
    
    HUD_FTI_DIST:set(fti_dist) 
    HUD_FTI_NUM:set(fti_num) 

    HUD_VOR_DIST:set(vor_dist) 
    HUD_VOR_MAG:set(vor_mag) 

    HUD_MACH:set(mach)
    
    HUD_AOA:set(aoa)
    HUD_AOA_DELTA:set(aoa_delta)

    HUD_ON:set(hud_on)

    HUD_BRIGHT:set(hud_bright)

    if get_avionics_master_mode_aa() then update_aa() end
    if get_avionics_master_mode_ag() then update_ag() end

    
end

function post_initialize()
    startup_print("hud: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end
    dev:performClickableAction(device_commands.UFCP_HUD_BRIGHT,0,true)
    startup_print("hud: postinit end")
end

local iCommandHUDBrightnessUp = 746
local iCommandHUDBrightnessDown = 747
dev:listen_command(iCommandHUDBrightnessUp)
dev:listen_command(iCommandHUDBrightnessDown)

function SetCommand(command,value)
    debug_message_to_user("environ: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.UFCP_WARNRST then
        if get_hud_warning() == 0 and value == 1 then 
            max_accel = 0
        end        
    elseif command == iCommandHUDBrightnessUp then
        value = get_cockpit_draw_argument_value(483) - 0.05
        if value > 1 then value = 1 end
        dev:performClickableAction(device_commands.UFCP_HUD_BRIGHT, value, true)
    elseif command == iCommandHUDBrightnessDown then
        value = get_cockpit_draw_argument_value(483) + 0.05
        if value < 0 then value = 0 end
        dev:performClickableAction(device_commands.UFCP_HUD_BRIGHT, value, true)
    end
end


startup_print("environ: load end")
need_to_be_closed = false -- close lua state after initialization


