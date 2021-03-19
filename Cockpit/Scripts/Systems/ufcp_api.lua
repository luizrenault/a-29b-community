
UFCP_NAV_MODE = get_param_handle("UFCP_NAV_MODE")
UFCP_NAV_TIME = get_param_handle("UFCP_NAV_TIME")

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
}

UFCP_MAIN_SEL_IDS = {
    FYT = 0,
}

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

UFCP_TIME_TYPE_IDS = {
    LC = 0,
    RT = 1,
    SW = 2.
}
UFCP_TIME_TYPE_IDS[UFCP_TIME_TYPE_IDS.LC] = "LC"
UFCP_TIME_TYPE_IDS[UFCP_TIME_TYPE_IDS.RT] = "RT"
UFCP_TIME_TYPE_IDS[UFCP_TIME_TYPE_IDS.SW] = "SW"
