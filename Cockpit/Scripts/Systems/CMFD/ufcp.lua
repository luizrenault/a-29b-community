dofile(LockOn_Options.script_path.."CMFD/CMFD_UFCP_ID_defs.lua")

local CMFD_UFCP_FORMAT = get_param_handle("CMFD_UFCP_FORMAT")

local ufcp_format = CMFD_UFCP_FORMAT_IDS.UFC1

function update_ufcp()
    CMFD_UFCP_FORMAT:set(ufcp_format)
end

function SetCommandUfcp(command,value, CMFD)
    local ufcp = GetDevice(devices.UFCP)
    if value == 1 then
        if ufcp_format >= CMFD_UFCP_FORMAT_IDS.UFC1 and ufcp_format <= CMFD_UFCP_FORMAT_IDS.UFC3 then
            if (command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1) then
                ufcp_format = (ufcp_format + 1) % 2
                -- TODO enable UFC3 when flying
            end
        end

        if ufcp_format >= CMFD_UFCP_FORMAT_IDS.UFC1 and ufcp_format <= CMFD_UFCP_FORMAT_IDS.UFC2 then
            if (command==device_commands.CMFD1OSS2 or command==device_commands.CMFD2OSS2) then
                ufcp:SetCommand(device_commands.UFCP_JOY_LEFT, 1)
            elseif (command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3) then
                ufcp:SetCommand(device_commands.UFCP_JOY_RIGHT, 1)
            elseif (command==device_commands.CMFD1OSS4 or command==device_commands.CMFD2OSS4) then
                ufcp:SetCommand(device_commands.UFCP_JOY_UP, 1)
            elseif (command==device_commands.CMFD1OSS5 or command==device_commands.CMFD2OSS5) then
                ufcp:SetCommand(device_commands.UFCP_JOY_DOWN, 1)
            elseif (command==device_commands.CMFD1OSS6 or command==device_commands.CMFD2OSS6) then
                ufcp:SetCommand(device_commands.UFCP_ENTR, 1)
            elseif (command==device_commands.CMFD1OSS12 or command==device_commands.CMFD2OSS12) then
                ufcp:SetCommand(device_commands.UFCP_A_A, 1)
            elseif (command==device_commands.CMFD1OSS13 or command==device_commands.CMFD2OSS13) then
                ufcp:SetCommand(device_commands.UFCP_A_G, 1)
            elseif (command==device_commands.CMFD1OSS14 or command==device_commands.CMFD2OSS14) then
                ufcp:SetCommand(device_commands.UFCP_NAV, 1)
            elseif (command==device_commands.CMFD1OSS21 or command==device_commands.CMFD2OSS21) then
                ufcp:SetCommand(device_commands.UFCP_CLR, 1)
            elseif (command==device_commands.CMFD1OSS22 or command==device_commands.CMFD2OSS22) then
                ufcp:SetCommand(device_commands.UFCP_DOWN, 1)
            elseif (command==device_commands.CMFD1OSS23 or command==device_commands.CMFD2OSS23) then
                ufcp:SetCommand(device_commands.UFCP_UP, 1)
            end
        end

        if ufcp_format == CMFD_UFCP_FORMAT_IDS.UFC1 then
            if (command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7) then
                ufcp:SetCommand(device_commands.UFCP_6, 1)
            elseif (command==device_commands.CMFD1OSS8 or command==device_commands.CMFD2OSS8) then
                ufcp:SetCommand(device_commands.UFCP_7, 1)
            elseif (command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9) then
                ufcp:SetCommand(device_commands.UFCP_8, 1)
            elseif (command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10) then
                ufcp:SetCommand(device_commands.UFCP_9, 1)
            elseif (command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11) then
                ufcp:SetCommand(device_commands.UFCP_0, 1)
            elseif (command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24) then
                ufcp:SetCommand(device_commands.UFCP_5, 1)
            elseif (command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25) then
                ufcp:SetCommand(device_commands.UFCP_4, 1)
            elseif (command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26) then
                ufcp:SetCommand(device_commands.UFCP_3, 1)
            elseif (command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27) then
                ufcp:SetCommand(device_commands.UFCP_2, 1)
            elseif (command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28) then
                ufcp:SetCommand(device_commands.UFCP_1, 1)
            end
        elseif ufcp_format == CMFD_UFCP_FORMAT_IDS.UFC2 then
            if (command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7) then
                ufcp:SetCommand(device_commands.UFCP_COM1, 1)
            elseif (command==device_commands.CMFD1OSS8 or command==device_commands.CMFD2OSS8) then
                ufcp:SetCommand(device_commands.UFCP_COM2, 1)
            elseif (command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9) then
                ufcp:SetCommand(device_commands.UFCP_NAVAIDS, 1)
            elseif (command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10) then
                ufcp:SetCommand(device_commands.UFCP_IDNT, 1)
            elseif (command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11) then
                ufcp:SetCommand(device_commands.UFCP_BARO_RALT, 1)
            elseif (command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24) then
                -- TODO Config COM2
            elseif (command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25) then
                -- TODO Config COM1
            elseif (command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26) then
                ufcp:SetCommand(device_commands.UFCP_WARNRST, 1)
            elseif (command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27) then
                ufcp:SetCommand(device_commands.UFCP_AIRSPD, 1)
            elseif (command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28) then
                ufcp:SetCommand(device_commands.UFCP_CZ, 1)
            end
        end
    end
end

function post_initialize_ufcp()

end