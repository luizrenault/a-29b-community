local CMFD_NAV_FYT_DTK_STT = get_param_handle("CMFD_NAV_FYT_DTK_STT")
local AVIONICS_HDG = get_param_handle("AVIONICS_HDG")

-- Constants

local SEL_IDS = {
    FORMAT = 0,
    MODE = 1,
    TIME = 2,
}

local MISC_SEL_IDS = {
    FORMAT = 0,
    MAGV_MODE = 1,
    MAGV_SIGN = 2,
    MAGV = 3,
    ZONE_MODE = 4,
    ZONE_Y = 5,
    ZONE_X = 6,
    DELTA_SIGN = 7,
    DELTA = 8,
}

-- Inits
ufcp_nav_mode = UFCP_NAV_MODE_IDS.AUTO
ufcp_nav_time = UFCP_NAV_TIME_IDS.TTD

ufcp_nav_misc_magv_auto = true
ufcp_nav_misc_magv_sign = 1
ufcp_nav_misc_magv = 0 -- TODO update MHDG using this Magnetic Variation instead of the calculated one.
ufcp_nav_misc_zone_auto = true
ufcp_nav_misc_zone_x = 1
ufcp_nav_misc_zone_y = 1
ufcp_nav_misc_delta_sign = 1
ufcp_nav_misc_delta = 0

-- Methods

local function ufcp_nav_misc_magv_validate(text, save)  
    -- Add decimal
    text = text:gsub("%.", "")
    text = tostring(tonumber(text) / 10)
    if tonumber(text) * 10 % 10 == 0 then text = text .. ".0" end
    
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number <= 90 then
            ufcp_nav_misc_magv = number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function ufcp_nav_misc_delta_validate(text, save)
    -- Add decimal
    text = text:gsub("%.", "")
    text = tostring(tonumber(text) / 10)
    if tonumber(text) * 10 % 10 == 0 then text = text .. ".0" end
    
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number <= 12 then
            ufcp_nav_misc_delta = number

            ufcp_edit_clear()
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local MISC_FIELD_INFO = {
    [MISC_SEL_IDS.MAGV] = {4, ufcp_nav_misc_magv_validate},
    [MISC_SEL_IDS.DELTA] = {4, ufcp_nav_misc_delta_validate},
}

local function get_heading(x1, y1, x2, y2)
    local x = x2 - x1
    local y = y2 - y1
    local hdg
    if x ~= 0 then
        hdg= math.deg(math.atan(y/x))
    else 
        if y > 0  then hdg = 90 else hdg = -90 end
    end
    if x > 0 then hdg = hdg + 180 end
    hdg = hdg % 360
    
    if x == 0 and y == 0 then return AVIONICS_HDG:get() end
    return hdg
end

local sel = 0
local misc_sel = 0
local max_sel = 3
local misc_max_sel = 9
function update_nav()
    local text = ""
    if ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MODE then 
        -- Format
        if sel == SEL_IDS.FORMAT then text = text .. "*" else text = text .. " " end
        text = text .. "NAV MODE"
        if sel == SEL_IDS.FORMAT then text = text .. "*" else text = text .. " " end
        text = text .. "\n"

        -- Mode
        text = text .. "   "
        if sel == SEL_IDS.MODE then text = text .. "*" else text = text .. " " end
        if ufcp_nav_mode == UFCP_NAV_MODE_IDS.AUTO then text = text .. "AUTO" else text = text .. "MAN " end
        if sel == SEL_IDS.MODE then text = text .. "*" else text = text .. " " end
        text = text .. "  "

        -- Time
        if sel == SEL_IDS.TIME then text = text .. "*" else text = text .. " " end
        if ufcp_nav_time == UFCP_NAV_TIME_IDS.ETA then text = text .. "ETA"
        elseif ufcp_nav_time == UFCP_NAV_TIME_IDS.TTD then text = text .. "TTG"
        else text = text .. " DT" end
        if sel == SEL_IDS.TIME then text = text .. "*" else text = text .. " " end
        text = text .. "        \n"
        
        -- Fly
        if ufcp_nav_time == UFCP_NAV_TIME_IDS.ETA or ufcp_nav_time == UFCP_NAV_TIME_IDS.DT then
            text = text .. "           FLY  "
            local stt = CMFD_NAV_FYT_DTK_STT:get()
            if stt > 0 then text = text .. string.format("%03.0f", stt) else text = text .. "XXX" end
            text = text .. " GS"
        end
        text = text .. "\n\n"
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MISC then
        local velx, vely, velz = sensor_data.getSelfVelocity() -- This is ground speed, right?
        local vel_air_x, vel_air_y, vel_air_z = sensor_data.getSelfAirspeed() -- And this is wind?

        -- No airspace engineer here, but true speed is ground speed minus wind, right?
        local vel_true_x = velx - vel_air_x
        local vel_true_y = vely - vel_air_y
        local vel_true_z = velz - vel_air_z

        local magv_auto = math.floor(velx, vely, vel_true_x, vel_true_y)

        -- Format
        if misc_sel == MISC_SEL_IDS.FORMAT then text = text .. "*" else text = text .. " " end
        text = text .. "NAV MISC"
        if misc_sel == MISC_SEL_IDS.FORMAT then text = text .. "*" else text = text .. " " end
        text = text .. "\n"

        -- MAGV Mode
        text = text .. " MAGV    " 
        if misc_sel == MISC_SEL_IDS.MAGV_MODE then text = text .. "*" else text = text .. " " end
        if ufcp_nav_misc_magv_auto then text = text .. "AUTO" else text = text .. " MAN" end
        if misc_sel == MISC_SEL_IDS.MAGV_MODE then text = text .. "*" else text = text .. " " end

        -- MAGV Sign
        if misc_sel == MISC_SEL_IDS.MAGV_SIGN then text = text .. "*" else text = text .. " " end
        if ufcp_nav_misc_magv_auto then
            if magv_auto < 0 then text = text .. "W" else text = text .. "E" end
        else
            if ufcp_nav_misc_magv_sign == 1 then text = text .. "E" else text = text .. "W" end
        end
        if misc_sel == MISC_SEL_IDS.MAGV_SIGN then text = text .. "*" else text = text .. " " end
        
        -- MAGV
        if misc_sel == MISC_SEL_IDS.MAGV then text = text .. "*" else text = text .. " " end
        if ufcp_nav_misc_magv_auto then
            text = text .. string.format("%04.1f", math.abs(magv_auto))
        else
            if misc_sel == MISC_SEL_IDS.MAGV and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%04.1f", ufcp_nav_misc_magv) end
        end
        if misc_sel == MISC_SEL_IDS.MAGV then text = text .. "*" else text = text .. " " end        
        text = text .. "\n"

        -- Geo Zone
        text = text .. "GEO ZONE"
        if misc_sel == MISC_SEL_IDS.ZONE_MODE then text = text .. "*" else text = text .. " " end
        if ufcp_nav_misc_zone_auto then text = text .. "AUTO" else text = text .. " MAN" end
        if misc_sel == MISC_SEL_IDS.ZONE_MODE then text = text .. "*" else text = text .. " " end

        if misc_sel == MISC_SEL_IDS.ZONE_Y then text = text .. "*" else text = text .. " " end
        if ufcp_nav_misc_zone_y == 1 then text = text .. "N" else text = text .. "S" end
        if misc_sel == MISC_SEL_IDS.ZONE_Y then text = text .. "*" else text = text .. " " end

        if misc_sel == MISC_SEL_IDS.ZONE_X then text = text .. "*" else text = text .. " " end
        if ufcp_nav_misc_zone_x == 1 then text = text .. "E" else text = text .. "W" end
        if misc_sel == MISC_SEL_IDS.ZONE_X then text = text .. "*" else text = text .. " " end
        
        text = text .. "  \n\n"

        -- Delta Zone
        text = text .. "DELTA ZONE"
        if misc_sel == MISC_SEL_IDS.DELTA_SIGN then text = text .. "*" else text = text .. " " end
        if ufcp_nav_misc_delta_sign == 1 then text = text .. "+" else text = text .. "-" end
        if misc_sel == MISC_SEL_IDS.DELTA_SIGN then text = text .. "*" else text = text .. " " end

        if misc_sel == MISC_SEL_IDS.DELTA then text = text .. "*" else text = text .. " " end
        if misc_sel == MISC_SEL_IDS.DELTA and ufcp_edit_pos > 0 then text = text .. ufcp_print_edit(true) else text = text .. string.format("%4.1f", ufcp_nav_misc_delta) end
        if misc_sel == MISC_SEL_IDS.DELTA then text = text .. "*" else text = text .. " " end
        text = text .. "HR "

        if misc_sel == MISC_SEL_IDS.MAGV and ufcp_edit_pos > 0 then
            text = replace_pos(text, 30)
            text = replace_pos(text, 35)
        elseif misc_sel == MISC_SEL_IDS.DELTA and ufcp_edit_pos > 0 then
            text = replace_pos(text, 74)
            text = replace_pos(text, 79)
        end
    end
    UFCP_TEXT:set(text)
end

function SetCommandNav(command,value)
    if ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MODE then 
        if command == device_commands.UFCP_JOY_DOWN and value == 1 then
            sel = (sel + 1) % max_sel
        elseif command == device_commands.UFCP_JOY_UP and value == 1 then
            sel = (sel - 1) % max_sel
        elseif sel == SEL_IDS.FORMAT and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
            ufcp_sel_format = UFCP_FORMAT_IDS.NAV_MISC
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and sel == 1 then
            ufcp_nav_mode = (ufcp_nav_mode + 1) % (UFCP_NAV_MODE_IDS.END)
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and sel == 2 then
            ufcp_nav_time = (ufcp_nav_time + 1) % (UFCP_NAV_TIME_IDS.END)
        end
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MISC then
        if command == device_commands.UFCP_JOY_DOWN and value == 1 then
            misc_sel = (misc_sel + 1) % misc_max_sel
            if ufcp_nav_misc_magv_auto and misc_sel == MISC_SEL_IDS.MAGV_SIGN then misc_sel = misc_sel + 2 end
            if ufcp_nav_misc_magv_auto and misc_sel == MISC_SEL_IDS.MAGV then misc_sel = misc_sel + 1 end
        elseif command == device_commands.UFCP_JOY_UP and value == 1 then
            misc_sel = (misc_sel - 1) % misc_max_sel
            if ufcp_nav_misc_magv_auto and misc_sel == MISC_SEL_IDS.MAGV_SIGN then misc_sel = misc_sel - 1 end
            if ufcp_nav_misc_magv_auto and misc_sel == MISC_SEL_IDS.MAGV then misc_sel = misc_sel - 2 end
        elseif misc_sel == MISC_SEL_IDS.FORMAT and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
            ufcp_sel_format = UFCP_FORMAT_IDS.NAV_MODE
        elseif misc_sel == MISC_SEL_IDS.MAGV_MODE and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
            ufcp_nav_misc_magv_auto = not ufcp_nav_misc_magv_auto
        elseif misc_sel == MISC_SEL_IDS.MAGV_SIGN and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
            ufcp_nav_misc_magv_sign = -ufcp_nav_misc_magv_sign
        elseif misc_sel == MISC_SEL_IDS.ZONE_MODE and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
            ufcp_nav_misc_zone_auto = not ufcp_nav_misc_zone_auto
        elseif misc_sel == MISC_SEL_IDS.ZONE_Y and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
            ufcp_nav_misc_zone_y = -ufcp_nav_misc_zone_y
        elseif misc_sel == MISC_SEL_IDS.ZONE_X and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
            ufcp_nav_misc_zone_x = -ufcp_nav_misc_zone_x
        elseif misc_sel == MISC_SEL_IDS.DELTA_SIGN and command == device_commands.UFCP_JOY_RIGHT and value == 1 then
            ufcp_nav_misc_delta_sign = -ufcp_nav_misc_delta_sign
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and sel == 1 then
            ufcp_nav_mode = (ufcp_nav_mode + 1) % #UFCP_NAV_MODE_IDS
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and sel == 2 then
            ufcp_nav_time = (ufcp_nav_time + 1) % #UFCP_NAV_TIME_IDS
        else
            if command == device_commands.UFCP_1 and value == 1 then
                ufcp_continue_edit("1", MISC_FIELD_INFO[misc_sel], false)
            elseif command == device_commands.UFCP_2 and value == 1 then
                ufcp_continue_edit("2", MISC_FIELD_INFO[misc_sel], false)
            elseif command == device_commands.UFCP_3 and value == 1 then
                ufcp_continue_edit("3", MISC_FIELD_INFO[misc_sel], false)
            elseif command == device_commands.UFCP_4 and value == 1 then
                ufcp_continue_edit("4", MISC_FIELD_INFO[misc_sel], false)
            elseif command == device_commands.UFCP_5 and value == 1 then
                ufcp_continue_edit("5", MISC_FIELD_INFO[misc_sel], false)
            elseif command == device_commands.UFCP_6 and value == 1 then
                ufcp_continue_edit("6", MISC_FIELD_INFO[misc_sel], false)
            elseif command == device_commands.UFCP_7 and value == 1 then
                ufcp_continue_edit("7", MISC_FIELD_INFO[misc_sel], false)
            elseif command == device_commands.UFCP_8 and value == 1 then
                ufcp_continue_edit("8", MISC_FIELD_INFO[misc_sel], false)
            elseif command == device_commands.UFCP_9 and value == 1 then
                ufcp_continue_edit("9", MISC_FIELD_INFO[misc_sel], false)
            elseif command == device_commands.UFCP_0 and value == 1 then
                ufcp_continue_edit("0", MISC_FIELD_INFO[misc_sel], false)
            elseif command == device_commands.UFCP_ENTR and value == 1 then
                ufcp_continue_edit("", MISC_FIELD_INFO[misc_sel], true)
            end
        end
    end
end