-- Constants
local SEL_IDS = {
    RALT = 0,
    BARO = 1
}

UFCP_DAH_BARO = get_param_handle("UFCP_DAH_BARO")
UFCP_DAH_RALT = get_param_handle("UFCP_DAH_RALT")
BFI_MB = get_param_handle("BFI_MB")

-- Inits
ufcp_dah_baro = 2000
ufcp_dah_ralt = 500

UFCP_DAH_BARO:set(ufcp_dah_baro)
UFCP_DAH_RALT:set(ufcp_dah_ralt)

-- Methods

local function ufcp_dah_ralt_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number <= 5000 then
            ufcp_dah_ralt = number
            UFCP_DAH_RALT:set(number)
            -- TODO call minimum alarm when radar height is below this number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_dah_baro_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= -1500 and number <= 35000 then
            ufcp_dah_baro = number
            UFCP_DAH_BARO:set(number)
            -- TODO call decision altitude alarm when altitude is below this number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local FIELD_INFO = {
    [SEL_IDS.RALT] = {4, ufcp_dah_ralt_validate},
    [SEL_IDS.BARO] = {5, ufcp_dah_baro_validate},
}

local sel = 0
local max_sel = 2
function update_da_h()
    local text = ""
    text = text .. "DA/H\n"

    -- RALT
    text = text .. "RALT  "
    if sel == SEL_IDS.RALT then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.RALT and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4d", ufcp_dah_ralt) end
    if sel == SEL_IDS.RALT then text = text .. "*" else text = text .. " " end

    text = text .. " FT      \n"

    -- BARO
    text = text .. "BARO "
    if sel == SEL_IDS.BARO then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.BARO and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%5d", ufcp_dah_baro) end
    if sel == SEL_IDS.BARO then text = text .. "*" else text = text .. " " end

    text = text .. " FT      \n\n"

    -- QNH
    -- TODO get QNH setting from BFI
    local qnh = BFI_MB:get()
    text = text .. "QNH " .. string.format("%04d", qnh) .. " HPA"

    if sel == SEL_IDS.RALT and ufcp_edit_pos > 0 then
        text = replace_pos(text, 12)
        text = replace_pos(text, 17)
    elseif sel == SEL_IDS.BARO and ufcp_edit_pos > 0 then
        text = replace_pos(text, 33)
        text = replace_pos(text, 39)
    end

    UFCP_TEXT:set(text)
end

function SetCommandDAH(command,value)
    if command == device_commands.UFCP_JOY_DOWN and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel + 1) % max_sel
    elseif command == device_commands.UFCP_JOY_UP and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel - 1) % max_sel
    elseif command == device_commands.UFCP_1 and value == 1 then
        ufcp_continue_edit("1", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_continue_edit("2", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_continue_edit("3", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_continue_edit("4", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_continue_edit("5", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_6 and value == 1 then
        ufcp_continue_edit("6", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_7 and value == 1 then
        ufcp_continue_edit("7", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_8 and value == 1 then
        ufcp_continue_edit("8", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_9 and value == 1 then
        ufcp_continue_edit("9", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_0 and value == 1 then
        if sel == SEL_IDS.BARO and ufcp_edit_pos == 0 then
            ufcp_continue_edit("-", FIELD_INFO[sel], false)
        else
            ufcp_continue_edit("0", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        ufcp_continue_edit("", FIELD_INFO[sel], true)
    end
end