local UFCP_LMT_MAX_G = get_param_handle("UFCP_LMT_MAX_G")
local UFCP_LMT_MIN_VEL = get_param_handle("UFCP_LMT_MIN_VEL")
local UFCP_LMT_MAX_VEL = get_param_handle("UFCP_LMT_MAX_VEL")
local UFCP_LMT_MAX_AOA = get_param_handle("UFCP_LMT_MAX_AOA")
local UFCP_LMT_MAX_AOA_FLAPS = get_param_handle("UFCP_LMT_MAX_AOA_FLAPS")
local UFCP_LMT_MAX_MACH = get_param_handle("UFCP_LMT_MAX_MACH")
local UFCP_LMT_ACFT_G = get_param_handle("UFCP_LMT_ACFT_G")

-- Constants
local SEL_IDS = {
    MAX_G = 0,
    MIN_VEL = 1,
    MAX_VEL = 2,
    MAX_MACH = 3,
    MAX_AOA = 4,
    MAX_AOA_FLAPS = 5,
}

-- Inits

-- TODO trigger alarms when flight parameters are off these limits, or off the calculated values
ufcp_lmt_max_g = 6.5 -- Max G
ufcp_lmt_min_vel = 80 -- Min speed
ufcp_lmt_max_vel = 220 -- Max speed
ufcp_lmt_max_aoa = 15 -- Max AOA with flaps up
ufcp_lmt_max_aoa_flaps = 13 -- Max AOA with flaps dn
ufcp_lmt_max_mach = 0.45 -- Max Mach

UFCP_LMT_MAX_G:set(ufcp_lmt_max_g)
UFCP_LMT_MIN_VEL:set(ufcp_lmt_min_vel)
UFCP_LMT_MAX_VEL:set(ufcp_lmt_max_vel)
UFCP_LMT_MAX_AOA:set(ufcp_lmt_max_aoa)
UFCP_LMT_MAX_AOA_FLAPS:set(ufcp_lmt_max_aoa_flaps)
UFCP_LMT_MAX_MACH:set(ufcp_lmt_max_mach)

UFCP_LMT_MAX_G:set(6) -- TODO Calculated by the aircraft, based on weight

-- Methods

local function ufcp_lmt_max_g_validate(text, save)
    if text:len() > 1 then
        text = text:sub(1,1) .. "." .. text:sub(2,2)
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 1 and number <= 7 then
            ufcp_lmt_max_g = number
            UFCP_LMT_MAX_G:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_lmt_min_vel_validate(text, save)  
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 70 and number <= 200 then
            ufcp_lmt_min_vel = number
            UFCP_LMT_MIN_VEL:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_lmt_max_vel_validate(text, save)  
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 70 and number <= 320 then
            ufcp_lmt_max_vel = number
            UFCP_LMT_MAX_VEL:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_lmt_max_mach_validate(text, save)
    if text:len() >= 2 then
        text = "0." .. text
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number <= 0.57 then
            ufcp_lmt_max_mach = number
            UFCP_LMT_MAX_MACH:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_lmt_max_aoa_validate(text, save)
    -- Add decimal
    text = text:gsub("%.", "")
    text = tostring(tonumber(text) / 10)
    if tonumber(text) * 10 % 10 == 0 then text = text .. ".0" end
    
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 9 and number <= 15 then
            ufcp_lmt_max_aoa = number
            UFCP_LMT_MAX_AOA:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_lmt_max_aoa_flaps_validate(text, save)
    -- Add decimal
    text = text:gsub("%.", "")
    text = tostring(tonumber(text) / 10)
    if tonumber(text) * 10 % 10 == 0 then text = text .. ".0" end
    
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 9 and number <= 13 then
            ufcp_lmt_max_aoa_flaps = number
            UFCP_LMT_MAX_AOA_FLAPS:set(number)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local FIELD_INFO = {
    [SEL_IDS.MAX_G] = {3, ufcp_lmt_max_g_validate},
    [SEL_IDS.MIN_VEL] = {3, ufcp_lmt_min_vel_validate},
    [SEL_IDS.MAX_VEL] = {3, ufcp_lmt_max_vel_validate},
    [SEL_IDS.MAX_MACH] = {4, ufcp_lmt_max_mach_validate},
    [SEL_IDS.MAX_AOA] = {4, ufcp_lmt_max_aoa_validate},
    [SEL_IDS.MAX_AOA_FLAPS] = {4, ufcp_lmt_max_aoa_flaps_validate},
}

local sel = 0
local max_sel = 6
function update_lmt()
    local ufcp_lmt_acft_g = UFCP_LMT_ACFT_G:get()

    local text = ""
    text = text .. " FLIGHT LIMITS\n"

    -- Max G
    text = text .. "MAX G   "
    if sel == SEL_IDS.MAX_G then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.MAX_G and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%3.1f", ufcp_lmt_max_g) end
    if sel == SEL_IDS.MAX_G then text = text .. "*" else text = text .. " " end

    -- Max ACFT G
    text = text .. "  AC G "
    text = text .. string.format("%3.1f", ufcp_lmt_acft_g)
    text = text .. " \n"

    -- Min Vel
    text = text .. "MIN VEL "
    if sel == SEL_IDS.MIN_VEL then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.MIN_VEL and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%3d", ufcp_lmt_min_vel) end
    if sel == SEL_IDS.MIN_VEL then text = text .. "*" else text = text .. " " end
    text = text .. "           \n"

    -- Max Vel
    text = text .. "MAX VEL "
    if sel == SEL_IDS.MAX_VEL then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.MAX_VEL and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%3d", ufcp_lmt_max_vel) end
    if sel == SEL_IDS.MAX_VEL then text = text .. "*" else text = text .. " " end
    text = text .. "   "

    -- Max Mach
    if sel == SEL_IDS.MAX_MACH then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.MAX_MACH and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4.2f", ufcp_lmt_max_mach) end
    if sel == SEL_IDS.MAX_MACH then text = text .. "*" else text = text .. " " end
    text = text .. "M \n"

    -- Max AOA
    text = text .. "MAX AOA UP"
    if sel == SEL_IDS.MAX_AOA then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.MAX_AOA and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4.1f", ufcp_lmt_max_aoa) end
    if sel == SEL_IDS.MAX_AOA then text = text .. "*" else text = text .. " " end

    -- Min AOA
    text = text .. "DN"
    if sel == SEL_IDS.MAX_AOA_FLAPS then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.MAX_AOA_FLAPS and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4.1f", ufcp_lmt_max_aoa_flaps) end
    if sel == SEL_IDS.MAX_AOA_FLAPS then text = text .. "*" else text = text .. " " end

    if sel == SEL_IDS.MAX_G and ufcp_edit_pos > 0 then
        text = replace_pos(text, 24)
        text = replace_pos(text, 28)
    elseif sel == SEL_IDS.MIN_VEL and ufcp_edit_pos > 0 then
        text = replace_pos(text, 49)
        text = replace_pos(text, 53)
    elseif sel == SEL_IDS.MAX_VEL and ufcp_edit_pos > 0 then
        text = replace_pos(text, 74)
        text = replace_pos(text, 78)
    elseif sel == SEL_IDS.MAX_VEL and ufcp_edit_pos > 0 then
        text = replace_pos(text, 74)
        text = replace_pos(text, 78)
    elseif sel == SEL_IDS.MAX_MACH and ufcp_edit_pos > 0 then
        text = replace_pos(text, 82)
        text = replace_pos(text, 87)
    elseif sel == SEL_IDS.MAX_MACH and ufcp_edit_pos > 0 then
        text = replace_pos(text, 82)
        text = replace_pos(text, 87)
    elseif sel == SEL_IDS.MAX_AOA and ufcp_edit_pos > 0 then
        text = replace_pos(text, 101)
        text = replace_pos(text, 106)
    elseif sel == SEL_IDS.MAX_AOA_FLAPS and ufcp_edit_pos > 0 then
        text = replace_pos(text, 109)
        text = replace_pos(text, 114)
    end

    UFCP_TEXT:set(text)
end

function SetCommandLmt(command,value)
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