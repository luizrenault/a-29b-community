local adhsi_ap_flash = 0
local adhsi_ap_status_old = 0
local adhsi_ap_status = 0
local adhsi_ap_ovrd = 0
local adhsi_ap_elapsed = 0
local adhsi_ap_period = 0.4

local adhsi_turnrate_elapsed = 0
local adhsi_turnrate_period = 0.4
local adhsi_turnrate_on = 0
local adhsi_rad_sel = 20
local adhsi_hdg_sel = 0
local adhsi_cdi = 0
local adhsi_cdi_show = 0
local adhsi_dtk = 0
local adhsi_dtk_hdg = -1
local adhsi_dtk_dist = 0
local adhsi_fyt_dtk_hdg = -1
local adhsi_fyt_dtk_dist = 0
local adhsi_ans_mode = 0
local adhsi_vor_hdg = -1
local adhsi_adf_hdg = -1
local adhsi_gps_hdg = -1


local ADHSI_VV_LIM = get_param_handle("ADHSI_VV_LIM")
local ADHSI_AP = get_param_handle("ADHSI_AP")
local ADHSI_ROLL = get_param_handle("ADHSI_ROLL")
local ADHSI_PITCH = get_param_handle("ADHSI_PITCH")
local ADHSI_TURN_RATE = get_param_handle("ADHSI_TURN_RATE")
local ADHSI_TURN_RATE_ON = get_param_handle("ADHSI_TURN_RATE_ON")
local ADHSI_RAD_SEL = get_param_handle("ADHSI_RAD_SEL")
local ADHSI_HDG_SEL = get_param_handle("ADHSI_HDG_SEL")
local ADHSI_VOR_HDG = get_param_handle("ADHSI_VOR_HDG")
local ADHSI_GPS_HDG = get_param_handle("ADHSI_GPS_HDG")
local ADHSI_COURSE = get_param_handle("ADHSI_COURSE")
local ADHSI_CDI = get_param_handle("ADHSI_CDI")
local ADHSI_CDI_SHOW = get_param_handle("ADHSI_CDI_SHOW")
local ADHSI_FYT_DTK_HDG = get_param_handle("ADHSI_FYT_DTK_HDG")
local ADHSI_FYT_DTK_DIST = get_param_handle("ADHSI_FYT_DTK_DIST")

local ADHSI_DTK_HDG = get_param_handle("ADHSI_DTK_HDG")
local ADHSI_DTK_DIST = get_param_handle("ADHSI_DTK_DIST")
local ADHSI_DTK = get_param_handle("ADHSI_DTK")

local ADHSI_ADF_HDG = get_param_handle("ADHSI_ADF_HDG")

local ADHSI_GPS_NAME = get_param_handle("ADHSI_GPS_NAME")

local CMFD_NAV_FYT_DTK_DIST = get_param_handle("CMFD_NAV_FYT_DTK_DIST")

ADHSI_COURSE:set(0)
ADHSI_CDI_SHOW:set(1)
ADHSI_GPS_NAME:set("")

function update_adhsi()
    adhsi_dtk_hdg = ADHSI_DTK_HDG:get()
    adhsi_dtk_dist = ADHSI_DTK_DIST:get()
    adhsi_dtk = ADHSI_DTK:get()


    adhsi_ap_elapsed = adhsi_ap_elapsed + update_time_step
    
    if adhsi_ap_status == 1 and adhsi_ap_ovrd == 0 then
        adhsi_ap = 1
    elseif adhsi_ap_status == 0 and adhsi_ap_status_old == 1 then
        adhsi_ap_flash = 4
        adhsi_ap_elapsed = 0
    elseif adhsi_ap_status == 0 and adhsi_ap_flash > 0 then
        if adhsi_ap_elapsed > adhsi_ap_period then
            adhsi_ap = 0
        elseif adhsi_ap_elapsed > adhsi_ap_period / 2 then 
            adhsi_ap = 1
        end
        if adhsi_ap_elapsed > adhsi_ap_period then adhsi_ap_flash = adhsi_ap_flash - 1 end
    elseif adhsi_ap_status == 1 and adhsi_ap_ovrd == 1 then
        if adhsi_ap_elapsed > adhsi_ap_period then
            adhsi_ap = 1
        elseif adhsi_ap_elapsed > adhsi_ap_period / 2 then 
            adhsi_ap = 0
        end
    end
    if adhsi_ap_elapsed > adhsi_ap_period then adhsi_ap_elapsed = 0 end
    adhsi_ap_status_old = adhsi_ap_status

    local adhsi_vv_lim = get_avionics_vv();
    if adhsi_vv_lim > 2000 then adhsi_vv_lim = 2000 end
    if adhsi_vv_lim < -2000 then adhsi_vv_lim = -2000 end

    -- Roll
    local adhsi_roll = sensor_data.getRoll()
    local adhsi_pitch = sensor_data.getPitch()

    local adhsi_turnrate = get_avionics_turn_rate()
    local adhsi_turnrate_blink = 0
    if adhsi_turnrate > 450 then
        adhsi_turnrate = 450
        adhsi_turnrate_blink = 1
    elseif adhsi_turnrate < -450 then
        adhsi_turnrate = -450
        adhsi_turnrate_blink = 1
    end
    if adhsi_turnrate_blink == 1 then
        adhsi_turnrate_elapsed = adhsi_turnrate_elapsed + update_time_step
        if adhsi_turnrate_elapsed > adhsi_turnrate_period then 
            adhsi_turnrate_on = 1
            adhsi_turnrate_elapsed = 0
        elseif adhsi_turnrate_elapsed > adhsi_turnrate_period / 2 then 
            adhsi_turnrate_on = 0
        end
    else 
        adhsi_turnrate_on = 1
    end 
    adhsi_turnrate = math.rad(adhsi_turnrate * 25 / 450)

    adhsi_fyt_dtk_dist = CMFD_NAV_FYT_DTK_DIST:get()
    adhsi_fyt_dtk_dist = adhsi_fyt_dtk_dist / adhsi_rad_sel
    if adhsi_fyt_dtk_dist > 1.3 then adhsi_fyt_dtk_dist = 1.3 end

    if adhsi_ans_mode ~= AVIONICS_ANS_MODE_IDS.EGI or get_avionics_master_mode() ~= AVIONICS_MASTER_MODE_ID.NAV then 
        ADHSI_DTK:set(0)
    end

    local adhsi_fyt_dist = get_param_handle("CMFD_NAV_FYT_DIST"):get()
    adhsi_fyt_dist = adhsi_fyt_dist / adhsi_rad_sel
    if adhsi_fyt_dist > 1.3 then adhsi_fyt_dist = 1.3 end
    get_param_handle("ADHSI_FYT_DIST"):get()

    if adhsi_ans_mode ~= AVIONICS_ANS_MODE_IDS.EGI or get_avionics_master_mode() ~= AVIONICS_MASTER_MODE_ID.NAV then 
        ADHSI_DTK:set(0)
    end

    local adhsi_cdi_show_ovrd = adhsi_cdi_show
    if adhsi_ans_mode == AVIONICS_ANS_MODE_IDS.ILS then adhsi_cdi_show_ovrd = 1 end

    if adhsi_vor_hdg == -1 then 
        adhsi_cdi_show_ovrd = 0
    end

    ADHSI_VV_LIM:set(adhsi_vv_lim)
    ADHSI_AP:set(adhsi_ap)
    ADHSI_ROLL:set(adhsi_roll)
    ADHSI_PITCH:set(adhsi_pitch)
    ADHSI_TURN_RATE:set(adhsi_turnrate)
    ADHSI_TURN_RATE_ON:set(adhsi_turnrate_on)
    ADHSI_RAD_SEL:set(adhsi_rad_sel)
    ADHSI_HDG_SEL:set(adhsi_hdg_sel)
    ADHSI_CDI:set(adhsi_cdi)
    ADHSI_CDI_SHOW:set(adhsi_cdi_show_ovrd)
    ADHSI_FYT_DTK_HDG:set(adhsi_fyt_dtk_hdg)
    ADHSI_FYT_DTK_DIST:set(adhsi_fyt_dtk_dist)
    ADHSI_VOR_HDG:set(adhsi_vor_hdg)
    ADHSI_ADF_HDG:set(adhsi_adf_hdg)
    ADHSI_GPS_HDG:set(adhsi_gps_hdg)

    AVIONICS_ANS_MODE:set(adhsi_ans_mode)
end

function SetCommandAdhsi(command,value, CMFD)
    if value == 1 then 
        if command==device_commands.CMFD1OSS8 or command==device_commands.CMFD2OSS8 then 
            local ufcp = GetDevice(devices.UFCP)
            if ufcp then ufcp:performClickableAction(device_commands.UFCP_VV, 1, true) end
        elseif command==device_commands.CMFD1OSS12 or command==device_commands.CMFD2OSS12 then 
            adhsi_hdg_sel = (adhsi_hdg_sel + 1) % 360
        elseif command==device_commands.CMFD1OSS13 or command==device_commands.CMFD2OSS13 then 
            if adhsi_hdg_sel == 0 then adhsi_hdg_sel = 359
            else 
                adhsi_hdg_sel = adhsi_hdg_sel - 1
            end
        elseif command==device_commands.CMFD1OSS14 or command==device_commands.CMFD2OSS14 then 
            if not (get_avionics_master_mode_aa() or get_avionics_master_mode_ag()) then
                ADHSI_DTK:set(1 - ADHSI_DTK:get())
            end
        elseif command==device_commands.CMFD1OSS21 or command==device_commands.CMFD2OSS21 then 
            if adhsi_vor_hdg ~= -1 then
                if adhsi_cdi_show == 0 then adhsi_cdi_show = 1 else adhsi_cdi_show = 0 end
            end

        -- Change zoom
        elseif command==device_commands.CMFD1OSS22 or command==device_commands.CMFD2OSS22 then 
            adhsi_rad_sel = math.max(10, adhsi_rad_sel / 2) -- increase zoom
        elseif command==device_commands.CMFD1OSS23 or command==device_commands.CMFD2OSS23 then 
            adhsi_rad_sel = math.min(80, adhsi_rad_sel * 2) -- decrease zoom
            
        elseif command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24 then 
            adhsi_ans_mode = (adhsi_ans_mode + 1) % 4
        end
    end
end

function post_initialize_adhsi()

end



-- get_mission_route = {}
-- get_mission_route[1] = {}
-- get_mission_route[1]["speed_locked"] = true
-- get_mission_route[1]["airdromeId"] = 27
-- get_mission_route[1]["action"] = "Fly Over Point"
-- get_mission_route[1]["alt_type"] = "BARO"
-- get_mission_route[1]["ETA"] = 0
-- get_mission_route[1]["alt"] = 2000
-- get_mission_route[1]["y"] = 760569.71987102
-- get_mission_route[1]["x"] = -124824.02621349
-- get_mission_route[1]["name"] = "DictKey_WptName_18"
-- get_mission_route[1]["ETA_locked"] = true
-- get_mission_route[1]["speed"] = 75
-- get_mission_route[1]["formation_template"] = ""
-- get_mission_route[1]["task"] = {}
-- get_mission_route[1]["task"]["id"] = "ComboTask"
-- get_mission_route[1]["task"]["params"] = {}
-- get_mission_route[1]["task"]["params"]["tasks"] = {}
-- get_mission_route[1]["type"] = "Turning Point"
-- get_mission_route[2] = {}
-- get_mission_route[2]["speed_locked"] = true
-- get_mission_route[2]["type"] = "TakeOff"
-- get_mission_route[2]["action"] = "From Runway"
-- get_mission_route[2]["alt_type"] = "BARO"
-- get_mission_route[2]["ETA"] = 0
-- get_mission_route[2]["y"] = 789260.82061283
-- get_mission_route[2]["x"] = -122670.06493381
-- get_mission_route[2]["name"] = "DictKey_WptName_19"
-- get_mission_route[2]["formation_template"] = ""
-- get_mission_route[2]["speed"] = 138.88888888889
-- get_mission_route[2]["ETA_locked"] = false
-- get_mission_route[2]["task"] = {}
-- get_mission_route[2]["task"]["id"] = "ComboTask"
-- get_mission_route[2]["task"]["params"] = {}
-- get_mission_route[2]["task"]["params"]["tasks"] = {}
-- get_mission_route[2]["alt"] = 267
