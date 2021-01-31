dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."CMFD/CMFD_pageID_defs.lua")

startup_print("cmfd_right: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

function update()
end

function post_initialize()
    startup_print("cmfd_right: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end
    startup_print("environ: postinit end")
end

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

local CMFD2Format=get_param_handle("CMFD2Format")
CMFD2Format:set(SUB_PAGE_ID.EICAS)

local CMFD2Soi=get_param_handle("CMFD2Soi")
CMFD2Soi:set(1)

local CMFD2Primary=get_param_handle("CMFD2Primary")
CMFD2Primary:set(0) -- 0=Left or OSS 19     1=Right or PSS 16

local CMFD2SelLeft=get_param_handle("CMFD2SelLeft")
CMFD2SelLeft:set(SUB_PAGE_ID.EICAS)

local CMFD2SelLeftName=get_param_handle("CMFD2SelLeftName")
CMFD2SelLeftName:set(SUB_PAGE_NAME[CMFD2SelLeft:get()])


local CMFD2SelRight=get_param_handle("CMFD2SelRight")
CMFD2SelRight:set(SUB_PAGE_ID.BLANK)

local CMFD2SelRightName=get_param_handle("CMFD2SelRightName")
CMFD2SelRightName:set(SUB_PAGE_NAME[CMFD2SelRight:get()])




-- HSD, SMS, UFCP, DVR, EW, ADHSI, EICAS, FLIR, EMERG, PFL, BIT, HUD, DTE e NAV


function SetCommandMenu1(command,value)
    local selected=-1
    if command==device_commands.CMFD2OSS1 then CMFD2Format:set(SUB_PAGE_ID.MENU2)
    elseif command==device_commands.CMFD2OSS3 then selected=SUB_PAGE_ID.BLANK
    elseif command==device_commands.CMFD2OSS5 then selected=SUB_PAGE_ID.BLANK
    elseif command==device_commands.CMFD2OSS6 then selected=SUB_PAGE_ID.BLANK
    elseif command==device_commands.CMFD2OSS7 then selected=SUB_PAGE_ID.DTE
    elseif command==device_commands.CMFD2OSS8 then selected=SUB_PAGE_ID.FLIR
    elseif command==device_commands.CMFD2OSS9 then selected=SUB_PAGE_ID.DVR
    elseif command==device_commands.CMFD2OSS10 then selected=SUB_PAGE_ID.EMERG
    elseif command==device_commands.CMFD2OSS11 then selected=SUB_PAGE_ID.PFL
    elseif command==device_commands.CMFD2OSS12 then selected=SUB_PAGE_ID.BIT
    elseif command==device_commands.CMFD2OSS13 then selected=SUB_PAGE_ID.NAV
    elseif command==device_commands.CMFD2OSS14 then selected=SUB_PAGE_ID.BLANK
    elseif command==device_commands.CMFD2OSS21 then selected=SUB_PAGE_ID.BLANK
    elseif command==device_commands.CMFD2OSS22 then selected=SUB_PAGE_ID.EICAS
    elseif command==device_commands.CMFD2OSS23 then selected=SUB_PAGE_ID.UFCP
    elseif command==device_commands.CMFD2OSS24 then selected=SUB_PAGE_ID.ADHSI
    elseif command==device_commands.CMFD2OSS25 then selected=SUB_PAGE_ID.EW
    elseif command==device_commands.CMFD2OSS26 then selected=SUB_PAGE_ID.SMS
    elseif command==device_commands.CMFD2OSS27 then selected=SUB_PAGE_ID.HUD
    elseif command==device_commands.CMFD2OSS28 then selected=SUB_PAGE_ID.HSD
    end
    if selected > 0 then
        CMFD2Format:set(selected)
        if CMFD2Primary:get()==1 then
            CMFD2SelRight:set(selected)
            CMFD2SelRightName:set(SUB_PAGE_NAME[selected])
            if CMFD2SelLeft:get() == selected then
                CMFD2SelLeft:set(SUB_PAGE_ID.BLANK)
                CMFD2SelLeftName:set(SUB_PAGE_NAME[SUB_PAGE_ID.BLANK])
            end
        else 
            CMFD2SelLeft:set(selected)
            CMFD2SelLeftName:set(SUB_PAGE_NAME[selected])
            if CMFD2SelRight:get() == selected then
                CMFD2SelRight:set(SUB_PAGE_ID.BLANK)
                CMFD2SelRightName:set(SUB_PAGE_NAME[SUB_PAGE_ID.BLANK])
            end
        end
    end

end

function SetCommandMenu2(command,value)
    if command==device_commands.CMFD2OSS1 then CMFD2Format:set(SUB_PAGE_ID.MENU1)
    end
end

function SetCommandEicas(command,value)
end

function SetCommand(command,value)
    CMFD2FormatSelected=CMFD2Format:get()
    if value == 1 then
        print_message_to_user("CMFD2: command "..tostring(command).." = "..tostring(value) .. " Tela=" .. tostring(CMFD2FormatSelected))
        if CMFD2FormatSelected == SUB_PAGE_ID.MENU1 then SetCommandMenu1(command,value) 
        elseif CMFD2FormatSelected == SUB_PAGE_ID.MENU2 then SetCommandMenu2(command,value) 
        elseif CMFD2FormatSelected == SUB_PAGE_ID.EICAS then SetCommandEicas(command,value) 
        end

        if command==device_commands.CMFD2OSS1 then
        elseif command == device_commands.CMFD2OSS2 then
            -- Função: Restaurar a configuração padrão do sistema para os formatos Primário e Secundário e para o DOI de cada modo principal.
        elseif command == device_commands.CMFD2OSS4 then
            -- Função: Restaurar os valores padrão do brilho da simbologia e do contraste das imagens de vídeo.
            -- Esta função é usada para se fazer uma recuperação rápida de ajustes errôneos de contraste ou brilho.
        elseif command == device_commands.CMFD2OSS15 then
            -- OSS 15 (DCLT) – Tem a função de alternar entre ocultar e apresentar as legendas adjacentes aos OSS 1 a 14 e 21 a 28.
            -- A legenda DCLT fica em vídeo inverso quando a função de ocultar estiver ativada e em vídeo normal quando desativada.
            -- Mesmo quando as legendas estiverem ocultas, os OSS continuam com suas funções habilitadas.
            -- A função DCLT é individual para cada formato, e é mantida a última seleção feita.        
        elseif command == device_commands.CMFD2OSS16 then
            if CMFD2Primary:get()==1 then
                if (CMFD2FormatSelected == SUB_PAGE_ID.MENU1) or (CMFD2FormatSelected == SUB_PAGE_ID.MENU2) then
                    CMFD2Format:set(CMFD2SelRight:get())
                else 
                    CMFD2Format:set(SUB_PAGE_ID.MENU1)
                end
            else 
                CMFD2Primary:set(1)
                CMFD2Format:set(CMFD2SelRight:get())
            end
        elseif command == device_commands.CMFD2OSS19 then
            if CMFD2Primary:get()==0 then
                if (CMFD2FormatSelected == SUB_PAGE_ID.MENU1) or (CMFD2FormatSelected == SUB_PAGE_ID.MENU2) then
                    CMFD2Format:set(CMFD2SelLeft:get())
                else 
                    CMFD2Format:set(SUB_PAGE_ID.MENU1)
                end
            else 
                CMFD2Primary:set(0)
                CMFD2Format:set(CMFD2SelLeft:get())
            end
            -- OSS 16 e 19 (Formatos Primário e Secundário) – Têm a função de selecionar o formato primário de apresentação.
            -- As legendas adjacentes aos OSS 16 e 19 representam os formatos primário e secundário selecionados e podem ser qualquer uma daquelas que representam os formatos possíveis de serem selecionados, quais sejam: HSD, SMS, UFCP, DVR, EW, ADHSI, EICAS, FLIR, EMERG, PFL, BIT, HUD, DTE e NAV.
            -- A legenda adjacente a um destes OSS que estiver em vídeo inverso indica que o respectivo formato é o primário e a que estiver em vídeo normal indica que o respectivo formato é o secundário.
            -- Pressionando-se o OSS adjacente à legenda do formato secundário (vídeo normal), inverte-se a seleção de formato primário e secundário entre as duas opções.
            -- Pressionando-se o OSS adjacente à legenda do formato primário (vídeo inverso), seleciona-se o formato MENU. Selecionando-se um outro formato a partir do formato MENU, este passa a ser o novo formato primário.
            -- Os displays primário e secundário apresentados ao ligar o sistema aviônico são determinados pelo modo principal selecionado ou da programação carregada por meio do DTC.
        elseif command == device_commands.CMFD2OSS17 then
            -- OSS 17 (DOI) – Tem a função de indicar se o respectivo CMFD é o display de interesse (Display Of Interest – DOI) selecionado.
            -- A seleção do DOI é feita pressionando-se o OSS 17 do respectivo CMFD ou movendo-se para a esquerda ou para a direita no Interruptor de Gerenciamento dos Displays no manche.
            -- O CMFD selecionado como DOI é aquele que estiver habilitado no momento para ser controlado pelos interruptores da função HOTAS.
            -- A seta do DOI pode ser apresentada apontando para cima ou para baixo nos CMFD e segue a seguinte lógica:
            --  • Seta para cima (⇑) no CMFD direito ou esquerdo indica que o referido display da nacele dianteira é o DOI;
            --  • Seta para baixo (⇓) no CMFD direito ou esquerdo indica que o referido display da nacele traseira é o DOI;
            --  • Nenhuma seta nos CMFD indica que o HUD é o DOI.
            -- A seleção do DOI é mantida de acordo com a última seleção feita ou modificada através da programação carregada por meio do DTC.
        elseif command == device_commands.CMFD2OSS18 then
            -- OSS 18 (SWAP) – Tem a função de trocar os formatos que estiverem sendo apresentados nos CMFDs da esquerda e da direita.
            -- Ao pressionar o OSS 18, o formato que esta sendo apresentado no CMFD esquerdo passa a ser apresentado no CMFD direito e vice-versa.
            -- Pode-se efetuar a troca (SWAP) entre os displays primário e secundário de um mesmo CMFD através de dois movimentos para a esquerda no Interruptor de Gerenciamento dos Displays (DMS) no punho do manche para o CMFD da esquerda. Analogamente pode-se fazer a mesma troca no CMFD da direita.
            -- A função de troca (SWAP) continua disponível mesmo que o CMFD direito não esteja instalado.

        elseif command == device_commands.CMFD2OSS20 then
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


print_message_to_user("CMFD2: load end")
need_to_be_closed = false -- close lua state after initialization


