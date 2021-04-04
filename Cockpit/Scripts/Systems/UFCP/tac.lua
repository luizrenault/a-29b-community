-- Methods

function update_tac()
    local text = ""
    text = text .. "TAC MENU\n"
    text = text .. "1CTLN 2AVOID 3        \n"
    text = text .. "4     5      6        \n"
    text = text .. "7     8      9        \n"
    UFCP_TEXT:set(text)
end

function SetCommandTacMenu(command,value)
    if command == device_commands.UFCP_1 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.TAC_CTLN
    elseif command == device_commands.UFCP_2 and value == 1 then
        ufcp_sel_format = UFCP_FORMAT_IDS.TAC_AVOID
    end
end

-- CTLN
function update_tac_ctln()
    local text = ""
    text = text .. "TAC CTLN\n"
    UFCP_TEXT:set(text)
end

function SetCommandTacCtln(command,value)

end

-- AVOID
function update_tac_avoid()
    local text = ""
    text = text .. "TAC AVOID\n"
    UFCP_TEXT:set(text)
end

function SetCommandTacAvoid(command,value)

end