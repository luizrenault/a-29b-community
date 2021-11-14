-- Constants

local SEL_IDS = {
    MAN_FREQUENCY = 0,
    CHANNEL = 1,
    PRST_FREQUENCY = 2,
    NEXT_FREQUENCY = 3,
    POWER = 4,
    MODULATION = 5,
    SQL = 6,
    MODE = 7,
}

UFCP_COM1_FREQ = get_param_handle("UFCP_COM1_FREQ")
UFCP_COM1_MOD = get_param_handle("UFCP_COM1_MOD")
UFCP_COM1_SQL = get_param_handle("UFCP_COM1_SQL")
UFCP_COM1_PWR = get_param_handle("UFCP_COM1_PWR")
UFCP_COM1_MODE = get_param_handle("UFCP_COM1_MODE")

UFCP_COM2_FREQ = get_param_handle("UFCP_COM2_FREQ")
UFCP_COM2_MOD = get_param_handle("UFCP_COM2_MOD")
UFCP_COM2_SQL = get_param_handle("UFCP_COM2_SQL")
UFCP_COM2_PWR = get_param_handle("UFCP_COM2_PWR")
UFCP_COM2_MODE = get_param_handle("UFCP_COM2_MODE")

-- Inits
ufcp_com1_mode = UFCP_COM_MODE_IDS.TR
ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
ufcp_com1_channel = 0
ufcp_com1_frequency = 118
ufcp_com1_tx = false
ufcp_com1_rx = false
ufcp_com1_channels = {}
ufcp_com1_max_channel = 79
ufcp_com1_frequency_manual = 118.0
ufcp_com1_frequency_next = 136.0
ufcp_com1_power = UFCP_COM_POWER_IDS.HIGH
ufcp_com1_modulation = UFCP_COM_MODULATION_IDS.AM
ufcp_com1_sql = true

ufcp_com1_memory = {
    frequency_last = 0,
    tx_last = false,
    rx_last = false,
    modulation_last = 0,
    sql_last = 0, 
}

function ufcp_com1_check()
    if ufcp_com1_memory.frequency_last ~= ufcp_com1_frequency then
        local radio = GetDevice(devices.VUHF1_RADIO)
        if radio then
            radio:set_frequency(ufcp_com1_frequency * 1e6)
        end
        ufcp_com1_memory.frequency_last = ufcp_com1_frequency
    end
    if ufcp_com1_memory.modulation_last ~= ufcp_com1_modulation then
        local radio = GetDevice(devices.VUHF1_RADIO)
        if radio then
            if ufcp_com1_modulation == UFCP_COM_MODE_IDS.AM then
                radio:set_modulation(MODULATION_AM)
            elseif ufcp_com1_modulation == UFCP_COM_MODE_IDS.FM then
                radio:set_modulation(MODULATION_FM)
            end
        end
        ufcp_com1_memory.modulation_last = ufcp_com1_modulation
    end
end


for i = 1,ufcp_com1_max_channel+1 do ufcp_com1_channels[i] = 118 end

-- Methods

local function ufcp_com1_channel_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number <= ufcp_com1_max_channel then
            ufcp_com1_channel = number
            if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            end

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_com1_frequency_man_validate(text, save)
    if text:len() == 3 then
        text = text .. "."
    end

    -- If enter is pressed before there are three digits.
    if save then 
        for i = 1,3-ufcp_edit_pos do text = text .. "0" end
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and is_com_frequency(number) then
            ufcp_com1_frequency_manual = number
            if ufcp_com1_frequency_sel ~= UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com1_frequency = number
            end

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_com1_frequency_prst_validate(text, save)
    if text:len() == 3 then
        text = text .. "."
    end

    -- If enter is pressed before there are three digits.
    if save then 
        for i = 1,3-ufcp_edit_pos do text = text .. "0" end
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and is_com_frequency(number) then
            ufcp_com1_channels[ufcp_com1_channel + 1] = number
            if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com1_frequency = number
            end

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_com1_frequency_next_validate(text, save)
    if text:len() == 3 then
        text = text .. "."
    end

    -- If enter is pressed before there are three digits.
    if save then 
        for i = 1,3-ufcp_edit_pos do text = text .. "0" end
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and is_com_frequency(number) then
            ufcp_com1_frequency_next = number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local FIELD_INFO = {
    [SEL_IDS.CHANNEL] = {2, ufcp_com1_channel_validate},
    [SEL_IDS.MAN_FREQUENCY] = {7, ufcp_com1_frequency_man_validate},
    [SEL_IDS.PRST_FREQUENCY] = {7, ufcp_com1_frequency_prst_validate},
    [SEL_IDS.NEXT_FREQUENCY] = {7, ufcp_com1_frequency_next_validate},
}



local sel = 0
function update_com1()
    local text = ""

    -- Line 1
    text = text .. "       COM 1   "
    if sel == SEL_IDS.MODE then text = text .. "*" else text = text .. " " end
    if ufcp_com1_mode == UFCP_COM_MODE_IDS.OFF then
        text = text .. "OFF "
    elseif ufcp_com1_mode == UFCP_COM_MODE_IDS.TR then
        text = text .. "TR  "
    elseif ufcp_com1_mode == UFCP_COM_MODE_IDS.TR_G then
        text = text .. "TR+G"
    end
    if sel == SEL_IDS.MODE then text = text .. "*" else text = text .. " " end
    text = text .. "\n"

    -- Line 2
    text = text .. " MAN  "
    if sel == SEL_IDS.MAN_FREQUENCY then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.MAN_FREQUENCY and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%07.3f", ufcp_com1_frequency_manual) end
    if sel == SEL_IDS.MAN_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. "         "
    text = text .. "\n"

    -- Line 3
    text = text .. " PRST "
    if sel == SEL_IDS.CHANNEL then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.CHANNEL and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%02.0f", ufcp_com1_channel) end
    if sel == SEL_IDS.CHANNEL then text = text .. "*" else text = text .. " " end
    text = text .. "^"
    if sel == SEL_IDS.PRST_FREQUENCY then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.PRST_FREQUENCY and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%07.3f", ufcp_com1_channels[ufcp_com1_channel + 1]) end
    if sel == SEL_IDS.PRST_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. " "
    if ucfp_com1_tx then text = text .. "TX" else text = text .. "  " end
    text = text .. " "
    text = text .. "\n"

    -- Line 4
    text = text .. " NEXT "
    if sel == SEL_IDS.NEXT_FREQUENCY then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.NEXT_FREQUENCY and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%07.3f", ufcp_com1_frequency_next) end
    if sel == SEL_IDS.NEXT_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. "     "
    text = text .. " "
    if ucfp_com1_rx then text = text .. "RX" else text = text .. "  " end
    text = text .. " "
    text = text .. "\n"

    -- Line 5
    text = text .. "POWER"
    if sel == SEL_IDS.POWER then text = text .. "*" else text = text .. " " end
    if ufcp_com1_power == UFCP_COM_POWER_IDS.HIGH then
        text = text .. "HIGH"
    elseif ufcp_com1_power == UFCP_COM_POWER_IDS.MED then
        text = text .. "MED "
    elseif ufcp_com1_power == UFCP_COM_POWER_IDS.LOW then
        text = text .. "LOW "
    end
    if sel == SEL_IDS.POWER then text = text .. "*" else text = text .. " " end
    text = text .. " "
    if sel == SEL_IDS.MODULATION then text = text .. "*" else text = text .. " " end
    if ufcp_com1_modulation == UFCP_COM_MODULATION_IDS.FM then
        text = text .. "FM"
    else
        text = text .. "AM"
    end
    if sel == SEL_IDS.MODULATION then text = text .. "*" else text = text .. " " end

    if sel == SEL_IDS.SQL then text = text .. "*" else text = text .. " " end
    text = text .. "SQL"
    if sel == SEL_IDS.SQL then text = text .. "*" else text = text .. " " end
    text = text .. " "

    if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.MAN then 
        text = replace_pos(text, 23)
        text = replace_pos(text, 27)
    else
        text = replace_pos(text, 48)
        text = replace_pos(text, 53)
    end

    if ufcp_com1_sql then
        text = replace_pos(text, 114)
        text = replace_pos(text, 118)
    end

    if sel == SEL_IDS.CHANNEL and ufcp_edit_pos > 0 then
        text = replace_pos(text, 54)
        text = replace_pos(text, 57)
    elseif sel == SEL_IDS.MAN_FREQUENCY and ufcp_edit_pos > 0 then
        text = replace_pos(text, 29)
        text = replace_pos(text, 37)
    elseif sel == SEL_IDS.PRST_FREQUENCY and ufcp_edit_pos > 0 then
        text = replace_pos(text, 59)
        text = replace_pos(text, 67)
    elseif sel == SEL_IDS.NEXT_FREQUENCY and ufcp_edit_pos > 0 then
        text = replace_pos(text, 79)
        text = replace_pos(text, 87)
    end

    UFCP_TEXT:set(text)
end

function SetCommandCom1(command,value)
    if command == device_commands.UFCP_JOY_DOWN and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel + 1) % 8
    elseif command == device_commands.UFCP_JOY_UP and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel - 1) % 8
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        if sel == SEL_IDS.POWER then
            ufcp_com1_power = (ufcp_com1_power + 1) % 3
        elseif sel == SEL_IDS.MODULATION then
            ufcp_com1_modulation = (ufcp_com1_modulation + 1) % 2
        elseif sel == SEL_IDS.MODE then
            ufcp_com1_mode = (ufcp_com1_mode + 1) % 3
        end
    elseif command == device_commands.UFCP_UP and value == 1 then
        if (sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY) and ufcp_edit_pos == 0 and ufcp_com1_channel < ufcp_com1_max_channel then
            ufcp_com1_channel = (ufcp_com1_channel + 1)
            if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            end
        end
    elseif command == device_commands.UFCP_DOWN and value == 1 and ufcp_com1_channel > 0 and ufcp_com1_channel > 0 then
        if (sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY) and ufcp_edit_pos == 0 then
            ufcp_com1_channel = (ufcp_com1_channel - 1)
            if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            end
        end
    elseif command == device_commands.UFCP_1 and value == 1 then
        if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
            ufcp_continue_edit("1", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_2 and value == 1 then
        if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
            ufcp_continue_edit("2", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_3 and value == 1 then
        if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
            ufcp_continue_edit("3", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_4 and value == 1 then
        if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
            ufcp_continue_edit("4", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_5 and value == 1 then
        if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
            ufcp_continue_edit("5", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_6 and value == 1 then
        if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
            ufcp_continue_edit("6", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_7 and value == 1 then
        if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
            ufcp_continue_edit("7", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_8 and value == 1 then
        if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
            ufcp_continue_edit("8", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_9 and value == 1 then
        if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
            ufcp_continue_edit("9", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_0 and value == 1 then
        if ufcp_edit_pos > 0 then
            if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
                ufcp_continue_edit("0", FIELD_INFO[sel], false)
            end
        elseif sel == SEL_IDS.MAN_FREQUENCY then
            ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
            ufcp_com1_frequency = ufcp_com1_frequency_manual
            ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
        elseif sel == SEL_IDS.CHANNEL then
            ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
            ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
        elseif sel == SEL_IDS.NEXT_FREQUENCY then
            local current_frequency_manual = ufcp_com1_frequency_manual
            ufcp_com1_frequency_manual = ufcp_com1_frequency_next
            ufcp_com1_frequency_next = current_frequency_manual
            ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
            ufcp_com1_frequency = ufcp_com1_frequency_manual
            ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
        elseif sel == SEL_IDS.SQL then
            ufcp_com1_sql = not ufcp_com1_sql
        end
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
            ufcp_continue_edit("", FIELD_INFO[sel], true)
        end
    end
end