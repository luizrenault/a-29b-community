dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."Systems/weapon_system_api.lua")



startup_print("cmfd_right: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

dofile(LockOn_Options.script_path.."Systems/cmfd_sms.lua")


-- getAngleOfAttack
-- getAngleOfSlide
-- getBarometricAltitude
-- getCanopyPos
-- getCanopyState
-- getEngineLeftFuelConsumption
-- getEngineLeftRPM
-- getEngineLeftTemperatureBeforeTurbine
-- getEngineRightFuelConsumption
-- getEngineRightRPM
-- getEngineRightTemperatureBeforeTurbine
-- getFlapsPos
-- getFlapsRetracted
-- getHeading
-- getHorizontalAcceleration
-- getIndicatedAirSpeed
-- getLandingGearHandlePos
-- getLateralAcceleration
-- getLeftMainLandingGearDown
-- getLeftMainLandingGearUp
-- getMachNumber
-- getMagneticHeading
-- getNoseLandingGearDown
-- getNoseLandingGearUp
-- getPitch
-- getRadarAltitude
-- getRateOfPitch
-- getRateOfRoll
-- getRateOfYaw
-- getRightMainLandingGearDown
-- getRightMainLandingGearUp
-- getRoll
-- getRudderPosition
-- getSpeedBrakePos
-- getSelfAirspeed
-- getSelfCoordinates
-- getSelfVelocity
-- getStickPitchPosition
-- getStickRollPosition
-- getThrottleLeftPosition
-- getThrottleRightPosition
-- getTotalFuelWeight
-- getTrueAirSpeed
-- getVerticalAcceleration
-- getVerticalVelocity
-- getWOW_LeftMainLandingGear
-- getWOW_NoseLandingGear
-- getWOW_RightMainLandingGear


local EICAS_TQ = get_param_handle("EICAS_TQ")
local EICAS_TQ_ROT = get_param_handle("EICAS_TQ_ROT")
local EICAS_TQ_REQ_ROT = get_param_handle("EICAS_TQ_REQ_ROT")
local EICAS_TQ_OPT_ROT = get_param_handle("EICAS_TQ_OPT_ROT")
local EICAS_TQ_COR = get_param_handle("EICAS_TQ_COR")

local EICAS_T5 = get_param_handle("EICAS_T5")
local EICAS_T5_ROT = get_param_handle("EICAS_T5_ROT")
local EICAS_T5_COR = get_param_handle("EICAS_T5_COR")

local EICAS_OIL_PRESS = get_param_handle("EICAS_OIL_PRESS")
local EICAS_OIL_PRESS_COR = get_param_handle("EICAS_OIL_PRESS_COR")

local EICAS_OIL_TEMP = get_param_handle("EICAS_OIL_TEMP")
local EICAS_OIL_TEMP_COR = get_param_handle("EICAS_OIL_TEMP_COR")

local EICAS_NP = get_param_handle("EICAS_NP")
local EICAS_NP_COR = get_param_handle("EICAS_NP_COR")

local EICAS_NG = get_param_handle("EICAS_NG")
local EICAS_NG_COR = get_param_handle("EICAS_NG_COR")

local EICAS_OAT = get_param_handle("EICAS_OAT")

local EICAS_IGN = get_param_handle("EICAS_IGN")

local EICAS_ENG_MODE = get_param_handle("EICAS_ENG_MODE")

local EICAS_HYD = get_param_handle("EICAS_HYD")
local EICAS_HYD_COR = get_param_handle("EICAS_HYD_COR")

local EICAS_CAB_PRESS = get_param_handle("EICAS_CAB_PRESS")
local EICAS_CAB_PRESS_COR = get_param_handle("EICAS_CAB_PRESS_COR")

local EICAS_BAT_AMP = get_param_handle("EICAS_BAT_AMP")
local EICAS_BAT_AMP_COR = get_param_handle("EICAS_BAT_AMP_COR")

local EICAS_BAT_VOLT = get_param_handle("EICAS_BAT_VOLT")
local EICAS_BAT_VOLT_COR = get_param_handle("EICAS_BAT_VOLT_COR")

local EICAS_BAT_TEMP = get_param_handle("EICAS_BAT_TEMP")
local EICAS_BAT_TEMP_COR = get_param_handle("EICAS_BAT_TEMP_COR")

local EICAS_TRIM_ROLL = get_param_handle("EICAS_TRIM_ROLL")
local EICAS_TRIM_PITCH = get_param_handle("EICAS_TRIM_PITCH")
local EICAS_TRIM_YAW = get_param_handle("EICAS_TRIM_YAW")

local EICAS_FUEL_FLOW = get_param_handle("EICAS_FUEL_FLOW")
local EICAS_FUEL = get_param_handle("EICAS_FUEL")
local EICAS_FUEL_COR = get_param_handle("EICAS_FUEL_COR")
local EICAS_FUEL_LEFT = get_param_handle("EICAS_FUEL_LEFT")
local EICAS_FUEL_LEFT_COR = get_param_handle("EICAS_FUEL_LEFT_COR")
local EICAS_FUEL_RIGHT = get_param_handle("EICAS_FUEL_RIGHT")
local EICAS_FUEL_RIGHT_COR = get_param_handle("EICAS_FUEL_RIGHT_COR")
local EICAS_FUEL_JOKER = get_param_handle("EICAS_FUEL_JOKER")
local EICAS_FUEL_JOKER_ROT = get_param_handle("EICAS_FUEL_JOKER_ROT")
local EICAS_FUEL_TOT_ROT = get_param_handle("EICAS_FUEL_TOT_ROT")
local EICAS_FUEL_INT_ROT = get_param_handle("EICAS_FUEL_INT_ROT")
local EICAS_FUEL_INIT = get_param_handle("EICAS_FUEL_INIT")

local EICAS_FLAP = get_param_handle("EICAS_FLAP")
local EICAS_FLAP_TXT = get_param_handle("EICAS_FLAP_TXT")

local EICAS_SPD_BRK = get_param_handle("EICAS_SPD_BRK")
local EICAS_SPD_BRK_TXT = get_param_handle("EICAS_SPD_BRK_TXT")


local EICAS_ERROR1_TEXT = get_param_handle("EICAS_ERROR1_TEXT")
local EICAS_ERROR1_COLOR = get_param_handle("EICAS_ERROR1_COLOR")

local EICAS_ON_GROUND = get_param_handle("EICAS_ON_GROUND")

local EICAS_INIT = get_param_handle("EICAS_INIT")

local fuel_init = 300;

local fuel_joker = 200;

local torque_tempo = -1
local np_tempo = -1
local oat_base = 25

local engine_limits_warning = 0
local fuel_imbalance_caution = 0


function update()
    update_eicas()
    update_adhsi()
    update_sms()
end

local adhsi_vv = 1

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
local ADHSI_VV = get_param_handle("ADHSI_VV")
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

ADHSI_COURSE:set(0)
ADHSI_CDI_SHOW:set(1)
ADHSI_GPS_NAME:set("")


function update_adhsi()
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


    if adhsi_ans_mode ~= ANS_MODE_IDS.EGI then 
        adhsi_dtk = 0
    end
    if adhsi_dtk == 1 then 
        adhsi_fyt_dtk_hdg = adhsi_dtk_hdg
        adhsi_fyt_dtk_dist = adhsi_dtk_dist
    end

    local adhsi_cdi_show_ovrd = adhsi_cdi_show
    if adhsi_ans_mode == ANS_MODE_IDS.ILS then adhsi_cdi_show_ovrd = 1 end

    if adhsi_vor_hdg == -1 then 
        adhsi_cdi_show_ovrd = 0
    end

    ADHSI_VV_LIM:set(adhsi_vv_lim)
    ADHSI_VV:set(adhsi_vv)
    ADHSI_AP:set(adhsi_ap)
    ADHSI_ROLL:set(adhsi_roll)
    ADHSI_PITCH:set(adhsi_pitch)
    ADHSI_TURN_RATE:set(adhsi_turnrate)
    ADHSI_TURN_RATE_ON:set(adhsi_turnrate_on)
    ADHSI_RAD_SEL:set(adhsi_rad_sel)
    ADHSI_HDG_SEL:set(adhsi_hdg_sel)
    ADHSI_CDI:set(adhsi_cdi)
    ADHSI_CDI_SHOW:set(adhsi_cdi_show_ovrd)
    ADHSI_DTK_HDG:set(adhsi_dtk_hdg)
    ADHSI_DTK_DIST:set(adhsi_dtk_dist)
    ADHSI_DTK:set(adhsi_dtk)
    ADHSI_FYT_DTK_HDG:set(adhsi_fyt_dtk_hdg)
    ADHSI_FYT_DTK_DIST:set(adhsi_fyt_dtk_dist)
    ADHSI_VOR_HDG:set(adhsi_vor_hdg)
    ADHSI_ADF_HDG:set(adhsi_adf_hdg)
    ADHSI_GPS_HDG:set(adhsi_gps_hdg)

    ANS_MODE:set(adhsi_ans_mode)

end

local cabin_press_cor=0

function update_eicas()
    update_cmfd_on()

    ----------------- temperatura do ar externo
    -- TODO: - obter / modelar temperatura do ar
    if oat_base < -30 then oat_base = -30 end
    if oat_base > 70 then oat_base = 70 end
    local oat = round_to(oat_base - 6.5*sensor_data.getBarometricAltitude()/1000,1)
    if oat < -70 then oat = -70 end
    if oat > 70 then oat = 70 end


    ------------------ mostrador de torque
    local torque = sensor_data.getEngineLeftRPM()
    if torque < 64 then torque = 64 end
    torque = (torque - 63) * 100 / 37
    if torque < 0 then torque = 0 end
    if torque > 225 then torque = 225 end
    
    -- gerencia contador de 20s para aviso amarelo virar vermelho
    if torque_tempo >= 0 then torque_tempo = torque_tempo + update_time_step end
    if torque >= 100 then
        if torque_tempo == -1 then torque_tempo = 0 end
    else torque_tempo = -1 end
    
    -- cor do ponteiro e valor digital de torque
    local torque_cor = 0
    if torque < 100 then torque_cor = 0 -- verde
    elseif (torque < 115) and torque_tempo < 20 then torque_cor = 1 -- amarelo 
    else torque_cor = 2 -- vermelho
    end

    -- ponteiro de torque
    local torque_rot = torque
    if torque_rot < 20 then torque_rot = 20 end
    if torque_rot > 120 then torque_rot = 120 end
    torque_rot = - (torque_rot -70) * math.pi / 60

    -- indicador de torque requerido
    local torque_req_rot = sensor_data.getThrottleLeftPosition()*100
    if torque_req_rot < 20 then torque_req_rot = 20 end
    if torque_req_rot > 120 then torque_req_rot = 120 end
    torque_req_rot = - (torque_req_rot -70) * math.pi / 60

    -- indicador de torque ótimo
    local torque_opt=0
    if sensor_data.getWOW_LeftMainLandingGear() > 0 then
        torque_opt=78
    end
    if torque_opt < 20 then torque_opt = 20 end
    if torque_opt > 120 then torque_opt = 120 end
    local torque_opt_rot = - (torque_opt -70) * math.pi / 60

    ----------------- mostrador de temperatura entre turbinas t5
    local t5 = sensor_data.getEngineLeftTemperatureBeforeTurbine()
    if t5 < -50 then t5 = -50 end
    if t5 > 1200 then t5 = 1200 end

    -- ponteiro de t5
    local t5_rot = t5
    if t5_rot < 200 then t5_rot = 200 end
    if t5_rot > 1200 then tr_rot = 1200 end
    t5_rot = - (t5_rot -700) * math.pi / 600

    t5=round_to(t5, 10)
    
    -- cor do ponteiro e valor digital de torque
    -- TODO: - Se, por qualquer motivo, os dados não estiverem disponíveis, uma etiqueta branca OFF, localizada no centro da apresentação analógica, substitui os ponteiros.
    if t5 < 860 then t5_cor = 0 -- verde
    elseif (t5 < 900) then t5_cor = 1 -- amarelo 
    else t5_cor = 2 -- vermelho
    end

    ------------------- pressão de óleo
    local oil_press=sensor_data.getEngineLeftRPM()*2
    if oil_press > 120 then oil_press = 120 end --simulação

    if oil_press < 0 then oil_press = 0 end
    if oil_press > 200 then oil_press = 200 end

    -- cor do ponteiro e valor digital da pressão de óleo
    -- TODO: - Se os dados não estiverem disponíveis, a janela apresenta “XXX”.
    if oil_press < 40 then 
        if oil_press_cor ~= 2 then set_warning(WARNING_ID.OIL_PRESS, 1) end
        oil_press_cor = 2
    elseif oil_press < 90 then 
        if oil_press_cor ~= 1 then set_warning(WARNING_ID.OIL_PRESS, 0) end
        oil_press_cor = 1
    elseif oil_press < 121 then 
        if oil_press_cor ~= 0 then set_warning(WARNING_ID.OIL_PRESS, 0) end
        oil_press_cor = 0
    elseif oil_press < 130 then 
        if oil_press_cor ~= 1 then set_warning(WARNING_ID.OIL_PRESS, 0) end
        oil_press_cor = 1
    else 
        if oil_press_cor ~= 2 then set_warning(WARNING_ID.OIL_PRESS, 1) end
        oil_press_cor = 2
    end

    ------------------- temperatura do óleo
    local oil_temp=oat + sensor_data.getEngineLeftRPM()*0.76

    if oil_temp < -50 then oil_temp = -50 end
    if oil_temp > 150 then oil_temp = 150 end

    -- cor do ponteiro e valor digital da temperatura do óleo
    -- TODO: - Se os dados não estiverem disponíveis, a janela apresenta “XXX”.
    if oil_temp < -40 then 
        if oil_temp_cor ~= 2 then set_warning(WARNING_ID.OIL_TEMP, 1) end
        oil_temp_cor = 2
    elseif oil_temp < 10 then 
        if oil_temp_cor ~= 1 then set_warning(WARNING_ID.OIL_TEMP, 0) end
        oil_temp_cor = 1
    elseif oil_temp < 106 then 
        if oil_temp_cor ~= 0 then set_warning(WARNING_ID.OIL_TEMP, 0) end
        oil_temp_cor = 0
    elseif oil_temp < 110 then 
        if oil_temp_cor ~= 1 then set_warning(WARNING_ID.OIL_TEMP, 0) end
        oil_temp_cor = 1
    else 
        if oil_temp_cor ~= 2 then set_warning(WARNING_ID.OIL_TEMP, 1) end
        oil_temp_cor = 2
    end
    
    ------------------- rotação da hélice %
    local np = sensor_data.getEngineLeftRPM()
    if np < 0 then np = 0 end
    if np > 130 then np = 130 end

    -- gerencia contador de 20s para aviso verde virar amarelo e 5s para virar vermelho
    if np_tempo >= 0 then np_tempo = np_tempo + update_time_step end
    if sensor_data.getWOW_LeftMainLandingGear() > 0 then
        if ((np >=25 and np < 40) or (np >= 52 and np < 68) or (np >= 87 and np < 98) or (np > 102)) then
            if np_tempo == -1 then np_tempo=0 end
        else np_tempo =- 1 end
    else 
        if np >= 102 and np < 109 then
            if np_tempo == -1 then np_tempo=0 end
        else np_tempo = -1 end
    end

    -- cor do valor digital da rotação da hélice
    if sensor_data.getWOW_LeftMainLandingGear() > 0 then
        if np < 109 then np_cor = 0 
        else np_cor = 2 end
        if (np >= 102 and np < 109) and np_tempo > 20 then np_cor = 1 end
        if ((np >=25 and np < 40) or (np >= 52 and np < 68) or (np >= 87 and np < 98)) and np_tempo > 5 then np_cor=2 end
    else 
        if np < 98 then np_cor = 1
        elseif np < 109 then np_cor = 0
        else np_cor = 2 end
        if np >= 102 and np < 109 and np_tempo > 20 then np_cor = 1 end
    end

    ----------------- rotação do gerador de gases
    local ng = sensor_data.getEngineLeftRPM()
    if ng < 0 then ng = 0 end
    if ng > 130 then ng = 130 end

    ng = round_to(ng, 0.2)

    -- cor do valor digital da rotação da gerador de gases
    if sensor_data.getWOW_LeftMainLandingGear() > 0 then
        if ng < 64.6 then ng_cor = 1 
        elseif ng <  104 then ng_cor = 0
        else ng_cor = 2 end
    else
        if ng < 75 then ng_cor = 1 
        elseif ng <  104 then ng_cor = 0
        else ng_cor = 2 end
    end

    ----------------- indicador de ignição
    local ign=0

    ----------------- indicador de modo de operação
    local eng_mode=""
    if sensor_data.getWOW_LeftMainLandingGear() > 0 then
        eng_mode="TO"  -- TakeOff, Alternate Takeoff, CLimb, CRuise
    end

    ------------------- indicador digital de pressão hidráulica
    local hyd=sensor_data.getEngineLeftRPM()*50
    if hyd > 3200 then hyd = 3200 end -- simulação
    
    if hyd < 0 then hyd = 0 end
    if hyd > 5000 then hyd = 5000 end

    hyd = round_to(hyd, 100)
    -- cor do valor digital da da pressão hidráulica
    -- TODO: - Se os dados não estiverem disponíveis, a janela apresenta “XXX”.
    if hyd < 2700 then 
        if hyd_cor ~=1 then set_caution(CAUTION_ID.HYD_RESS,1) end 
        hyd_cor = 1
    elseif hyd < 3300 then 
        if hyd_cor ~=0 then set_caution(CAUTION_ID.HYD_RESS,0) end 
        hyd_cor = 0
    else 
        if hyd_cor ~=1 then set_caution(CAUTION_ID.HYD_RESS,1) end 
        hyd_cor = 1
    end

    ------------------- indicador digital de pressão cabine
    local cabin_press = sensor_data.getBarometricAltitude()*3.28084
    if cabin_press < -7000 then cabin_press = -7000 end
    if cabin_press > 40000 then cabin_press = 40000 end
    cabin_press = round_to(cabin_press, 500)
    -- cor do valor digital da da pressão cabine
    if cabin_press < 16000 then 
        if cabin_press_cor == 1 then set_caution(CAUTION_ID.CAB_ALT, 0) end
        if cabin_press_cor == 2 then set_warning(WARNING_ID.CAB_ALT, 0) end
        cabin_press_cor = 0
    elseif cabin_press < 25000 then 
        if cabin_press_cor == 2 then set_warning(WARNING_ID.CAB_ALT, 0) end
        if cabin_press_cor ~= 1 then set_caution(CAUTION_ID.CAB_ALT, 1) end
        cabin_press_cor = 1
    else 
        if cabin_press_cor == 1 then set_caution(CAUTION_ID.CAB_ALT, 0) end
        if cabin_press_cor ~= 2 then set_warning(WARNING_ID.CAB_ALT, 1) end
        cabin_press_cor = 2
    end

    ------------------- indicador digital de bateria
    local bat_amp = 127
    bat_amp = round_to(bat_amp,5)
    if bat_amp < 0 then bat_amp = 0 end
    if bat_amp > 950 then bat_amp = 950 end
    if bat_amp <= 400 then bat_amp_cor = 0 
    else bat_amp_cor = 1 end

    local bat_volt = 28.8
    bat_volt = round_to(bat_volt,0.1)
    if bat_volt < 0 then bat_volt = 0 end
    if bat_volt > 40 then bat_volt = 40 end
    if bat_volt <= 30 then bat_volt_cor = 0 
    else bat_volt_cor = 2 end

    local bat_temp = 37
    bat_temp = round_to(bat_temp,1)
    if bat_temp < -30 then bat_temp = -30 end
    if bat_temp > 100 then bat_temp = 100 end
    if bat_temp <= 76 then 
        if bat_temp_cor == 2 then set_warning(WARNING_ID.BAT_TEMP,0) end
        bat_temp_cor = 0 
    else 
        if bat_temp_cor == 0 then set_warning(WARNING_ID.BAT_TEMP,1) end
        bat_temp_cor = 2 
    end


    ------------------- indicador compensador
    local trim_roll = 0
    if trim_roll < -10 then trim_roll = -10 end
    if trim_roll > 10 then trim_roll = 10 end

    local trim_pitch = 0
    if trim_pitch < -10 then trim_pitch = -10 end
    if trim_pitch > 10 then trim_pitch = 10 end

    local trim_yaw = 0
    if trim_yaw < -10 then trim_yaw = -10 end
    if trim_yaw > 10 then trim_yaw = 10 end

    ------------------- indicador combustível
    local fuel_flow = sensor_data.getEngineLeftFuelConsumption()*60*60;
    if fuel_flow < 0 then fuel_flow = 0 end
    --if fuel_flow > 500 then fuel_flow = 500 end

    if fuel_init > 1465 then fuel_init = 1465 end
    if fuel_init < 0 then fuel_init = 0 end
    fuel_init = fuel_init - sensor_data.getEngineLeftFuelConsumption()*update_time_step

    -- Se os dados de fluxo de combustível não estiverem disponíveis por mais de 5 minutos, o campo apresenta os caracteres “XXXX” na cor vermelha e os dados não mais estarão disponíveis.

    if fuel_joker > 1465 then fuel_joker = 1465 end
    if fuel_joker < 95 then fuel_joker = 95 end
    local fuel_joker_rot
    if fuel_joker <= 300 then
        fuel_joker_rot = (115.5- 55/300*fuel_joker)*math.pi/180
    else
        fuel_joker_rot = (60.5- 152/1300* (fuel_joker-305))*math.pi/180
    end

    local fuel = sensor_data.getTotalFuelWeight()
    if fuel < 0 then fuel = 0 end
    if fuel > 500 then fuel = 500 end
    local fuel_left = fuel / 2 -- simple model
    if fuel_left < 0 then fuel_left = 0 end
    if fuel_left > 245 then fuel_left = 245 end
    local fuel_right = fuel - fuel_left -- simple model
    if fuel_right < 0 then fuel_right = 0 end
    if fuel_right > 250 then fuel_right = 250 end
    fuel = round_to(fuel, 5)
    fuel_left = round_to(fuel_left, 5)
    fuel_right = round_to(fuel_right, 5)
    if math.abs(fuel_left - fuel_right) >= 60 then 
        if fuel_imbalance_caution == 0 then 
            set_caution(CAUTION_ID.FUEL_IMB, 1)
            fuel_imbalance_caution = 1
        end
    else
        if fuel_imbalance_caution == 1 then 
            set_caution(CAUTION_ID.FUEL_IMB, 0)
            fuel_imbalance_caution = 0
        end
    end

    local fuel_tot_rot = 0
    if fuel_init <= 300 then
        fuel_tot_rot = math.rad((300 - fuel_init) * 10 / 50) + math.rad((1770 - 300) * 12.5 / 100)
    else
        fuel_tot_rot = math.rad((1770 - fuel_init) * 12.5 / 100)
    end

    local fuel_int_rot = 0
    if fuel <= 300 then
        fuel_int_rot = math.rad((300 - fuel) * 10 / 50) + math.rad((500 - 300) * 12.5 / 100)
    else
        fuel_int_rot = math.rad((500 - fuel) * 12.5 / 100)
    end

    -- cores dos indicadores de combustível
    if fuel <= 125 then 
        if fuel_cor ~= 2 then set_warning(WARNING_ID.FUEL_LVL,1) end
        fuel_cor = 2
    else 
        if fuel_cor ~= 0 then set_warning(WARNING_ID.FUEL_LVL,0) end
        fuel_cor = 0 
    end
    if fuel_left <= 60 then fuel_left_cor = 2
    else fuel_left_cor = 0 end
    if fuel_right <= 60 then fuel_right_cor = 2
    else fuel_right_cor = 0 end

    if (torque_cor == 2 or t5_cor == 2 or ng_cor == 2 or np_cor == 2) and engine_limits_warning == 0 then
        set_warning(WARNING_ID.ENG_LMTS,1)
        engine_limits_warning = 1
    elseif (torque_cor ~= 2 and t5_cor ~= 2 and ng_cor ~= 2 and np_cor ~= 2) and engine_limits_warning ~= 0 then 
        set_warning(WARNING_ID.ENG_LMTS,0)
        engine_limits_warning = 0
    end

    EICAS_TQ:set(torque)
    EICAS_TQ_ROT:set(torque_rot)
    EICAS_TQ_REQ_ROT:set(torque_req_rot)
    EICAS_TQ_OPT_ROT:set(torque_opt_rot)
    EICAS_TQ_COR:set(torque_cor)

    EICAS_T5:set(t5)
    EICAS_T5_ROT:set(t5_rot)
    EICAS_T5_COR:set(t5_cor)
    
    EICAS_OIL_PRESS:set(oil_press)
    EICAS_OIL_PRESS_COR:set(oil_press_cor)

    EICAS_OIL_TEMP:set(oil_temp)
    EICAS_OIL_TEMP_COR:set(oil_temp_cor)

    EICAS_NP:set(np)
    EICAS_NP_COR:set(np_cor)

    EICAS_NG:set(ng)
    EICAS_NG_COR:set(ng_cor)

    EICAS_OAT:set(oat)

    EICAS_IGN:set(ign)

    EICAS_ENG_MODE:set(eng_mode)

    EICAS_HYD:set(hyd)
    EICAS_HYD_COR:set(hyd_cor)

    EICAS_CAB_PRESS:set(cabin_press)
    EICAS_CAB_PRESS_COR:set(cabin_press_cor)

    EICAS_BAT_AMP:set(bat_amp)
    EICAS_BAT_AMP_COR:set(bat_amp_cor)

    EICAS_BAT_VOLT:set(bat_volt)
    EICAS_BAT_VOLT_COR:set(bat_volt_cor)

    EICAS_BAT_TEMP:set(bat_temp)
    EICAS_BAT_TEMP_COR:set(bat_temp_cor)

    EICAS_TRIM_ROLL:set(trim_roll)
    EICAS_TRIM_PITCH:set(trim_pitch)
    EICAS_TRIM_YAW:set(trim_yaw)

    EICAS_FUEL_FLOW:set(round_to(fuel_flow,5))
    EICAS_FUEL:set(fuel)
    EICAS_FUEL_COR:set(fuel_cor)
    EICAS_FUEL_LEFT:set(fuel_left)
    EICAS_FUEL_LEFT_COR:set(fuel_left_cor)
    EICAS_FUEL_RIGHT:set(fuel_right)
    EICAS_FUEL_RIGHT_COR:set(fuel_right_cor)
    EICAS_FUEL_INIT:set(round_to(fuel_init,5))
    EICAS_FUEL_JOKER:set(round_to(fuel_joker,5))
    EICAS_FUEL_JOKER_ROT:set(fuel_joker_rot)
    EICAS_FUEL_INT_ROT:set(fuel_int_rot)
    EICAS_FUEL_TOT_ROT:set(fuel_tot_rot)


    flap_pos = sensor_data.getFlapsPos()
    if flap_pos < 0.1 then
        EICAS_FLAP:set(0)
        EICAS_FLAP_TXT:set("UP")
    elseif flap_pos > 0.9 then 
        EICAS_FLAP:set(1)
        EICAS_FLAP_TXT:set("DOWN")
    else 
        EICAS_FLAP:set(0)
        EICAS_FLAP_TXT:set("----")
    end


    -- - Se os dados não estiverem disponíveis, a janela apresenta “XXX”.
    if sensor_data.getSpeedBrakePos() <0.1 then
        EICAS_SPD_BRK:set(0)
        EICAS_SPD_BRK_TXT:set("CLOSED")
    else 
        EICAS_SPD_BRK:set(1)
        EICEICAS_SPD_BRK_TXTAS_FLAP_TXT:set("OPEN")
    end


end


dev:listen_command(device_commands.CMFD2OSS1)
dev:listen_command(device_commands.CMFD2OSS2)
dev:listen_command(device_commands.CMFD2OSS3)
dev:listen_command(device_commands.CMFD2OSS4)
dev:listen_command(device_commands.CMFD2OSS5)
dev:listen_command(device_commands.CMFD2OSS6)
dev:listen_command(device_commands.CMFD2OSS7)
dev:listen_command(device_commands.CMFD2OSS8)
dev:listen_command(device_commands.CMFD2OSS9)
dev:listen_command(device_commands.CMFD2OSS10)
dev:listen_command(device_commands.CMFD2OSS11)
dev:listen_command(device_commands.CMFD2OSS12)
dev:listen_command(device_commands.CMFD2OSS13)
dev:listen_command(device_commands.CMFD2OSS14)
dev:listen_command(device_commands.CMFD2OSS15)
dev:listen_command(device_commands.CMFD2OSS16)
dev:listen_command(device_commands.CMFD2OSS17)
dev:listen_command(device_commands.CMFD2OSS18)
dev:listen_command(device_commands.CMFD2OSS19)
dev:listen_command(device_commands.CMFD2OSS20)
dev:listen_command(device_commands.CMFD2OSS21)
dev:listen_command(device_commands.CMFD2OSS22)
dev:listen_command(device_commands.CMFD2OSS23)
dev:listen_command(device_commands.CMFD2OSS24)
dev:listen_command(device_commands.CMFD2OSS25)
dev:listen_command(device_commands.CMFD2OSS26)
dev:listen_command(device_commands.CMFD2OSS27)
dev:listen_command(device_commands.CMFD2OSS28)
dev:listen_command(device_commands.CMFD2ButtonOn)
dev:listen_command(device_commands.CMFD2ButtonGain)
dev:listen_command(device_commands.CMFD2ButtonSymb)
dev:listen_command(device_commands.CMFD2ButtonBright)

dev:listen_command(device_commands.CMFD1OSS1)
dev:listen_command(device_commands.CMFD1OSS2)
dev:listen_command(device_commands.CMFD1OSS3)
dev:listen_command(device_commands.CMFD1OSS4)
dev:listen_command(device_commands.CMFD1OSS5)
dev:listen_command(device_commands.CMFD1OSS6)
dev:listen_command(device_commands.CMFD1OSS7)
dev:listen_command(device_commands.CMFD1OSS8)
dev:listen_command(device_commands.CMFD1OSS9)
dev:listen_command(device_commands.CMFD1OSS10)
dev:listen_command(device_commands.CMFD1OSS11)
dev:listen_command(device_commands.CMFD1OSS12)
dev:listen_command(device_commands.CMFD1OSS13)
dev:listen_command(device_commands.CMFD1OSS14)
dev:listen_command(device_commands.CMFD1OSS15)
dev:listen_command(device_commands.CMFD1OSS16)
dev:listen_command(device_commands.CMFD1OSS17)
dev:listen_command(device_commands.CMFD1OSS18)
dev:listen_command(device_commands.CMFD1OSS19)
dev:listen_command(device_commands.CMFD1OSS20)
dev:listen_command(device_commands.CMFD1OSS21)
dev:listen_command(device_commands.CMFD1OSS22)
dev:listen_command(device_commands.CMFD1OSS23)
dev:listen_command(device_commands.CMFD1OSS24)
dev:listen_command(device_commands.CMFD1OSS25)
dev:listen_command(device_commands.CMFD1OSS26)
dev:listen_command(device_commands.CMFD1OSS27)
dev:listen_command(device_commands.CMFD1OSS28)
dev:listen_command(device_commands.CMFD1ButtonOn)
dev:listen_command(device_commands.CMFD1ButtonGain)
dev:listen_command(device_commands.CMFD1ButtonSymb)
dev:listen_command(device_commands.CMFD1ButtonBright)

local CMFDNumber=get_param_handle("CMFDNumber")
CMFDNumber:set(0)

local CMFD1Format=get_param_handle("CMFD1Format")
CMFD1Format:set(SUB_PAGE_ID.SMS)

local CMFD2Format=get_param_handle("CMFD2Format")
CMFD2Format:set(SUB_PAGE_ID.EICAS)

local CMFDDoi=get_param_handle("CMFDDoi")
CMFDDoi:set(0)

local CMFD1DCLT=get_param_handle("CMFD1DCLT")
CMFD1DCLT:set(0)

local CMFD2DCLT=get_param_handle("CMFD2DCLT")
CMFD2DCLT:set(0)

local CMFD1Primary=get_param_handle("CMFD1Primary")
CMFD1Primary:set(0) -- 0=Left or OSS 19     1=Right or PSS 16

local CMFD2Primary=get_param_handle("CMFD2Primary")
CMFD2Primary:set(0) -- 0=Left or OSS 19     1=Right or PSS 16

local CMFD1Sel=get_param_handle("CMFD1Sel")
CMFD1Sel:set(SUB_PAGE_ID.ADHSI)

local CMFD2Sel=get_param_handle("CMFD2Sel")
CMFD2Sel:set(SUB_PAGE_ID.EICAS)

local CMFD1SelLeft=get_param_handle("CMFD1SelLeft")
CMFD1SelLeft:set(SUB_PAGE_ID.ADHSI)

local CMFD2SelLeft=get_param_handle("CMFD2SelLeft")
CMFD2SelLeft:set(SUB_PAGE_ID.EICAS)

local CMFD1SelLeftName=get_param_handle("CMFD1SelLeftName")
CMFD1SelLeftName:set(SUB_PAGE_NAME[CMFD1SelLeft:get()])

local CMFD2SelLeftName=get_param_handle("CMFD2SelLeftName")
CMFD2SelLeftName:set(SUB_PAGE_NAME[CMFD2SelLeft:get()])

local CMFD1SelRight=get_param_handle("CMFD1SelRight")
CMFD1SelRight:set(SUB_PAGE_ID.SMS)

local CMFD2SelRight=get_param_handle("CMFD2SelRight")
CMFD2SelRight:set(SUB_PAGE_ID.BLANK)

local CMFD1SelRightName=get_param_handle("CMFD1SelRightName")
CMFD1SelRightName:set(SUB_PAGE_NAME[CMFD1SelRight:get()])

local CMFD2SelRightName=get_param_handle("CMFD2SelRightName")
CMFD2SelRightName:set(SUB_PAGE_NAME[CMFD2SelRight:get()])

local CMFD1On=get_param_handle("CMFD1On")
local CMFD2On=get_param_handle("CMFD2On")

local CMFD1SwOn=get_param_handle("CMFD1SwOn")
local CMFD2SwOn=get_param_handle("CMFD2SwOn")

local CMFD1_BRIGHT=get_param_handle("CMFD1_BRIGHT")
local CMFD2_BRIGHT=get_param_handle("CMFD2_BRIGHT")

CMFD1_BRIGHT:set(1)
CMFD2_BRIGHT:set(1)




function update_cmfd_on()
    if sensor_data.getWOW_LeftMainLandingGear()==0 then EICAS_INIT:set(0)   -- INIT -> DETOT
    elseif get_elec_main_bar_ok() then EICAS_INIT:set(1) end                    -- DETOT -> INIT

    CMFD1On:set(get_elec_avionics_ok() and 1 or 0)
    CMFD2On:set(get_elec_emergency_ok() and 1 or 0)

end

function post_initialize()
    startup_print("cmfd_right: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" then
        dev:performClickableAction(device_commands.CMFD1ButtonOn,1)
        dev:performClickableAction(device_commands.CMFD2ButtonOn,1)
        EICAS_INIT:set(1)
    elseif birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.CMFD1ButtonOn,1)
        dev:performClickableAction(device_commands.CMFD2ButtonOn,1)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.CMFD1ButtonOn,0)
        dev:performClickableAction(device_commands.CMFD2ButtonOn,0)
        EICAS_INIT:set(1)
    end
    fuel_init=round_to(sensor_data.getTotalFuelWeight(),5)
    fuel_joker=round_to(fuel_init/2,5)

    post_initialize_sms()

    startup_print("environ: postinit end")
end



-- HSD, SMS, UFCP, DVR, EW, ADHSI, EICAS, FLIR, EMERG, PFL, BIT, HUD, DTE e NAV

function SetCommandMenu1(command,value, CMFD)
    if value == 1 then 
        local selected=-1
        if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then CMFD["Format"]:set(SUB_PAGE_ID.MENU2)
        elseif command == device_commands.CMFD1OSS2 or command == device_commands.CMFD2OSS2 then
            -- Função: Restaurar a configuração padrão do sistema para os formatos Primário e Secundário e para o DOI de cada modo principal.
        elseif command == device_commands.CMFD1OSS4 or command == device_commands.CMFD2OSS4 then
            -- Função: Restaurar os valores padrão do brilho da simbologia e do contraste das imagens de vídeo.
            -- Esta função é usada para se fazer uma recuperação rápida de ajustes errôneos de contraste ou brilho.
        elseif command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3 then selected=SUB_PAGE_ID.BLANK
        elseif command==device_commands.CMFD1OSS5 or command==device_commands.CMFD2OSS5 then selected=SUB_PAGE_ID.BLANK
        elseif command==device_commands.CMFD1OSS6 or command==device_commands.CMFD2OSS6 then selected=SUB_PAGE_ID.BLANK
        elseif command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7 then selected=SUB_PAGE_ID.DTE
        elseif command==device_commands.CMFD1OSS8 or command==device_commands.CMFD2OSS8 then selected=SUB_PAGE_ID.FLIR
        elseif command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9 then selected=SUB_PAGE_ID.DVR
        elseif command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10 then selected=SUB_PAGE_ID.EMERG
        elseif command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11 then selected=SUB_PAGE_ID.PFL
        elseif command==device_commands.CMFD1OSS12 or command==device_commands.CMFD2OSS12 then selected=SUB_PAGE_ID.BIT
        elseif command==device_commands.CMFD1OSS13 or command==device_commands.CMFD2OSS13 then selected=SUB_PAGE_ID.NAV
        elseif command==device_commands.CMFD1OSS14 or command==device_commands.CMFD2OSS14 then selected=SUB_PAGE_ID.BLANK
        elseif command==device_commands.CMFD1OSS21 or command==device_commands.CMFD2OSS21 then selected=SUB_PAGE_ID.BLANK
        elseif command==device_commands.CMFD1OSS22 or command==device_commands.CMFD2OSS22 then selected=SUB_PAGE_ID.EICAS
        elseif command==device_commands.CMFD1OSS23 or command==device_commands.CMFD2OSS23 then selected=SUB_PAGE_ID.UFCP
        elseif command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24 then selected=SUB_PAGE_ID.ADHSI
        elseif command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25 then selected=SUB_PAGE_ID.EW
        elseif command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26 then selected=SUB_PAGE_ID.SMS
        elseif command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27 then selected=SUB_PAGE_ID.HUD
        elseif command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28 then selected=SUB_PAGE_ID.HSD
        end

        if selected > 0 then
            CMFD["Format"]:set(selected)
            CMFD["Sel"]:set(selected)
            if CMFD["Primary"]:get()==1 then
                CMFD["SelRight"]:set(selected)
                CMFD["SelRightName"]:set(SUB_PAGE_NAME[selected])
                -- if CMFD["SelLeft"]:get() == selected then
                --     CMFD["SelLeft"]:set(SUB_PAGE_ID.BLANK)
                --     CMFD["SelLeftName"]:set(SUB_PAGE_NAME[SUB_PAGE_ID.BLANK])
                -- end
            else 
                CMFD["SelLeft"]:set(selected)
                CMFD["SelLeftName"]:set(SUB_PAGE_NAME[selected])
                -- if CMFD["SelRight"]:get() == selected then
                --     CMFD["SelRight"]:set(SUB_PAGE_ID.BLANK)
                --     CMFD["SelRightName"]:set(SUB_PAGE_NAME[SUB_PAGE_ID.BLANK])
                -- end
            end
        end
    end
end

function SetCommandMenu2(command,value, CMFD)
    if value == 1 then 
        if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then CMFD["Format"]:set(SUB_PAGE_ID.MENU1)
        elseif command == device_commands.CMFD2OSS2 then
            -- Função: Restaurar a configuração padrão do sistema para os formatos Primário e Secundário e para o DOI de cada modo principal.
        elseif command == device_commands.CMFD2OSS4 then
            -- Função: Restaurar os valores padrão do brilho da simbologia e do contraste das imagens de vídeo.
            -- Esta função é usada para se fazer uma recuperação rápida de ajustes errôneos de contraste ou brilho.
        end
    end
end

function SetCommandEicas(command,value, CMFD)
    if value == 1 then 
        if command==device_commands.CMFD1OSS13 or command==device_commands.CMFD2OSS13 then fuel_joker = fuel_joker + 5
        elseif command==device_commands.CMFD1OSS14 or command==device_commands.CMFD2OSS14 then fuel_joker = fuel_joker - 5
        elseif (command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11) and EICAS_INIT:get() == 1 then fuel_init = fuel_init + 5
        elseif (command==device_commands.CMFD1OSS12 or command==device_commands.CMFD2OSS12) and EICAS_INIT:get() == 1 then fuel_init = fuel_init - 5
        elseif command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25 then oat_base = oat_base - 1
        elseif command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26 then oat_base = oat_base + 1
        end
    end
end

function SetCommandAdhsi(command,value, CMFD)
    if value == 1 then 
        if command==device_commands.CMFD1OSS8 or command==device_commands.CMFD2OSS8 then 
            if adhsi_vv == 0 then 
                adhsi_vv = 1
            else 
                adhsi_vv = 0
            end
        elseif command==device_commands.CMFD1OSS12 or command==device_commands.CMFD2OSS12 then 
            adhsi_hdg_sel = (adhsi_hdg_sel + 1) % 360
        elseif command==device_commands.CMFD1OSS13 or command==device_commands.CMFD2OSS13 then 
            if adhsi_hdg_sel == 0 then adhsi_hdg_sel = 359
            else 
                adhsi_hdg_sel = adhsi_hdg_sel - 1
            end
        elseif command==device_commands.CMFD1OSS14 or command==device_commands.CMFD2OSS14 then 
            if adhsi_ans_mode == ANS_MODE_IDS.EGI then
                if adhsi_dtk == 0 then adhsi_dtk = 1 else adhsi_dtk = 0 end
            end
        elseif command==device_commands.CMFD1OSS21 or command==device_commands.CMFD2OSS21 then 
            if adhsi_vor_hdg ~= -1 then
                if adhsi_cdi_show == 0 then adhsi_cdi_show = 1 else adhsi_cdi_show = 0 end
            end
        elseif command==device_commands.CMFD1OSS22 or command==device_commands.CMFD2OSS22 then 
            if adhsi_rad_sel == 20 then adhsi_rad_sel = 10
            elseif adhsi_rad_sel == 40 then adhsi_rad_sel = 20
            elseif adhsi_rad_sel == 80 then adhsi_rad_sel = 40
            end
        elseif command==device_commands.CMFD1OSS23 or command==device_commands.CMFD2OSS23 then 
            if adhsi_rad_sel == 10 then adhsi_rad_sel = 20
            elseif adhsi_rad_sel == 20 then adhsi_rad_sel = 40
            elseif adhsi_rad_sel == 40 then adhsi_rad_sel = 80
            end
        elseif command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24 then 
            adhsi_ans_mode = (adhsi_ans_mode + 1) % 4
        end
    end
end


local CMFD = {{},{}}
CMFD[1]["Number"]          = 1
CMFD[1]["DCLT"]            = CMFD1DCLT
CMFD[1]["Primary"]         = CMFD1Primary
CMFD[1]["Format"]          = CMFD1Format
CMFD[1]["SelLeft"]         = CMFD1SelLeft
CMFD[1]["SelRight"]        = CMFD1SelRight
CMFD[1]["SelLeftName"]     = CMFD1SelLeftName
CMFD[1]["SelRightName"]    = CMFD1SelRightName
CMFD[1]["Sel"]             = CMFD1Sel
CMFD[1]["Selected"]        = CMFD1Format:get()
CMFD[1]["On"]              = CMFD1On
CMFD[1]["SwOn"]            = CMFD1SwOn

CMFD[2]["Number"]          = 2
CMFD[2]["DCLT"]            = CMFD2DCLT
CMFD[2]["Primary"]         = CMFD2Primary
CMFD[2]["Format"]          = CMFD2Format
CMFD[2]["SelLeft"]         = CMFD2SelLeft
CMFD[2]["SelRight"]        = CMFD2SelRight
CMFD[2]["SelLeftName"]     = CMFD2SelLeftName
CMFD[2]["SelRightName"]    = CMFD2SelRightName
CMFD[2]["Sel"]             = CMFD2Sel
CMFD[2]["On"]              = CMFD2On
CMFD[2]["SwOn"]            = CMFD2SwOn

function SetCommand(command,value)
    local cmfdnumber = 0
    if command >= device_commands.CMFD1OSS1 and command <= device_commands.CMFD1ButtonBright then 
        cmfdnumber=1
    elseif command >= device_commands.CMFD2OSS1 and command <= device_commands.CMFD2ButtonBright then 
        cmfdnumber=2
    end

    if command == device_commands.CMFD1OSS1 and value == -100 then -- Salvo Pressed
        CMFD1Format:set(SUB_PAGE_ID.SMS)
        SetCommandSms(command, value, CMFD[cmfdnumber])
        return 0
    elseif command == device_commands.CMFD1OSS1 and value == -200 then -- E-J Finished
        SetCommandSms(command, value, CMFD[cmfdnumber])
        CMFD1Format:set(CMFD1Sel:get())
        return 0
    end

    if command == device_commands.CMFD1ButtonOn or command == device_commands.CMFD2ButtonOn then
        -- Quando se liga o CMFD, as imagens tornam-se visíveis depois de aproximadamente 30 segundos e o seu desempenho é total depois de 5 minutos.
        CMFD[cmfdnumber]["SwOn"]:set(value)
    end

    if CMFD[cmfdnumber]["On"]:get() == 0 then return end

    if CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU1 then SetCommandMenu1(command,value, CMFD[cmfdnumber]) 
    elseif CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU2 then SetCommandMenu2(command,value, CMFD[cmfdnumber]) 
    elseif CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.EICAS then SetCommandEicas(command,value, CMFD[cmfdnumber]) 
    elseif CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.ADHSI then SetCommandAdhsi(command,value, CMFD[cmfdnumber]) 
    elseif CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.SMS   then SetCommandSms(command,value, CMFD[cmfdnumber]) 
    end

    if value == 1 then
        --print_message_to_user("CMFD: command "..tostring(command).." = "..tostring(value) .. " Tela=" .. tostring(CMFD["Selected"]))

        if command == device_commands.CMFD1OSS15 or command == device_commands.CMFD2OSS15 then
            CMFD[cmfdnumber]["DCLT"]:set((CMFD[cmfdnumber]["DCLT"]:get()+1)%2)
            -- OSS 15 (DCLT) – Tem a função de alternar entre ocultar e apresentar as legendas adjacentes aos OSS 1 a 14 e 21 a 28.
            -- A legenda DCLT fica em vídeo inverso quando a função de ocultar estiver ativada e em vídeo normal quando desativada.
            -- Mesmo quando as legendas estiverem ocultas, os OSS continuam com suas funções habilitadas.
            -- A função DCLT é individual para cada formato, e é mantida a última seleção feita.
        elseif command == device_commands.CMFD1OSS16 or command == device_commands.CMFD2OSS16 then
            if CMFD[cmfdnumber]["Primary"]:get()==1 then
                if (CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU1) or (CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU2) then
                    CMFD[cmfdnumber]["Format"]:set(CMFD[cmfdnumber]["SelRight"]:get())
                    CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelRight"]:get())
                else 
                    CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelRight"]:get())
                    CMFD[cmfdnumber]["Format"]:set(SUB_PAGE_ID.MENU1)
                end
            else 
                CMFD[cmfdnumber]["Primary"]:set(1)
                CMFD[cmfdnumber]["Format"]:set(CMFD[cmfdnumber]["SelRight"]:get())
                CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelRight"]:get())
            end
        elseif command == device_commands.CMFD1OSS19 or command == device_commands.CMFD2OSS19 then
            if CMFD[cmfdnumber]["Primary"]:get()==0 then
                if (CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU1) or (CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU2) then
                    CMFD[cmfdnumber]["Format"]:set(CMFD[cmfdnumber]["SelLeft"]:get())
                    CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelLeft"]:get())
                else 
                    CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelLeft"]:get())
                    CMFD[cmfdnumber]["Format"]:set(SUB_PAGE_ID.MENU1)
                end
            else 
                CMFD[cmfdnumber]["Primary"]:set(0)
                CMFD[cmfdnumber]["Format"]:set(CMFD[cmfdnumber]["SelLeft"]:get())
                CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelLeft"]:get())
            end
            -- OSS 16 e 19 (Formatos Primário e Secundário) – Têm a função de selecionar o formato primário de apresentação.
            -- As legendas adjacentes aos OSS 16 e 19 representam os formatos primário e secundário selecionados e podem ser qualquer uma daquelas que representam os formatos possíveis de serem selecionados, quais sejam: HSD, SMS, UFCP, DVR, EW, ADHSI, EICAS, FLIR, EMERG, PFL, BIT, HUD, DTE e NAV.
            -- A legenda adjacente a um destes OSS que estiver em vídeo inverso indica que o respectivo formato é o primário e a que estiver em vídeo normal indica que o respectivo formato é o secundário.
            -- Pressionando-se o OSS adjacente à legenda do formato secundário (vídeo normal), inverte-se a seleção de formato primário e secundário entre as duas opções.
            -- Pressionando-se o OSS adjacente à legenda do formato primário (vídeo inverso), seleciona-se o formato MENU. Selecionando-se um outro formato a partir do formato MENU, este passa a ser o novo formato primário.
            -- Os displays primário e secundário apresentados ao ligar o sistema aviônico são determinados pelo modo principal selecionado ou da programação carregada por meio do DTC.
        elseif command == device_commands.CMFD1OSS17 or command == device_commands.CMFD2OSS17 then
            CMFDDoi:set(cmfdnumber)
            -- OSS 17 (DOI) – Tem a função de indicar se o respectivo CMFD é o display de interesse (Display Of Interest – DOI) selecionado.
            -- A seleção do DOI é feita pressionando-se o OSS 17 do respectivo CMFD ou movendo-se para a esquerda ou para a direita no Interruptor de Gerenciamento dos Displays no manche.
            -- O CMFD selecionado como DOI é aquele que estiver habilitado no momento para ser controlado pelos interruptores da função HOTAS.
            -- A seta do DOI pode ser apresentada apontando para cima ou para baixo nos CMFD e segue a seguinte lógica:
            --  • Seta para cima (⇑) no CMFD direito ou esquerdo indica que o referido display da nacele dianteira é o DOI;
            --  • Seta para baixo (⇓) no CMFD direito ou esquerdo indica que o referido display da nacele traseira é o DOI;
            --  • Nenhuma seta nos CMFD indica que o HUD é o DOI.
            -- A seleção do DOI é mantida de acordo com a última seleção feita ou modificada através da programação carregada por meio do DTC.
        elseif command == device_commands.CMFD1OSS18 or command == device_commands.CMFD2OSS18 then
            if CMFD1Primary:get() == 0 then
                selected1 = CMFD1SelLeft
                name1 = CMFD1SelLeftName
            else 
                selected1 = CMFD1SelRight
                name1 = CMFD1SelRightName
            end
            if CMFD2Primary:get() == 0 then
                selected2 = CMFD2SelLeft
                name2 = CMFD2SelLeftName
            else 
                selected2 = CMFD2SelRight
                name2 = CMFD2SelRightName
            end
            seltemp = selected1:get()
            nametemp = name1:get()
            selected1:set(selected2:get())
            name1:set(name2:get())
            selected2:set(seltemp)
            name2:set(nametemp)
            CMFD1Sel:set(selected1:get())
            CMFD1Format:set(selected1:get())
            CMFD2Sel:set(selected2:get())
            CMFD2Format:set(selected2:get())
            -- OSS 18 (SWAP) – Tem a função de trocar os formatos que estiverem sendo apresentados nos CMFDs da esquerda e da direita.
            -- Ao pressionar o OSS 18, o formato que esta sendo apresentado no CMFD esquerdo passa a ser apresentado no CMFD direito e vice-versa.
            -- Pode-se efetuar a troca (SWAP) entre os displays primário e secundário de um mesmo CMFD através de dois movimentos para a esquerda no Interruptor de Gerenciamento dos Displays (DMS) no punho do manche para o CMFD da esquerda. Analogamente pode-se fazer a mesma troca no CMFD da direita.
            -- A função de troca (SWAP) continua disponível mesmo que o CMFD direito não esteja instalado.
        elseif command == device_commands.CMFD1OSS20 or command == device_commands.CMFD2OSS20 then
            -- OSS 20 (IND) – Tem a função de individualizar a seleção dos formatos dos CMFDs dianteiro e traseiro de um mesmo lado.
            -- Esta função está habilitada somente na nacele traseira e a sua ativação e desativação é feita pressionando-se o OSS 20. Entretanto, a legenda é apresentada nas duas naceles.
            -- Quando a função estiver ativada, a legenda IND é apresentada com uma moldura. Neste caso, é possível selecionar formatos distintos nos CMFDs do mesmo lado.
            -- Quando a legenda IND é apresentada sem moldura (função desativada), os CMFDs dianteiro e traseiro do mesmo lado apresentam obrigatoriamente o mesmo formato.
            -- Durante a operação com a função IND ativada, a edição de dados em um dos CMFDs edita os mesmos dados no outro CMFD (exemplo: modificação do ponto FYT).
            -- Pressionando-se o OSS 18 (SWAP) nos CMFDs da nacele traseira estando com a função IND ativada em um ou ambos os CMFD, a função IND é desativada em todos os CMFDs. Caso a função SWAP seja acionada na nacele dianteira, não provoca a desativação da função IND.
            -- Uma troca de modo principal não afeta quando a função IND está ativada. O modo principal afeta os CMFDs da nacele dianteira e todos os outros CMFDs que estiverem no modo de CMFD repetidor.
        end
    end

end

startup_print("CMFD2: load end")
need_to_be_closed = false -- close lua state after initialization


