-- Constants
local SEL_IDS = {
    IMPACT = 0,
    DX = 1,
    DX_DIR = 2,
    DY = 3,
    DY_DIR = 4,
    RNG = 5,
    TOF = 6,
    MBAL = 7
}

-- Inits
ufcp_bal_impact = false;
ufcp_bal_dx = 0; -- m
ufcp_bal_dy = 0; -- m
ufcp_bal_dx_dir = 1; -- -1Left +1Right
ufcp_bal_dy_dir = 1; -- -1Under +1Over
ufcp_bal_rng = 0; -- ft
ufcp_bal_tof = 0;
ufcp_bal_mbal = false;

-- Methods

local function ufcp_bal_dx_validate(text, save)  
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number < 1000 then
            ufcp_bal_dx = number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_bal_dy_validate(text, save)  
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number < 1000 then
            ufcp_bal_dy = number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_bal_rng_validate(text, save)  
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number < 10000 then
            ufcp_bal_rng = number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_bal_tof_validate(text, save)
    -- Add decimal
    text = text:gsub("%.", "")
    text = tostring(tonumber(text) / 10)
    if tonumber(text) * 10 % 10 == 0 then text = text .. ".0" end
    
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number < 100 then
            ufcp_bal_tof = number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local FIELD_INFO = {
    [SEL_IDS.DX] = {3, ufcp_bal_dx_validate},
    [SEL_IDS.DY] = {3, ufcp_bal_dy_validate},
    [SEL_IDS.RNG] = {4, ufcp_bal_rng_validate},
    [SEL_IDS.TOF] = {4, ufcp_bal_tof_validate},
}

local sel = 0
local max_sel = 8
function update_bal()
    local text = ""
    text = text .. "BAL  "

    -- Impact
    if sel == SEL_IDS.IMPACT then text = text .. "*" else text = text .. " " end
    text = text .. "IMPACT"
    if sel == SEL_IDS.IMPACT then text = text .. "*" else text = text .. " " end
    text = text .. "         \n"

    -- DX
    text = text .. "       DX ERR"
    if sel == SEL_IDS.DX then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.DX and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%3d", ufcp_bal_dx) end
    if sel == SEL_IDS.DX then text = text .. "*" else text = text .. " " end
    text = text .. " M"

    -- DX_DIR
    if sel == SEL_IDS.DX_DIR then text = text .. "*" else text = text .. " " end
    text = text .. (ufcp_bal_dx_dir == 1 and "RT" or "LF")
    if sel == SEL_IDS.DX_DIR then text = text .. "*" else text = text .. " " end
    text = text .. "\n"

    -- DY
    text = text .. "       DY ERR"
    if sel == SEL_IDS.DY then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.DY and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%3d", ufcp_bal_dy) end
    if sel == SEL_IDS.DY then text = text .. "*" else text = text .. " " end
    text = text .. " M"

    -- DX_DIR
    if sel == SEL_IDS.DY_DIR then text = text .. "*" else text = text .. " " end
    text = text .. (ufcp_bal_dy_dir == 1 and "OV" or "UN")
    if sel == SEL_IDS.DY_DIR then text = text .. "*" else text = text .. " " end
    text = text .. "\n"

    -- MBAL
    if sel == SEL_IDS.MBAL then text = text .. "*" else text = text .. " " end
    text = text .. "MBAL"
    if sel == SEL_IDS.MBAL then text = text .. "*" else text = text .. " " end

    -- RNG
    text = text .. "  RNG  "
    if sel == SEL_IDS.RNG then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.RNG and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4d", ufcp_bal_rng) end
    if sel == SEL_IDS.RNG then text = text .. "*" else text = text .. " " end
    text = text .. " FT\n"

    -- TOF
    text = text .. "        TOF  "
    if sel == SEL_IDS.TOF then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.TOF and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4.1f", ufcp_bal_tof) end
    if sel == SEL_IDS.TOF then text = text .. "*" else text = text .. " " end
    text = text .. "SEC"

    if ufcp_bal_impact then
        text = replace_pos(text, 6)
        text = replace_pos(text, 13)
    end

    if sel == SEL_IDS.DX and ufcp_edit_pos > 0 then
        text = replace_pos(text, 37)
        text = replace_pos(text, 41)
    elseif sel == SEL_IDS.DY and ufcp_edit_pos > 0 then
        text = replace_pos(text, 62)
        text = replace_pos(text, 66)
    elseif sel == SEL_IDS.RNG and ufcp_edit_pos > 0 then
        text = replace_pos(text, 87)
        text = replace_pos(text, 92)
    elseif sel == SEL_IDS.TOF and ufcp_edit_pos > 0 then
        text = replace_pos(text, 110)
        text = replace_pos(text, 115)
    end

    if ufcp_bal_mbal then
        text = replace_pos(text, 74)
        text = replace_pos(text, 79)
    end

    UFCP_TEXT:set(text)
end

function SetCommandBal(command,value)
    if command == device_commands.UFCP_JOY_DOWN and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel + 1) % max_sel
    elseif command == device_commands.UFCP_JOY_UP and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel - 1) % max_sel
    elseif sel == SEL_IDS.IMPACT and command == device_commands.UFCP_0 and value == 1 then
        ufcp_bal_impact = not ufcp_bal_impact
    elseif sel == SEL_IDS.MBAL and command == device_commands.UFCP_0 and value == 1 then
        ufcp_bal_mbal = not ufcp_bal_mbal
    elseif sel == SEL_IDS.DX_DIR and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_bal_dx_dir = -ufcp_bal_dx_dir
    elseif sel == SEL_IDS.DY_DIR and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_bal_dy_dir = -ufcp_bal_dy_dir
    else
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