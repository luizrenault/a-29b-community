function update_menu1()
    
end

function SetCommandMenu1(command,value, CMFD)
    if value == 1 then 
        local selected=-1
        if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then CMFD["Format"]:set(SUB_PAGE_ID.MENU2)
        elseif command == device_commands.CMFD1OSS2 or command == device_commands.CMFD2OSS2 then
            -- Função: Restaurar a configuração padrão do sistema para os formatos Primário e Secundário e para o DOI de cada modo principal.
        elseif command == device_commands.CMFD1OSS4 or command == device_commands.CMFD2OSS4 then
            -- Função: Restaurar os valores padrão do brilho da simbologia e do contraste das imagens de vídeo.
            -- Esta função é usada para se fazer uma recuperação rápida de ajustes errôneos de contraste ou brilho.
        elseif command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3 then selected=SUB_PAGE_ID.BLANK
        elseif command==device_commands.CMFD1OSS5 or command==device_commands.CMFD2OSS5 then selected=SUB_PAGE_ID.BLANK
        elseif command==device_commands.CMFD1OSS6 or command==device_commands.CMFD2OSS6 then selected=SUB_PAGE_ID.BLANK
        elseif command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7 then selected=SUB_PAGE_ID.DTE
        elseif command==device_commands.CMFD1OSS8 or command==device_commands.CMFD2OSS8 then selected=SUB_PAGE_ID.FLIR
        elseif command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9 then selected=SUB_PAGE_ID.DVR
        elseif command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10 then selected=SUB_PAGE_ID.CHECKLIST
        elseif command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11 then selected=SUB_PAGE_ID.PFL
        elseif command==device_commands.CMFD1OSS12 or command==device_commands.CMFD2OSS12 then selected=SUB_PAGE_ID.BIT
        elseif command==device_commands.CMFD1OSS13 or command==device_commands.CMFD2OSS13 then selected=SUB_PAGE_ID.NAV
        elseif command==device_commands.CMFD1OSS14 or command==device_commands.CMFD2OSS14 then selected=SUB_PAGE_ID.BLANK
        elseif command==device_commands.CMFD1OSS21 or command==device_commands.CMFD2OSS21 then selected=SUB_PAGE_ID.BLANK
        elseif command==device_commands.CMFD1OSS22 or command==device_commands.CMFD2OSS22 then selected=SUB_PAGE_ID.EICAS
        elseif command==device_commands.CMFD1OSS23 or command==device_commands.CMFD2OSS23 then selected=SUB_PAGE_ID.UFCP
        elseif command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24 then selected=SUB_PAGE_ID.ADHSI
        elseif command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25 then selected=SUB_PAGE_ID.EW
        elseif command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26 then selected=SUB_PAGE_ID.SMS
        elseif command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27 then selected=SUB_PAGE_ID.HUD
        elseif command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28 then selected=SUB_PAGE_ID.HSD
        end

        if selected > 0 then
            CMFD["Format"]:set(selected)
            CMFD["Sel"]:set(selected)
            if CMFD["Primary"]:get()==1 then
                CMFD["SelRight"]:set(selected)
                CMFD["SelRightName"]:set(SUB_PAGE_NAME[selected])
                -- if CMFD["SelLeft"]:get() == selected then
                --     CMFD["SelLeft"]:set(SUB_PAGE_ID.BLANK)
                --     CMFD["SelLeftName"]:set(SUB_PAGE_NAME[SUB_PAGE_ID.BLANK])
                -- end
            else 
                CMFD["SelLeft"]:set(selected)
                CMFD["SelLeftName"]:set(SUB_PAGE_NAME[selected])
                -- if CMFD["SelRight"]:get() == selected then
                --     CMFD["SelRight"]:set(SUB_PAGE_ID.BLANK)
                --     CMFD["SelRightName"]:set(SUB_PAGE_NAME[SUB_PAGE_ID.BLANK])
                -- end
            end
        end
    end
end

function post_initialize_menu1()
    
end
