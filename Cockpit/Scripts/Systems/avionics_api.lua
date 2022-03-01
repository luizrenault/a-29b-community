AVIONICS_MASTER_MODE_ID = {
    NAV         = 1,
    LANDING     = 2, 
    INT_B       = 3, 
    INT_L       = 4, 
    DGFT_B      = 5,
    DGFT_L      = 6,
    GUN         = 7,
    GUN_R       = 8,
    GUN_M       = 9,
    DTOS        = 10,
    DTOS_R      = 11,
    CCRP        = 12,
    CCIP        = 13,
    CCIP_R      = 14,
    MAN         = 15,
    SJ          = 16,
    EJ          = 17,
    MARK        = 18,
    MARK_R      = 19,
    FIX         = 20,
    FIX_R       = 21,
    RALT        = 22,
    ACAL        = 23,
    A_G         = 24,
    A_A         = 25,
}
AVIONICS_MASTER_MODE_STR={}

AVIONICS_MASTER_MODE_STR[1] = "NAV"
AVIONICS_MASTER_MODE_STR[2] = ""
AVIONICS_MASTER_MODE_STR[3] = "INT B"
AVIONICS_MASTER_MODE_STR[4] = "INT L"
AVIONICS_MASTER_MODE_STR[5] = "DGFT B"
AVIONICS_MASTER_MODE_STR[6] = "DGFT L"
AVIONICS_MASTER_MODE_STR[7] = "GUN"
AVIONICS_MASTER_MODE_STR[8] = "GUN R"
AVIONICS_MASTER_MODE_STR[9] = "GUN"
AVIONICS_MASTER_MODE_STR[10] = "DTOS"
AVIONICS_MASTER_MODE_STR[11] = "DTOS R"
AVIONICS_MASTER_MODE_STR[12] = "CCRP"
AVIONICS_MASTER_MODE_STR[13] = "CCIP"
AVIONICS_MASTER_MODE_STR[14] = "CCIP R"
AVIONICS_MASTER_MODE_STR[15] = "MAN"
AVIONICS_MASTER_MODE_STR[16] = "SJ"
AVIONICS_MASTER_MODE_STR[17] = "EJ"
AVIONICS_MASTER_MODE_STR[18] = "MARK"
AVIONICS_MASTER_MODE_STR[19] = "MARK R"
AVIONICS_MASTER_MODE_STR[20] = "FIX"
AVIONICS_MASTER_MODE_STR[21] = "FIX R"
AVIONICS_MASTER_MODE_STR[22] = "RALT"
AVIONICS_MASTER_MODE_STR[23] = "ACAL"
AVIONICS_MASTER_MODE_STR[24] = ""
AVIONICS_MASTER_MODE_STR[25] = ""


AVIONICS_ANS_MODE_IDS = {
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

AVIONICS_ANS_MODE = get_param_handle("AVIONICS_ANS_MODE")
AVIONICS_MASTER_MODE = get_param_handle("AVIONICS_MASTER_MODE")
AVIONICS_MASTER_MODE_LAST = get_param_handle("AVIONICS_MASTER_MODE_LAST")
AVIONICS_MASTER_MODE_TXT = get_param_handle("AVIONICS_MASTER_MODE_TXT")
AVIONICS_GEAR_UP = get_param_handle("BASE_SENSOR_LEFT_GEAR_UP")

local UFCP_DTK_ENABLED = get_param_handle("ADHSI_DTK")


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
    if new_mode ~= current_mode and current_mode ~= AVIONICS_MASTER_MODE_ID.EJ and current_mode ~= AVIONICS_MASTER_MODE_ID.SJ and current_mode ~= AVIONICS_MASTER_MODE_ID.A_G then
        AVIONICS_MASTER_MODE_LAST:set(current_mode)
    end

    -- Disable these stuff in A/A or A/G
    if get_avionics_master_mode_aa(new_mode) or get_avionics_master_mode_ag(new_mode) then
        UFCP_DTK_ENABLED:set(0)
    end
    AVIONICS_MASTER_MODE:set(new_mode)
end

function get_avionics_master_mode_aa(master_mode)
    master_mode = master_mode or get_avionics_master_mode()
    return  master_mode == AVIONICS_MASTER_MODE_ID.DGFT_B or
        master_mode == AVIONICS_MASTER_MODE_ID.DGFT_L or
        master_mode == AVIONICS_MASTER_MODE_ID.INT_B or 
        master_mode == AVIONICS_MASTER_MODE_ID.INT_L
end

function get_avionics_master_mode_aa_int(master_mode)
    master_mode = master_mode or get_avionics_master_mode()
    return  master_mode == AVIONICS_MASTER_MODE_ID.INT_B or 
        master_mode == AVIONICS_MASTER_MODE_ID.INT_L
end

function get_avionics_master_mode_aa_dgft(master_mode)
    master_mode = master_mode or get_avionics_master_mode()
    return  master_mode == AVIONICS_MASTER_MODE_ID.DGFT_B or
    master_mode == AVIONICS_MASTER_MODE_ID.DGFT_L
end

function get_avionics_master_mode_ag_gun(master_mode)
    master_mode = master_mode or get_avionics_master_mode()
    return master_mode >= AVIONICS_MASTER_MODE_ID.GUN and master_mode <= AVIONICS_MASTER_MODE_ID.GUN_M
end

function get_avionics_master_mode_ag(master_mode)
    master_mode = master_mode or get_avionics_master_mode()
    return master_mode >= AVIONICS_MASTER_MODE_ID.GUN and master_mode <= AVIONICS_MASTER_MODE_ID.MAN
end

function get_avionics_gs()
    local gsx, gsy, gsz = get_base_data():getSelfVelocity()
    return math.sqrt(gsx * gsx + gsz * gsz)
end