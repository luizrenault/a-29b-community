dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."Systems/weapon_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")



startup_print("cmfd_right: load")

dev = GetSelf()

update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

sensor_data = get_base_data()

dofile(LockOn_Options.script_path.."Systems/cmfd_sms.lua")
dofile(LockOn_Options.script_path.."Systems/cmfd_adhsi.lua")
dofile(LockOn_Options.script_path.."Systems/cmfd_eicas.lua")
dofile(LockOn_Options.script_path.."Systems/cmfd_nav.lua")



dev:listen_command(device_commands.CMFD2OSS1)
dev:listen_command(device_commands.CMFD2OSS2)
dev:listen_command(device_commands.CMFD2OSS3)
dev:listen_command(device_commands.CMFD2OSS4)
dev:listen_command(device_commands.CMFD2OSS5)
dev:listen_command(device_commands.CMFD2OSS6)
dev:listen_command(device_commands.CMFD2OSS7)
dev:listen_command(device_commands.CMFD2OSS8)
dev:listen_command(device_commands.CMFD2OSS9)
dev:listen_command(device_commands.CMFD2OSS10)
dev:listen_command(device_commands.CMFD2OSS11)
dev:listen_command(device_commands.CMFD2OSS12)
dev:listen_command(device_commands.CMFD2OSS13)
dev:listen_command(device_commands.CMFD2OSS14)
dev:listen_command(device_commands.CMFD2OSS15)
dev:listen_command(device_commands.CMFD2OSS16)
dev:listen_command(device_commands.CMFD2OSS17)
dev:listen_command(device_commands.CMFD2OSS18)
dev:listen_command(device_commands.CMFD2OSS19)
dev:listen_command(device_commands.CMFD2OSS20)
dev:listen_command(device_commands.CMFD2OSS21)
dev:listen_command(device_commands.CMFD2OSS22)
dev:listen_command(device_commands.CMFD2OSS23)
dev:listen_command(device_commands.CMFD2OSS24)
dev:listen_command(device_commands.CMFD2OSS25)
dev:listen_command(device_commands.CMFD2OSS26)
dev:listen_command(device_commands.CMFD2OSS27)
dev:listen_command(device_commands.CMFD2OSS28)
dev:listen_command(device_commands.CMFD2ButtonOn)
dev:listen_command(device_commands.CMFD2ButtonGain)
dev:listen_command(device_commands.CMFD2ButtonSymb)
dev:listen_command(device_commands.CMFD2ButtonBright)

dev:listen_command(device_commands.CMFD1OSS1)
dev:listen_command(device_commands.CMFD1OSS2)
dev:listen_command(device_commands.CMFD1OSS3)
dev:listen_command(device_commands.CMFD1OSS4)
dev:listen_command(device_commands.CMFD1OSS5)
dev:listen_command(device_commands.CMFD1OSS6)
dev:listen_command(device_commands.CMFD1OSS7)
dev:listen_command(device_commands.CMFD1OSS8)
dev:listen_command(device_commands.CMFD1OSS9)
dev:listen_command(device_commands.CMFD1OSS10)
dev:listen_command(device_commands.CMFD1OSS11)
dev:listen_command(device_commands.CMFD1OSS12)
dev:listen_command(device_commands.CMFD1OSS13)
dev:listen_command(device_commands.CMFD1OSS14)
dev:listen_command(device_commands.CMFD1OSS15)
dev:listen_command(device_commands.CMFD1OSS16)
dev:listen_command(device_commands.CMFD1OSS17)
dev:listen_command(device_commands.CMFD1OSS18)
dev:listen_command(device_commands.CMFD1OSS19)
dev:listen_command(device_commands.CMFD1OSS20)
dev:listen_command(device_commands.CMFD1OSS21)
dev:listen_command(device_commands.CMFD1OSS22)
dev:listen_command(device_commands.CMFD1OSS23)
dev:listen_command(device_commands.CMFD1OSS24)
dev:listen_command(device_commands.CMFD1OSS25)
dev:listen_command(device_commands.CMFD1OSS26)
dev:listen_command(device_commands.CMFD1OSS27)
dev:listen_command(device_commands.CMFD1OSS28)
dev:listen_command(device_commands.CMFD1ButtonOn)
dev:listen_command(device_commands.CMFD1ButtonGain)
dev:listen_command(device_commands.CMFD1ButtonSymb)
dev:listen_command(device_commands.CMFD1ButtonBright)

dev:listen_command(Keys.DisplayMngt)


local CMFDNumber=get_param_handle("CMFDNumber")
CMFDNumber:set(0)

local CMFD1Format=get_param_handle("CMFD1Format")
CMFD1Format:set(SUB_PAGE_ID.ADHSI)

local CMFD2Format=get_param_handle("CMFD2Format")
CMFD2Format:set(SUB_PAGE_ID.EICAS)

local CMFDDoi=get_param_handle("CMFDDoi")
CMFDDoi:set(0)

local CMFD1DCLT=get_param_handle("CMFD1DCLT")
CMFD1DCLT:set(0)

local CMFD2DCLT=get_param_handle("CMFD2DCLT")
CMFD2DCLT:set(0)

local CMFD1Primary=get_param_handle("CMFD1Primary")
CMFD1Primary:set(0) -- 0=Left or OSS 19     1=Right or PSS 16

local CMFD2Primary=get_param_handle("CMFD2Primary")
CMFD2Primary:set(0) -- 0=Left or OSS 19     1=Right or PSS 16

local CMFD1Sel=get_param_handle("CMFD1Sel")
CMFD1Sel:set(SUB_PAGE_ID.ADHSI)

local CMFD2Sel=get_param_handle("CMFD2Sel")
CMFD2Sel:set(SUB_PAGE_ID.EICAS)

local CMFD1SelLeft=get_param_handle("CMFD1SelLeft")
CMFD1SelLeft:set(SUB_PAGE_ID.ADHSI)

local CMFD2SelLeft=get_param_handle("CMFD2SelLeft")
CMFD2SelLeft:set(SUB_PAGE_ID.EICAS)

local CMFD1SelLeftName=get_param_handle("CMFD1SelLeftName")
CMFD1SelLeftName:set(SUB_PAGE_NAME[CMFD1SelLeft:get()])

local CMFD2SelLeftName=get_param_handle("CMFD2SelLeftName")
CMFD2SelLeftName:set(SUB_PAGE_NAME[CMFD2SelLeft:get()])

local CMFD1SelRight=get_param_handle("CMFD1SelRight")
CMFD1SelRight:set(SUB_PAGE_ID.SMS)

local CMFD2SelRight=get_param_handle("CMFD2SelRight")
CMFD2SelRight:set(SUB_PAGE_ID.NAV)

local CMFD1SelRightName=get_param_handle("CMFD1SelRightName")
CMFD1SelRightName:set(SUB_PAGE_NAME[CMFD1SelRight:get()])

local CMFD2SelRightName=get_param_handle("CMFD2SelRightName")
CMFD2SelRightName:set(SUB_PAGE_NAME[CMFD2SelRight:get()])

local CMFD1On=get_param_handle("CMFD1On")
local CMFD2On=get_param_handle("CMFD2On")

local CMFD1SwOn=get_param_handle("CMFD1SwOn")
local CMFD2SwOn=get_param_handle("CMFD2SwOn")

local CMFD1_BRIGHT=get_param_handle("CMFD1_BRIGHT")
local CMFD2_BRIGHT=get_param_handle("CMFD2_BRIGHT")

CMFD1_BRIGHT:set(1)
CMFD2_BRIGHT:set(1)


local DMSLeftElapsed = -1
local DMSRightElapsed = -1
local cmfd_bright = {}
cmfd_bright[1] = 1
cmfd_bright[2] = 1

function update()
    CMFD1On:set(get_elec_avionics_ok() and 1 or 0)
    CMFD2On:set(get_elec_emergency_ok() and 1 or 0)

    update_eicas()
    update_adhsi()
    update_sms()
    update_nav()

    CMFD1_BRIGHT:set(cmfd_bright[1])
    CMFD2_BRIGHT:set(cmfd_bright[2])
    
    if DMSLeftElapsed > 0 then
        DMSLeftElapsed = DMSLeftElapsed - update_time_step
    elseif DMSLeftElapsed > -1 then
        CMFDDoi:set(1)
        DMSLeftElapsed = -1
    end
    if DMSRightElapsed > 0 then
        DMSRightElapsed = DMSRightElapsed - update_time_step
    elseif DMSRightElapsed > -1 then
        CMFDDoi:set(2)
        DMSRightElapsed = -1
    end
end


function post_initialize()
    startup_print("cmfd_right: postinit start")
    
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end
    dev:performClickableAction(device_commands.CMFD1ButtonOn,1)
    dev:performClickableAction(device_commands.CMFD2ButtonOn,1)
post_initialize_sms()
    post_initialize_eicas()
    post_initialize_nav()
    startup_print("environ: postinit end")
end



-- HSD, SMS, UFCP, DVR, EW, ADHSI, EICAS, FLIR, EMERG, PFL, BIT, HUD, DTE e NAV

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
        elseif command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10 then selected=SUB_PAGE_ID.EMERG
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




local CMFD = {{},{}}
CMFD[1]["Number"]          = 1
CMFD[1]["DCLT"]            = CMFD1DCLT
CMFD[1]["Primary"]         = CMFD1Primary
CMFD[1]["Format"]          = CMFD1Format
CMFD[1]["SelLeft"]         = CMFD1SelLeft
CMFD[1]["SelRight"]        = CMFD1SelRight
CMFD[1]["SelLeftName"]     = CMFD1SelLeftName
CMFD[1]["SelRightName"]    = CMFD1SelRightName
CMFD[1]["Sel"]             = CMFD1Sel
CMFD[1]["On"]              = CMFD1On
CMFD[1]["SwOn"]            = CMFD1SwOn

CMFD[2]["Number"]          = 2
CMFD[2]["DCLT"]            = CMFD2DCLT
CMFD[2]["Primary"]         = CMFD2Primary
CMFD[2]["Format"]          = CMFD2Format
CMFD[2]["SelLeft"]         = CMFD2SelLeft
CMFD[2]["SelRight"]        = CMFD2SelRight
CMFD[2]["SelLeftName"]     = CMFD2SelLeftName
CMFD[2]["SelRightName"]    = CMFD2SelRightName
CMFD[2]["Sel"]             = CMFD2Sel
CMFD[2]["On"]              = CMFD2On
CMFD[2]["SwOn"]            = CMFD2SwOn

function SetCommand(command,value)
    local cmfdnumber = 0
    if command >= device_commands.CMFD1OSS1 and command <= device_commands.CMFD1ButtonBright then 
        cmfdnumber=1
    elseif command >= device_commands.CMFD2OSS1 and command <= device_commands.CMFD2ButtonBright then 
        cmfdnumber=2
    end

    if command == device_commands.CMFD1OSS1 and value == -100 then -- Salvo Pressed
        CMFD1Format:set(SUB_PAGE_ID.SMS)
        SetCommandSms(command, value, CMFD[cmfdnumber])
        return 0
    elseif command == device_commands.CMFD1OSS1 and value == -200 then -- E-J Finished
        SetCommandSms(command, value, CMFD[cmfdnumber])
        CMFD1Format:set(CMFD1Sel:get())
        return 0
    elseif command == device_commands.NAV_INC_FYT then
        SetCommandNav(command, value)
        return 0
    elseif command == device_commands.NAV_DEC_FYT then
        SetCommandNav(command, value)
        return 0
    end
    if command == Keys.DisplayMngt then
        if value == 1 then -- Fwd
            CMFDDoi:set(0)
        elseif value == 3 then -- Left
            if DMSLeftElapsed > 0 then
                DMSLeftElapsed = -1
                if CMFD1Primary:get() == 1 then 
                    dev:performClickableAction(device_commands.CMFD1OSS19, 1)
                else
                    dev:performClickableAction(device_commands.CMFD1OSS16, 1)
                end
            else
                DMSLeftElapsed = 0.4
            end
        elseif value == 4 then -- Right
            if DMSRightElapsed > 0 then
                DMSRightElapsed = -1
                if CMFD2Primary:get() == 1 then 
                    dev:performClickableAction(device_commands.CMFD2OSS19, 1)
                else
                    dev:performClickableAction(device_commands.CMFD2OSS16, 1)
                end
            else
                DMSRightElapsed = 0.4
            end
        end
        return 0
    end


    if command == device_commands.CMFD1ButtonOn or command == device_commands.CMFD2ButtonOn then
        -- Quando se liga o CMFD, as imagens tornam-se visíveis depois de aproximadamente 30 segundos e o seu desempenho é total depois de 5 minutos.
        CMFD[cmfdnumber]["SwOn"]:set(value)
    end

    if CMFD[cmfdnumber]["On"]:get() == 0 then return end

    if CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU1 then SetCommandMenu1(command,value, CMFD[cmfdnumber]) 
    elseif CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU2 then SetCommandMenu2(command,value, CMFD[cmfdnumber]) 
    elseif CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.EICAS then SetCommandEicas(command,value, CMFD[cmfdnumber]) 
    elseif CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.ADHSI then SetCommandAdhsi(command,value, CMFD[cmfdnumber]) 
    elseif CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.SMS   then SetCommandSms(command,value, CMFD[cmfdnumber]) 
    elseif CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.NAV   then SetCommandNav(command,value, CMFD[cmfdnumber]) 
    end

    if command == device_commands.CMFD1ButtonBright or command == device_commands.CMFD2ButtonBright then
        if value == -1 then
            cmfd_bright[cmfdnumber] = cmfd_bright[cmfdnumber] - 0.1
            if cmfd_bright[cmfdnumber] < 0 then cmfd_bright[cmfdnumber] = 0 end
        elseif value == 1 then
            cmfd_bright[cmfdnumber] = cmfd_bright[cmfdnumber] + 0.1
            if cmfd_bright[cmfdnumber] > 1 then cmfd_bright[cmfdnumber] = 1 end
        end
    end

    if value == 1 then
        --print_message_to_user("CMFD: command "..tostring(command).." = "..tostring(value) .. " Tela=" .. tostring(CMFD["Selected"]))

        if command == device_commands.CMFD1OSS15 or command == device_commands.CMFD2OSS15 then
            CMFD[cmfdnumber]["DCLT"]:set((CMFD[cmfdnumber]["DCLT"]:get()+1)%2)
            -- OSS 15 (DCLT) – Tem a função de alternar entre ocultar e apresentar as legendas adjacentes aos OSS 1 a 14 e 21 a 28.
            -- A legenda DCLT fica em vídeo inverso quando a função de ocultar estiver ativada e em vídeo normal quando desativada.
            -- Mesmo quando as legendas estiverem ocultas, os OSS continuam com suas funções habilitadas.
            -- A função DCLT é individual para cada formato, e é mantida a última seleção feita.
        elseif command == device_commands.CMFD1OSS16 or command == device_commands.CMFD2OSS16 then
            if CMFD[cmfdnumber]["Primary"]:get()==1 then
                if (CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU1) or (CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU2) then
                    CMFD[cmfdnumber]["Format"]:set(CMFD[cmfdnumber]["SelRight"]:get())
                    CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelRight"]:get())
                else 
                    CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelRight"]:get())
                    CMFD[cmfdnumber]["Format"]:set(SUB_PAGE_ID.MENU1)
                end
            else 
                CMFD[cmfdnumber]["Primary"]:set(1)
                CMFD[cmfdnumber]["Format"]:set(CMFD[cmfdnumber]["SelRight"]:get())
                CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelRight"]:get())
            end
        elseif command == device_commands.CMFD1OSS19 or command == device_commands.CMFD2OSS19 then
            if CMFD[cmfdnumber]["Primary"]:get()==0 then
                if (CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU1) or (CMFD[cmfdnumber]["Format"]:get() == SUB_PAGE_ID.MENU2) then
                    CMFD[cmfdnumber]["Format"]:set(CMFD[cmfdnumber]["SelLeft"]:get())
                    CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelLeft"]:get())
                else 
                    CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelLeft"]:get())
                    CMFD[cmfdnumber]["Format"]:set(SUB_PAGE_ID.MENU1)
                end
            else 
                CMFD[cmfdnumber]["Primary"]:set(0)
                CMFD[cmfdnumber]["Format"]:set(CMFD[cmfdnumber]["SelLeft"]:get())
                CMFD[cmfdnumber]["Sel"]:set(CMFD[cmfdnumber]["SelLeft"]:get())
            end
            -- OSS 16 e 19 (Formatos Primário e Secundário) – Têm a função de selecionar o formato primário de apresentação.
            -- As legendas adjacentes aos OSS 16 e 19 representam os formatos primário e secundário selecionados e podem ser qualquer uma daquelas que representam os formatos possíveis de serem selecionados, quais sejam: HSD, SMS, UFCP, DVR, EW, ADHSI, EICAS, FLIR, EMERG, PFL, BIT, HUD, DTE e NAV.
            -- A legenda adjacente a um destes OSS que estiver em vídeo inverso indica que o respectivo formato é o primário e a que estiver em vídeo normal indica que o respectivo formato é o secundário.
            -- Pressionando-se o OSS adjacente à legenda do formato secundário (vídeo normal), inverte-se a seleção de formato primário e secundário entre as duas opções.
            -- Pressionando-se o OSS adjacente à legenda do formato primário (vídeo inverso), seleciona-se o formato MENU. Selecionando-se um outro formato a partir do formato MENU, este passa a ser o novo formato primário.
            -- Os displays primário e secundário apresentados ao ligar o sistema aviônico são determinados pelo modo principal selecionado ou da programação carregada por meio do DTC.
        elseif command == device_commands.CMFD1OSS17 or command == device_commands.CMFD2OSS17 then
            CMFDDoi:set(cmfdnumber)
            -- OSS 17 (DOI) – Tem a função de indicar se o respectivo CMFD é o display de interesse (Display Of Interest – DOI) selecionado.
            -- A seleção do DOI é feita pressionando-se o OSS 17 do respectivo CMFD ou movendo-se para a esquerda ou para a direita no Interruptor de Gerenciamento dos Displays no manche.
            -- O CMFD selecionado como DOI é aquele que estiver habilitado no momento para ser controlado pelos interruptores da função HOTAS.
            -- A seta do DOI pode ser apresentada apontando para cima ou para baixo nos CMFD e segue a seguinte lógica:
            --  • Seta para cima (⇑) no CMFD direito ou esquerdo indica que o referido display da nacele dianteira é o DOI;
            --  • Seta para baixo (⇓) no CMFD direito ou esquerdo indica que o referido display da nacele traseira é o DOI;
            --  • Nenhuma seta nos CMFD indica que o HUD é o DOI.
            -- A seleção do DOI é mantida de acordo com a última seleção feita ou modificada através da programação carregada por meio do DTC.
        elseif command == device_commands.CMFD1OSS18 or command == device_commands.CMFD2OSS18 then
            -- OSS 18 (SWAP) – Tem a função de trocar os formatos que estiverem sendo apresentados nos CMFDs da esquerda e da direita.
            -- Ao pressionar o OSS 18, o formato que esta sendo apresentado no CMFD esquerdo passa a ser apresentado no CMFD direito e vice-versa.
            -- Pode-se efetuar a troca (SWAP) entre os displays primário e secundário de um mesmo CMFD através de dois movimentos para a esquerda no Interruptor de Gerenciamento dos Displays (DMS) no punho do manche para o CMFD da esquerda. Analogamente pode-se fazer a mesma troca no CMFD da direita.
            -- A função de troca (SWAP) continua disponível mesmo que o CMFD direito não esteja instalado.
            if CMFD1Primary:get() == 0 then
                selected1 = CMFD1SelLeft
                name1 = CMFD1SelLeftName
            else 
                selected1 = CMFD1SelRight
                name1 = CMFD1SelRightName
            end
            if CMFD2Primary:get() == 0 then
                selected2 = CMFD2SelLeft
                name2 = CMFD2SelLeftName
            else 
                selected2 = CMFD2SelRight
                name2 = CMFD2SelRightName
            end
            seltemp = selected1:get()
            nametemp = name1:get()
            selected1:set(selected2:get())
            name1:set(name2:get())
            selected2:set(seltemp)
            name2:set(nametemp)
            CMFD1Sel:set(selected1:get())
            CMFD1Format:set(selected1:get())
            CMFD2Sel:set(selected2:get())
            CMFD2Format:set(selected2:get())
        elseif command == device_commands.CMFD1OSS20 or command == device_commands.CMFD2OSS20 then
            -- OSS 20 (IND) – Tem a função de individualizar a seleção dos formatos dos CMFDs dianteiro e traseiro de um mesmo lado.
            -- Esta função está habilitada somente na nacele traseira e a sua ativação e desativação é feita pressionando-se o OSS 20. Entretanto, a legenda é apresentada nas duas naceles.
            -- Quando a função estiver ativada, a legenda IND é apresentada com uma moldura. Neste caso, é possível selecionar formatos distintos nos CMFDs do mesmo lado.
            -- Quando a legenda IND é apresentada sem moldura (função desativada), os CMFDs dianteiro e traseiro do mesmo lado apresentam obrigatoriamente o mesmo formato.
            -- Durante a operação com a função IND ativada, a edição de dados em um dos CMFDs edita os mesmos dados no outro CMFD (exemplo: modificação do ponto FYT).
            -- Pressionando-se o OSS 18 (SWAP) nos CMFDs da nacele traseira estando com a função IND ativada em um ou ambos os CMFD, a função IND é desativada em todos os CMFDs. Caso a função SWAP seja acionada na nacele dianteira, não provoca a desativação da função IND.
            -- Uma troca de modo principal não afeta quando a função IND está ativada. O modo principal afeta os CMFDs da nacele dianteira e todos os outros CMFDs que estiverem no modo de CMFD repetidor.
        end
    end

end

dev:listen_event("WeaponRearmComplete")
dev:listen_event("ReloadDone")
dev:listen_event("RefuelDone")


function CockpitEvent(command,val)
    -- val seems to mostly be empty table: {}
    -- log.alert("CockpitEvent event: "..tostring(command).."="..tostring(val))
    -- if val then
    --     local str=dump("event",val)
    --     local lines=strsplit("\n",str)
    --     for k,v in ipairs(lines) do
    --         log.alert(v)
    --     end
    -- end
    -- print_message_to_user("CockpitEvent event: "..tostring(command).."="..tostring(val))
    -- if val then
    --     local str=dump("event",val)
    --     local lines=strsplit("\n",str)
    --     for k,v in ipairs(lines) do
    --         print_message_to_user(v)
    --     end
    -- end
    fuel_init=round_to(sensor_data.getTotalFuelWeight(),5)
    fuel_joker=round_to(fuel_init/2,5)
end


startup_print("CMFD2: load end")
need_to_be_closed = false -- close lua state after initialization


