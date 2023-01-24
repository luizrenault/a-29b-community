dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/engine_api.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")


startup_print("electric_system: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

debug = true

-- Argument List
-- 962  Generator Switch


function update()
end

dev:listen_command(315) -- iCommandPowerBattery1

dev:listen_command(706) -- iCommandPowerBattery1
dev:listen_command(707) -- iCommandPowerBattery1Cover
dev:listen_command(708) -- iCommandPowerBattery2
dev:listen_command(709) -- iCommandPowerBattery1Cover
dev:listen_command(710) -- iCommandPowerBattery1Cover
dev:listen_command(711) -- iCommandPowerBattery1Cover
dev:listen_command(712) -- iCommandPowerBattery1Cover
dev:listen_command(713) -- iCommandPowerBattery1Cover

dev:listen_command(1071) -- iCommandPowerBattery1Cover
dev:listen_command(1072) -- iCommandPowerBattery1Cover
dev:listen_command(1073) -- iCommandPowerBattery1Cover
dev:listen_command(1074) -- iCommandPowerBattery1Cover
dev:listen_command(1075) -- iCommandPowerBattery1Cover
dev:listen_command(1076) -- iCommandPowerBattery1Cover


function post_initialize()
    -- startup_print("electric_system: postinit start")
    -- --update_electrical()

    -- local birth = LockOn_Options.init_conditions.birth_place

    -- if birth=="GROUND_HOT" or birth=="AIR_HOT" then
    --     dev:performClickableAction(device_commands.ElecBatt, 0, true)
    --     dev:performClickableAction(device_commands.AviMst, 1, true)
    -- elseif birth=="GROUND_COLD" then
    --     dev:performClickableAction(device_commands.ElecBatt, -1, true)
    --     dev:performClickableAction(device_commands.AviMst, 0, true)
    --     elec_avionics_emergency_warm_up_until = -1.0
    --     elec_avionics_warm_up_until = -1.0
    -- end

    -- dev:performClickableAction(device_commands.ElecExtPwr, 0, true)
    -- dev:performClickableAction(device_commands.ElecEmer, -1, true)
    -- dev:performClickableAction(device_commands.ElecAcftIntc, -1, true)
    -- dev:performClickableAction(device_commands.AviVuhf, 0, true)

    -- dev:performClickableAction(device_commands.AviMdp1, 1, true)
    -- dev:performClickableAction(device_commands.AviMdp2, 1, true)
    -- dev:performClickableAction(device_commands.ElecBkp, 1, true)
    -- dev:performClickableAction(device_commands.AviSms, 1, true)
    -- dev:performClickableAction(device_commands.ElecGen, 1, true)
    -- startup_print("electric_system: postinit end")
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
    -- --debug_message_to_user("electric_system: command "..tostring(command).." = "..tostring(value))
    -- if command == device_commands.ElecBatt then
    --     if value==0 then
    --         dev:DC_Battery_on(true)
    --     elseif value == -1 then 
    --         dev:DC_Battery_on(false)
    --     end
    -- elseif command == device_commands.ElecGen then
    --     if value==1 then
    --         electric_system:AC_Generator_1_on(true)
    --     else
    --         electric_system:AC_Generator_1_on(false)
    --     end
    -- elseif command == Keys.PowerGeneratorLeft then
    --     if value==1 then
    --         electric_system:AC_Generator_1_on(true)
    --     else
    --         electric_system:AC_Generator_1_on(false)
    --     end
    -- elseif command == Keys.BatteryPower then
    --     if value==0 then
    --         dev:DC_Battery_on(true)
    --     elseif value == -1 then 
    --         dev:DC_Battery_on(false)
    --     end
    -- elseif command == Keys.AviMdp1 then
    --     dev:performClickableAction(device_commands.AviMdp1, (get_cockpit_draw_argument_value(841) + 1) % 2)
    -- elseif command == Keys.AviMdp2 then
    --     dev:performClickableAction(device_commands.AviMdp2, (get_cockpit_draw_argument_value(842) + 1) % 2)
    -- elseif command == Keys.AviMst then
    --     dev:performClickableAction(device_commands.AviMst, (get_cockpit_draw_argument_value(843) + 1) % 2)
    -- elseif command == Keys.AviSms then
    --     dev:performClickableAction(device_commands.AviSms, (get_cockpit_draw_argument_value(844) + 1) % 2)
    -- elseif command == Keys.AviVuhf then
    --     dev:performClickableAction(device_commands.AviVuhf, (get_cockpit_draw_argument_value(845) + 1) % 2)
    -- elseif command == Keys.ElecBatt then
    --     dev:performClickableAction(device_commands.ElecBatt, get_cockpit_draw_argument_value(961) == 0 and -1 or 0)
    -- elseif command == Keys.ElecGen then
    --     dev:performClickableAction(device_commands.ElecGen, (get_cockpit_draw_argument_value(962) + 1) % 2)
    -- elseif command == Keys.ElecExtPwr then
    --     dev:performClickableAction(device_commands.ElecExtPwr, (get_cockpit_draw_argument_value(963) + 1) % 2)
    -- elseif command == Keys.ElecBkp then
    --     dev:performClickableAction(device_commands.ElecBkp, (get_cockpit_draw_argument_value(964) + 1) % 2)
    -- elseif command == Keys.ElecEmer then
    --     dev:performClickableAction(device_commands.ElecEmer, get_cockpit_draw_argument_value(965) == 1 and -1 or 1)
    -- elseif command == Keys.ElecAcftIntc then
    --     dev:performClickableAction(device_commands.ElecAcftIntc, get_cockpit_draw_argument_value(966) == 1 and -1 or 1)
    -- end
end


startup_print("electric_system: load end")
need_to_be_closed = false -- close lua state after initialization


