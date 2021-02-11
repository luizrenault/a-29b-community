dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."HUD/HUD_ID_defs.lua")

startup_print("hud: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()


local function round_to(value, roundto)
    value = value + roundto/2
    return value - value % roundto
end


local HUD_PITCH = get_param_handle("HUD_PITCH")
local HUD_ROLL = get_param_handle("HUD_ROLL")
local HUD_PL_GHOST = get_param_handle("HUD_PL_GHOST")
local HUD_IAS = get_param_handle("HUD_IAS")
local HUD_HDG = get_param_handle("HUD_HDG")
local HUD_ALT_K = get_param_handle("HUD_ALT_K")
local HUD_ALT_N = get_param_handle("HUD_ALT_N")
local HUD_FPM_SLIDE = get_param_handle("HUD_FPM_SLIDE")
local HUD_FPM_VERT = get_param_handle("HUD_FPM_VERT")
local HUD_FPM_OOR = get_param_handle("HUD_FPM_OOR")
local HUD_PL_SLIDE = get_param_handle("HUD_PL_SLIDE")
local HUD_RI_ROLL = get_param_handle("HUD_RI_ROLL")

-- Visuals
local HUD_DRIFT_CO = get_param_handle("HUD_DRIFT_CO")
local HUD_DCLT = get_param_handle("HUD_DCLT")
local HUD_VAH = get_param_handle("HUD_VAH")
local HUD_VV = get_param_handle("HUD_VV")
local HUD_FPM_CROSS = get_param_handle("HUD_FPM_CROSS")

local HUD_NORMAL_ACCEL = get_param_handle("HUD_NORMAL_ACCEL")
local HUD_MAX_ACCEL = get_param_handle("HUD_MAX_ACCEL")
local HUD_RDY = get_param_handle("HUD_RDY")
local HUD_RDY_S = get_param_handle("HUD_RDY_S")
local HUD_DOI = get_param_handle("HUD_DOI")
local HUD_RADAR_ALT = get_param_handle("HUD_RADAR_ALT")
local HUD_RANGE = get_param_handle("HUD_RANGE")
local HUD_TIME_MIN = get_param_handle("HUD_TIME_MIN")
local HUD_TIME_SEC = get_param_handle("HUD_TIME_SEC")
local HUD_FTI_DIST = get_param_handle("HUD_FTI_DIST")
local HUD_FTI_NUM = get_param_handle("HUD_FTI_NUM")
local HUD_VOR_DIST = get_param_handle("HUD_VOR_DIST")
local HUD_VOR_MAG = get_param_handle("HUD_VOR_MAG")
local HUD_MACH = get_param_handle("HUD_MACH")

local HUD_MODE = get_param_handle("HUD_MODE")
local HUD_MODE_TXT = get_param_handle("HUD_MODE_TXT")

local HUD_AOA = get_param_handle("HUD_AOA")

local CMFDDoi = get_param_handle("CMFDDoi")


HUD_DCLT:set(0)
HUD_DRIFT_CO:set(0)
HUD_VAH:set(0)

HUD_RDY:set(0)
HUD_RDY_S:set(0)

local hud_mode = HUD_MODE_ID.NAV

local max_accel = 0

function update()
    if hud_mode == HUD_MODE_ID.NAV and sensor_data.getLeftMainLandingGearDown() == 1 then hud_mode = HUD_MODE_ID.LANDING end
    if hud_mode == HUD_MODE_ID.LANDING and sensor_data.getLeftMainLandingGearDown() == 0 then hud_mode = HUD_MODE_ID.NAV end

    local hud_mode_txt = HUD_MODE_STR[hud_mode]

    local pitch = sensor_data.getPitch()
    local roll = sensor_data.getRoll()
    local hdg = math.floor(math.deg(-sensor_data.getHeading()))
    if hdg < 0 then hdg = 360 + hdg end
    hdg = hdg % 360

    local altitude = round_to(sensor_data.getBarometricAltitude()*3.2808399,10)
    local alt_k = math.floor(altitude/1000)
    local alt_n = altitude%1000

    if pitch > 10 then pl_ghost = 1
    elseif pitch < -10 then pl_ghost = -1
    else pl_ghost = 0 end
    
    local speedx, speedy, speedz = sensor_data:getSelfVelocity()
    local speedh=math.sqrt(speedx*speedx + speedz*speedz)
    if speedh == 0 then 
        anglev = 0
    else  
        anglev = math.atan(speedy/speedh)
    end

    local iasx, iasy, iasz = sensor_data.getSelfAirspeed()
    angleh = math.atan2(iasz, iasx) - math.atan2(speedz, speedx)
    angleh = math.rad(sensor_data.getAngleOfSlide())-angleh


    if HUD_DRIFT_CO:get() == 0 then 
    else 
        angleh = 0
    end

    fpm_cross = 0        
    if angleh > math.rad(5) then
        angleh = math.rad(5)
        fpm_cross = 1
    elseif angleh < math.rad(-5) then
        angleh = math.rad(-5)
        fpm_cross = 1
    end
    if (anglev - pitch) < math.rad(-7.5) then
        anglev = pitch + math.rad(-7.5)
        fpm_cross = 1
    end

    local pl_slide = angleh + (anglev-pitch) * math.tan(roll)

    local ias = math.sqrt(iasx * iasx + iasz * iasz ) * 1.94384

    if ias < 30 then
        ias = 0
        if sensor_data.getWOW_LeftMainLandingGear() > 0 then 
            angleh = 0
            anglev = 0
            pl_slide = 0
        end
    end

    ri_roll = roll
    if ri_roll > math.rad(50) then 
        ri_roll = math.rad(50)
    elseif ri_roll < math.rad(-50) then
        ri_roll = math.rad(-50)
    end

    local normal_accel = sensor_data.getVerticalAcceleration()
    if normal_accel > max_accel then max_accel = normal_accel end
    local max_accel_val = max_accel

    if CMFDDoi:get() == 0 then hud_doi = 1 else hud_doi = 0 end

    local radar_alt = sensor_data.getRadarAltitude() * 3.2808399
    if radar_alt > 0 and radar_alt < 5000 then radar_alt = round_to(radar_alt, 10) else radar_alt = -1 end
    
    local range = -1

    local time_min = 5
    local time_sec = -1

    local fti_dist = -1
    local fti_num = 0
    fti_dist = round_to(fti_dist, 0.1)

    local vor_dist = -1
    local vor_mag = 270

    local mach = round_to(sensor_data.getMachNumber(), 0.01)
    if hud_mode == HUD_MODE_ID.LANDING and sensor_data.getWOW_LeftMainLandingGear() == 0 then 
        mach = -1 
        max_accel_val = -1
    end

    local aoa = math.deg(sensor_data.getAngleOfAttack())
    if aoa < -9 then aoa = -9 end
    if aoa > 40 then aoa = 40 end
    
    HUD_PITCH:set(pitch - pl_slide*math.sin(roll))
    HUD_ROLL:set(roll)
    HUD_HDG:set(hdg)
    HUD_IAS:set(ias)
    HUD_ALT_K:set(alt_k)
    HUD_ALT_N:set(alt_n)
    HUD_FPM_VERT:set(anglev - pitch)
    HUD_FPM_SLIDE:set(angleh)
    HUD_FPM_CROSS:set(fpm_cross)
    HUD_PL_SLIDE:set(pl_slide)
    HUD_PL_GHOST:set(pl_ghost) 
    HUD_RI_ROLL:set(ri_roll) 

    HUD_NORMAL_ACCEL:set(normal_accel)
    HUD_MAX_ACCEL:set(max_accel_val)
    
    HUD_DOI:set(hud_doi)

    HUD_RADAR_ALT:set(radar_alt) 
    HUD_RANGE:set(range) 

    HUD_TIME_MIN:set(time_min) 
    HUD_TIME_SEC:set(time_sec) 

    HUD_FTI_DIST:set(fti_dist) 
    HUD_FTI_NUM:set(fti_num) 

    HUD_VOR_DIST:set(vor_dist) 
    HUD_VOR_MAG:set(vor_mag) 

    HUD_MACH:set(mach)
    
    HUD_MODE:set(hud_mode)
    HUD_MODE_TXT:set(hud_mode_txt)

    HUD_AOA:set(aoa)

    -- Escalas de Velocidade, Altitude ou Altura e Proa – Apresentadas quando as funções VV/VAH e VAH estão ativadas no UFCP ou no CMFD, estando em qualquer modo principal. Ficam ocultas quando estas funções estiverem desativadas;
    -- Escala de Velocidade Vertical – Apresentada somente quando a função VV/VAH estiver ativada no UFCP ou no CMFD e o modo principal NAV estiver em operação;
    -- Proa, Velocidade e Altitude ou Altura Digitais – Apresentadas quando as funções VV/VAH e VAH estiverem desativadas no UFCP, e o CMFD esteja em qualquer modo principal. Ficam ocultas quando estas funções estão ativadas.


    -- 6. Linha do horizonte (Horizon Line)
        -- A linha do horizonte é sempre cheia e maior que as outras barras de atitude. Quando ela excede o limite do campo de visada do HUD, uma linha de horizonte tracejada é apresentada no limite do campo de visada do HUD.
        -- Essa linha desaparece quando a função DCLT do formato DCLT no UFCP estiver ativada, exceto se a aeronave estiver operando nos submodos NAV LANDING, A/A INT e A/G CCIP.
    -- 7. Indicador de inclinação (Roll Angle Indicator)
        -- A indicação de inclinação é apresentada na base do campo visual do HUD, quando a aeronave estiver operando no submodo NAV LANDING. É constituída de uma escala de inclinação curva com traços curtos indicando 10° e 20° de inclinação e um traço mais longo indicando 0°, 30° e 45° de inclinação.
        -- A referência para determinar a proa é o indicador de inclinação representado pelo "Δ" abaixo da escala.
        -- Se o ângulo de inclinação da aeronave for maior que 50°, o indicador de inclinação aponta para 5° além do último traço da escala (esquerda ou direita). 
        -- A escala e o indicador de ângulo de inclinação não aparecem quando o ângulo de inclinação for inválido, se a função DCLT do formato DCLT no UFCP estiver ativada e se estiver em outro submodo de operação.
    -- 8. Barras de atitude (Attitude Bars)
        -- As barras de atitude são mostradas em todos os modos de operação, exceto no modo DGFT, no qual aparece somente a barra do horizonte.
        -- As barras de atitude são representadas por linhas cheias para indicar ângulos de cabrada e tracejadas para indicar ângulos de picada. Nas extremidades de cada linha existem traços verticais apontando para o horizonte e o valor do ângulo de cabrada ou de picada que a linha representa. Entre 0° e 60°, a indicação é feita em intervalos de 5°. Entre 60° e 90°, a indicação é feita em intervalos de 10°.
        -- As barras de atitude abaixo do horizonte são inclinadas em direção ao horizonte para enfatizar o ângulo de picada. Esta inclinação é igual à metade do ângulo de picada no momento.
        -- Quando o submodo NAV LANDING é apresentado, uma barra adicional de 2,5° de picada é apresentada. Esta linha é mais curta, tracejada e sem os traços e dígitos nas extremidades. Sua função é proporcionar uma melhor referência para voar na rampa ideal.
        -- Todas as barras são descontinuadas no centro para permitir a visualização do FPM movimentando-se sobre elas.
        -- O ângulo de atitude de ± 90° é simbolizado por pequenas circunferências. A circunferência sem símbolo interno representa a atitude de 90° cabrados, enquanto a circunferência com um “X” inscrito representa a atitude de 90° picados.
        -- As barras são estabilizadas em rolamento e quando a função DRIFT C/O é ativada, no formato DRIFT do UFCP, passam a ser apresentadas sem correção de deriva.
        -- Essas barras não aparecem se a função DCLT do formato DCLT no UFCP estiver ativada, exceto se a aeronave estiver operando nos submodos NAV LANDING, A/A INT e A/G CCIP.
        -- As barras de atitude não aparecem quando os dados de atitude forem inválidos. 
    -- 9. Indicador de AOA (bracket) (AOA Bracket)
        -- O indicador de ângulo de ataque é apresentado no submodo NAV LANDING e é utilizado como um auxílio para o piloto realizar o tráfego e pouso mantendo a velocidade correta.
        -- O bracket e o FPM movem-se na direção vertical e a posição ótima é quando a asa esquerda do FPM é posicionada no ponto médio do indicador de AOA e, simultaneamente, é posicionado em uma rampa aproximada de 3°.
        -- Quando a asa do FPM está posicionada na borda superior do bracket, indica que o ângulo de ataque é de 3°, e quando está posicionada na borda inferior do bracket, indica que o ângulo de ataque é de 6°.
        -- Este indicador está associado à indicação digital do AOA atual (item 13) e desaparece quando os dados de AOA são inválidos.
    -- 1. Símbolo zênite (+90° Attitude Symbol)
        -- O símbolo do Céu é representado por uma circunferência pequena, que indica a posição de 90° de cabrada.
    -- 2. Símbolo nadir (–90° Attitude Symbol)
        -- O símbolo da Terra é representado por uma circunferência pequena com um “X” inscrito, que indica a posição de 90° de picada.
    -- 3. “X” de limite (Limit “X”)
        -- O “X” de limite aparece sobre alguns símbolos do HUD quando eles estiverem além do campo de visada do HUD. 
        -- O “X” de limite se sobrepõe aos seguintes símbolos: retículo da LCOS, retículo do snapshot, autodiretor do míssil travado e destravado, ponto do FYT, ponto de visada deslocada (OAP), ponto de início de balsing, indicador de direção, diretor de vôo do ILS, FPM e retículo do CCIP.
    -- 15. Indicador de trajetória (Flight Path Marker)
        -- No modo A/A, quando um míssil estiver selecionado e a chave seletora MASS estiver em LIVE ou SIM, o FPM pisca para indicar que o WRB foi pressionado para lançar o míssil.
        -- No modo A/G, quando um armamento estiver selecionado e a chave seletora MASS estiver em LIVE ou SIM, o FPM fica piscando enquanto o WRB estiver pressionado.
    -- 16. Indicador de direção (Steering Cue)
        -- O indicador de direção consiste em uma circunferência pequena representando a posição em que a aeronave se encontra e um traço longo (o dobro do diâmetro) saindo da circunferência em direção ao ponto FYT, quando a aeronave estiver operando no modo principal NAV.
        -- O indicador de direção é estabilizado em rolamento e se desloca no campo de visada em uma linha paralela à linha do horizonte. A pilotagem para o FYT é feita levando-se o FPM para o indicador de direção até que ele indique a proa às 12 horas e mantendo-se essa posição. Nessa posição, o indicador de direção apresenta o FYT na posição de 0° em relação à aeronave.
        -- Caso indique a posição de 3 ou 9 horas, o indicador de direção apresenta o FYT na posição de 90° à direita ou à esquerda em relação à aeronave.
        -- Quando o indicador de direção estiver além do limite do campo de visada do HUD, um símbolo "X" aparece superposto ao indicador.
        -- O indicador de direção não aparece quando os dados de indicação de direção ou o rumo para o FYT forem inválidos.
    -- 17. Símbolo de gravação (Record Symbol)
        -- Este símbolo aparece enquanto estiver ocorrendo a gravação.
    -- 18. Símbolo de display de interesse (Display Of Interest)
        -- Este símbolo indica que o HUD está selecionado como display de interesse (DOI).
        -- O símbolo do DOI para o HUD pode aparecer em todos os modos e consiste em uma seta apontada para cima, localizada no canto superior direito do HUD.
        -- O HUD é selecionado como o DOI, pressionando-se o interruptor de gerenciamento dos displays (DMS) uma vez para a frente.
        -- Somente o DMS da nacele dianteira é habilitado para selecionar o display de interesse.
    -- 19. Indicador de velocidade vertical (Vertical Speed Cue)
        -- O indicador de velocidade vertical é apresentado à esquerda da escala (>) que se desloca verticalmente em uma escala fixa.
        -- Se a velocidade vertical for maior que 2000 ft/min de subida ou maior que 2000 ft/min de descida, o ponteiro indicador de velocidade vertical (>) posiciona-se no topo ou na base da escala, respectivamente.
    -- 20. Escala de velocidade vertical (Vertical Velocity Scale)
        -- A escala de velocidade vertical aparece no display quando a função VV/VAH estiver ativada no formato VV/VAH do UFCP ou quando a opção VV no formato ADHSI do CMFD estiver selecionada (OSS 8), desde que a aeronave esteja operando no modo principal NAV.
        -- A escala é formada por traços longos indicando 0, ± 1000 e ± 2000 ft/min, intercalados por traços curtos indicando ± 500 e ± 1500 ft/min.
        -- A referência para indicar 0 ft/min de velocidade vertical é a mesma da escala de altitude/altura barométrica.
        -- A escala de velocidade vertical não é mostrada quando a velocidade vertical for inválida, quando estiver nos modos principais A/A e A/G ou quando a função VV não estiver ativada.
    -- 21. Estado de alinhamento do EGIR (EGI Alignment Status) Janela 26
        -- A janela 26 é utilizada para apresentar o estado de alinhamento do EGIR. A legenda apresentada varia de acordo com o estado e segue a seguinte lógica:
            -- OFF O botão de EGI está na posição OFF;
            -- ALGN constante Indica que o inercial está pronto para navegar com desempenho degradado;
            -- ALGN piscando Indica que o inercial está pronto para navegar com toda sua capacidade operacional.
        -- Os estados de alinhamento também são apresentados no formato EGI do UFCP, onde a mensagem RDY substitui a mensagem ALGN.
    -- 22. Modo de operação (Master Mode or Submode) Janela 8
        -- Apresenta as mensagens relativas aos modos principais ou submodos em operação, de acordo com a lista abaixo:
            -- NAV Modo NAV, exceto quando estiver no submodo NAV LANDING, quando desaparece;
            -- INT Submodo A/A INT;
            -- DGFT B Submodo A/A DGFT;
            -- DGFT L Submodo A/A DGFT orientado pelo sistema de enlace de dados;
            -- DTOS Submodo A/G DTOS;
            -- DTOS R Submodo A/G DTOS com sensor RALT selecionado;
            -- CCRP Submodo A/G CCRP;
            -- CCIP Submodo A/G CCIP;
            -- CCIP R Submodo A/G CCIP com sensor RALT selecionado;
            -- MAN Submodo A/G MAN;
            -- GUN Submodo A/G GUN (STRAF e MAN);
            -- GUN R Submodo A/G GUN com sensor RALT selecionado (STRAF e MAN);
            -- SJ Modo de alijamento seletivo, selecionado no formato SMS do CMFD;
            -- EJ Modo de alijamento em emergência, selecionado pressionando-se o Botão SALVO;
            -- MARK Função MARK selecionada no formato MARK;
            -- MARK R Função MARK selecionada no formato MARK, com o RALT funcionando;
            -- FIX Função FIX selecionada no formato FIX;
            -- FIX R Função FIX selecionada no formato FIX, com o RALT funcionando;
            -- ACAL Função ACAL selecionada no formato ACAL.
    -- 23. “G” máximo/DXDY/MBAL (Maximum G, DXDY, MBAL) Janela 6
        -- Apresenta a carga “g” positiva máxima registrada com precisão decimal, durante uma missão. Está diretamente relacionado com a indicação presente no campo “G” atual.
        -- É apresentado em todos os modos, mas no modo A/G pode ser substituído pela informação DXDY ou MBAL programado no formato BAL do UFCP. Também no submodo NAV LANDING, este campo não é apresentado quando a aeronave estiver voando.
        -- A indicação deste campo é restaurada em 1 “g” quando o MDP for ligado ou quando a tecla WARN RST do UFCP for pressionada sem que haja mensagem de alerta sendo apresentada na janela 10.
        -- No modo principal A/G, esta janela apresenta as informações de acordo com a seguinte lógica:
            -- DXDY Quando a função BAL for ativada no formato BAL do UFCP;
            -- MBAL Quando a função MBAL for ativada no formato BAL do UFCP;
            -- MAXG Quando as funções BAL e MBAL estiverem desativadas.
    -- 24. AOA atual (AOA) Janela 7
        -- Este campo apresenta o ângulo de ataque que a aeronave está voando no momento, podendo medir ângulos de –9 até 40.
        -- Quando o dado de AOA for inválido, apresenta “XX”.
    -- 25. Número Mach (Mach Number) Janela 5
        -- Apresenta o número Mach que a aeronave está voando no momento, com precisão centesimal.
        -- Quando o número Mach for inválido, este campo apresenta “X.XX”.
        -- Este campo é apresentado em todos os modos, mas no submodo NAV LANDING, ele aparece somente quando a aeronave estiver no solo.
    -- 26. Tipo de velocidade (Velocity Scale Type) Janela 3
        -- O tipo de velocidade que se está utilizando no momento é representado no HUD por meio de uma letra identificadora, selecionada através da tecla AIR SPD do UFCP ou, automaticamente, em função do submodo em operação.
        -- Os tipos de velocidade apresentados no HUD junto à escala ou ao valor numérico da velocidade são:
            -- C Velocidade calibrada;
            -- T Velocidade verdadeira;
            -- G Velocidade no solo.
        -- Quando o tipo de velocidade T ou G estiver sendo apresentado e o submodo NAV LANDING A/A INT, ou A/A DGFT for selecionado, o sistema passa automaticamente para tipo C. Caso esteja operando em um desses submodos, a seleção do tipo de velocidade fica desabilitada. Ao sair destes submodos, a seleção anterior é recuperada automaticamente.
    -- 27. Indicador de velocidade de referência (Velocity Guidance Cue)
        -- O indicador de velocidade de referência é representado pelo ponteiro “<”, localizado à direita da escala de velocidade. Esse ponteiro desloca-se em função da velocidade calculada para sobrevoar o ponto FYT na hora estimada de sobrevôo (ETA) ou de acordo com o tempo delta (DT) previsto, quando estas funções estiverem selecionadas no subformato NAV MODE do UFCP.
        -- Também pode indicar a velocidade calculada quando a função CRUS estiver ativada no formato CRUS do UFCP.
        -- O ponteiro indica a velocidade no solo calculada necessária para atingir o FYT na hora estimada. Se a velocidade selecionada for calibrada (C) ou verdadeira (T), o ponteiro apresenta a velocidade correspondente à velocidade no solo calculada.
        -- Quando o ponteiro coincide com a marca do índice fixo, a velocidade da aeronave coincide com o valor desejado para sobrevoar o ponto FYT na hora estimada.
        -- Quando a velocidade calculada para sobrevoar o ponto FYT na hora estimada for maior que a velocidade máxima da escala, o ponteiro aparece acima do traço superior e a velocidade desejada é apresentada na forma digital à sua direita.
        -- Quando a velocidade calculada para sobrevoar o ponto FYT na hora estimada for menor que a velocidade mínima da escala, o ponteiro aparece abaixo do traço inferior, sem aindicação digital.
        -- O ponteiro de velocidade aparece em todos os submodos de operação da aeronave, exceto no submodo NAV LANDING ou se o seu valor não for válido.
    -- 28. Escala de velocidade (Velocity Scale) Janela 3
        -- A escala de velocidade apresentada no HUD é composta de traços curtos a cada incremento de 5 kt e traços longos a cada incremento de 20 kt. Cada traço longo é acompanhado de um número com dois dígitos representando as dezenas de kt (24 representa 240 kt). A referência para identificação da velocidade da aeronave é um índice fixo (traço longo na parte interna), sobre o qual fica posicionada a letra identificadora do tipo de velocidade (C, G, T).
        -- A escala é apresentada quando as funções VV/VAH e VAH estiverem selecionadas e se movimenta na direção vertical em função da aceleração e desaceleração. Quando a velocidade não for válida, a escala desaparece.
    -- 29. “G” Atual  (Normal Acceleration) Janela 2
        -- Este campo é apresentado em todos os modos de operação da aeronave. Indica com precisão decimal, a carga “g” que a aeronave está sendo submetida no momento.
        -- Se a aceleração normal for inválida, indica XX.
    -- 4. Barras do ILS (ILS Deviation Steering) 
        -- As barras do ILS aparecem no modo principal NAV quando a freqüência de ILS estiver selecionada no formato NAV AIDS no UFCP e o modo de apresentação ILS estiver selecionado no formato ADHSI do CMFD.
        -- Este símbolo é composto de uma barra vertical que indica o desvio lateral, em relação ao localizador, e uma barra horizontal que indica o desvio vertical em relação à rampa de planeio.
        -- Essas barras são posicionadas no HUD em relação ao FPM e não aparecem quando os dados de ILS forem inválidos. 
        -- As informações de ILS são apresentadas também no formato ADHSI do CMFD pelas referências de ILS.
    -- 5. Diretor de vôo do ILS (ILS FD Symbol)
        -- O diretor de vôo é um símbolo que aparece no modo principal NAV, quando a freqüência de ILS estiver selecionada no formato NAV AIDS no UFCP, o modo de apresentação ILS estiver selecionado no formato ADHSI do CMFD e os dados de curso do ILS forem válidos. Esse símbolo consiste em uma circunferência pequena (􀁻) e um traço que se estende para cima quando a aeronave estiver na rampa ideal.
        -- O diretor de vôo fornece a ordem de pilotagem para que a aeronave se encaixe e mantenha o eixo da rampa do ILS, o que é feito levando-se o FPM para o indicador do diretor de vôo.
        -- A posição do símbolo em relação ao FPM indica a inclinação necessária para interceptar e manter-se no localizador do ILS.
        -- Se a aeronave desviar-se do eixo do ILS (0,8° da rampa de planeio ou 3,6° do localizador) um “X” emoldurado aparece no topo do traço vertical do símbolo e o diretor de vôo passa a fornecer somente ordem de pilotagem de azimute e se desloca para o horizonte. Para remover o “X”, é necessário interceptaro eixo ou selecionar novamente o modo de apresentação ILS no formato ADHSI.
        -- Quando o diretor de vôo estiver além do limite do campo de visada do HUD, um pequeno ”X” aparece no centro do círculo.
        -- Se o diretor de vôo do AFDS (= =) estiver selecionado, o diretor de vôo do ILS fica desabilitado e o seu símbolo (􀁻) não é apresentado no HUD.

end

function post_initialize()
    startup_print("hud: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end
    startup_print("hud: postinit end")
end

-- dev:listen_command(device_commands.IcePropeller)
-- dev:listen_command(device_commands.IceWindshield)
-- dev:listen_command(device_commands.IcePitotPri)
-- dev:listen_command(device_commands.IcePitotSec)

function SetCommand(command,value)
    debug_message_to_user("environ: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.EngineStart then
    elseif command == iCommandEnginesStart then
    elseif command == iCommandEnginesStop then
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    end
end


startup_print("environ: load end")
need_to_be_closed = false -- close lua state after initialization


