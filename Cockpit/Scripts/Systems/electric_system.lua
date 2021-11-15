dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/engine_api.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")

--dofile(LockOn_Options.script_path.."utils.lua")

-- 50%ng GCU abre o CPM (contactor de partida do motor)

-- Barras DC
--      Barra Principal DC
--      Barra Quente
--      Barra Quente Reserva
--      Barra Reserva 1
--      Barra Reserva 2
--      Barra Emergência Reserva
--      Barra Emergência DC
--      Barra Principal DC Avionics Master
--      Barra Emergência DC Avionics Master
-- Elemento com maior tensao irá fornecer. Normalmente 28V do gerador
-- Barras quentes estão sempre ligadas a uma bateria, mesmo sem gerador, barras de emergência podem ser conectadas à bateria quando sem gerador

-- Alimentação Externa
--      Conecta na barra principal DC quando EXT PWR ON
--      Quando conectada tem prioridade
--      Deve ter 28.5V e 1200A a 15V e 400A a 28,5V contínuo

-- Avionics master
--      Barra principal Avionics Master, Barra Emergência Avionics Master e interruptor Avionics Master
--      Isola eqp nav e com durante a partida



-- batteries
-- CPM2 -> bateria interna
-- caso de falha pode alimentar a aeronave por 30 minutos
-- Bateria desligada o descarregando -> ERRO BATTERY, CAUTION sound, CAUT flash
-- monitoramento de temperatura > 76oC WARN BAT TEMP, WARN soiund, WARN flash, WARN HUD
-- BAT TEMP -> piloto deve colocar em off (não carregar)
-- verificar tensão da bateria antes da partida com a chave em on
-- se menor que 22V, remover para manutenção
-- bateria reserva alimenta a barra quente reserva e é carreada pela barra principal dc
-- durante a partida, a bat reserva provê alimentação para barra quente reserva, barra reserva 1, barra reserva 2 e barra de emergência reserva
-- em caso de emergência, auto ou manual, a bat reserva alimenta apenas barra quente reserva e barra de emergência reserva
--      nesse caso não é carregada e alimenta por até 2h: BFI (basic flight instrument) BFI traseiro, GPS, Iluminação e Bússola Magnética


startup_print("electric_system: load")

local electric_system = GetSelf()
local dev = electric_system

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()


local bat_pcp_v=28             -- main battery voltage
local bat_pcp_vmin=22          -- main battery minimum voltage
local bat_pcp_a=0              -- main battery curent
local bat_pcp_res=0            -- main battery resistance
local bat_pcp_ah=56            -- main battery capacity
local bat_pcp_t=25             -- main battery temperature
local bat_pcp_prot = false     -- main baterry protection

local bat_res_v=24             -- reserve battery voltage
local bat_res_a=0              -- reserve battery current
local bat_res_res=0            -- reserve battery resistance
local bat_res_ah=11            -- reserve battery capacity

-- CPM1 -> fonte externa
local ext_pwr_on = false
local ext_on = false
local ext_v = 0
local ext_vnom = 28.5


-- gcu generator control unit
-- Gerador inadequadamente fora da barra -> ERRO GEN, CAUTION sound, CAUT flash
-- Gerador -> off/reset reinicia os circuitos de proteção do gerador
-- Falha no gerador, EDS liga bateria para alimentar cargas para pouso automaticamente
local gen_on = false
local gen_v = 0
local gen_vnom = 30
local gen_amax=400

local mdp_warmup_delay = 28
local avoinics_master_on_delay = 2
local mdp_switch_delay = 2

-- Contactoras
local contact_cfe = false
local contact_clg = false
local contact_cpm1 = false
local contact_cpm2 = false
local contact_cb = false
local contact_cbe1 = false
local contact_cbe2 = false


-- Disjuntores
local disj_bat_res = true
local disj_bat_res_amax = 5000

local disj_avi_mst_bar_pcp_dc = true
local disj_avi_mst_bar_pcp_dc_amax = 5000

local disj_avi_mst_bar_emer_dc = true
local disj_avi_mst_bar_emer_dc_amax = 5000

local disj_res1 = true
local disj_res1_amax = 5000

local disj_res2 = true
local disj_res2_amax = 5000

local disj_emer_res = true
local disj_emer_res_amax = 5000

-- Fusíveis
local fuse_cbe1 = true
local fuse_cbe1_amax = 5000

local fuse_cbe2 = true
local fuse_cbe2_amax = 5000


-- Chaves
local sw_rbr = false
local sw_ar_solo = false
local sw_avi_mst = false


-- Barras
local bar_pcp_dc_v = 0
local bar_pcp_dc_a = 0
local bar_pcp_dc_res = 0

local bar_hot_v = 0
local bar_hot_a = 0
local bar_hot_res = 0

local bar_hot_res_v = 0
local bar_hot_res_a = 0
local bar_hot_res_res = 0

local bar_emer_dc_v = 0
local bar_emer_dc_a = 0
local bar_emer_dc_res = 0

local bar_res1_v = 0
local bar_res1_a = 0
local bar_res1_res = 0

local bar_res2_v = 0
local bar_res2_a = 0
local bar_res2_res = 0

local bar_emer_res_v = 0
local bar_emer_res_a = 0
local bar_emer_res_res = 0

local bar_avi_mst_pcp_dc_v = 0
local bar_avi_mst_pcp_dc_a = 0
local bar_avi_mst_pcp_dc_res = 0

local bar_avi_mst_emer_dc_v = 0
local bar_avi_mst_emer_dc_a = 0
local bar_avi_mst_emer_dc_res = 0

-- controls
local ctl_sw_ext_pwr_on = false

local battery_caution = 0
local gen_caution = 0

local elec_avionics_emergency_warm_up_until = 0
local elec_avionics_warm_up_until = 0

function update()
    if get_batt_on() or
    (get_generator_on() and get_engine_on())  then -- Generator On and Engine On
        elec_main_bar_ok:set(((sensor_data.getWOW_LeftMainLandingGear() > 0 or get_engine_on()) and not get_emer_ovrd()) and 1 or 0)
        if elec_emergency_ok:get() == 0 then set_caution(CAUTION_ID.EMER_BUS,0) end
        elec_emergency_ok:set(1)
        
        if get_batt_on() and get_cockpit_draw_argument_value(964) == 1 then 
            elec_emergency_reserve_ok:set(1) 
        else 
            elec_emergency_reserve_ok:set(0) 
        end

        local mdp = elec_avionics_master_mdp:get()
        if mdp == 0 and get_mdp1_on() then
            elec_avionics_master_mdp:set(1)
        elseif mdp == 0 and get_mdp2_on() then
            elec_avionics_master_mdp:set(2)
        elseif (mdp == 1 and not get_mdp1_on()) or (mdp == 2 and not get_mdp2_on()) then
            elec_avionics_master_mdp:set(0)
    
            -- Load backup MDP in two seconds, if available
            if get_mdp1_on() or get_mdp2_on() then
                if get_mdp1_on() then
                    elec_avionics_master_mdp:set(1)
                elseif get_mdp2_on() then
                    elec_avionics_master_mdp:set(2)
                end

                elec_avionics_emergency_ok:set(0)
                elec_avionics_ok:set(0)
                elec_avionics_emergency_warm_up_until = get_absolute_model_time() + mdp_switch_delay
                elec_avionics_warm_up_until = get_absolute_model_time() + mdp_switch_delay
            end
        end

        if elec_avionics_ok:get() == 0 then
            if get_avionics_on() and elec_avionics_master_mdp:get() > 0 and get_elec_main_bar_ok() and (sensor_data.getWOW_LeftMainLandingGear() > 0 or get_engine_on()) then
                if elec_avionics_warm_up_until == -1 then
                    -- Start warm up
                    elec_avionics_warm_up_until = get_absolute_model_time() + avoinics_master_on_delay
                    --elec_avionics_emergency_ok:set(1)
                elseif get_absolute_model_time() >= elec_avionics_warm_up_until and get_absolute_model_time() >= elec_avionics_emergency_warm_up_until then
                    -- End warm up
                    elec_avionics_ok:set(1)
                    elec_avionics_warm_up_until = -1.0
                else
                    -- Continue warm up
                end
            else
                elec_avionics_ok:set(0)
                if elec_avionics_warm_up_until > 0 then
                    elec_avionics_warm_up_until = -1.0
                end
            end
        else
            if get_avionics_on() and elec_avionics_master_mdp:get() > 0 and get_elec_main_bar_ok() and (sensor_data.getWOW_LeftMainLandingGear() > 0 or get_engine_on()) then

            else
                elec_avionics_ok:set(0)
                elec_avionics_warm_up_until = -1.0
            end
        end

        if elec_avionics_emergency_ok:get() == 0 then
            -- Take 28 seconds to turn it on
            if elec_avionics_master_mdp:get() > 0 and get_elec_emergency_ok() then
                if elec_avionics_emergency_warm_up_until == -1 then
                    -- Start warm up
                    elec_avionics_emergency_warm_up_until = get_absolute_model_time() + mdp_warmup_delay
                    --elec_avionics_emergency_ok:set(1)
                elseif get_absolute_model_time() >= elec_avionics_emergency_warm_up_until then
                    -- End warm up
                    elec_avionics_emergency_ok:set(1)
                    elec_avionics_emergency_warm_up_until = -1.0
                else
                    -- Continue warm up
                end
            else
                elec_avionics_emergency_ok:set(0)
                if elec_avionics_emergency_warm_up_until > 0 then
                    elec_avionics_emergency_warm_up_until = -1.0
                end
            end
        else
            if elec_avionics_master_mdp:get() > 0 and get_elec_emergency_ok() then

            else
                elec_avionics_emergency_ok:set(0)
                elec_avionics_emergency_warm_up_until = -1.0
            end 
        end
        
    else
        elec_main_bar_ok:set(0)
        elec_avionics_ok:set(0)
        elec_avionics_emergency_ok:set(0)
        if elec_emergency_ok:get() == 1 then set_caution(CAUTION_ID.EMER_BUS,1) end
        elec_emergency_ok:set(0)
        if sensor_data.getWOW_LeftMainLandingGear() > 0 then  elec_emergency_reserve_ok:set(0) end
    end
    if sensor_data.getWOW_LeftMainLandingGear() == 0 then
        elec_emergency_reserve_ok:set(1)
    end

    if not get_batt_on() and battery_caution == 0 then
        set_caution(CAUTION_ID.BATTERY, 1)
        battery_caution = 1
    elseif get_batt_on() and battery_caution == 1 then
        set_caution(CAUTION_ID.BATTERY, 0)
        battery_caution = 0
    end

    -- Engine is running but generator switch is off
    if get_engine_on() and not get_generator_on() and gen_caution == 0 then
        set_caution(CAUTION_ID.GEN, 1)
        gen_caution = 1
    -- Engine is running and generator switch is on
    elseif get_engine_on() and get_generator_on() and gen_caution == 1 then
        set_caution(CAUTION_ID.GEN, 0)
        gen_caution = 0
    -- Engine is not running and aircraft is airborne
    elseif not get_engine_on() and sensor_data.getWOW_LeftMainLandingGear() == 0 then
        set_caution(CAUTION_ID.GEN, 1)
        gen_caution = 1
    -- Engine is not running and aircraft is on the ground
    elseif not get_engine_on() and sensor_data.getWOW_LeftMainLandingGear() > 0 then
        set_caution(CAUTION_ID.GEN, 0)
        gen_caution = 0
    end

    if get_acft_intc_on() and get_engine_on() and get_generator_on() and get_batt_on() and not get_ext_pwr_on() then
        set_advice(ADVICE_ID.INTC_ON, 1)
    else
        set_advice(ADVICE_ID.INTC_ON, 0)
    end

    -- update_electrical()
end

electric_system:listen_command(315) -- iCommandPowerBattery1

electric_system:listen_command(706) -- iCommandPowerBattery1
electric_system:listen_command(707) -- iCommandPowerBattery1Cover
electric_system:listen_command(708) -- iCommandPowerBattery2
electric_system:listen_command(709) -- iCommandPowerBattery1Cover
electric_system:listen_command(710) -- iCommandPowerBattery1Cover
electric_system:listen_command(711) -- iCommandPowerBattery1Cover
electric_system:listen_command(712) -- iCommandPowerBattery1Cover
electric_system:listen_command(713) -- iCommandPowerBattery1Cover

electric_system:listen_command(1071) -- iCommandPowerBattery1Cover
electric_system:listen_command(1072) -- iCommandPowerBattery1Cover
electric_system:listen_command(1073) -- iCommandPowerBattery1Cover
electric_system:listen_command(1074) -- iCommandPowerBattery1Cover
electric_system:listen_command(1075) -- iCommandPowerBattery1Cover
electric_system:listen_command(1076) -- iCommandPowerBattery1Cover


function post_initialize()
    startup_print("electric_system: postinit start")
    --update_electrical()

    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.ElecBatt, 0, true)
        dev:performClickableAction(device_commands.AviMst, 1, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.ElecBatt, -1, true)
        dev:performClickableAction(device_commands.AviMst, 0, true)
        elec_avionics_emergency_warm_up_until = -1.0
        elec_avionics_warm_up_until = -1.0
    end

    dev:performClickableAction(device_commands.ElecExtPwr, 0, true)
    dev:performClickableAction(device_commands.ElecEmer, -1, true)
    dev:performClickableAction(device_commands.ElecAcftIntc, -1, true)
    dev:performClickableAction(device_commands.AviVuhf, 0, true)

    dev:performClickableAction(device_commands.AviMdp1, 1, true)
    dev:performClickableAction(device_commands.AviMdp2, 1, true)
    dev:performClickableAction(device_commands.ElecBkp, 1, true)
    dev:performClickableAction(device_commands.AviSms, 1, true)
    dev:performClickableAction(device_commands.ElecGen, 1, true)
    startup_print("electric_system: postinit end")
end


dev:listen_command(Keys.BatteryPower)
dev:listen_command(Keys.PowerGeneratorLeft)
dev:listen_command(Keys.PowerGeneratorRight)  -- No 2nd generator on A-29B

dev:listen_command(device_commands.ElecBatt)
dev:listen_command(device_commands.ElecGen)
dev:listen_command(device_commands.ElecExtPwr)
dev:listen_command(device_commands.ElecBkp)
dev:listen_command(device_commands.ElecEmer)
dev:listen_command(device_commands.ElecAcftIntc)
dev:listen_command(device_commands.AviMdp1)
dev:listen_command(device_commands.AviMdp2)
dev:listen_command(device_commands.AviMst)
dev:listen_command(device_commands.AviSms)
dev:listen_command(device_commands.AviVuhf)
dev:listen_command(Keys.AviMdp1)
dev:listen_command(Keys.AviMdp2)
dev:listen_command(Keys.AviMst)
dev:listen_command(Keys.AviSms)
dev:listen_command(Keys.AviVuhf)
dev:listen_command(Keys.ElecBatt)
dev:listen_command(Keys.ElecGen)
dev:listen_command(Keys.ElecExtPwr)
dev:listen_command(Keys.ElecBkp)
dev:listen_command(Keys.ElecEmer)
dev:listen_command(Keys.ElecAcftIntc)


function SetCommand(command,value)
    --debug_message_to_user("electric_system: command "..tostring(command).." = "..tostring(value))
    if command == device_commands.ElecBatt then
        if value==0 then
            dev:DC_Battery_on(true)
        elseif value == -1 then 
            dev:DC_Battery_on(false)
        end
    elseif command == device_commands.ElecGen then
        if value==1 then
            electric_system:AC_Generator_1_on(true)
        else
            electric_system:AC_Generator_1_on(false)
        end
    elseif command == Keys.PowerGeneratorLeft then
        if value==1 then
            electric_system:AC_Generator_1_on(true)
        else
            electric_system:AC_Generator_1_on(false)
        end
    elseif command == Keys.BatteryPower then
        if value==0 then
            dev:DC_Battery_on(true)
        elseif value == -1 then 
            dev:DC_Battery_on(false)
        end
    elseif command == Keys.AviMdp1 then
        dev:performClickableAction(device_commands.AviMdp1, (get_cockpit_draw_argument_value(841) + 1) % 2)
    elseif command == Keys.AviMdp2 then
        dev:performClickableAction(device_commands.AviMdp2, (get_cockpit_draw_argument_value(842) + 1) % 2)
    elseif command == Keys.AviMst then
        dev:performClickableAction(device_commands.AviMst, (get_cockpit_draw_argument_value(843) + 1) % 2)
    elseif command == Keys.AviSms then
        dev:performClickableAction(device_commands.AviSms, (get_cockpit_draw_argument_value(844) + 1) % 2)
    elseif command == Keys.AviVuhf then
        dev:performClickableAction(device_commands.AviVuhf, (get_cockpit_draw_argument_value(845) + 1) % 2)
    elseif command == Keys.ElecBatt then
        dev:performClickableAction(device_commands.ElecBatt, get_cockpit_draw_argument_value(961) == 0 and -1 or 0)
    elseif command == Keys.ElecGen then
        dev:performClickableAction(device_commands.ElecGen, (get_cockpit_draw_argument_value(962) + 1) % 2)
    elseif command == Keys.ElecExtPwr then
        dev:performClickableAction(device_commands.ElecExtPwr, (get_cockpit_draw_argument_value(963) + 1) % 2)
    elseif command == Keys.ElecBkp then
        dev:performClickableAction(device_commands.ElecBkp, (get_cockpit_draw_argument_value(964) + 1) % 2)
    elseif command == Keys.ElecEmer then
        dev:performClickableAction(device_commands.ElecEmer, get_cockpit_draw_argument_value(965) == 1 and -1 or 1)
    elseif command == Keys.ElecAcftIntc then
        dev:performClickableAction(device_commands.ElecAcftIntc, get_cockpit_draw_argument_value(966) == 1 and -1 or 1)
    end
end

-- function update_electrical()
--     -- update contactors
--     if (not contact_cfe) and ctl_sw_ext_pwr_on and (ext_v >= ext_vnom) then 
--         if contact_clg then
--             print_message_to_user("Gen Desconectado!")
--             contact_clg = false
--         end
--         print_message_to_user("GPU Conectada!")
--         contact_cfe = true 
--         bar_pcp_dc_v = ext_v
--     elseif contact_cfe and ((not ctl_sw_ext_pwr_on) or (ext_v < ext_vnom)) then
--         print_message_to_user("GPU Desconectada!")
--         contact_cfe = false
--         bar_pcp_dc_v = 0 
--     end

--     if (not contact_clg) and (not contact_cfe) and (gen_v > bar_pcp_dc_v) then
--         print_message_to_user("Gen Conectado!")
--         contact_clg=true
--         if contact_cb then print_message_to_user("Bateria Principal Carregando!") end
--         if disj_bat_res then print_message_to_user("Bateria Reserva Carregando!") end
--         bar_pcp_dc_v = gen_v
--     elseif contact_clg and ((contact_cb and (gen_v < bar_hot_v)) or (disj_bat_res and (gen_v < bat_res_v))) then 
--         print_message_to_user("Gen Desconectado!")
--         contact_clg=false
--         bar_pcp_dc_v = 0 
--     end


--     if bat_pcp_prot and sw_bat_reset then
--         print_message_to_user("Proteção Bateria Principal Reiniciada!")
--         bat_pcp_prot = false 
--     end

--     if contact_clg and (not ctl_gen_on) then
--         print_message_to_user("Gen Desconectado!")
--         contact_clg = false
--     end

--     if contact_cb and (not ctl_sw_bat_on) then
--         print_message_to_user("Bateria Principal Desconectada!")
--         contact_cb = false 
--     end

--     if ctl_sw_bat_on and contact_cb and (bat_pcp_v > bar_pcp_dc_v) then
--         print_message_to_user("Bateria Principal Conectada e Descarregando!")
--         bar_pcp_dc_v=bat_pcp_v
--     elseif ctl_sw_bat_on and (not contact_cb) and (not bat_pcp_prot) then
--         print_message_to_user("Bateria Principal Conectada!")
--         contact_cb = true
--     end


--     --update Disjuntores
--     if disj_bat_res and bat_res_v > bar_pcp_dc_v and bar_pcp_dc_a > disj_bat_res_amax then 
--         print_message_to_user("Disj Bateria Reserva Aberto!")
--         disj_bat_res = false 
--     end
--     if disj_res1 and sw_rbr and bar_res1_a > disj_res1_amax then 
--         print_message_to_user("Disj Barra Reserva 1 Aberto!")
--         disj_res1 =  false 
--     end
--     if disj_res2 and sw_rbr and bar_res2_a > disj_res2_amax then 
--         print_message_to_user("Disj Barra Reserva 2 Aberto!")
--         disj_res2 =  false 
--     end
--     if disj_emer_res and (sw_rbr or sw_ar_solo) and bar_emer_res_a > disj_emer_res_amax then 
--         print_message_to_user("Disj Barra Emergência Reserva Aberto!")
--         disj_emer_res = false 
--     end
--     if disj_avi_mst_bar_pcp_dc and sw_avi_mst and bar_avi_mst_pcp_dc_a > disj_avi_mst_bar_pcp_dc_amax then 
--         print_message_to_user("Disj Barra Avionics Master Principal DC Aberto!")
--         disj_avi_mst_bar_pcp_dc =  false 
--     end
--     if disj_avi_mst_bar_emer_dc and sw_avi_mst and bar_avi_mst_emer_dc_a > disj_avi_mst_bar_emer_dc_amax then 
--         print_message_to_user("Disj Barra Avionics Master Emergência DC Aberto!")
--         disj_avi_mst_bar_emer_dc =  false
--      end

--     --update fuses
--     if fuse_cbe1 and contact_cbe1 and bar_emer_dc_a > fuse_cbe1_amax then
--         print_message_to_user("Fuse Contactor Barra Emergência 1 Quimado!")
--         fuse_cbe1 = false 
--     end
--     if fuse_cbe2 and contact_cbe2 and bar_emer_dc_a > fuse_cbe2_amax then 
--         print_message_to_user("Fuse Contactor Barra Emergência 2 Quimado!")
--         fuse_cbe2 = false 
--     end

--     --update currents
--     bat_res_a = bar_hot_res_a + (bar_pcp_dc_v > bat_res_v) ? bar_pcp_dc_a : 0
--     bar_hot_res_a = (disj_res1 and sw_rbr)?bar_res1_a:0 + (disj_res2 and sw_rbr)?bar_res2_a:0 + ((disj_emer_res and sw_rbr) or sw_ar_solo)?bar_emer_res_a:0
--     bar_emer_dc_a = (sw_avi_mst and disj_avi_mst_bar_emer_dc) ? bar_avi_mst_emer_dc_a : 0


--     -- update bar_hot
--     bar_hot_v = bat_pcp_v - bat_pcp_a * bat_pcp_res          
    
--     -- update bar_hot_res
--     bar_hot_res_v = bat_res_v - bat_res_a * bat_res_res

--     -- update bar_res1
--     if disj_res1 and sw_rbr then
--         bar_res1_v = bar_hot_res_v - bar_hot_res_a * bar_hot_res_res
--     else
--         bar_res1_v = 0
--     end

--     -- update bar_res2
--     if disj_res2 and sw_rbr then
--         bar_res2_v = bar_hot_res_v - bar_hot_res_a * bar_hot_res_res
--     else
--         bar_res2_v = 0
--     end

--     -- update bar_emer_res
--     if (disj_emer_res and sw_rbr) or sw_ar_solo then
--         bar_emer_res_v = bar_hot_res_v - bar_hot_res_a * bar_hot_res_res
--     else
--         bar_emer_res_v = 0
--     end

--     -- update bar_avi_mst_emer_dc
--     if disj_avi_mst_bar_emer_dc and sw_avi_mst then
--         bar_avi_mst_emer_dc_v = bar_emer_dc_v - bar_emer_dc_a * bar_emer_dc_res
--     else
--         bar_emer_res_v = 0
--     end

--     -- update bar_avi_mst_emer_dc
--     if disj_avi_mst_bar_pcp_dc and sw_avi_mst then
--         bar_avi_mst_pcp_dc_v = bar_pcp_dc_v - bar_pcp_dc_a * bar_emer_dc_res
--     else
--         bar_emer_res_v = 0
--     end
    
    
-- end


startup_print("electric_system: load end")
need_to_be_closed = false -- close lua state after initialization



-- function update_elec_state()
--     -- External power switch is located on outside of aircraft, not in cockpit
--     --local external_power_connected=(get_aircraft_draw_argument_value(402)==1) -- pretend we have external power when huffer is shown (TODO: AC electric mobile power plant, see Fig 1-49 of NATOPS)
--     local external_power_connected=get_elec_external_power()
--     if true --[[(electric_system:get_AC_Bus_1_voltage() ~= prev_ac_volts) or (prev_emerg_gen ~= emergency_generator_deployed)--]] then
--         if electric_system:get_AC_Bus_1_voltage() > 0 and ((not emergency_generator_deployed) or (emergency_generator_deployed and emergency_generator_bypass)) then
--             -- main generator on
--             elec_primary_ac_ok:set(1)
--             elec_primary_dc_ok:set(1)
--             elec_26V_ac_ok:set(1)
--             elec_mon_primary_ac_ok:set(1)
--             elec_aft_mon_ac_ok:set(1)
--             elec_fwd_mon_ac_ok:set(1)
--             elec_mon_dc_ok:set(1)
--             elec_mon_arms_dc_ok:set(master_arm and 1 or 0)
--             --elec_external_power:set(0)
--         else
--             -- main generator off or disconnected by emergency generator
--             if emergency_generator_deployed and (not emergency_generator_bypass) and (not external_power_connected) then
--                 local ias_knots = sensor_data.getIndicatedAirSpeed()*1.9438444924574
--                 -- simulate problems if IAS<120kts (NATOPS says emergency generator may supply insufficient power at lower than 120kts IAS)
--                 -- set these busses that should be 1 to 0 randomly (PWM style), with probability based on proximity to 120kts, i.e. if much slower than 120, good chance of failure
--                 -- the plane starts to stall and fall out of the sky around 100kts IAS anyway (and airspeed then stays around 100), so this effect is not very pronounced
--                 local onoff=1
--                 if (ias_knots < 120) then
--                     onoff = (math.random() < (ias_knots / 120.0)) and 1 or 0
--                 end
--                 elec_primary_ac_ok:set(onoff)
--                 elec_primary_dc_ok:set(onoff)
--                 elec_26V_ac_ok:set(onoff)
--                 elec_mon_primary_ac_ok:set(onoff)
--                 -- the following busses don't get power from emergency generator
--                 elec_aft_mon_ac_ok:set(0)
--                 elec_fwd_mon_ac_ok:set(0)
--                 elec_mon_dc_ok:set(0)
--                 elec_mon_arms_dc_ok:set(0)

--                 --elec_external_power:set(0)
--             else
--                 if external_power_connected then
--                     elec_primary_ac_ok:set(1)
--                     elec_primary_dc_ok:set(1)
--                     elec_26V_ac_ok:set(1)
--                     elec_mon_primary_ac_ok:set(1)
--                     elec_aft_mon_ac_ok:set(1)
--                     elec_fwd_mon_ac_ok:set(1)
--                     elec_mon_dc_ok:set(0)
--                     elec_mon_arms_dc_ok:set(0)
--                     --elec_external_power:set(1)
--                     if emergency_generator_deployed then
--                         emergency_generator_deployed = false -- pretend ground crew has reset RAT
--                         print_message_to_user("Ground crew reset emergency generator")
--                     end
--                 else
--                     -- no main generator, no backup generator, no external power... no power at all
--                     elec_primary_ac_ok:set(0)
--                     elec_primary_dc_ok:set(0)
--                     elec_26V_ac_ok:set(0)
--                     elec_mon_primary_ac_ok:set(0)
--                     elec_aft_mon_ac_ok:set(0)
--                     elec_fwd_mon_ac_ok:set(0)
--                     elec_mon_dc_ok:set(0)
--                     elec_mon_arms_dc_ok:set(0)

--                     --elec_external_power:set(0)
--                 end
--             end
--         end
--         elec_emergency_gen_active:set(emergency_generator_deployed and 1 or 0)
--         prev_ac_volts = electric_system:get_AC_Bus_1_voltage()
--         prev_emerg_gen = emergency_generator_deployed
--     end

--     local wow = sensor_data.getWOW_LeftMainLandingGear()
--     if wow > 0 then
--         elec_ground_mode:set(1)
--     else
--         elec_ground_mode:set(0)
--     end
-- end




--[[
gyrovague's notes&observations of avSimpleElectricSystem device:
This simple system provides two AC power sources and two DC power sources. It
seems like the two AC power sources are based on emulated generators connected
to the left and right engines, and the 2nd AC is always 0 for the A-4E (having no second engine...)
The AC voltage is either 115 or 0 (depending on 1 or 0 supplied to AC_Generator_x_on() as
well as corresponding engine RPM)

The first DC bus gives 28V if either of the AC sources is 115VAC, and 0 otherwise, so would
appear to emulate an AC-to-DC converter output. The second DC bus is indepedent of the
AC, and goes to 0 if DC_Battery_on(0) is called.

From DLL exports inspection, these are the methods support by avSimpleElectricSystem:
AC_Generator_1_on   <- pass true or false to this to enable or disable
AC_Generator_2_on   <- pass true or false to this to enable or disable
DC_Battery_on       <- pass true or false to this to enable or disable
get_AC_Bus_1_voltage  <- returns 115 if enabled (and left engine running), otherwise 0
get_AC_Bus_2_voltage  <- returns 115 if enabled (and right engine running), otherwise 0
get_DC_Bus_1_voltage  <- returns 28 if either AC bus has 115V, otherwise 0
get_DC_Bus_2_voltage  <- returns 28 if battery enabled, otherwise 0


potentially relevant standard base input commands:
iCommandPowerOnOff	315   -- the command dispatched by rshift-L in FC modules

iCommandGroundPowerDC	704
iCommandGroundPowerDC_Cover	705
iCommandPowerBattery1	706
iCommandPowerBattery1_Cover	707
iCommandPowerBattery2	708
iCommandPowerBattery2_Cover	709
iCommandGroundPowerAC	710
iCommandPowerGeneratorLeft	711
iCommandPowerGeneratorRight	712
iCommandElectricalPowerInverter	713

iCommandAPUGeneratorPower	1071
iCommandBatteryPower	1073
iCommandElectricalPowerInverterSTBY	1074
iCommandElectricalPowerInverterOFF	1075
iCommandElectricalPowerInverterTEST	1076
--]]