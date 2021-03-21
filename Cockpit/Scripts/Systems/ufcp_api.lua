UFCP_NAV_MODE = get_param_handle("UFCP_NAV_MODE")
UFCP_NAV_TIME = get_param_handle("UFCP_NAV_TIME")
UFCP_VAH = get_param_handle("UFCP_VAH")
UFCP_VV = get_param_handle("UFCP_VV")

UFCP_FORMAT_IDS = {
    MAIN = 0,
    COM1 = 1,
    COM2 = 2,
    COM2_NET = 3,
    NAV_AIDS = 4,
    VV_VAH = 5,
    WPT = 6,
    WPT_UTM = 7,
    XPDR = 8,
    TIME = 9,
    MARK = 10,
    FIX = 11,
    TIP = 12,
    MENU = 13,
    LMT = 14,
    DTK = 15,
    BAL = 16,
    NAV_MODE = 17,
    NAV_MISC = 18,
    WS = 19,
    EGI_INS = 20,
    EGI_GPS = 21,
    TAC_MENU = 22,
    TAC_CTLN = 23,
    TAC_AVOID = 24,
    MODE = 25,
    OAP = 26,
    ACAL = 27,
    FUEL = 28,
    MISC = 29,
    PARA = 30,
    FTI = 31,
    DCLT = 32,
    CRUS = 33,
    DRFT = 34,
    TK_L_DATA = 35,
    TK_L_TKOF = 36,
    TK_L_LAND = 37,
    STRM = 38,
    FLIR = 39,
    DL_MENU = 40,
    DL_SET = 41,
    DL_INV = 42,
    DL_MSG = 43,
    MSG_READ = 44,
    DLWP = 45,
    SNDP = 46,
    DA_H = 47,
    C_F = 48,
    F_ACK = 49,
}

-- MAIN
UFCP_MAIN_SEL_IDS = {
    FYT = 0,
    COM1 = 1,
    COM2 = 2,
    TIME = 3,
}

-- COM 1 & 2
UFCP_COM_MODE_IDS = {
    OFF = 0,
    TR= 1,
    TR_G = 2,
}

UFCP_COM_FREQUENCY_SEL_IDS = {
    MAN = 0,
    PRST = 1,
}

UFCP_COM_POWER_IDS = {
    HIGH = 0,
    MED= 1,
    LOW = 2,
}

UFCP_COM_MODULATION_IDS = {
    AM = 0,
    FM= 1,
}

-- COM 1
UFCP_COM1_SEL_IDS = {
    MAN_FREQUENCY = 0,
    CHANNEL = 1,
    PRST_FREQUENCY = 2,
    NEXT_FREQUENCY = 3,
    POWER = 4,
    MODULATION = 5,
    SQL = 6,
    MODE = 7,
}

-- COM 2
UFCP_COM2_SEL_IDS = {
    MAN_FREQUENCY = 0,
    CHANNEL = 1,
    PRST_FREQUENCY = 2,
    NEXT_FREQUENCY = 3,
    POWER = 4,
    MODULATION = 5,
    SQL = 6,
    FORMAT = 7,
    MODE = 8,
    DL = 9
}

-- VV/VAH
UFCP_VVVAH_MODE_IDS = {
    VAH = 0,
    OFF = 1,
    VV_VAH = 2,
}

-- WPT
UFCP_WPT_TYPE_IDS = {
    FYT = 0,
    WP = 1,
}
UFCP_WPT_TYPE_IDS[UFCP_WPT_TYPE_IDS.FYT] = "FYT"
UFCP_WPT_TYPE_IDS[UFCP_WPT_TYPE_IDS.WP] = " WP"

UFCP_WPT_SEL_IDS = {
    FYT_WP = 0,
    -- GEO_UTM = 1,
    LAT = 1,
    LON = 2,
    ELV = 3,
    TOFT = 4,

    END = 5,
}

-- NAV
UFCP_NAV_MODE_IDS = {
    MAN = 0,
    AUTO = 1,
    END = 2,
}

UFCP_NAV_TIME_IDS = {
    ETA = 0,
    TTD = 1,
    DT = 2,
    END = 3,
}

UFCP_NAV_SOLUTION_IDS = {
    NAV_EGI = 0,
    NAV_INS = 1,
    NAV_GPS = 2,
    NAV_BU  = 3,
}
UFCP_NAV_SOLUTION_IDS[UFCP_NAV_SOLUTION_IDS.NAV_EGI] = "NAV-EGI"
UFCP_NAV_SOLUTION_IDS[UFCP_NAV_SOLUTION_IDS.NAV_INS] = "NAV-INS"
UFCP_NAV_SOLUTION_IDS[UFCP_NAV_SOLUTION_IDS.NAV_GPS] = "NAV-GPS"
UFCP_NAV_SOLUTION_IDS[UFCP_NAV_SOLUTION_IDS.NAV_BU] = "NAV-B/U"

-- TIME
UFCP_TIME_TYPE_IDS = {
    LC = 0,
    RT = 1,
    SW = 2.
}
UFCP_TIME_TYPE_IDS[UFCP_TIME_TYPE_IDS.LC] = "LC"
UFCP_TIME_TYPE_IDS[UFCP_TIME_TYPE_IDS.RT] = "RT"
UFCP_TIME_TYPE_IDS[UFCP_TIME_TYPE_IDS.SW] = "SW"
