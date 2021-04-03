local UFCP_XPDR_CODE = get_param_handle("UFCP_XPDR_CODE")

-- Constants

local SEL_IDS = {
    MODE = 0,
    CODE = 1,
    NORDO = 2,
    EMER = 3,
}

local MODE_IDS = {
    STBY = 0,
    ON = 1,
    ALT = 2,
}

-- Inits
ufcp_xpdr_mode = MODE_IDS.STBY
ufcp_xpdr_ident = false
ufcp_xpdr_code = "2000"
ufcp_xpdr_nordo = false
ufcp_xpdr_emer = false

-- Methods

UFCP_XPDR_CODE:set(ufcp_xpdr_code)

local function ufcp_xpdr_code_validate(text, save)
    if text:len() >= ufcp_edit_lim then
        local number = tonumber(text)
        if number ~= nil and tonumber(text:sub(1,1)) < 8 and tonumber(text:sub(2,2)) < 8 and tonumber(text:sub(3,3)) < 8 and tonumber(text:sub(4,4)) < 8 then
            ufcp_xpdr_code = text
            UFCP_XPDR_CODE:set(ufcp_xpdr_code)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local FIELD_INFO = {
    [SEL_IDS.CODE] = {4, ufcp_xpdr_code_validate},
}

local sel = 0
local max_sel = 4
function update_xpdr()
    local text = ""

    text = text .. "  XPDR"

    -- Mode
    if sel == SEL_IDS.MODE then text = text .. "*" else text = text .. " " end
    if ufcp_xpdr_mode == MODE_IDS.STBY then
        text = text .. "STBY"
    elseif ufcp_xpdr_mode == MODE_IDS.ON then
        text = text .. "ON  "
    else
        text = text .. "ALT "
    end
    if sel == SEL_IDS.MODE then text = text .. "*" else text = text .. " " end

    text = text .. "      "

    -- Ident
    if ufcp_xpdr_ident then text = text .. "IDNT" else text = text .. "    " end

    text = text .. " \n\n"

    -- Code
    text = text .. "CODE "
    if sel == SEL_IDS.CODE then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.CODE and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. ufcp_xpdr_code end
    if sel == SEL_IDS.CODE then text = text .. "*" else text = text .. " " end

    text = text .. "  "

    -- NORDO
    if sel == SEL_IDS.NORDO then text = text .. "*" else text = text .. " " end
    text = text .. "EMER  7600"
    if sel == SEL_IDS.NORDO then text = text .. "*" else text = text .. " " end
    text = text .. "\n"

    -- EMER
    text = text .. "             "
    if sel == SEL_IDS.EMER then text = text .. "*" else text = text .. " " end
    text = text .. "EMER  7700"
    if sel == SEL_IDS.EMER then text = text .. "*" else text = text .. " " end

    if sel == SEL_IDS.CODE and ufcp_edit_pos > 0 then
        text = replace_pos(text, 31)
        text = replace_pos(text, 36)
    end

    if ufcp_xpdr_nordo then
        text = replace_pos(text, 39)
        text = replace_pos(text, 50)
    end

    if ufcp_xpdr_emer then
        text = replace_pos(text, 65)
        text = replace_pos(text, 76)
    end

    UFCP_TEXT:set(text)
end

function SetCommandXPDR(command,value)
    if command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        if sel == SEL_IDS.MODE then
            ufcp_xpdr_mode = (ufcp_xpdr_mode + 1) % 3
        end
    elseif command == device_commands.UFCP_JOY_DOWN and value == 1 then
        sel = (sel + 1) % max_sel
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        sel = (sel - 1) % max_sel
    elseif sel == SEL_IDS.NORDO and command == device_commands.UFCP_0 and value == 1 then
        ufcp_xpdr_emer = false
        ufcp_xpdr_nordo = not ufcp_xpdr_nordo
        if ufcp_xpdr_nordo then UFCP_XPDR_CODE:set(7600) else UFCP_XPDR_CODE:set(ufcp_xpdr_code) end
    elseif sel == SEL_IDS.EMER and command == device_commands.UFCP_0 and value == 1 then
        ufcp_xpdr_nordo = false
        ufcp_xpdr_emer = not ufcp_xpdr_emer
        if ufcp_xpdr_emer then UFCP_XPDR_CODE:set(7700) else UFCP_XPDR_CODE:set(ufcp_xpdr_code) end
    elseif sel == SEL_IDS.CODE then
        if command == device_commands.UFCP_1 and value == 1 then
            ufcp_continue_edit("1", FIELD_INFO[SEL_IDS.CODE], false)
        elseif command == device_commands.UFCP_2 and value == 1 then
            ufcp_continue_edit("2", FIELD_INFO[SEL_IDS.CODE], false)
        elseif command == device_commands.UFCP_3 and value == 1 then
            ufcp_continue_edit("3", FIELD_INFO[SEL_IDS.CODE], false)
        elseif command == device_commands.UFCP_4 and value == 1 then
            ufcp_continue_edit("4", FIELD_INFO[SEL_IDS.CODE], false)
        elseif command == device_commands.UFCP_5 and value == 1 then
            ufcp_continue_edit("5", FIELD_INFO[SEL_IDS.CODE], false)
        elseif command == device_commands.UFCP_6 and value == 1 then
            ufcp_continue_edit("6", FIELD_INFO[SEL_IDS.CODE], false)
        elseif command == device_commands.UFCP_7 and value == 1 then
            ufcp_continue_edit("7", FIELD_INFO[SEL_IDS.CODE], false)
        elseif command == device_commands.UFCP_8 and value == 1 then
            ufcp_continue_edit("8", FIELD_INFO[SEL_IDS.CODE], false)
        elseif command == device_commands.UFCP_9 and value == 1 then
            ufcp_continue_edit("9", FIELD_INFO[SEL_IDS.CODE], false)
        elseif command == device_commands.UFCP_0 and value == 1 then
            ufcp_continue_edit("0", FIELD_INFO[SEL_IDS.CODE], false)
        end
    end
end