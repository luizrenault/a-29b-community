local UFCP_DTK_ENABLED = get_param_handle("ADHSI_DTK")

-- Methods

function update_menu()
    local text = ""
    text = text .. "MENU\n"
    text = text .. "1LMT 2DTK  3BAL C ACAL\n"
    text = text .. "4NAV 5WS   6EGI E FUEL\n"
    text = text .. "7TAC 8MODE 9OAP O MISC\n"

    if UFCP_DTK_ENABLED:get() == 1 then
        text = replace_pos(text, 10)
    end

    -- If ufcp_bal_impact or ufcp_bal_mbal is true, this should be highlighted.
    -- TODO Check which.
    if ufcp_bal_impact then
    --if ufcp_bal_mbal then
        text = replace_pos(text, 16)
    end
    UFCP_TEXT:set(text)
end

function SetCommandMenu(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.LMT
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DTK
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.BAL
    elseif command == device_commands.UFCP_CLR and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.ACAL
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.NAV_MODE
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.WS
    elseif command == device_commands.UFCP_6 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.EGI_INS
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.FUEL
    elseif command == device_commands.UFCP_7 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.TAC_MENU
    elseif command == device_commands.UFCP_8 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.MODE
    elseif command == device_commands.UFCP_9 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.OAP
    elseif command == device_commands.UFCP_0 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.MISC
    elseif command == device_commands.UFCP_JOY_RIGHT and value == 1 then
    elseif command == device_commands.UFCP_UP and value == 1 then
    elseif command == device_commands.UFCP_DOWN and value == 1 then
    end
end

function update_misc()
    local text = ""
    text = text .. "MISC\n"
    text = text .. "1C/F  2PARA 3FTI  C  \n"
    text = text .. "4DCLT 5CRUS 6DRFT EDL\n"
    text = text .. "7TK/L 8STRM 9FLIR O  \n"
    UFCP_TEXT:set(text)
end

function SetCommandMisc(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.C_F
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.PARA
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.FTI
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DCLT
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.CRUS
    elseif command == device_commands.UFCP_6 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DRFT
    elseif command == device_commands.UFCP_ENTR and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DL_MENU
    elseif command == device_commands.UFCP_7 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.TK_L_DATA
    elseif command == device_commands.UFCP_8 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.STRM
    elseif command == device_commands.UFCP_9 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.FLIR
    end
end