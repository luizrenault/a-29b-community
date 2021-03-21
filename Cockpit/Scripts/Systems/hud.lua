dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."HUD/HUD_ID_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."Systems/weapon_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")
dofile(LockOn_Options.script_path.."Systems/ufcp_nav.lua")

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
}
local WPN = {
    TD_AZIMUTH = get_param_handle("WPN_TD_AZIMUTH"),
    TD_ELEVATION = get_param_handle("WPN_TD_ELEVATION"),
    CCRP_TIME = get_param_handle("WPN_CCRP_TIME"),
    CCRP_TIME_MAX_RANGE = get_param_handle("WPN_CCRP_TIME_MAX_RANGE"),
    WEAPON_RELEASE = get_param_handle("WPN_WEAPON_RELEASE"),
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

local WS_GUN_PIPER_AZIMUTH = get_param_handle("WS_GUN_PIPER_AZIMUTH")
local WS_GUN_PIPER_ELEVATION = get_param_handle("WS_GUN_PIPER_ELEVATION")
-- local WS_GUN_PIPER_SPAN = get_param_handle("WS_GUN_PIPER_SPAN")
local WS_TARGET_RANGE = get_param_handle("WS_TARGET_RANGE")
local CMFD_NAV_FYT_OAP_BRG = get_param_handle("CMFD_NAV_FYT_OAP_BRG")
local CMFD_NAV_FYT_OAP_AZIMUTH = get_param_handle("CMFD_NAV_FYT_OAP_AZIMUTH")
local CMFD_NAV_FYT_OAP_ELEVATION = get_param_handle("CMFD_NAV_FYT_OAP_ELEVATION")
local CMFD_NAV_FYT_OAP_STT = get_param_handle("CMFD_NAV_FYT_OAP_STT")
local CMFD_NAV_FYT_OAP_TTD = get_param_handle("CMFD_NAV_FYT_OAP_TTD")
local CMFD_NAV_FYT_OAP_DT = get_param_handle("CMFD_NAV_FYT_OAP_DT")

local function limit_xy(x, y, limit_x, limit_y, limit_x_down, limit_y_down) 
    limit_x_down = limit_x_down or -limit_x
    limit_y_down = limit_y_down or -limit_y

    local limited_x = false
    local limited_y = false
    if x > limit_x then 
        y = y * limit_x / x
        x = limit_x
        limited_x = true
    end
    if x < limit_x_down then 
        y = y * limit_x_down / x
        x = limit_x_down 
        limited_x = true
    end
    if y > limit_y then 
        x = x * limit_y / y
        y = limit_y 
        limited_y = true
    end
    if y < limit_y_down then 
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

    local az, el, limited
    az, el, limited = limit_xy(WPN_CCIP_PIPER_AZIMUTH:get(), WPN_CCIP_PIPER_ELEVATION:get(), hud_limit.x, hud_limit.y, -hud_limit.x, -hud_limit.y * 1.3)

    HUD_CCIP_PIPER_AZIMUTH:set(az)
    HUD_CCIP_PIPER_ELEVATION:set(el)
    HUD_CCIP_PIPER_HIDDEN:set(limited)

    local roll = math.atan((slide-az) / (vert-el))

    HUD_PIPER_LINE_A_X:set(slide - 0.004 * math.sin(roll))
    HUD_PIPER_LINE_A_Y:set(vert  - 0.004 * math.cos(roll))

    HUD_PIPER_LINE_B_X:set(az + 0.005 * math.sin(roll))
    HUD_PIPER_LINE_B_Y:set(el + 0.005 * math.cos(roll))
end

local function update_piper_lcos()
    local piper_x = WS_GUN_PIPER_AZIMUTH:get()
    local piper_y = WS_GUN_PIPER_ELEVATION:get()
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
    if master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R or get_avionics_master_mode_ag_gun(master_mode) then update_piper_ccip() end
    if get_avionics_master_mode_ag_gun() then
        HUD_RANGE:set(WS_TARGET_RANGE:get())
    else 
        HUD_RANGE:set(-1)
    end
    
end

local function atan(y, x)
    local angle
    x = x or 1
    if x == 0 then
        if y >= 0 then angle = 0 else angle = math.pi end
    else 
        angle = math.atan(y/math.abs(x))
        if x < 0 then angle = math.pi - angle end
    end
    return angle
end

local function update_td()
    local master_mode = get_avionics_master_mode()

    local td_azimuth = WPN.TD_AZIMUTH:get()
    local td_elevation = WPN.TD_ELEVATION:get()
    local td_angle = atan(td_elevation - math.rad(1.2), td_azimuth)
    
    local hud_fyt_azimuth, hud_fyt_elevation, hud_fyt_os, hud_fyt_lim_x, hud_fyt_lim_y = limit_xy(CMFD_NAV_FYT_OAP_AZIMUTH:get(), CMFD_NAV_FYT_OAP_ELEVATION:get(), hud_limit.x, hud_limit.y, -hud_limit.x, -hud_limit.y * 1.3)
    HUD.FYT_AZIMUTH:set(hud_fyt_azimuth)
    HUD.FYT_ELEVATION:set(hud_fyt_elevation)
    HUD.FYT_OS:set(hud_fyt_os)
    HUD.FYT_HIDE:set(0)


    if master_mode == AVIONICS_MASTER_MODE_ID.CCRP and (get_wpn_mass() == WPN_MASS_IDS.SAFE or get_avionics_onground() or (get_wpn_mass() == WPN_MASS_IDS.LIVE and WPN_AG_SEL:get() == 0) or (get_wpn_mass() == WPN_MASS_IDS.SIM and WPN_AG_SEL:get() == 0) ) then
        HUD.CCRP:set(0)
    elseif master_mode == AVIONICS_MASTER_MODE_ID.CCRP then
        HUD.CCRP:set(1)
        HUD.TD_HIDE:set(0)
        HUD.FYT_HIDE:set(1)
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

    local time_to_max_range = WPN.CCRP_TIME_MAX_RANGE:get()
    if time_to_max_range > 0 and time_to_max_range < 2 then
        HUD.MAX_RANGE:set(1)
    elseif time_to_max_range > -2 and time_to_max_range < 0 then
        local blink_time = math.floor(-time_to_max_range * 10)
        if blink_time % 2 == 0 then HUD.MAX_RANGE:set(1) else HUD.MAX_RANGE:set(0) end
    else 
        HUD.MAX_RANGE:set(0)
    end

    local time_to_impact = WPN.CCRP_TIME:get()
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

local hud_warn_period = 0.1
local hud_warn_elapsed = 0
local hud_warning = get_param_handle("HUD_WARNING")

function update()
    local master_mode = get_avionics_master_mode()
    local hud_on = get_elec_avionics_ok() and 1 or 0
    local hud_bright = get_cockpit_draw_argument_value(483)
    if get_cockpit_draw_argument_value(476) == 0 then hud_bright = hud_bright * 0.5 end

    if (get_avionics_master_mode_ag() or get_avionics_master_mode_aa()) and WPN_READY:get() == 1 then HUD_RDY:set(1) 
    elseif (get_avionics_master_mode_ag() or get_avionics_master_mode_aa()) and WPN_SIM_READY:get() == 1 then HUD_RDY:set(2)
    else HUD_RDY:set(0) end

    update_td()

    local hud_warn = get_hud_warning()
    hud_warn_elapsed = hud_warn_elapsed + update_time_step
    if hud_warn == 1 then
        if hud_warn_elapsed > 2* hud_warn_period then
            hud_warning:set(1)
        elseif hud_warn_elapsed > hud_warn_period then 
            hud_warning:set(0)
        end
    else 
        hud_warning:set(0)
    end
    if hud_warn_elapsed > 2* hud_warn_period then
        hud_warn_elapsed = 0
    end
    
    
    local pitch = sensor_data.getPitch()
    local roll = sensor_data.getRoll()
    local hdg = get_avionics_hdg()

    local hdg_des = CMFD_NAV_FYT_OAP_BRG:get()

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

    local speedx, speedy, speedz = sensor_data:getSelfVelocity()
    local speedh=math.sqrt(speedx*speedx + speedz*speedz)
    local anglev
    if speedh == 0 then 
        anglev = 0
    else  
        anglev = math.atan(speedy/speedh)
    end

    local iasx, iasy, iasz = sensor_data.getSelfAirspeed()
    local angleh = math.atan2(iasz, iasx) - math.atan2(speedz, speedx)
    angleh = math.rad(sensor_data.getAngleOfSlide())-angleh

    if HUD_DRIFT_CO:get() == 1 then 
        angleh = 0
    else 
    end

    local fpm_cross = 0        
    angleh, anglev, fpm_cross = limit_xy(angleh, anglev - pitch, hud_limit.x, hud_limit.y)
    anglev = anglev + pitch
   
    local pl_slide = angleh + (anglev-pitch) * math.tan(roll)
    
    local ias = get_avionics_ias()
    if ias == 0 and sensor_data.getWOW_LeftMainLandingGear() > 0 then 
            angleh = 0
            anglev = 0
            pl_slide = 0
    end

    local ias_des = -1
    local nav_time = UFCP_NAV_TIME:get()
    if nav_time == UFCP_NAV_TIME_IDS.DT or nav_time == UFCP_NAV_TIME_IDS.ETA then ias_des = CMFD_NAV_FYT_OAP_STT:get() end
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


    ri_roll = roll
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
    local time_text = ""
    local ttd = CMFD_NAV_FYT_OAP_TTD:get()
    local dt = CMFD_NAV_FYT_OAP_DT:get()

    local ccrp_time = WPN.CCRP_TIME:get() + 1
    if ccrp_time >= 0 then 
        time_text = time_text .. string.format("%02.0f:%02.0f ", math.floor(ccrp_time / 60), math.floor(ccrp_time % 60) )
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
    
    HUD_PITCH:set(pitch - pl_slide*math.sin(roll))
    HUD_ROLL:set(roll)
    HUD_HDG:set(hdg)
    HUD_IAS:set(ias)
    HUD_ALT_K:set(alt_k)
    HUD_ALT_N:set(alt_n)
    HUD_FPM_VERT:set(anglev - pitch)
    HUD_FPM_SLIDE:set(angleh)
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
    dev:performClickableAction(device_commands.UFCP_HUD_BRIGHT,1,true)
    startup_print("hud: postinit end")
end

-- dev:listen_command(device_commands.IcePropeller)
-- dev:listen_command(device_commands.IceWindshield)
-- dev:listen_command(device_commands.IcePitotPri)
-- dev:listen_command(device_commands.IcePitotSec)

function SetCommand(command,value)
    debug_message_to_user("environ: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.UFCP_WARNRST then
        if get_hud_warning() == 0 and value == 1 then 
            max_accel = 0
        end        
    elseif command == iCommandEnginesStart then
    elseif command == iCommandEnginesStop then
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    end
end


startup_print("environ: load end")
need_to_be_closed = false -- close lua state after initialization


