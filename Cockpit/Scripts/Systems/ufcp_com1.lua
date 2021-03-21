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



-- Inits
ufcp_com1_mode = UFCP_COM_MODE_IDS.TR
ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
ufcp_com1_channel = 0
ufcp_com1_frequency = 118
ufcp_com1_tx = false
ufcp_com1_rx = false
ufcp_com1_channels = {118, 119, 120, 121, 122, 123, 124, 125, 126, 127}
ufcp_com1_max_channel = 78
ufcp_com1_frequency_manual = 118.0
ufcp_com1_frequency_next = 136.0
ufcp_com1_power = UFCP_COM_POWER_IDS.HIGH
ufcp_com1_modulation = UFCP_COM_MODULATION_IDS.AM
ufcp_com1_sql = true


-- Methods

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
    text = text .. string.format("%07.3f", ufcp_com1_frequency_manual)
    if sel == SEL_IDS.MAN_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. "         "
    text = text .. "\n"

    -- Line 3
    text = text .. " PRST "
    if sel == SEL_IDS.CHANNEL then text = text .. "*" else text = text .. " " end
    text = text .. string.format("%02.0f", ufcp_com1_channel)
    if sel == SEL_IDS.CHANNEL then text = text .. "*" else text = text .. " " end
    text = text .. "^"
    if sel == SEL_IDS.PRST_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. string.format("%07.3f", ufcp_com1_channels[ufcp_com1_channel + 1])
    if sel == SEL_IDS.PRST_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. " "
    if ucfp_com1_tx then text = text .. "TX" else text = text .. "  " end
    text = text .. " "
    text = text .. "\n"

    -- Line 4
    text = text .. " NEXT "
    if sel == SEL_IDS.NEXT_FREQUENCY then text = text .. "*" else text = text .. " " end
    text = text .. string.format("%07.3f", ufcp_com1_frequency_next)
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

    UFCP_TEXT:set(text)
end

function SetCommandCom1(command,value)
    if command == device_commands.UFCP_JOY_DOWN and value == 1 then
        sel = (sel + 1) % 8
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        sel = (sel - 1) % 8
    elseif sel == SEL_IDS.MAN_FREQUENCY and command == device_commands.UFCP_0 and value == 1 then
        ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
        ufcp_com1_frequency = ufcp_com1_frequency_manual
        ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
    elseif sel == SEL_IDS.CHANNEL then
        if command == device_commands.UFCP_UP and value == 1 and ufcp_com1_channel < ufcp_com1_max_channel then
            ufcp_com1_channel = (ufcp_com1_channel + 1)
            if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            end
        elseif command == device_commands.UFCP_DOWN and value == 1 and ufcp_com1_channel > 0 then
            ufcp_com1_channel = (ufcp_com1_channel - 1)
            if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            end
        elseif command == device_commands.UFCP_0 and value == 1 then
            ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
            ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
        end
    elseif sel == SEL_IDS.PRST_FREQUENCY then

    elseif sel == SEL_IDS.NEXT_FREQUENCY and command == device_commands.UFCP_0 and value == 1 then
        local current_frequency_manual = ufcp_com1_frequency_manual
        ufcp_com1_frequency_manual = ufcp_com1_frequency_next
        ufcp_com1_frequency_next = current_frequency_manual
        ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
        ufcp_com1_frequency = ufcp_com1_frequency_manual
        ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
    elseif sel == SEL_IDS.POWER and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_com1_power = (ufcp_com1_power + 1) % 3
    elseif sel == SEL_IDS.MODULATION and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_com1_modulation = (ufcp_com1_modulation + 1) % 2
    elseif sel == SEL_IDS.SQL and command == device_commands.UFCP_0 and value == 1 then
        ufcp_com1_sql = not ufcp_com1_sql
    elseif sel == SEL_IDS.MODE and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_com1_mode = (ufcp_com1_mode + 1) % 3
    end
end