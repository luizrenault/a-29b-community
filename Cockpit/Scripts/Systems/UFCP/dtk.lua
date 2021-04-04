local UFCP_DTK_ENABLED = get_param_handle("ADHSI_DTK") -- 0disabled 1enabled
local UFCP_DTK_BRG = get_param_handle("ADHSI_DTK_HDG")
local UFCP_DTK_RNG = get_param_handle("ADHSI_DTK_DIST")

-- Constants
local SEL_IDS = {
    ENABLE = 0,
    BRG = 1,
    RNG = 2,
}

-- Inits
ufcp_dtk_enabled = false
ufcp_dtk_brg = 0
ufcp_dtk_rng = 0

UFCP_DTK_ENABLED:set(0)
UFCP_DTK_BRG:set(ufcp_dtk_brg)
UFCP_DTK_RNG:set(ufcp_dtk_rng)

-- Methods

local function ufcp_dtk_brg_validate(text, save)  
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number < 360 then
            ufcp_dtk_brg = number
            UFCP_DTK_BRG:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_dtk_rng_validate(text, save)
    -- Add decimal
    text = text:gsub("%.", "")
    text = tostring(tonumber(text) / 10)
    if tonumber(text) * 10 % 10 == 0 then text = text .. ".0" end
    
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number < 100 then
            ufcp_dtk_rng = number
            UFCP_DTK_RNG:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local FIELD_INFO = {
    [SEL_IDS.BRG] = {3, ufcp_dtk_brg_validate},
    [SEL_IDS.RNG] = {4, ufcp_dtk_rng_validate},
}

local sel = 0
local max_sel = 3
function update_dtk()
    ufcp_nav_only()
    
    ufcp_dtk_enabled = (UFCP_DTK_ENABLED:get() == 1)

    local text = ""

    -- Enabled
    if sel == SEL_IDS.ENABLE then text = text .. "*" else text = text .. " " end
    text = text .. "DTK"
    if sel == SEL_IDS.ENABLE then text = text .. "*" else text = text .. " " end

    text = text .. "\n\n"

    -- Bearing
    text = text .. "   BRG "
    if sel == SEL_IDS.BRG then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.BRG and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%03d", ufcp_dtk_brg) end
    text = text .. "$"
    if sel == SEL_IDS.BRG then text = text .. "*" else text = text .. " " end

    text = text .. "  \n"

    -- Range
    text = text .. "   RNG "
    if sel == SEL_IDS.RNG then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.RNG and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4.1f", ufcp_dtk_rng) end
    if sel == SEL_IDS.RNG then text = text .. "*" else text = text .. " " end

    text = text .. "NM\n"

    if sel == SEL_IDS.BRG and ufcp_edit_pos > 0 then
        text = replace_pos(text, 15)
        text = replace_pos(text, 20)
    elseif sel == SEL_IDS.RNG and ufcp_edit_pos > 0 then
        text = replace_pos(text, 31)
        text = replace_pos(text, 36)
    end

    if ufcp_dtk_enabled then
        text = replace_pos(text,1)
        text = replace_pos(text,5)
    end

    UFCP_TEXT:set(text)

end

function SetCommandDtk(command,value)
    if command == device_commands.UFCP_JOY_DOWN and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel + 1) % max_sel
    elseif command == device_commands.UFCP_JOY_UP and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel - 1) % max_sel
    elseif sel == SEL_IDS.ENABLE and command == device_commands.UFCP_0 and value == 1 then
        ufcp_dtk_enabled = not ufcp_dtk_enabled
        if ufcp_dtk_enabled then UFCP_DTK_ENABLED:set(1) else UFCP_DTK_ENABLED:set(0) end
    elseif sel == SEL_IDS.BRG or sel == SEL_IDS.RNG then
        if command == device_commands.UFCP_1 and value == 1 then
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
end