local CMFD_NAV_FYT_OAP_STT = get_param_handle("CMFD_NAV_FYT_OAP_STT")

-- Constants

-- Variables
ufcp_nav_mode = UFCP_NAV_MODE_IDS.AUTO
ufcp_nav_time = UFCP_NAV_TIME_IDS.TTD
ufcp_nav_solution = UFCP_NAV_SOLUTION_IDS.NAV_EGI
ufcp_nav_egi_error = 35 -- meters


local ufcp_menu_sel = 0
function update_nav()
    local text = ""
    if ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MODE then 
        if ufcp_menu_sel > 2 then ufcp_menu_sel = 0 elseif ufcp_menu_sel < 0 then ufcp_menu_sel = 2 end

        if ufcp_menu_sel == 0 then text = text .. "*" else text = text .. " " end
        text = text .. "NAV MODE"
        if ufcp_menu_sel == 0 then text = text .. "*" else text = text .. " " end
        text = text .. "\n"
        text = text .. "   "
        if ufcp_menu_sel == 1 then text = text .. "*" else text = text .. " " end
        if ufcp_nav_mode == UFCP_NAV_MODE_IDS.AUTO then text = text .. "AUTO" else text = text .. "MAN " end
        if ufcp_menu_sel == 1 then text = text .. "*" else text = text .. " " end
        text = text .. "  "
        if ufcp_menu_sel == 2 then text = text .. "*" else text = text .. " " end
        if ufcp_nav_time == UFCP_NAV_TIME_IDS.ETA then text = text .. "ETA"
        elseif ufcp_nav_time == UFCP_NAV_TIME_IDS.TTD then text = text .. "TTG"
        else text = text .. "DT " end
        if ufcp_menu_sel == 2 then text = text .. "*" else text = text .. " " end
        text = text .. "        \n"
        if ufcp_nav_time == UFCP_NAV_TIME_IDS.ETA or ufcp_nav_time == UFCP_NAV_TIME_IDS.DT then
            text = text .. "           FLY  "
            local stt = CMFD_NAV_FYT_OAP_STT:get()
            if stt > 0 then text = text .. string.format("%03.0f", stt) else text = text .. "XXX" end
            text = text .. " GS"
        end
        text = text .. "\n\n"
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MISC then
        if ufcp_menu_sel > 0 then ufcp_menu_sel = 0 elseif ufcp_menu_sel < 0 then ufcp_menu_sel = 0 end
        if ufcp_menu_sel == 0 then text = text .. "*" else text = text .. " " end
        text = text .. "NAV MISC"
        if ufcp_menu_sel == 0 then text = text .. "*" else text = text .. " " end
        text = text .. "\n"
        text = text .. "MAGV     AUTO  X  XX.X\n"
        text = text .. "GEO ZONE MAN          \n"
        text = text .. "\n"
        text = text .. "DELTA ZONE +  1.5 HR  "
    end
    UFCP_TEXT:set(text)
end

function SetCommandNav(command,value)
    if ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MODE then 
        if command == device_commands.UFCP_JOY_DOWN and value == 1 then
            ufcp_menu_sel = ufcp_menu_sel + 1
        elseif command == device_commands.UFCP_JOY_UP and value == 1 then
            ufcp_menu_sel = ufcp_menu_sel - 1
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 0 then
            ufcp_menu_sel = 0
            ufcp_sel_format = UFCP_FORMAT_IDS.NAV_MISC
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 1 then
            ufcp_nav_mode = (ufcp_nav_mode + 1) % (UFCP_NAV_MODE_IDS.END)
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 2 then
            ufcp_nav_time = (ufcp_nav_time + 1) % (UFCP_NAV_TIME_IDS.END)
        end
    elseif ufcp_sel_format == UFCP_FORMAT_IDS.NAV_MISC then
        if command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 0 then
            ufcp_menu_sel = 0
            ufcp_sel_format = UFCP_FORMAT_IDS.NAV_MODE
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 1 then
            ufcp_nav_mode = (ufcp_nav_mode + 1) % #UFCP_NAV_MODE_IDS
        elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 and ufcp_menu_sel == 2 then
            ufcp_nav_time = (ufcp_nav_time + 1) % #UFCP_NAV_TIME_IDS
        end
    end

    if command == device_commands.UFCP_1 and value == 1 then
    elseif command == device_commands.UFCP_4 and value == 1 then
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
    elseif command == device_commands.UFCP_UP and value == 1 then
    elseif command == device_commands.UFCP_DOWN and value == 1 then
    end
    SetCommandCommon(command, value)
end