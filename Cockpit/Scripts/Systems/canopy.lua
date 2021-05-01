dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()

local update_time_step = 0.02  --50 time per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local canopy_int_anim_arg = 26
local canopy_ext_anim_arg = 38
local canopy_lever_cpt_anim_arg = 129

--Creating local variables
local initial_canopy = get_aircraft_draw_argument_value(canopy_ext_anim_arg)
local CANOPY_COMMAND = 0   -- 0 closing, 1 opening, 2 jettisoned
if (initial_canopy > 0) then
    CANOPY_COMMAND = 1
end

dev:listen_command(Keys.Canopy)
dev:listen_command(Keys.ToggleStick)

dev:listen_event("repair")

local stick_vis_state = 0   -- 0 = visible, 1 = hidden
local stick_vis_param = get_param_handle("HIDE_STICK")
local optionsData_hidestick =  get_option_value("difficulty.hideStick","local")

if optionsData_hidestick == true then
    stick_vis_state = 1
else
    stick_vis_state = 0
end

-- getCanopyPos
-- getCanopyState

function SetCommand(command,value)
	if (command == Keys.Canopy) then
        if CANOPY_COMMAND <= 1 then -- only toggle while not jettisoned
            CANOPY_COMMAND = 1-CANOPY_COMMAND --toggle
        end
    elseif command == Keys.ToggleStick then
        stick_vis_state = 1 - stick_vis_state
	end
end

local prev_canopy_val = -1
local canopy_warning = 0

local sndhost
local canopy_snd
local canopy_move_snd

function post_initialize()
    sndhost = create_sound_host("COCKPIT_CANOPY","HEADPHONES",0,0,0)
    canopy_snd = sndhost:create_sound("Aircrafts/A-29B/Canopy")
    canopy_move_snd = sndhost:create_sound("Aircrafts/A-29B/CanopyMove")
end

function update()
    local current_canopy_position = get_aircraft_draw_argument_value(canopy_ext_anim_arg)
    if current_canopy_position > 0.95 then
        CANOPY_COMMAND = 2 -- canopy was jettisoned
    end
	if (CANOPY_COMMAND == 0 and current_canopy_position > 0) then
		-- lower canopy in increments of 0.01 (50x per second)
        if current_canopy_position > 0.89 then 
            canopy_move_snd:play_once()
        end
        current_canopy_position = current_canopy_position - 0.01
	elseif (CANOPY_COMMAND == 1 and current_canopy_position <= 0.89) then
        -- raise canopy in increment of 0.01 (50x per second)
        if current_canopy_position == 0 then 
            canopy_snd:play_once() 
            canopy_move_snd:play_once()
        end
		current_canopy_position = current_canopy_position + 0.01
    elseif current_canopy_position < 0 then current_canopy_position = 0
        canopy_snd:play_once()
        canopy_move_snd:stop()
    elseif current_canopy_position >= 0.89 and current_canopy_position < 0.95 then current_canopy_position = 0.9
        canopy_move_snd:stop()
    end
    set_aircraft_draw_argument_value(canopy_ext_anim_arg, current_canopy_position)
    local cockpit_lever = get_cockpit_draw_argument_value(canopy_int_anim_arg)
    if prev_canopy_val ~= cockpit_lever then
        local canopy_lever_clickable_ref = get_clickable_element_reference("PNT_129")
        canopy_lever_clickable_ref:update() -- ensure the connector moves too
        prev_canopy_val = cockpit_lever
    end
    if current_canopy_position > 0 and canopy_warning == 0 then 
        set_warning(WARNING_ID.CANOPY,1) 
        canopy_warning = 1
    elseif current_canopy_position <= 0 and canopy_warning == 1 then 
        set_warning(WARNING_ID.CANOPY,0) 
        canopy_warning = 0
    end
    stick_vis_param:set(stick_vis_state)
end

function CockpitEvent(event, val)
    if event == "repair" then
        CANOPY_COMMAND = 1 -- reset canopy from jettison state to open state
    end
end

need_to_be_closed = false -- close lua state after initialization