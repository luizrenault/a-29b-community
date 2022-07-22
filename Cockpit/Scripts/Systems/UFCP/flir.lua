-- Methods

local flir_mode_text = {}
flir_mode_text[0] = "PNT"
flir_mode_text[1] = "SCH"

local flir_scr_text = {}
flir_scr_text[0] = "LOW"
flir_scr_text[1] = "MED"
flir_scr_text[2] = "HGH"

local flir_scw_text = {}
flir_scw_text[0] = "FULL"
flir_scw_text[1] = "REDU"

local flir_sel = 0

local FLIR = {
    last_look_mode_change = 0,
    last_look_mode = 0,
    look_mode = 0,
    search = 0,
    look_az = 0,
    look_el = 0,
    look_wpt = 0,
    look_scr = 0,
    look_scw = 0,
    

    LOOK_MODE = get_param_handle("FLIR_LOOK_MODE"),
    LOOK_WPT = get_param_handle("FLIR_LOOK_WPT"),
    LOOK_WPT_SET = get_param_handle("FLIR_LOOK_WPT_SET"),
    LOOK_LAT = get_param_handle("FLIR_LOOK_LAT"),
    LOOK_LON = get_param_handle("FLIR_LOOK_LON"),
    LOOK_ALT = get_param_handle("FLIR_LOOK_ALT"),
    LOOK_AZ = get_param_handle("FLIR_LOOK_AZ"),
    LOOK_EL = get_param_handle("FLIR_LOOK_EL"),
    SEARCH = get_param_handle("FLIR_SEARCH"),
}

FLIR.LOOK_WPT_SET:set(-1)

local function flir_wpt_num_validate(text, save)
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= 0 and number <= 99 then
            FLIR.LOOK_WPT_SET:set(number)
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function flir_az_validate(text, save)
    if text == "0" then
        text = "-"
    end
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= -180 and number <= 180 then
            FLIR.look_az = number
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end

local function flir_el_validate(text, save)
    if text == "0" then
        text = "-"
    end
    if text:len() >= ufcp_edit_lim or save then
        local number = tonumber(text)
        if number ~= nil and number >= -120 and number <= 30 then
            FLIR.look_el = number
            text = ""
        else
            ufcp_edit_invalid = true
        end
    end
    return text
end


local FLIR_FIELD_INFO = {
    [2] = {2, flir_wpt_num_validate, 21},
    [4] = {5, flir_az_validate, 31},
    [6] = {5, flir_el_validate, 56},
}


function update_flir()
    local text = ""

-- FLIR   LOOK     WPT 00 ^
--  AZ  -045`    MODE AAA  
--  EL  -045`     SCR AAA  
--                SCW AAAA 
    FLIR.look_wpt = FLIR.LOOK_WPT:get()
    text = text .. string.format("FLIR   LOOK     WPT %02d ^\n", FLIR.look_wpt )
    text = text .. string.format(" AZ  %+4d$    MODE %s  \n", FLIR.look_az, flir_mode_text[FLIR.search])
    text = text .. string.format(" EL  %+4d$     SCR %s  \n", FLIR.look_el, flir_scr_text[FLIR.look_scr])
    text = text .. string.format("                SCW %s  \n", flir_scw_text[FLIR.look_scw])

    if flir_sel == 0 then text = replace_select(text, 7, 4)     -- LOOK
    elseif flir_sel == 1 then text = replace_select(text, 16,3) -- WPT
    elseif flir_sel == 2 then text = replace_select(text, 20,2) -- WPT NR
    elseif flir_sel == 3 then text = replace_select(text, 26,2) -- AZ
    elseif flir_sel == 4 then text = replace_select(text, 30,5) -- AZ value
    elseif flir_sel == 5 then text = replace_select(text, 51,2) -- EL
    elseif flir_sel == 6 then text = replace_select(text, 55,5) -- EL value
    elseif flir_sel == 7 then text = replace_select(text, 44,3) -- MODE
    elseif flir_sel == 8 then text = replace_select(text, 69,3) -- SCR
    elseif flir_sel == 9 then text = replace_select(text, 95,4) -- SCW
    end

    if FLIR.look_mode == 1 then text = replace_enable(text, 7, 4)
    elseif FLIR.look_mode == 2 then text = replace_enable(text, 16, 3)
    elseif FLIR.look_mode == 3 then 
        text = replace_enable(text, 26, 2)
        text = replace_enable(text, 51, 2)
    end

    text = ufcp_edit_replace(text)

    UFCP_TEXT:set(text)

    if FLIR.last_look_mode ~= FLIR.look_mode then
        FLIR.last_look_mode_change = get_absolute_model_time()
        FLIR.last_look_mode = FLIR.look_mode
    end
    local last_look_mode_interval = get_absolute_model_time() - FLIR.last_look_mode_change
    if FLIR.look_mode == 1 and last_look_mode_interval > 2 then
        FLIR.look_mode = 0
    end

    FLIR.LOOK_MODE:set(FLIR.look_mode)
    FLIR.LOOK_EL:set(FLIR.look_el)
    FLIR.LOOK_AZ:set(FLIR.look_az)
    FLIR.LOOK_WPT:set(FLIR.look_wpt)
    FLIR.SEARCH:set(FLIR.search)
end

function SetCommandFlir(command,value)
    if value ~= 1 then return end
    if command == device_commands.UFCP_JOY_DOWN then 
        flir_sel = (flir_sel + 1) % 10
        if FLIR.look_mode == 2 and flir_sel == 3 then flir_sel = 4 end
        if FLIR.look_mode == 2 and flir_sel == 5 then flir_sel = 6 end
        if FLIR.look_mode == 3 and flir_sel == 1 then flir_sel = 2 end
    elseif command == device_commands.UFCP_JOY_UP then 
        flir_sel = (flir_sel - 1) % 10
        if FLIR.look_mode == 2 and flir_sel == 5 then flir_sel = 4 end
        if FLIR.look_mode == 2 and flir_sel == 3 then flir_sel = 2 end
        if FLIR.look_mode == 3 and flir_sel == 1 then flir_sel = 0 end
    elseif command == device_commands.UFCP_0 then
        if flir_sel == 0 then FLIR.look_mode = 1
        elseif flir_sel == 1 then 
            if FLIR.look_mode == 2 then FLIR.look_mode = 0 else FLIR.look_mode = 2 end
        elseif flir_sel == 3 or flir_sel == 5 then 
            if FLIR.look_mode == 3 then FLIR.look_mode = 0 else FLIR.look_mode = 3 end
        end
    elseif command == device_commands.UFCP_JOY_RIGHT then
        if flir_sel == 7 then FLIR.search = (FLIR.search + 1) % 2 
        elseif flir_sel == 8 then FLIR.look_scr = (FLIR.look_scr + 1) % 3 
        elseif flir_sel == 9 then FLIR.look_scw = (FLIR.look_scw + 1) % 2 
        end
    elseif command == device_commands.UFCP_UP then
        FLIR.LOOK_WPT_SET:set(-2)
    elseif command == device_commands.UFCP_DOWN then
        FLIR.LOOK_WPT_SET:set(-3)
    end


    if flir_sel == 2 or flir_sel == 4 or flir_sel == 6 then
        if command == device_commands.UFCP_1 then
            ufcp_continue_edit("1", FLIR_FIELD_INFO[flir_sel], false)
        elseif command == device_commands.UFCP_2 then
            ufcp_continue_edit("2", FLIR_FIELD_INFO[flir_sel], false)
        elseif command == device_commands.UFCP_3 then
            ufcp_continue_edit("3", FLIR_FIELD_INFO[flir_sel], false)
        elseif command == device_commands.UFCP_4 then
            ufcp_continue_edit("4", FLIR_FIELD_INFO[flir_sel], false)
        elseif command == device_commands.UFCP_5 then
            ufcp_continue_edit("5", FLIR_FIELD_INFO[flir_sel], false)
        elseif command == device_commands.UFCP_6 then
            ufcp_continue_edit("6", FLIR_FIELD_INFO[flir_sel], false)
        elseif command == device_commands.UFCP_7 then
            ufcp_continue_edit("7", FLIR_FIELD_INFO[flir_sel], false)
        elseif command == device_commands.UFCP_8 then
            ufcp_continue_edit("8", FLIR_FIELD_INFO[flir_sel], false)
        elseif command == device_commands.UFCP_9 then
            ufcp_continue_edit("9", FLIR_FIELD_INFO[flir_sel], false)
        elseif command == device_commands.UFCP_0 then
            ufcp_continue_edit("0", FLIR_FIELD_INFO[flir_sel], false)
        elseif command == device_commands.UFCP_ENTR then
            ufcp_continue_edit("", FLIR_FIELD_INFO[flir_sel], true)
        end
    end

end

function flir_post_initialize()
    FLIR.LOOK_WPT_SET:set(0)
end
