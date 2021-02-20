AVIONICS_MASTER_MODE_ID = {
    NAV         = 1,
    LANDING     = 2, 
    INT         = 3, 
    DGFT_B      = 4,
    DGFT_L      = 5,
    DTOS        = 6,
    DTOS_R      = 7,
    CCRP        = 8,
    CCIP        = 9,
    CCIP_R      = 10,
    MAN         = 11,
    GUN         = 12,
    GUN_R       = 13,
    SJ          = 14,
    EJ          = 15,
    MARK        = 16,
    MARK_R      = 17,
    FIX         = 18,
    FIX_R       = 19,
    RALT        = 20,
    ACAL        = 21,
}
AVIONICS_MASTER_MODE_STR={}

AVIONICS_MASTER_MODE_STR[1] = "NAV"
AVIONICS_MASTER_MODE_STR[2] = ""
AVIONICS_MASTER_MODE_STR[3] = "INT"
AVIONICS_MASTER_MODE_STR[4] = "DGFT B"
AVIONICS_MASTER_MODE_STR[5] = "DGFT L"
AVIONICS_MASTER_MODE_STR[6] = "DTOS"
AVIONICS_MASTER_MODE_STR[7] = "DTOS R"
AVIONICS_MASTER_MODE_STR[8] = "CCRP"
AVIONICS_MASTER_MODE_STR[9] = "CCIP"
AVIONICS_MASTER_MODE_STR[10] = "CCIP R"
AVIONICS_MASTER_MODE_STR[11] = "MAN"
AVIONICS_MASTER_MODE_STR[12] = "GUN"
AVIONICS_MASTER_MODE_STR[13] = "GUN R"
AVIONICS_MASTER_MODE_STR[14] = "SJ"
AVIONICS_MASTER_MODE_STR[15] = "EJ"
AVIONICS_MASTER_MODE_STR[16] = "MARK"
AVIONICS_MASTER_MODE_STR[17] = "MARK R"
AVIONICS_MASTER_MODE_STR[18] = "FIX"
AVIONICS_MASTER_MODE_STR[19] = "FIX R"
AVIONICS_MASTER_MODE_STR[20] = "RALT"
AVIONICS_MASTER_MODE_STR[21] = "ACAL"


ANS_MODE_IDS = {
    EGI = 0,
    VOR = 1,
    GPS = 2,
    ILS = 3,
}

AVIONICS_IAS = get_param_handle("AVIONICS_IAS")
AVIONICS_ALT = get_param_handle("AVIONICS_ALT")
AVIONICS_VV = get_param_handle("AVIONICS_VV")
AVIONICS_HDG = get_param_handle("AVIONICS_HDG")
AVIONICS_RALT = get_param_handle("AVIONICS_RALT")
AVIONICS_TURN_RATE = get_param_handle("AVIONICS_TURN_RATE")
AVIONICS_ONGROUND = get_param_handle("BASE_SENSOR_WOW_LEFT_GEAR")

ANS_MODE = get_param_handle("ANS_MODE")
AVIONICS_MASTER_MODE = get_param_handle("AVIONICS_MASTER_MODE")
AVIONICS_MASTER_MODE_LAST = get_param_handle("AVIONICS_MASTER_MODE_LAST")
AVIONICS_MASTER_MODE_TXT = get_param_handle("AVIONICS_MASTER_MODE_TXT")
AVIONICS_GEAR_UP = get_param_handle("BASE_SENSOR_LEFT_GEAR_UP")


function get_avionics_ias()
    return AVIONICS_IAS:get()
end

function get_avionics_alt()
    return AVIONICS_ALT:get()
end

function get_avionics_hdg()
    return AVIONICS_HDG:get()
end

function get_avionics_ralt()
    return AVIONICS_RALT:get()
end

function get_avionics_vv()
    return AVIONICS_VV:get()
end

function get_avionics_turn_rate()
    return AVIONICS_TURN_RATE:get()
end

function get_avionics_onground()
    return AVIONICS_ONGROUND:get() == 1
end

function get_avionics_gear_down()
    return AVIONICS_GEAR_UP:get() == 0
end

function get_avionics_master_mode_last()
    return AVIONICS_MASTER_MODE_LAST:get()
end

function get_avionics_master_mode()
    return AVIONICS_MASTER_MODE:get()
end

function set_avionics_master_mode(new_mode)
    local current_mode = get_avionics_master_mode()
    if new_mode ~= current_mode and current_mode ~= AVIONICS_MASTER_MODE_ID.EJ and current_mode ~= AVIONICS_MASTER_MODE_ID.SJ then
        AVIONICS_MASTER_MODE_LAST:set(current_mode)
    end
    AVIONICS_MASTER_MODE:set(new_mode)
end

function get_avionics_master_mode_aa(master_mode)
    master_mode = master_mode or get_avionics_master_mode()
    return  master_mode == AVIONICS_MASTER_MODE_ID.DGFT_B or
        master_mode == AVIONICS_MASTER_MODE_ID.DGFT_L or
        master_mode == AVIONICS_MASTER_MODE_ID.INT
end

function get_avionics_master_mode_ag(master_mode)
    master_mode = master_mode or get_avionics_master_mode()
    return master_mode == AVIONICS_MASTER_MODE_ID.GUN or
        master_mode == AVIONICS_MASTER_MODE_ID.MAN or
        master_mode == AVIONICS_MASTER_MODE_ID.GUN_R or
        master_mode == AVIONICS_MASTER_MODE_ID.CCIP or
        master_mode == AVIONICS_MASTER_MODE_ID.CCIP_R or
        master_mode == AVIONICS_MASTER_MODE_ID.CCRP or
        master_mode == AVIONICS_MASTER_MODE_ID.DTOS or
        master_mode == AVIONICS_MASTER_MODE_ID.DTOS_R
end