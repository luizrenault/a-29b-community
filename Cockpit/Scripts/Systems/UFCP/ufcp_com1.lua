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

local UFCP_COM1_DTC_READ = get_param_handle("UFCP_COM1_DTC_READ")
UFCP_COM1_DTC_READ:set("")

-- Inits
ufcp_com1_frequency_manual = 121.0
ufcp_com1_frequency_next = 136.0

-- Methods

local function ufcp_com1_channel_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        local radio = GetDevice(devices.VUHF1_RADIO)
        if number ~= nil and radio:is_channel_in_range(number) then
            if radio:get_channel_mode() then
                radio:set_channel(number)
            else
                local freq = radio:get_frequency()
                radio:set_channel(number)
                radio:set_frequency(freq)
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
        local radio = GetDevice(devices.VUHF1_RADIO)
        if number ~= nil and radio:is_frequency_in_range(number * 1e6) then
            ufcp_com1_frequency_manual = number
            if not radio:get_channel_mode() then
                radio:set_frequency(ufcp_com1_frequency_manual * 1e6)
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
        local radio = GetDevice(devices.VUHF1_RADIO)
        if number ~= nil and radio:is_frequency_in_range(number * 1e6) then
            radio:set_channel_frequency(radio:get_channel(), number * 1e6)

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
        local radio = GetDevice(devices.VUHF1_RADIO)
        if number ~= nil and radio:is_frequency_in_range(number * 1e6) then
            ufcp_com1_frequency_next = number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

-- Reads data from a DTC, when DB or ALL is selected in CMFD DTE
function ufcp_com1_load_dtc()
    if UFCP_COM1_DTC_READ:get() ~= "" then
        dofile(UFCP_COM1_DTC_READ:get())
        local radio = GetDevice(devices.VUHF1_RADIO)
        for _, value in pairs(COMM1) 
        do
            radio:set_channel_frequency(value.ID, value.Freq.Mhz * 1e6 + value.Freq.Khz * 1000)
        end
        
        UFCP_COM1_DTC_READ:set("")
    end
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

    local radio = GetDevice(devices["VUHF1_RADIO"])

    -- Line 1
    text = text .. "       COM 1   "
    if sel == SEL_IDS.MODE then text = text .. "*" else text = text .. " " end

    if radio:is_on() then
        if radio:get_guard_on_off() then
            text = text .. "TR+G"
        else 
            text = text .. "TR  "
        end
    else
        text = text .. "OFF "
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
    if sel == SEL_IDS.CHANNEL and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%02.0f", radio:get_channel()) end
    if sel == SEL_IDS.CHANNEL then text = text .. "*" else text = text .. " " end
    text = text .. "^"
    if sel == SEL_IDS.PRST_FREQUENCY then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.PRST_FREQUENCY and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%07.3f", radio:get_channel_frequency(radio:get_channel())/1e6) end
    if sel == SEL_IDS.PRST_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. " "
    if radio:is_transmitting() then text = text .. "TX" else text = text .. "  " end
    text = text .. " "
    text = text .. "\n"

    -- Line 4
    text = text .. " NEXT "
    if sel == SEL_IDS.NEXT_FREQUENCY then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.NEXT_FREQUENCY and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%07.3f", ufcp_com1_frequency_next) end
    if sel == SEL_IDS.NEXT_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. "     "
    text = text .. " "
    if radio:is_receiving() then text = text .. "RX" else text = text .. "  " end
    text = text .. " "
    text = text .. "\n"

    -- Line 5
    text = text .. "POWER"
    if sel == SEL_IDS.POWER then text = text .. "*" else text = text .. " " end
    local power = radio:get_transmitter_power()
    if power > 7 then
        text = text .. "HIGH"
    elseif power > 3 then
        text = text .. "MED "
    else 
        text = text .. "LOW "
    end
    if sel == SEL_IDS.POWER then text = text .. "*" else text = text .. " " end
    text = text .. " "
    if sel == SEL_IDS.MODULATION then text = text .. "*" else text = text .. " " end
    if radio:get_modulation() == UFCP_COM_MODULATION_IDS.FM then
        text = text .. "FM"
    else
        text = text .. "AM"
    end
    if sel == SEL_IDS.MODULATION then text = text .. "*" else text = text .. " " end

    if sel == SEL_IDS.SQL then text = text .. "*" else text = text .. " " end
    text = text .. "SQL"
    if sel == SEL_IDS.SQL then text = text .. "*" else text = text .. " " end
    text = text .. " "

    if not radio:get_channel_mode() then 
        text = replace_pos(text, 23)
        text = replace_pos(text, 27)
    else
        text = replace_pos(text, 48)
        text = replace_pos(text, 53)
    end

    if radio:get_squelch() then
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
            local radio = GetDevice(devices["VUHF1_RADIO"])
            local power = radio:get_transmitter_power()
            if power > 7 then
                radio:set_transmitter_power(1)
            elseif power > 3 then
                radio:set_transmitter_power(10)
            else 
                radio:set_transmitter_power(5)
            end
    elseif sel == SEL_IDS.MODULATION then
            local radio = GetDevice(devices["VUHF1_RADIO"])
            radio:set_modulation((radio:get_modulation()+1) % 2)
        elseif sel == SEL_IDS.MODE then
            local radio = GetDevice(devices["VUHF1_RADIO"])
            if radio:is_on() then
                if radio:get_guard_on_off() then
                    radio:set_on_off(false)
                    radio:set_guard_on_off(false)
                else 
                    radio:set_guard_on_off(true)
                end
            else
                radio:set_on_off(true)
                radio:set_guard_on_off(false)
            end
        end
    elseif command == device_commands.UFCP_UP and value == 1 then
        local radio = GetDevice(devices["VUHF1_RADIO"])
        if (sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY) and ufcp_edit_pos == 0 and radio:is_channel_in_range(radio:get_channel()+1) then
            if radio:get_channel_mode() then
                radio:set_channel(radio:get_channel() + 1)
            else
                local freq = radio:get_frequency()
                radio:set_channel(radio:get_channel() + 1)
                radio:set_frequency(freq)
            end
        end
    elseif command == device_commands.UFCP_DOWN and value == 1 then
        local radio = GetDevice(devices["VUHF1_RADIO"])
        if (sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY) and ufcp_edit_pos == 0 and radio:get_channel() > 0 then
            if radio:get_channel_mode() then
                radio:set_channel(radio:get_channel() - 1)
            else
                local freq = radio:get_frequency()
                radio:set_channel(radio:get_channel() - 1)
                radio:set_frequency(freq)
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
        local radio = GetDevice(devices["VUHF1_RADIO"])
        if ufcp_edit_pos > 0 then
            if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
                ufcp_continue_edit("0", FIELD_INFO[sel], false)
            end
        elseif sel == SEL_IDS.MAN_FREQUENCY then
            radio:set_frequency(ufcp_com1_frequency_manual * 1e6)
            ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
        elseif sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY then
            radio:set_channel(radio:get_channel())
            ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
        elseif sel == SEL_IDS.NEXT_FREQUENCY then
            local current_frequency_manual = ufcp_com1_frequency_manual
            ufcp_com1_frequency_manual = ufcp_com1_frequency_next
            ufcp_com1_frequency_next = current_frequency_manual
            radio:set_frequency(ufcp_com1_frequency_manual * 1e6)
            ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
        elseif sel == SEL_IDS.SQL then
            radio:set_squelch(not radio:get_squelch())
        end
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        if sel == SEL_IDS.MAN_FREQUENCY or sel == SEL_IDS.CHANNEL or sel == SEL_IDS.PRST_FREQUENCY or sel == SEL_IDS.NEXT_FREQUENCY then
            ufcp_continue_edit("", FIELD_INFO[sel], true)
        end
    end
end