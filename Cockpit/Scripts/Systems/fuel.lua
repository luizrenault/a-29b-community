dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

startup_print("fuel: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

function update()
end

function post_initialize()
    startup_print("fuel: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.FuelMain, 1, true)
        dev:performClickableAction(device_commands.FuelAux, 0.25, true)
        dev:performClickableAction(device_commands.FuelXfr, 0, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.FuelMain, 0, true)
        dev:performClickableAction(device_commands.FuelAux, 0.25, true)
        dev:performClickableAction(device_commands.FuelXfr, -1, true)
    end
    startup_print("fuel: postinit end")
end

dev:listen_command(device_commands.FuelMain)
dev:listen_command(device_commands.FuelAux)
dev:listen_command(device_commands.FuelXfr)

function SetCommand(command,value)
    debug_message_to_user("fuel: command "..tostring(command).." = "..tostring(value))
    if command==device_commands.EngineStart then
    elseif command == iCommandEnginesStart then
    elseif command == iCommandEnginesStop then
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    end
    -- Quando o desbalanceamento entre os tanques atinge 35 kg, a bomba auxiliar do tanque que estiver com mais combustível começa a funcionar, permanecendo ligada até que a diferença fique abaixo de 20 kg, quando é desligada. Esse ciclo volta a ser ativado toda vez que o desbalanceamento atingir 35 kg.
end


startup_print("fuel: load end")
need_to_be_closed = false -- close lua state after initialization


