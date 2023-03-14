dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

local dev = GetSelf()

local update_time_step = 0.02
make_default_activity(update_time_step)

local flaps_ind = get_param_handle("D_FLAPS_IND")

dev:listen_command(Keys.PlaneFlaps)
dev:listen_command(Keys.PlaneFlapsOn)
dev:listen_command(Keys.PlaneFlapsOff)
dev:listen_command(Keys.PlaneFlapsStop)
dev:listen_command(Keys.PlaneFlapsUpHotas)
dev:listen_command(Keys.PlaneFlapsDownHotas)
dev:listen_command(device_commands.flaps)

function SetCommand(command,value)
end

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        dev:performClickableAction(Keys.PlaneFlapsOff, 0, true)
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(Keys.PlaneFlapsOn, 1, true)
    end
end

function update()
	flaps_ind:set(get_aircraft_draw_argument_value(9))
	-- set_aircraft_draw_argument_value(9,FLAPS_STATE)
	-- set_aircraft_draw_argument_value(10,FLAPS_STATE)
	
end

need_to_be_closed = false -- close lua state after initialization
