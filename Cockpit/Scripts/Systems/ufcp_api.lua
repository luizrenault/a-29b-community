UFCP_NAV_MODE = get_param_handle("UFCP_NAV_MODE")
UFCP_NAV_TIME = get_param_handle("UFCP_NAV_TIME")
UFCP_VAH = get_param_handle("UFCP_VAH")
UFCP_VV = get_param_handle("UFCP_VV")
UFCP_TEXT = get_param_handle("UFCP_TEXT")

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

ufcp_sel_format = UFCP_FORMAT_IDS.MAIN

-- COM 1 & 2
UFCP_COM_FREQUENCY_SEL_IDS = {
    MAN = 0,
    PRST = 1,
}

ufcp_edit_pos = 0
ufcp_edit_lim = 0
ufcp_edit_string = ""
ufcp_edit_validate = nil

UFCP_TEXT = get_param_handle("UFCP_TEXT")

ufcp_cmfd_ref = nil

update_time_step = 0.02 --update will be called 50 times per second

function ufcp_edit_clear()
    ufcp_edit_pos = 0
    ufcp_edit_lim = 0
    ufcp_edit_string = ""
    ufcp_edit_validate = nil
end

function replace_text(text, c_start, c_size)
    if ufcp_edit_pos == 0 then return text end
    local text_copy = text:sub(1,c_start-1)
    local text_new = text:sub(c_start, c_start+c_size-1)
    if ufcp_edit_pos > 0 then 
        text_new = "*"
        for i=1,(c_size - ufcp_edit_pos-2) do
            text_new = text_new .. " "
        end
        text_new = text_new .. ufcp_edit_string .. "*"
    end
    for i=1, c_size do
        local val = string.byte(text_new,i)
        if val >= string.byte("A") and val <= string.byte("Z") then val = val + 32
        elseif val >= string.byte("0") and val <= string.byte("9") then val = val - 34
        elseif val >= string.byte(" ") and val <= string.byte("+") then val = val - 31
        elseif val >= string.byte(",") and val <= string.byte("/") then val = val - 20
        elseif val == string.byte(":") then val = val - 30
        end
        text_copy = text_copy .. string.char(val)
    end
    text_copy = text_copy .. text:sub(c_start + c_size)
    return text_copy
end

function replace_pos(text, c_pos)
    local text_copy = text:sub(1,c_pos-1)
    local val = string.byte(text,c_pos)
    if     val >= string.byte("A") and val <= string.byte("Z") then val = val + 32
    elseif val >= string.byte("0") and val <= string.byte("9") then val = val - 34
    elseif val >= string.byte(" ") and val <= string.byte("+") then val = val - 31
    elseif val >= string.byte(",") and val <= string.byte("/") then val = val - 20
    elseif val == string.byte(":") then val = val - 30
    end
    text_copy = text_copy .. string.char(val)
    text_copy = text_copy .. text:sub(c_pos + 1)
    return text_copy
end