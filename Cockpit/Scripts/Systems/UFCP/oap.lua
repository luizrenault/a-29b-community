local UFCP_OAP_ENABLED = get_param_handle("UFCP_OAP") -- 0disabled 1enabled
local CMFD_NAV_FYT = get_param_handle("CMFD_NAV_FYT")
local CMFD_NAV_FYT_SET = get_param_handle("CMFD_NAV_FYT_SET")
local CMFD_NAV_SET_OAP_BRG = get_param_handle("CMFD_NAV_SET_OAP_BRG")
local CMFD_NAV_SET_OAP_RNG = get_param_handle("CMFD_NAV_SET_OAP_RNG")
local CMFD_NAV_SET_OAP_ELEV = get_param_handle("CMFD_NAV_SET_OAP_ELEV")
local CMFD_NAV_SET_OAP_INDEX = get_param_handle("CMFD_NAV_SET_OAP_INDEX")

local CMFD_NAV_GET_OAP_BRG = get_param_handle("CMFD_NAV_GET_OAP_BRG")
local CMFD_NAV_GET_OAP_RNG = get_param_handle("CMFD_NAV_GET_OAP_RNG")
local CMFD_NAV_GET_OAP_ELEV = get_param_handle("CMFD_NAV_GET_OAP_ELEV")
local CMFD_NAV_GET_OAP_INDEX = get_param_handle("CMFD_NAV_GET_OAP_INDEX")
local CMFD_NAV_GET_OAP_RDY = get_param_handle("CMFD_NAV_GET_OAP_RDY")

-- Constants
local SEL_IDS = {
    ENABLE = 0,
    FYT = 1,
    BRG = 2,
    RNG = 3,
    ELEV = 4,
}

-- Inits
local ufcp_oap={
    enabled = false,
    brg = 0,
    rng = 0,
    elev = 0,
    fyt = 0,
    fyt_last = -1,
    sel = 0,
    max_sel = 5,
    save_now = false
}

UFCP_OAP_ENABLED:set(0)

-- Methods


local function ufcp_oap_load()
    if ufcp_oap.fyt ~= ufcp_oap.fyt_last then
        ufcp_oap.save_now = false
        if CMFD_NAV_GET_OAP_INDEX:get() < 0 and CMFD_NAV_GET_OAP_RDY:get() == 0 then
            -- start query
            CMFD_NAV_GET_OAP_INDEX:set(ufcp_oap.fyt)
        elseif CMFD_NAV_GET_OAP_INDEX:get() == ufcp_oap.fyt and CMFD_NAV_GET_OAP_RDY:get() == 1 then
            -- read and free query
            ufcp_oap.brg = CMFD_NAV_GET_OAP_BRG:get()
            ufcp_oap.rng = CMFD_NAV_GET_OAP_RNG:get()
            ufcp_oap.elev = CMFD_NAV_GET_OAP_ELEV:get()
            CMFD_NAV_GET_OAP_INDEX:set(-1)
            CMFD_NAV_GET_OAP_RDY:set(0)
            ufcp_oap.fyt_last = ufcp_oap.fyt
        end
    end
end

local function ufcp_oap_save()
    if ufcp_oap.save_now then
        if CMFD_NAV_SET_OAP_INDEX:get() < 0  then
            CMFD_NAV_SET_OAP_BRG:set(ufcp_oap.brg)
            CMFD_NAV_SET_OAP_RNG:set(ufcp_oap.rng)
            CMFD_NAV_SET_OAP_ELEV:set(ufcp_oap.elev)
            CMFD_NAV_SET_OAP_INDEX:set(ufcp_oap.fyt)
            ufcp_oap.save_now = false
        end
    end
end


local function ufcp_oap_brg_validate(text, save)  
    -- Add decimal
    text = text:gsub("%.", "")
    text = tostring(tonumber(text) / 10)
    if tonumber(text) * 10 % 10 == 0 then text = text .. ".0" end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number < 360 then
            ufcp_oap.brg = number
            ufcp_oap.save_now = true
            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end


local function ufcp_oap_rng_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number < 100000 then
            ufcp_oap.rng = number
            ufcp_oap.save_now = true
            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_oap_elev_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= -1500 and number < 8000 then
            ufcp_oap.elev = number
            ufcp_oap.save_now = true
            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_oap_fyt_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number < 100 then
            ufcp_oap.fyt = number
            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local FIELD_INFO = {
    [SEL_IDS.FYT] = {2, ufcp_oap_fyt_validate},
    [SEL_IDS.BRG] = {5, ufcp_oap_brg_validate},
    [SEL_IDS.RNG] = {5, ufcp_oap_rng_validate},
    [SEL_IDS.ELEV] = {5, ufcp_oap_elev_validate},
}

function update_oap()
    
    ufcp_oap.fyt = CMFD_NAV_FYT:get()

    ufcp_oap_save()
    ufcp_oap_load()
    
    ufcp_oap.enabled = (UFCP_OAP_ENABLED:get() == 1)

    local text = "      "

    -- Enabled
    if ufcp_oap.sel == SEL_IDS.ENABLE then text = text .. "*" else text = text .. " " end
    text = text .. "OAP"
    if ufcp_oap.sel == SEL_IDS.ENABLE then text = text .. "*" else text = text .. " " end

    text = text .. "     "

    -- FYT
    text = text .. "FYT " 
    if ufcp_oap.sel == SEL_IDS.FYT then text = text .. "*" else text = text .. " " end
    if ufcp_oap.sel == SEL_IDS.FYT and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%02d", ufcp_oap.fyt) end
    if ufcp_oap.sel == SEL_IDS.FYT then text = text .. "*" else text = text .. " " end

    text = text .. "^\n"

    -- Bearing
    text = text .. "   BRG "
    if ufcp_oap.sel == SEL_IDS.BRG then text = text .. "*" else text = text .. " " end
    if ufcp_oap.sel == SEL_IDS.BRG and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%05.1f", ufcp_oap.brg) end
    if ufcp_oap.sel == SEL_IDS.BRG then text = text .. "*" else text = text .. " " end
    text = text .. "$"

    text = text .. "  \n"

    -- Range
    text = text .. "   RNG "
    if ufcp_oap.sel == SEL_IDS.RNG then text = text .. "*" else text = text .. " " end
    if ufcp_oap.sel == SEL_IDS.RNG and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%5.0f", ufcp_oap.rng) end
    if ufcp_oap.sel == SEL_IDS.RNG then text = text .. "*" else text = text .. " " end

    text = text .. "FT \n"

    -- Elev
    text = text .. "  ELEV "
    if ufcp_oap.sel == SEL_IDS.ELEV then text = text .. "*" else text = text .. " " end
    if ufcp_oap.sel == SEL_IDS.ELEV and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%5.0f", ufcp_oap.elev) end
    if ufcp_oap.sel == SEL_IDS.ELEV then text = text .. "*" else text = text .. " " end
    
    text = text .. "FT \n"

    if ufcp_oap.sel == SEL_IDS.FYT and ufcp_edit_pos > 0 then
        text = replace_pos(text, 21)
        text = replace_pos(text, 24)
    elseif ufcp_oap.sel == SEL_IDS.BRG and ufcp_edit_pos > 0 then
        text = replace_pos(text, 34)
        text = replace_pos(text, 40)
    elseif ufcp_oap.sel == SEL_IDS.RNG and ufcp_edit_pos > 0 then
        text = replace_pos(text, 52)
        text = replace_pos(text, 58)
    elseif ufcp_oap.sel == SEL_IDS.ELEV and ufcp_edit_pos > 0 then
        text = replace_pos(text, 70)
        text = replace_pos(text, 76)
    end

    if ufcp_oap.enabled then
        text = replace_pos(text,7)
        text = replace_pos(text,11)
    end

    UFCP_TEXT:set(text)

end

function SetCommandOAP(command,value)
    if command == device_commands.UFCP_JOY_DOWN and ufcp_edit_pos == 0 and value == 1 then
        ufcp_oap.sel = (ufcp_oap.sel + 1) % ufcp_oap.max_sel
    elseif command == device_commands.UFCP_JOY_UP and ufcp_edit_pos == 0 and value == 1 then
        ufcp_oap.sel = (ufcp_oap.sel - 1) % ufcp_oap.max_sel
    elseif ufcp_oap.sel == SEL_IDS.ENABLE and command == device_commands.UFCP_0 and value == 1 then
        ufcp_oap.enabled = not ufcp_oap.enabled
        if ufcp_oap.enabled then UFCP_OAP_ENABLED:set(1) else UFCP_OAP_ENABLED:set(0) end
    elseif command == device_commands.UFCP_UP and value == 1 then 
        ufcp_cmfd_ref:performClickableAction(device_commands.NAV_INC_FYT, 1, true)
    elseif command == device_commands.UFCP_DOWN and value == 1 then
        ufcp_cmfd_ref:performClickableAction(device_commands.NAV_DEC_FYT, 1, true)
    elseif ufcp_oap.sel >= SEL_IDS.FYT or ufcp_oap.sel <= SEL_IDS.ELEV then
        if command == device_commands.UFCP_1 and value == 1 then
            ufcp_continue_edit("1", FIELD_INFO[ufcp_oap.sel], false)
        elseif command == device_commands.UFCP_2 and value == 1 then
            ufcp_continue_edit("2", FIELD_INFO[ufcp_oap.sel], false)
        elseif command == device_commands.UFCP_3 and value == 1 then
            ufcp_continue_edit("3", FIELD_INFO[ufcp_oap.sel], false)
        elseif command == device_commands.UFCP_4 and value == 1 then
            ufcp_continue_edit("4", FIELD_INFO[ufcp_oap.sel], false)
        elseif command == device_commands.UFCP_5 and value == 1 then
            ufcp_continue_edit("5", FIELD_INFO[ufcp_oap.sel], false)
        elseif command == device_commands.UFCP_6 and value == 1 then
            ufcp_continue_edit("6", FIELD_INFO[ufcp_oap.sel], false)
        elseif command == device_commands.UFCP_7 and value == 1 then
            ufcp_continue_edit("7", FIELD_INFO[ufcp_oap.sel], false)
        elseif command == device_commands.UFCP_8 and value == 1 then
            ufcp_continue_edit("8", FIELD_INFO[ufcp_oap.sel], false)
        elseif command == device_commands.UFCP_9 and value == 1 then
            ufcp_continue_edit("9", FIELD_INFO[ufcp_oap.sel], false)
        elseif command == device_commands.UFCP_0 and value == 1 then
            ufcp_continue_edit("0", FIELD_INFO[ufcp_oap.sel], false)
        elseif command == device_commands.UFCP_ENTR and value == 1 then
            ufcp_continue_edit("", FIELD_INFO[ufcp_oap.sel], true)
        end
    end
end