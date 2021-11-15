local UFCP_FUEL_BINGO = get_param_handle("UFCP_FUEL_BINGO")
local UFCP_FUEL_HMPT = get_param_handle("UFCP_FUEL_HMPT")
local EICAS_FUEL_INIT = get_param_handle("EICAS_FUEL_INIT")
local EICAS_FUEL_JOKER = get_param_handle("EICAS_FUEL_JOKER")

-- Constants
local SEL_IDS = {
    BINGO = 0,
    HMPT= 1,
    JOKER = 2,
}

-- Inits

local ufcp_fuel_bingo = 140
local ufcp_fuel_hmpt = 0

UFCP_FUEL_BINGO:set(ufcp_fuel_bingo)
UFCP_FUEL_HMPT:set(ufcp_fuel_hmpt)

-- Methods

local function ufcp_fuel_bingo_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number <= 1700 and number % 5 == 0 then
            ufcp_fuel_bingo = number
            UFCP_FUEL_BINGO:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_fuel_joker_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number <= 1700 and number % 5 == 0 then
            EICAS_FUEL_JOKER:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_fuel_hmpt_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil then
            ufcp_fuel_hmpt = number
            UFCP_FUEL_HMPT:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local FIELD_INFO = {
    [SEL_IDS.BINGO] = {4, ufcp_fuel_bingo_validate},
    [SEL_IDS.HMPT] = {2, ufcp_fuel_hmpt_validate},
    [SEL_IDS.JOKER] = {4, ufcp_fuel_joker_validate},
}

local sel = 0
local max_sel = 3
function update_fuel()
    local text = ""

    text = text .. "         FUEL      " .. string.format("%3d", EICAS_FUEL_INIT:get()) .. " KG\n\n"

    -- BINGO
    text = text .. "  BINGO"
    if sel == SEL_IDS.BINGO then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.BINGO and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4d", ufcp_fuel_bingo) end
    if sel == SEL_IDS.BINGO then text = text .. "*" else text = text .. " " end

    -- HOMEPOINT
    text = text .. "KG  HP"
    if sel == SEL_IDS.HMPT then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.HMPT and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%02d", ufcp_fuel_hmpt) end
    if sel == SEL_IDS.HMPT then text = text .. "*" else text = text .. " " end

    -- JOKER
    text = text .. "\n\n"
    text = text .. "JOKER"
    if sel == SEL_IDS.JOKER then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.JOKER and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4d", EICAS_FUEL_JOKER:get()) end
    if sel == SEL_IDS.JOKER then text = text .. "*" else text = text .. " " end
    text = text .. "KG      "

    if sel == SEL_IDS.BINGO and ufcp_edit_pos > 0 then
        text = replace_pos(text, 35)
        text = replace_pos(text, 40)
    elseif sel == SEL_IDS.HMPT and ufcp_edit_pos > 0 then
        text = replace_pos(text, 47)
        text = replace_pos(text, 50)
    elseif sel == SEL_IDS.JOKER and ufcp_edit_pos > 0 then
        text = replace_pos(text, 58)
        text = replace_pos(text, 63)
    end

    UFCP_TEXT:set(text)
end

function SetCommandFuel(command,value)
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
        ufcp_continue_edit("0", FIELD_INFO[sel], false)
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        ufcp_continue_edit("", FIELD_INFO[sel], true)
    end
end