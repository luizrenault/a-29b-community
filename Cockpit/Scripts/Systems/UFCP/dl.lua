-- Methods

-- DL MENU
function update_dl_menu()
    local text = ""
    text = text .. "DL MENU\n"
    text = text .. "1SET  2INV  3MSG  C  \n"
    text = text .. "4DLWP 5SNDP 6     E  \n"
    text = text .. "7     8S    9     O  \n"
    UFCP_TEXT:set(text)
end

function SetCommandDlMenu(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DL_SET
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DL_INV
    elseif command == device_commands.UFCP_3 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DL_MSG
    elseif command == device_commands.UFCP_4 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.DLWP
    elseif command == device_commands.UFCP_5 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.SNDP
    end
end

-- DL SET
function update_dl_set()
    local text = ""
    text = text .. "DL SET\n"
    UFCP_TEXT:set(text)
end

function SetCommandDlSet(command,value)

end

-- DL_INV
function update_dl_inv()
    local text = ""
    text = text .. "DL INV\n"
    UFCP_TEXT:set(text)
end

function SetCommandDlInv(command,value)

end

-- DL MSG
function update_dl_msg()
    local text = ""
    text = text .. "DL MSG\n"
    UFCP_TEXT:set(text)
end

function SetCommandDlMsg(command,value)

end

-- DLWP
function update_dlwp()
    local text = ""
    text = text .. "DLWP\n"
    UFCP_TEXT:set(text)
end

function SetCommandDlwp(command,value)

end

-- SNDP
function update_sndp()
    local text = ""
    text = text .. "SNDP\n"
    UFCP_TEXT:set(text)
end

function SetCommandSndp(command,value)

end