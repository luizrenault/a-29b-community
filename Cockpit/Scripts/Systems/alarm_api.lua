dofile(LockOn_Options.script_path.."devices.lua")

local count = 0
local function counter()
    count = count + 1
    return count
end

local count = 0

WARNING_ID = {
    AFT_OXY         = 0,
    AP        = counter(),
    BAT_TEMP        = counter(),
    BLD_LEAK        = counter(),
    CAB_ALT        = counter(),
    CAB_PRESS        = counter(),
    CANOPY        = counter(),
    ENG_LMTS        = counter(),
    ENG_MAN        = counter(),
    FIRE        = counter(),
    FUEL_FUS        = counter(),
    FUEL_LVL        = counter(),
    FWD_OXY        = counter(),
    OIL_PRESS        = counter(),
    OIL_TEMP        = counter(),
    OXYGEN          = counter(),
    LDG_GEAR        = counter(),
}

CAUTION_ID = {
    AFT_PIN        = counter(),
    AIR_COND        = counter(),
    AP_MIST        = counter(),
    ARM_OFF        = counter(),
    BATTERY        = counter(),
    BKUP_BAT        = counter(),
    BLD_OVHT        = counter(),
    CAB_ALT        = counter(),
    CHIP_DET        = counter(),
    ELEC_XFR        = counter(),
    ELEC_OVH        = counter(),
    EMER_BRK        = counter(),
    EMER_BUS        = counter(),
    EMER_GEAR        = counter(),
    FUEL_IMB          = counter(),
    FUEL_FILT          = counter(),
    FUEL_PRESS          = counter(),
    FUEL_XFER          = counter(),
    FWD_PIN          = counter(),
    GB_OVLD          = counter(),
    GEN          = counter(),
    HYD_RESS          = counter(),
    MAN_RUD_T          = counter(),
    PITO_TAT          = counter(),
    PROP_DEIC          = counter(),
    S_PITOT          = counter(),
    STARTER          = counter(),
    STORM          = counter(),
    BINGO          = counter(),
    AVIONICS          = counter(),
    FLIR          = counter(),

}

ADVICE_ID = {
    DVR_END        = counter(),
    DVR_10_MN        = counter(),
    INERT_SEP        = counter(),
    INTC_ON        = counter(),
    OXYBIT        = counter(),
    WING_CLOS        = counter(),
    WS_DEICE        = counter(),
    XFER_OVRD        = counter(),
}

VOICE_ID = {
    STALL        = counter(),
    OVER_G        = counter(),
    SPEED        = counter(),
    LANDING_GEAR        = counter(),
    DECISION_ALTITUDE        = counter(),
    MINIMUM        = counter(),
    PULL_UP        = counter(),
    XFER_OVRD        = counter(),
    AUTOPILOT       = counter(),
}

-- alarm state 0 = off; 1 = on; 2 = acknowledged
-- alarm id ;


function set_warning(id, state)
    state = state or 1
    local alarm = GetDevice(devices.ALARM)
    if state == 0 then          alarm:SetCommand(device_commands.ALERTS_RESET_WARNING,id)
    elseif state == 1 then      alarm:SetCommand(device_commands.ALERTS_SET_WARNING,id)
    elseif state == 2 then      alarm:SetCommand(device_commands.ALERTS_ACK_WARNING,id)
    end
end

function set_caution(id, state)
    state = state or 1
    local alarm = GetDevice(devices.ALARM)
    if state == 0 then          alarm:SetCommand(device_commands.ALERTS_RESET_CAUTION,id)
    elseif state == 1 then      alarm:SetCommand(device_commands.ALERTS_SET_CAUTION,id)
    elseif state == 2 then      alarm:SetCommand(device_commands.ALERTS_ACK_CAUTION,id)
    end
end

function set_advice(id, state)
    state = state or 1
    local alarm = GetDevice(devices.ALARM)
    if state == 0 then          alarm:SetCommand(device_commands.ALERTS_RESET_ADVICE,id)
    elseif state == 1 then      alarm:SetCommand(device_commands.ALERTS_SET_ADVICE,id)
    end
end

function set_voice(id, state) -- TODO create voice alarms
    state = state or 1
    local alarm = GetDevice(devices.ALARM)
    --if state == 0 then          alarm:SetCommand(device_commands.ALERTS_RESET_ADVICE,id)
    --elseif state == 1 then      alarm:SetCommand(device_commands.ALERTS_SET_ADVICE,id)
    --end
end


function acknowledge_warnings()
    local alarm = GetDevice(devices.ALARM)
    alarm:SetCommand(device_commands.ALERTS_ACK_WARNINGS, 0)
end

function acknowledge_cautions()
    local alarm = GetDevice(devices.ALARM)
    alarm:SetCommand(device_commands.ALERTS_ACK_CAUTIONS, 0)
end

local hud_warn_on = get_param_handle("HUD_WARN_ON")
function get_hud_warning()
    return hud_warn_on:get()
end

function set_hud_warning(value)
    return hud_warn_on:set(value)
end