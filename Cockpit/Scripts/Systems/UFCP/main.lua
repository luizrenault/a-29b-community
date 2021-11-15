local CMFD_NAV_FYT = get_param_handle("CMFD_NAV_FYT")
local EICAS_FUEL_INIT = get_param_handle("EICAS_FUEL_INIT")
local UFCP_XPDR_CODE = get_param_handle("UFCP_XPDR_CODE")

-- Constants
local SEL_IDS = {
    FYT = 0,
    COM1 = 1,
    COM2 = 2,
    TIME = 3,
}

local TIME_TYPE_IDS = {
    LC = 0,
    RT = 1,
    SW = 2.
}
TIME_TYPE_IDS[TIME_TYPE_IDS.LC] = "LC"
TIME_TYPE_IDS[TIME_TYPE_IDS.RT] = "RT"
TIME_TYPE_IDS[TIME_TYPE_IDS.SW] = "SW"

-- Variables
ufcp_main_time_type =  TIME_TYPE_IDS.RT
ufcp_main_stopwatch = 0
ufcp_main_stopwatch_running = false

-- Methods

local ufcp_main_sel = SEL_IDS.FYT
function update_main()
    elapsed = elapsed + update_time_step
    if elapsed > 0.4 then elapsed = 0
    elseif elapsed > 0.2 then ufcp_ident_blink = false
    else ufcp_ident_blink = true end

    local text = ""
    
    -- Line 1
    if ufcp_nav_mode == UFCP_NAV_MODE_IDS.AUTO then
        text = text .. "AUT"
    elseif ufcp_nav_mode == UFCP_NAV_MODE_IDS.MAN then
        text = text .. "MAN"
    end
    local ans_mode = AVIONICS_ANS_MODE:get()
    if ans_mode == AVIONICS_ANS_MODE_IDS.GPS then
        text = text .. "XX"
    else
        text = text .. string.format("%-2d", CMFD_NAV_FYT:get())
    end
    if ufcp_main_sel == SEL_IDS.FYT then text = text .. "^" else text = text .. " " end 
    text = text .. " "
    text = text .. UFCP_NAV_SOLUTION_IDS[ufcp_nav_solution]
    text = text .. " "
    text = text .. "ERR<" .. string.format("%03.0f", ufcp_nav_egi_error)
    text = text .. "\n"

    -- Line 2
    text = text .. "COM1 "
    if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
        text = text .. string.format("%-2d", ufcp_com1_channel)
        if ufcp_main_sel == SEL_IDS.COM1 then text = text .. "^" else text = text .. " " end 
        text = text .. string.format("[%07.3f]     ", ufcp_com1_frequency)
    else
        text = text .. string.format("%07.3f", ufcp_com1_frequency)
        if ufcp_main_sel == SEL_IDS.COM1 then text = text .. "^" else text = text .. " " end 
        text = text .. "         "
    end
    text = text .. "\n"

    -- Line 3
    text = text .. "COM2 "
    
    if ufcp_com2_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
        text = text .. string.format("%-2d", ufcp_com2_channel)
        if ufcp_main_sel == SEL_IDS.COM2 then text = text .. "^" else text = text .. " " end 
        text = text .. string.format("[%07.3f]  ", ufcp_com2_frequency)
    else
        text = text .. string.format("%07.3f", ufcp_com2_frequency)
        if ufcp_main_sel == SEL_IDS.COM2 then text = text .. "^" else text = text .. " " end 
        text = text .. "      "
    end
    if ufcp_com2_sync then text = text .. "SOK" else text = text .. "   " end
    text = text .. "\n"

    -- Line 4
    text = text .. TIME_TYPE_IDS[ufcp_main_time_type]
    if ufcp_main_time_type == TIME_TYPE_IDS.LC then
        text = text .. " "
        local time = get_absolute_model_time()
        local time_secs = math.floor(time % 60)
        local time_mins = math.floor((time / 60) % 60)
        local time_hours =  math.floor(time / 3600)

        if time_hours >= 100 then
            time_secs = 59
            time_mins = 59
            time_hours =  99
        end
    
        text = text .. string.format("%02.0f:%02.0f:%02.0f", time_hours, time_mins, time_secs)
    elseif ufcp_main_time_type == TIME_TYPE_IDS.RT then
        if ufcp_time_run > 0 then text = text .. " " end
        text = text .. seconds_to_string(ufcp_time_run)
    else
        text = text .. " "
        text = text .. seconds_to_string(ufcp_main_stopwatch)
    end
    if ufcp_main_sel == SEL_IDS.TIME then text = text .. "^" else text = text .. " " end 
    text = text .. "       "

    if ufcp_com2_por then text = text .. "POR" else text = text .. "   " end
    text = text .. "\n"

    -- Line 5
    local ufcp_total_fuel = EICAS_FUEL_INIT:get()
    local ufcp_xpdr = UFCP_XPDR_CODE:get()
    text = text .. string.format("%04.0fKG      %04.0f  ", ufcp_total_fuel, ufcp_xpdr)
    if ufcp_ident and ufcp_ident_blink then text = text .. "IDNT" else text = text .. "    " end

    UFCP_TEXT:set(text)
end

function SetCommandMain(command,value)
    if command == device_commands.UFCP_JOY_DOWN and value == 1 then
        ufcp_main_sel = (ufcp_main_sel + 1) % 4
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        ufcp_main_sel = (ufcp_main_sel - 1) % 4
    elseif command == device_commands.UFCP_1 and value == 1 then
        ufcp_vvvah_enter()
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DA_H
    elseif command == device_commands.UFCP_3 and value == 1 then
        -- TODO show/hide PFL page on CMFD
        -- If the AVIONICS alarm is ON, the PFL page will show up for 5 seconds
        -- unless OSS 2, 4 or 5 are pressed before. It will return to the last
        -- page.
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.WPT
        ufcp_wpt_sel = 0
        ufcp_wpt_utm_sel = 9
        ufcp_wpt_fyt = true
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.XPDR
    elseif command == device_commands.UFCP_6 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.TIME
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DL_MENU
    elseif command == device_commands.UFCP_7 and value == 1 then
        ufcp_mark_mode = UFCP_MARK_MODE_IDS.ONTOP
        mark()
        ufcp_sel_format = UFCP_FORMAT_IDS.MARK
    elseif command == device_commands.UFCP_8 and value == 1 then
        ufcp_fix_mode = UFCP_MARK_MODE_IDS.ONTOP
        fix()
        ufcp_sel_format = UFCP_FORMAT_IDS.FIX
    elseif command == device_commands.UFCP_9 and value == 1 then
        ufcp_tip_reset_cursor_timer()
        ufcp_sel_format = UFCP_FORMAT_IDS.TIP
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.MENU
    elseif ufcp_main_sel == SEL_IDS.FYT and AVIONICS_ANS_MODE:get() ~= AVIONICS_ANS_MODE_IDS.GPS and ufcp_cmfd_ref ~= nil then
        if command == device_commands.UFCP_UP and value == 1 then 
            ufcp_cmfd_ref:performClickableAction(device_commands.NAV_INC_FYT, 1, true)
        elseif command == device_commands.UFCP_DOWN and value == 1 then
            ufcp_cmfd_ref:performClickableAction(device_commands.NAV_DEC_FYT, 1, true)
        end
    elseif ufcp_main_sel == SEL_IDS.COM1 then
        if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
            if command == device_commands.UFCP_UP and value == 1 and ufcp_com1_channel < ufcp_com1_max_channel then
                ufcp_com1_channel = (ufcp_com1_channel + 1)
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            elseif command == device_commands.UFCP_DOWN and value == 1 and ufcp_com1_channel > 0 then
                ufcp_com1_channel = (ufcp_com1_channel - 1)
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            end
        end
        if command == device_commands.UFCP_0 and value == 1 then
            if ufcp_com1_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
                ufcp_com1_frequency = ufcp_com1_frequency_manual
            else
                ufcp_com1_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
                ufcp_com1_frequency = ufcp_com1_channels[ufcp_com1_channel + 1]
            end
        end
    elseif ufcp_main_sel == SEL_IDS.COM2 then
        if ufcp_com2_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
            if command == device_commands.UFCP_UP and value == 1 and ufcp_com2_channel < ufcp_com2_max_channel then
                ufcp_com2_channel = (ufcp_com2_channel + 1)
                ufcp_com2_frequency = ufcp_com2_channels[ufcp_com2_channel + 1]
            elseif command == device_commands.UFCP_DOWN and value == 1 and ufcp_com2_channel > 0 then
                ufcp_com2_channel = (ufcp_com2_channel - 1)
                ufcp_com2_frequency = ufcp_com2_channels[ufcp_com1_channel + 1]
            end
        end
        if command == device_commands.UFCP_0 and value == 1 then
            if ufcp_com2_frequency_sel == UFCP_COM_FREQUENCY_SEL_IDS.PRST then
                ufcp_com2_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.MAN
                ufcp_com2_frequency = ufcp_com2_frequency_manual
            else
                ufcp_com2_frequency_sel = UFCP_COM_FREQUENCY_SEL_IDS.PRST
                ufcp_com2_frequency = ufcp_com2_channels[ufcp_com2_channel + 1]
            end
        end
    elseif ufcp_main_sel == SEL_IDS.TIME then
        if command == device_commands.UFCP_0 and value == 1 then
            if ufcp_main_time_type ~= TIME_TYPE_IDS.SW then
                ufcp_main_time_type = 1 - ufcp_main_time_type
            end
        elseif command == device_commands.UFCP_UP and value == 1 then 
            ufcp_main_stopwatch = 0
            ufcp_main_stopwatch_running = true
            ufcp_main_time_type = TIME_TYPE_IDS.SW
        elseif command == device_commands.UFCP_DOWN and value == 1 then
            if not ufcp_main_stopwatch_running then
                ufcp_main_time_type = TIME_TYPE_IDS.RT -- TODO selecionar o último modo entre LC e RT
            else
                ufcp_main_stopwatch_running = false
            end
        end
    end
end