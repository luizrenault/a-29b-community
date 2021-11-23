local ADHSI_COURSE = get_param_handle("ADHSI_COURSE")

-- Constants

local SEL_IDS = {
    POWER = 0,
    ILS = 1,
    VOR = 2,
    ADF = 3,
    CRS = 4,
    ADF_NEXT = 5,
    ADF_MODE = 6,
    HOLD = 7,
}

local ADF_MODE_IDS = {
    ADF = 0,
    ANT = 1,
    BFO = 2,
}

local ADHSI_ILS_FREQ = get_param_handle("ADHSI_ILS_FREQ")


-- Inits
ufcp_navaids_on = true
ufcp_navaids_ils = 110.3
ufcp_navaids_vor = 116.1
ufcp_navaids_adf = 1739.5
ufcp_navaids_adf_next = 1519.5
ufcp_navaids_vor_hold = 116.1
ufcp_navaids_hold = false
ufcp_navaids_crs = 0
ufcp_navaids_adf_mode = ADF_MODE_IDS.ADF

ADHSI_COURSE:set(ufcp_navaids_crs)

for i = 1,ufcp_com1_max_channel+1 do ufcp_com1_channels[i] = 118 end

-- Methods

local function is_adf_frequency(frequency)
    if frequency < 190 then return false
    elseif frequency >= 1750 and frequency < 2179 then return false
    elseif frequency > 2185 then return false
    elseif (frequency * 10) % 5 > 0 then return false
    else return true
    end
end

local function is_vor_frequency(frequency)
    if frequency < 108 then return false
    elseif frequency >= 118  then return false
    elseif (frequency * 100) % 5 > 0 then return false
    else return true
    end
end

local function ufcp_navaids_ils_validate(text, save)
    if text:len() == 3 then
        text = text .. "."
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and is_vor_frequency(number) then
            ufcp_navaids_ils = number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_navaids_vor_validate(text, save)
    if text:len() == 3 then
        text = text .. "."
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and is_vor_frequency(number) then
            ufcp_navaids_vor = number

            if not ufcp_navaids_hold then
                ufcp_navaids_vor_hold = ufcp_navaids_vor
            end

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_navaids_adf_validate(text, save)
    if text:len() == 4 then
        text = text .. "."
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and is_adf_frequency(number) then
            ufcp_navaids_adf = number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_navaids_adf_next_validate(text, save)
    if text:len() == 4 then
        text = text .. "."
    end

    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and is_adf_frequency(number) then
            ufcp_navaids_adf_next = number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_navaids_crs_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number < 360 then
            ufcp_navaids_crs = number
            ADHSI_COURSE:set(ufcp_navaids_crs)

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local FIELD_INFO = {
    [SEL_IDS.ILS] = {6, ufcp_navaids_ils_validate},
    [SEL_IDS.VOR] = {6, ufcp_navaids_vor_validate},
    [SEL_IDS.ADF] = {6, ufcp_navaids_adf_validate},
    [SEL_IDS.CRS] = {3, ufcp_navaids_crs_validate},
    [SEL_IDS.ADF_NEXT] = {6, ufcp_navaids_adf_next_validate},
}

local sel = 0
local max_sel = 8
function update_nav_aids()
    local text = ""
    text = text .. "NAV AIDS "

    -- Power
    if sel == SEL_IDS.POWER then text = text .. "*" else text = text .. " " end
    if ufcp_navaids_on then text = text .. "ON " else text = text .. "OFF" end
    if sel == SEL_IDS.POWER then text = text .. "*" else text = text .. " " end

    text = text .. "  "

    -- CRS
    text = text .. "CRS"
    if sel == SEL_IDS.CRS then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.CRS and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%03.0f", ufcp_navaids_crs) end
    if sel == SEL_IDS.CRS then text = text .. "*" else text = text .. " " end

    text = text .. "\n"

    -- ILS
    text = text .. " ILS"
    if sel == SEL_IDS.ILS then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.ILS and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%06.2f", ufcp_navaids_ils) end
    if sel == SEL_IDS.ILS then text = text .. "*" else text = text .. " " end

    text = text .. "            \n"

    -- VOR
    text = text .. " VOR"
    if sel == SEL_IDS.VOR then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.VOR and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%06.2f", ufcp_navaids_vor) end
    if sel == SEL_IDS.VOR then text = text .. "*" else text = text .. " " end

    text = text .. "            \n"

    -- ADF
    text = text .. " ADF"
    if sel == SEL_IDS.ADF then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.ADF and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%6.1f", ufcp_navaids_adf) end
    if sel == SEL_IDS.ADF then text = text .. "*" else text = text .. " " end

    -- ADF next
    text = text .. "NEXT"
    if sel == SEL_IDS.ADF_NEXT then text = text .. "*" else text = text .. " " end
    if sel == SEL_IDS.ADF_NEXT and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit() else text = text .. string.format("%6.1f", ufcp_navaids_adf_next) end
    if sel == SEL_IDS.ADF_NEXT then text = text .. "*" else text = text .. " " end

    text = text .. "\n"

    -- HOLD
    if sel == SEL_IDS.HOLD then text = text .. "*" else text = text .. " " end
    text = text .. "HOLD"
    if sel == SEL_IDS.HOLD then text = text .. "*" else text = text .. " " end
    text = text .. string.format("%06.2f", ufcp_navaids_vor_hold)
    
    text = text .. "      "

    -- ADF MODE
    if sel == SEL_IDS.ADF_MODE then text = text .. "*" else text = text .. " " end
    if ufcp_navaids_adf_mode == ADF_MODE_IDS.ADF then
        text = text .. "ADF"
    elseif ufcp_navaids_adf_mode == ADF_MODE_IDS.ANT then
        text = text .. "ANT"
    else
        text = text .. "BFO"
    end
    if sel == SEL_IDS.ADF_MODE then text = text .. "*" else text = text .. " " end

    text = text .. " "

    if sel == SEL_IDS.CRS and ufcp_edit_pos > 0 then
        text = replace_pos(text, 20)
        text = replace_pos(text, 24)
    end

    if sel == SEL_IDS.ILS and ufcp_edit_pos > 0 then
        text = replace_pos(text, 30)
        text = replace_pos(text, 37)
    end

    if sel == SEL_IDS.VOR and ufcp_edit_pos > 0 then
        text = replace_pos(text, 55)
        text = replace_pos(text, 62)
    end

    if sel == SEL_IDS.ADF and ufcp_edit_pos > 0 then
        text = replace_pos(text, 80)
        text = replace_pos(text, 87)
    end

    if sel == SEL_IDS.ADF_NEXT and ufcp_edit_pos > 0 then
        text = replace_pos(text, 92)
        text = replace_pos(text, 99)
    end

    if ufcp_navaids_hold then
        text = replace_pos(text, 101)
        text = replace_pos(text, 106)
    end

    text = replace_pos(text, 119)
    text = replace_pos(text, 123)

    UFCP_TEXT:set(text)

    ADHSI_ILS_FREQ:set(ufcp_navaids_ils)

    
end

function SetCommandNavAids(command,value)
    if command == device_commands.UFCP_JOY_DOWN and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel + 1) % max_sel
    elseif command == device_commands.UFCP_JOY_UP and ufcp_edit_pos == 0 and value == 1 then
        sel = (sel - 1) % max_sel
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        if sel == SEL_IDS.POWER then
            ufcp_navaids_on = not ufcp_navaids_on
        elseif sel == SEL_IDS.ADF_MODE then
            ufcp_navaids_adf_mode = (ufcp_navaids_adf_mode+1)%3
        end
    elseif command == device_commands.UFCP_1 and value == 1 then
        if sel == SEL_IDS.ILS or sel == SEL_IDS.VOR or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
            ufcp_continue_edit("1", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_2 and value == 1 then
        if sel == SEL_IDS.ILS or sel == SEL_IDS.VOR or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
            ufcp_continue_edit("2", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_3 and value == 1 then
        if sel == SEL_IDS.ILS or sel == SEL_IDS.VOR or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
            ufcp_continue_edit("3", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_4 and value == 1 then
        if sel == SEL_IDS.ILS or sel == SEL_IDS.VOR or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
            ufcp_continue_edit("4", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_5 and value == 1 then
        if sel == SEL_IDS.ILS or sel == SEL_IDS.VOR or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
            ufcp_continue_edit("5", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_6 and value == 1 then
        if sel == SEL_IDS.ILS or sel == SEL_IDS.VOR or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
            ufcp_continue_edit("6", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_7 and value == 1 then
        if sel == SEL_IDS.ILS or sel == SEL_IDS.VOR or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
            ufcp_continue_edit("7", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_8 and value == 1 then
        if sel == SEL_IDS.ILS or sel == SEL_IDS.VOR or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
            ufcp_continue_edit("8", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_9 and value == 1 then
        if sel == SEL_IDS.ILS or sel == SEL_IDS.VOR or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
            ufcp_continue_edit("9", FIELD_INFO[sel], false)
        end
    elseif command == device_commands.UFCP_0 and value == 1 then
        if ufcp_edit_pos > 0 or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
            if sel == SEL_IDS.ILS or sel == SEL_IDS.VOR or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
                ufcp_continue_edit("0", FIELD_INFO[sel], false)
            end
        elseif sel == SEL_IDS.HOLD then
            ufcp_navaids_hold = not ufcp_navaids_hold
            if not ufcp_navaids_hold then
                ufcp_navaids_vor_hold = ufcp_navaids_vor
            end
        end
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        if sel == SEL_IDS.ILS or sel == SEL_IDS.VOR or sel == SEL_IDS.ADF or sel == SEL_IDS.ADF_NEXT or sel == SEL_IDS.CRS then
            ufcp_continue_edit("", FIELD_INFO[sel], true)
        end
    end
end