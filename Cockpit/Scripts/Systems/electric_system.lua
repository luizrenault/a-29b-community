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


local bat_pcp_v=24             -- main battery voltage
local bat_pcp_vmin=22          -- main battery minimum voltage
local bat_pcp_vmax=25          -- main battery maximum voltage
local bat_pcp_a=0              -- main battery curent
local bat_pcp_res=0            -- main battery resistance
local bat_pcp_ah=56            -- main battery capacity
local bat_pcp_t=25             -- main battery temperature
local bat_pcp_prot = false     -- main baterry protection
local bat_pcp_next_discharge = -1.0
local bat_pcp_next_recharge = -1.0

local bat_res_v=24             -- reserve battery voltage
local bat_res_vmax=24          -- reserve battery maximum voltage
local bat_res_vmin=22          -- reserve battery minimum voltage
local bat_res_a=0              -- reserve battery current
local bat_res_res=0            -- reserve battery resistance
local bat_res_ah=11            -- reserve battery capacity
local bat_res_next_discharge = -1.0
local bat_res_next_recharge = -1.0

-- CPM1 -> fonte externa
local ext_pwr_on = false
local ext_on = false
local ext_v = 28.5
local ext_vnom = 28.5


-- gcu generator control unit
-- Gerador inadequadamente fora da barra -> ERRO GEN, CAUTION sound, CAUT flash
-- Gerador -> off/reset reinicia os circuitos de proteção do gerador
-- Falha no gerador, EDS liga bateria para alimentar cargas para pouso automaticamente
local gen_on = false
local gen_v = 28
local gen_vnom = 30
local gen_amax=400

local mdp_warmup_delay = 28
local avoinics_master_on_delay = 2
local mdp_switch_delay = 2

-- Contactoras
local contact_cfe = false -- contactor de fonte externa
local contact_clg = false -- contactor do gerador
local contact_cpm1 = false -- contactor de partida do motor 1
local contact_cpm2 = false -- contactor de partida do motor 2
local contact_cb = false -- contactor de bateria
local contact_cbe1 = false -- contactor de barra de emergência 1
local contact_cbe2 = false -- contactor de barra de emergência 2
local contact_avi_mst = false -- contactor avionics master
local contact_avi_mst_emer = false -- contactor avionics master emergência


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


-- Relés
local relay_rbr = false -- relés de barra reserva


-- Barras
local bar_pcp_dc_v = 0
local bar_pcp_dc_vmin = 22
local bar_pcp_dc_a = 0
local bar_pcp_dc_res = 0

local bar_hot_v = 0
local bar_hot_vmin = 22
local bar_hot_a = 0
local bar_hot_res = 0

local bar_hot_res_v = 0
local bar_hot_res_vmin = 22
local bar_hot_res_a = 0
local bar_hot_res_res = 0

local bar_emer_dc_v = 0
local bar_emer_dc_vmin = 22
local bar_emer_dc_a = 0
local bar_emer_dc_res = 0

local bar_res1_v = 0
local bar_res1_vmin = 22
local bar_res1_a = 0
local bar_res1_res = 0

local bar_res2_v = 0
local bar_res2_vmin = 22
local bar_res2_a = 0
local bar_res2_res = 0

local bar_emer_res_v = 0
local bar_emer_res_vmin = 22
local bar_emer_res_a = 0
local bar_emer_res_res = 0

local bar_avi_mst_pcp_dc_v = 0
local bar_avi_mst_pcp_dc_vmin = 22
local bar_avi_mst_pcp_dc_a = 0
local bar_avi_mst_pcp_dc_res = 0

local bar_avi_mst_emer_dc_v = 0
local bar_avi_mst_emer_dc_vmin = 22
local bar_avi_mst_emer_dc_a = 0
local bar_avi_mst_emer_dc_res = 0

-- controls
local ctl_sw_ext_pwr_on = false

local emer_bus_caution = 0
local gen_caution = 0
local battery_caution = 0
local bkup_bat_caution = 0

local elec_avionics_emergency_warm_up_until = 0
local elec_avionics_warm_up_until = 0

local engine_starter=get_param_handle("ENGINE_STARTER") -- 1 or 0

function update()

    -- Reset the buses
    bar_pcp_dc_v = 0
    bar_hot_v = 0
    bar_hot_res_v = 0
    bar_emer_dc_v = 0
    bar_res1_v = 0
    bar_res2_v = 0
    bar_emer_res_v = 0
    bar_avi_mst_pcp_dc_v = 0
    bar_avi_mst_emer_dc_v = 0

    -- -- Systems checks

    -- TODO check if the external power is connected to the aircraft
    ext_on = true

    -- If engine is on, the generator is on
    -- TODO check if NG is above 50%
    if get_engine_on() and sensor_data.getEngineLeftRPM() >= 50 then
        gen_on = true
    else
        gen_on = false
    end

    -- Switches and contactors checks

    -- If external power is connected, the CFE is connected to the main bus
    if get_ext_pwr_on() and ext_on and sensor_data.getWOW_LeftMainLandingGear() > 0 then
        contact_cfe = true
    else
        contact_cfe = false
    end

    -- If the generator switch is on, the generator is on, the external power is disconnected and the CPM1 and CPM2 are disconnected, 
    -- the CLG is connected to the main bus
    if get_generator_on() and gen_on and not contact_cfe and not (contact_cpm1 or contact_cpm2) then
        contact_clg = true
    else
        contact_clg = false
    end

    -- Connect the main bus and emer bus if gen is on or aircraft is on the ground
    if contact_clg or sensor_data.getWOW_LeftMainLandingGear() > 0 then
        contact_cbe1 = true
        contact_cbe2 = false
    else
        contact_cbe1 = false
        contact_cbe2 = true
    end

    -- If battery switch is on and (generator is on and connected or aircraft is on the ground), the battery is connected to the main bus
    if get_batt_on() and (contact_clg or sensor_data.getWOW_LeftMainLandingGear() > 0) then
        contact_cb = true
    else
        contact_cb = false
    end

    -- If emer override switch is in EMER, the CBE2 is connected and CB and CBE1 are disconnected
    if get_emer_ovrd() then
        contact_cbe2 = true
        contact_cb = false
        contact_cbe1 = false
    else
        -- No effect
    end

    -- If backup battery switch is on, 
    if get_bkp_on() then
        -- If the aircraft is not on the ground, or the (battery is or the generator is on or external power is connected)
        if (sensor_data.getWOW_LeftMainLandingGear() == 0 or gen_on or get_batt_on() or contact_cfe) then
            relay_rbr = true
        else
            relay_rbr = false
        end
    else
        relay_rbr = false
    end

    -- If the avionics master switch is on, the avi_mst contactors are connected
    if get_avionics_on() then
        contact_avi_mst = true
        contact_avi_mst_emer = true
    else
        contact_avi_mst = false
        contact_avi_mst_emer = false
    end

    -- -- Power distribution

    -- Hot bus should have the same voltage as the main battery
    bar_hot_v = bat_pcp_v

    -- Hot reserve bus should have the same voltage as the reserve battery
    bar_hot_res_v = bat_res_v

    -- If external power is connected and CFE is connected, power up the main bus
    if ext_on and contact_cfe and bar_pcp_dc_v < ext_v then
        bar_pcp_dc_v = ext_v

    -- If the generator is on and the CLG is connected, power up the main bus
    elseif gen_on and contact_clg and bar_pcp_dc_v < gen_v then
        bar_pcp_dc_v = gen_v

    -- If the battery is connected, power up the main bus
    elseif contact_cb and bar_pcp_dc_v < bar_hot_v then
        bar_pcp_dc_v = bar_hot_v
    end

    -- If the relay is closed, power up the reserve buses
    if relay_rbr then
        bar_res1_v = bar_hot_res_v
        bar_res2_v = bar_hot_res_v
        bar_emer_res_v = bar_hot_res_v -- TODO there is something about air/ground in the manual?
    end

    -- If CBE1 is connected, power up the emergency bus from the main bus
    if contact_cbe1 and bar_pcp_dc_v > bar_emer_dc_v then
        bar_emer_dc_v = bar_pcp_dc_v
    end

    -- If CBE2 is connected, power up the emergency bus from the hot bus
    if contact_cbe2 and bar_hot_v > bar_emer_dc_v then
        bar_emer_dc_v = bar_hot_v 
    end

    -- If the avionics master contactor is connected, power up the avionics master bus
    if contact_avi_mst then
        bar_avi_mst_pcp_dc_v = bar_pcp_dc_v
    end

    -- If the avionics master emergency contactor is connected, power up the avionics master emergency bus
    if contact_avi_mst_emer then
        bar_avi_mst_emer_dc_v = bar_emer_dc_v
    end

    elec_emer_dc_v:set(bar_emer_dc_v)

    -- -- Drain or charge batteries

    -- Main bus is powered up and there is no generator or external power
    if not contact_clg and not contact_cfe and (bar_pcp_dc_v > 0 or bar_emer_dc_v > 0) then

        -- Drain the main battery, proportional to what's powered on
        -- TODO consider the actual systems that are powered on (Landing lights, etc)
        local bat_pcp_discharge_rate = 0.0
        if bar_pcp_dc_v > 0 then
            bat_pcp_discharge_rate = bat_pcp_discharge_rate + 0.5 / 600
        end
        if bar_emer_dc_v > 0 then
            bat_pcp_discharge_rate = bat_pcp_discharge_rate + 0.5 / 600
        end
        if bar_avi_mst_pcp_dc_v > 0 then
            bat_pcp_discharge_rate = bat_pcp_discharge_rate + 0.5 / 600
        end
        if bar_avi_mst_emer_dc_v > 0 then
            bat_pcp_discharge_rate = bat_pcp_discharge_rate + 0.5 / 600
        end
        if engine_starter:get() == 1 then
            bat_pcp_discharge_rate = bat_pcp_discharge_rate + 0.035
        end

        -- Discharge every 1 second
        if bat_pcp_next_discharge == -1.0 then
            bat_pcp_next_discharge = get_absolute_model_time() + 1
        elseif get_absolute_model_time() > bat_pcp_next_discharge then
            bat_pcp_next_discharge = get_absolute_model_time() + 1
            bat_pcp_v = math.max(bat_pcp_v - bat_pcp_discharge_rate, bat_pcp_vmin)
        end

    -- Main bus and emergency bus are disconnected, but the emer bus is powered up
    elseif not contact_cbe1 and bar_emer_dc_v > 0 then

        -- Drain the main battery, proportional to what's powered on
        -- TODO consider the actual systems that are powered on (Landing lights, etc)
        local bat_pcp_discharge_rate = 0.0
        if bar_emer_dc_v > 0 then
            bat_pcp_discharge_rate = bat_pcp_discharge_rate + 0.5 / 600
        end
        if bar_avi_mst_emer_dc_v > 0 then
            bat_pcp_discharge_rate = bat_pcp_discharge_rate + 0.5 / 600
        end

        -- Discharge every 1 second
        if bat_pcp_next_discharge == -1.0 then
            bat_pcp_next_discharge = get_absolute_model_time() + 1
        elseif get_absolute_model_time() > bat_pcp_next_discharge then
            bat_pcp_next_discharge = get_absolute_model_time() + 1
            bat_pcp_v = math.max(bat_pcp_v - bat_pcp_discharge_rate, bat_pcp_vmin)
        end

    -- External power is connected
    elseif contact_cfe then

        -- Don't discharge the main battery
        bat_pcp_next_discharge = -1.0

    -- Generator is on
    elseif contact_clg then

        -- Charge the main battery
        bat_pcp_v = math.min(bat_pcp_v + 0.01, bat_pcp_vmax)
        bat_pcp_next_discharge = -1.0
    end

    if bar_pcp_dc_v <= bar_pcp_dc_vmin and relay_rbr then

        local bat_res_discharge_rate = 1.0 / 3600

        -- Discharge every 1 second
        if bat_res_next_discharge == -1.0 then
            bat_res_next_discharge = get_absolute_model_time() + 1
        elseif get_absolute_model_time() > bat_res_next_discharge then
            bat_res_next_discharge = get_absolute_model_time() + 1
            bat_res_v = math.max(bat_res_v - bat_res_discharge_rate, bat_res_vmin)
        end
    elseif bar_pcp_dc_v > bar_pcp_dc_vmin then
        bat_res_next_discharge = -1.0
        bat_res_v = math.min(bat_res_v + 0.01, bat_res_vmax)
    end

    -- if the generator is off, the battery will go down from 24V to 21V in 30 minutes
    -- when the generator and engine come back on, the battery will recharge up to 24V

    -- -- Power up buses

    -- Check if the buses have the minimum voltage
    elec_main_bar_ok:set((bar_pcp_dc_v > bar_pcp_dc_vmin) and 1 or 0)
    elec_hot_ok:set((bar_hot_v > bar_hot_vmin) and 1 or 0)
    elec_hot_res_ok:set((bar_hot_res_v > bar_hot_res_vmin) and 1 or 0)
    elec_emergency_ok:set((bar_emer_dc_v > bar_emer_dc_vmin) and 1 or 0)
    elec_reserve1_ok:set((bar_res1_v > bar_res1_vmin) and 1 or 0)
    elec_reserve2_ok:set((bar_res2_v > bar_res2_vmin) and 1 or 0)
    elec_emergency_reserve_ok:set((bar_emer_res_v > bar_emer_res_vmin) and 1 or 0)
    elec_avionics_emergency_ok:set((bar_avi_mst_emer_dc_v > bar_avi_mst_emer_dc_vmin) and 1 or 0)

    -- Add a delay to turn on the avionics bus
    if elec_avionics_ok:get() == 0 and bar_avi_mst_pcp_dc_v > bar_avi_mst_pcp_dc_vmin then
        if elec_avionics_warm_up_until == -1 then
            elec_avionics_warm_up_until = get_absolute_model_time() + mdp_switch_delay
        elseif get_absolute_model_time() >= elec_avionics_warm_up_until then
            elec_avionics_ok:set((bar_avi_mst_pcp_dc_v > bar_avi_mst_pcp_dc_vmin) and 1 or 0)
            elec_avionics_warm_up_until = -1
        end
        
    else
        elec_avionics_ok:set((bar_avi_mst_pcp_dc_v > bar_avi_mst_pcp_dc_vmin) and 1 or 0)
    end

    -- -- Power up systems
    if elec_emergency_ok:get() == 1 or elec_avionics_ok:get() == 1 or elec_reserve1_ok:get() == 1 then
        -- MDPs are powered up

        local mdp = elec_avionics_master_mdp:get()
        if mdp == 0 and get_mdp1_on() then
            elec_avionics_master_mdp:set(1)
        elseif mdp == 0 and get_mdp2_on() then
            elec_avionics_master_mdp:set(2)
        elseif (mdp == 1 and not get_mdp1_on()) or (mdp == 2 and not get_mdp2_on()) then
            elec_avionics_master_mdp:set(0)
            elec_mdp_ok:set(0)
    
            -- Load backup MDP in two seconds, if available
            if get_mdp1_on() or get_mdp2_on() then
                if get_mdp1_on() then
                    elec_avionics_master_mdp:set(1)
                elseif get_mdp2_on() then
                    elec_avionics_master_mdp:set(2)
                end

                elec_avionics_emergency_warm_up_until = get_absolute_model_time() + mdp_switch_delay
                elec_avionics_warm_up_until = get_absolute_model_time() + mdp_switch_delay
            end
        end

        -- The MDPs are powered up, but they haven't started up yet
        if elec_mdp_ok:get() == 0 then

            -- Take 28 seconds to start up the mdps
            if elec_avionics_master_mdp:get() > 0 then
                
                if elec_avionics_emergency_warm_up_until == -1 then
                    -- Start warm up
                    elec_avionics_emergency_warm_up_until = get_absolute_model_time() + mdp_warmup_delay

                elseif get_absolute_model_time() >= elec_avionics_emergency_warm_up_until then
                    -- End warm up
                    elec_mdp_ok:set(1)
                    elec_avionics_emergency_warm_up_until = -1.0
                end
            else
                if elec_avionics_emergency_warm_up_until > 0 then
                    elec_avionics_emergency_warm_up_until = -1.0
                end
            end
        else
            if elec_avionics_master_mdp:get() == 0 then
                elec_mdp_ok:set(0)
                elec_avionics_emergency_warm_up_until = -1.0
            end 
        end
    else
        elec_mdp_ok:set(0)
        elec_avionics_emergency_warm_up_until = -1.0
    end 

    -- Battery is disconnected from the main bus
    if not contact_cb and battery_caution == 0 then
        set_caution(CAUTION_ID.BATTERY, 1)
        battery_caution = 1
    elseif contact_cb and battery_caution == 1 then
        set_caution(CAUTION_ID.BATTERY, 0)
        battery_caution = 0
    end

    -- Emergency bus is not powered
    if elec_emergency_ok:get() == 0 and emer_bus_caution == 0 then
        set_caution(CAUTION_ID.EMER_BUS, 1)
        emer_bus_caution = 1
    elseif elec_emergency_ok:get() == 1 and emer_bus_caution == 1 then
        set_caution(CAUTION_ID.EMER_BUS, 0)
        emer_bus_caution = 0
    end

    -- Engine is running but generator switch is off
    if not contact_clg and not contact_cfe and gen_caution == 0 and (sensor_data.getWOW_LeftMainLandingGear() == 0 or sensor_data.getEngineLeftRPM() > 50) then
        set_caution(CAUTION_ID.GEN, 1)
        gen_caution = 1
    elseif (contact_clg or contact_cfe) and gen_caution == 1 then
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
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.ElecBatt, -1, true)
        elec_avionics_emergency_warm_up_until = -1.0
        elec_avionics_warm_up_until = -1.0
    end

    dev:performClickableAction(device_commands.ElecExtPwr, 0, true)
    dev:performClickableAction(device_commands.ElecEmer, -1, true)
    dev:performClickableAction(device_commands.ElecAcftIntc, -1, true)
    dev:performClickableAction(device_commands.AviVuhf, 0, true)

    dev:performClickableAction(device_commands.AviMdp1, 1, true)
    dev:performClickableAction(device_commands.AviMdp2, 1, true)
    dev:performClickableAction(device_commands.AviMst, 1, true)
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