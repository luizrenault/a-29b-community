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

ANS_MODE = get_param_handle("ANS_MODE")


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
