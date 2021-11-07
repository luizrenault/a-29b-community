-- TODO use these values to draw TIP in HUD.
-- TODO Set ufcp_tip.dir to 0 when distance to FYT is less than 2NM and aircraft is outbound, or after a FYT is changed.
local UFCP_TIP_DIR = get_param_handle("UFCP_TIP_DIR") -- -1Left 0Disabled 1Right
local UFCP_TIP_ALONG = get_param_handle("UFCP_TIP_ALONG") -- in NM
local UFCP_TIP_ACROSS = get_param_handle("UFCP_TIP_ACROSS") -- in NM

UFCP_TIP_DIR:set(0)
UFCP_TIP_ALONG:set(0)
UFCP_TIP_ACROSS:set(0)

-- Constants
local SEL_IDS = {
    DIR = 0,
    ALONG = 1,
    ACROSS = 2,
}

-- Inits
local ufcp_tip = {
    enabled = false,
    dir = -1,
    along = 0,
    across = 0,
}


-- Methods

-- Return to MAIN if no data is inserted or cursor is not moved in 5 seconds
local cursor_timer = -1
function ufcp_tip_reset_cursor_timer()
    cursor_timer = ufcp_time + 5
end

local function ufcp_tip_along_validate(text, save)
    -- Add decimal
    text = text:gsub("%.", "")
    text = tostring(tonumber(text) / 10)
    if tonumber(text) * 10 % 10 == 0 then text = text .. ".0" end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number < 100 then
            ufcp_tip.along = number
            UFCP_TIP_ALONG:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_tip_across_validate(text, save)
    -- Add decimal
    text = text:gsub("%.", "")
    text = tostring(tonumber(text) / 10)
    if tonumber(text) * 10 % 10 == 0 then text = text .. ".0" end
    
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number < 100 then
            ufcp_tip.across = number
            UFCP_TIP_ACROSS:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local FIELD_INFO = {
    [SEL_IDS.ALONG] = {4, ufcp_tip_along_validate},
    [SEL_IDS.ACROSS] = {4, ufcp_tip_across_validate},
}

local sel = SEL_IDS.DIR
local max_sel = 3
function update_tip()
    -- Return to MAIN if no data is inserted or cursor is not moved in 5 seconds
    if cursor_timer > 0 and ufcp_time > cursor_timer then
        ufcp_edit_clear()
        ufcp_sel_format = UFCP_FORMAT_IDS.MAIN
    end

    -- Check if it was not updated by another system
    ufcp_tip.enabled = not (UFCP_TIP_DIR:get() == 0)

    local text = ""
    text = text .. "TIP  L/R    \n\n"

    -- Direction/Enabled
    if sel == SEL_IDS.DIR then text = text .. "*" else text = text .. " " end
    if ufcp_tip.dir == -1 then
        text = text .. "LEFT "
    elseif ufcp_tip.dir == 1 then
        text = text .. "RIGHT"
    end
    if sel == SEL_IDS.DIR then text = text .. "*" else text = text .. " " end

    text = text .. " \n"

    -- Along
    text = text .. "ALONG "
    if sel == SEL_IDS.ALONG then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.ALONG and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4.1f", ufcp_tip.along) end
    if sel == SEL_IDS.ALONG then text = text .. "*" else text = text .. " " end
    text = text .. "NM    "
    text = text .. "\n"

    -- Across
    text = text .. "ACROSS"
    if sel == SEL_IDS.ACROSS then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.ACROSS and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4.1f", ufcp_tip.across) end
    if sel == SEL_IDS.ACROSS then text = text .. "*" else text = text .. " " end
    text = text .. "NM    "

    if ufcp_tip.enabled then
        text = replace_pos(text, 15)
        text = replace_pos(text, 21)
    end

    if sel == SEL_IDS.ALONG and ufcp_edit_pos > 0 then
        text = replace_pos(text, 30)
        text = replace_pos(text, 35)
    elseif sel == SEL_IDS.ACROSS and ufcp_edit_pos > 0 then
            text = replace_pos(text, 49)
            text = replace_pos(text, 54)
    end
    UFCP_TEXT:set(text)
end

function SetCommandTip(command,value)
    if command == device_commands.UFCP_JOY_DOWN and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel + 1) % max_sel
        cursor_timer = -1
    elseif command == device_commands.UFCP_JOY_UP and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel - 1) % max_sel
        cursor_timer = -1
    elseif sel == SEL_IDS.DIR then
        if command == device_commands.UFCP_JOY_RIGHT and value == 1 then
            ufcp_tip.dir = -ufcp_tip.dir
            cursor_timer = -1
        elseif command == device_commands.UFCP_0 and value == 1 then
            ufcp_tip.enabled = not ufcp_tip.enabled
        end
        if ufcp_tip.enabled then
            UFCP_TIP_DIR:set(ufcp_tip.dir)
        else
            UFCP_TIP_DIR:set(0)
        end
    elseif command == device_commands.UFCP_1 and value == 1 then
        ufcp_continue_edit("1", FIELD_INFO[sel], false)
        cursor_timer = -1
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_continue_edit("2", FIELD_INFO[sel], false)
        cursor_timer = -1
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_continue_edit("3", FIELD_INFO[sel], false)
        cursor_timer = -1
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_continue_edit("4", FIELD_INFO[sel], false)
        cursor_timer = -1
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_continue_edit("5", FIELD_INFO[sel], false)
        cursor_timer = -1
    elseif command == device_commands.UFCP_6 and value == 1 then
        ufcp_continue_edit("6", FIELD_INFO[sel], false)
        cursor_timer = -1
    elseif command == device_commands.UFCP_7 and value == 1 then
        ufcp_continue_edit("7", FIELD_INFO[sel], false)
        cursor_timer = -1
    elseif command == device_commands.UFCP_8 and value == 1 then
        ufcp_continue_edit("8", FIELD_INFO[sel], false)
        cursor_timer = -1
    elseif command == device_commands.UFCP_9 and value == 1 then
        ufcp_continue_edit("9", FIELD_INFO[sel], false)
        cursor_timer = -1
    elseif command == device_commands.UFCP_0 and value == 1 then
        ufcp_continue_edit("0", FIELD_INFO[sel], false)
        cursor_timer = -1
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        ufcp_continue_edit("", FIELD_INFO[sel], true)
        cursor_timer = -1
    end

end