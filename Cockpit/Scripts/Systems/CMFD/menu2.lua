function update_menu2()
    
end

function SetCommandMenu2(command,value, CMFD)
    if value == 1 then 
        if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then CMFD["Format"]:set(SUB_PAGE_ID.MENU1)
        elseif command == device_commands.CMFD2OSS2 then
            -- Função: Restaurar a configuração padrão do sistema para os formatos Primário e Secundário e para o DOI de cada modo principal.
        elseif command == device_commands.CMFD2OSS4 then
            -- Função: Restaurar os valores padrão do brilho da simbologia e do contraste das imagens de vídeo.
            -- Esta função é usada para se fazer uma recuperação rápida de ajustes errôneos de contraste ou brilho.
        end
    end
end

function post_initialize_menu2()
    
end
