dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")

local PANEL_ALARM_TEST = get_param_handle("PANEL_ALARM_TEST")

-- dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")

startup_print("gear: load")

local dev = GetSelf()

local update_time_step = 0.01 --was 0.05
make_default_activity(update_time_step)

local sensor_data = get_base_data()




-- constants/conversion values

local rate_met2knot = 0.539956803456
local ias_knots = 0 -- * rate_met2knot

-- keys & devices

local Gear  = Keys.PlaneGear
local GearUp = Keys.PlaneGearUp
local GearDown = Keys.PlaneGearDown
local GearHandle = device_commands.Gear

local GearNoseRetractTimeSec = 8    -- 8 seconds to retract
local GearNoseExtendTimeSec = 6     -- 6 seconds to extend

local GearMainTimeSec = 5           -- 5 seconds to retract and extend main gear

local LeftSideLead = 0.4 / (GearMainTimeSec) -- left side main gear leads right side, both opening and closing, by 0.7 seconds

local GEAR_NOSE_STATE = 1.0 -- 0 = retracted, 1.0 = extended -- "current" nose gear position
local GEAR_LEFT_STATE =	1.0 -- 0 = retracted, 1.0 = extended -- "current" main left gear position
local GEAR_RIGHT_STATE = 1.0 -- 0 = retracted, 1.0 = extended -- "current" main right gear position
local GEAR_TARGET =     1.0 -- 0 = retracted, 1.0 = extended -- "future" gear position

local GEAR_ERR   = 0

local emergency_gear_countdown = 0

local ONCE = 1

dev:listen_command(Keys.PlaneGear)
dev:listen_command(Keys.PlaneGearUp)
dev:listen_command(Keys.PlaneGearDown)

dev:listen_command(device_commands.LndGear)
dev:listen_command(device_commands.LndGearBeep)
dev:listen_command(device_commands.LndGearOvr)
dev:listen_command(device_commands.LndGearEmer)

-- dev:listen_command(device_commands.emer_gear_release)
-- dev:listen_command(NWS_Engage)
-- dev:listen_command(NWS_Disengage)

--[[
dev:listen_command(Hook)
dev:listen_command(HookUp)
dev:listen_command(HookDown)
dev:listen_command(HookHandle)
--]]

local function get_elec_primary_ac_ok()
    return true
end

local function get_elec_retraction_release_ground()
    return sensor_data.getWOW_LeftMainLandingGear() > 0
end

local function get_elec_retraction_release_airborne()
    return sensor_data.getWOW_LeftMainLandingGear() == 0
end

local function get_hyd_utility_ok()
    return true
end

local function get_elec_external_power()
    return false
end
local function get_elec_primary_dc_ok()
    return true;
end

function SetCommand(command,value)
    debug_message_to_user("gear: command "..tostring(command).." = "..tostring(value))

 --[[
	if command == Hook then
        dev:performClickableAction(HookHandle, 1-HOOK_TARGET, false)    -- send the object click when user presses key, with invert
    elseif command == HookUp then
        dev:performClickableAction(HookHandle, 0, false)                -- send the object click when user presses key, force 0
    elseif command == HookDown then
        dev:performClickableAction(HookHandle, 1, false)                -- send the object click when user presses key, force 1
    elseif command == HookHandle then
        if value ~= HOOK_TARGET then
            HOOK_TARGET = value                     -- only set it if the value is different
            dispatch_action(nil,iCommandPlaneHook)  -- dispatch the built-in SFM command, since we cannot override it drawing to our model's external args
            -- NOTE: for some reason this doesn't work in DCS replays
        end
    end
--]]
	--print_message_to_user("Command: ".. command)
    local retraction_release_solenoid = get_elec_primary_ac_ok()
    local gear_handle_pos = get_cockpit_draw_argument_value(821)  -- 1==down, 0==up
    -- TODO: prevent gear handle being moved if retraction_release_solenoid is false
    if command == Keys.PlaneGear then
        if gear_handle_pos==1 then
            if not get_elec_retraction_release_ground() then
                dev:performClickableAction(device_commands.LndGear, 0, false)
            end
        elseif gear_handle_pos==0 then
            dev:performClickableAction(device_commands.LndGear, 1, false)
        end
    elseif command == Keys.PlaneGearUp then
        if (get_elec_retraction_release_airborne()) then
            dev:performClickableAction(device_commands.LndGear, 0, false)                -- gear handle animation:  0 = retracted, 1 = extended
        end
    elseif command == Keys.PlaneGearDown then
        if (get_elec_retraction_release_airborne()) then
            dev:performClickableAction(device_commands.LndGear, 1, false)                -- gear handle animation:  0 = retracted, 1 = extended
        end
    elseif command == device_commands.LndGear then
        if value ~= GEAR_TARGET then
            if get_hyd_utility_ok() then
                GEAR_TARGET = value
            end
        end
    -- elseif command == device_commands.emer_gear_release then
    --     if (value==1)  then
    --         emergency_gear_countdown = 0.25 -- seconds until T-handle bungees back
    --         if GEAR_ERR==0 then -- necessary to differentiate from gear error?
    --             if gear_handle_pos == 1 then  -- gear handle down
    --                 if not get_hyd_utility_ok() then
    --                     -- print_message_to_user("Emergency gear release")
    --                     GEAR_ERR = 1 -- necessary to differentiate from gear error?
    --                     GEAR_TARGET = 1
    --                 end
    --             end
    --         end
    --     end
	-- elseif command == NWS_Engage then
	-- 	if get_hyd_utility_ok() then
	-- 		efm_data_bus.fm_setNWS(1.0)
	-- 	else
	-- 		efm_data_bus.fm_setNWS(0.0)
	-- 	end
	-- elseif command == NWS_Disengage then
	-- 	efm_data_bus.fm_setNWS(0.0)
    end
end


-- local DC_param = get_param_handle("DC")
-- local DC_param = get_param_handle("DC")
-- local DC_param = get_param_handle("DC")
-- local DC_param = get_param_handle("DC")



local gear_nose_retract_increment = update_time_step / GearNoseRetractTimeSec
local gear_nose_extend_increment = update_time_step / GearNoseExtendTimeSec
local gear_main_increment = update_time_step / GearMainTimeSec
local prev_retraction_release_airborne=get_elec_retraction_release_airborne()


local gear_light_param = get_param_handle("GEAR_HANDLE_LIGHT")
local dev_gear_nose = get_param_handle("GEAR_NOSE_LIGHT")
local dev_gear_left = get_param_handle("GEAR_LEFT_LIGHT")
local dev_gear_right = get_param_handle("GEAR_RIGHT_LIGHT")


function update_gear()
    local gear_handle_pos = get_cockpit_draw_argument_value(821)  -- 1==down, 0==up
    local retraction_release_solenoid = get_elec_primary_ac_ok()    -- according to NATOPS, if system is on emer gen power, the safety solenoid opens, allowing the gear handle to be moved up and gear retracted.  However, see gyrovague's notes at end of this file.
    local retraction_release_airborne = get_elec_retraction_release_airborne()
    -- gear retraction is allowed if retraction_release_solenoid is powered AND aircraft is airborne.
    local allowRetract = (retraction_release_solenoid) and (retraction_release_airborne)
    --[[
    To prevent movement of the landing gear handle to
    UP when the aircraft is on the ground , the landing
    gear handle is latched in the DOWN position. In
    normal operation , the retraction release switch
    located on the left main landing gear strut is actuated
    when the aircraft becomes airborne and the landing
    gear struts extend , energizing the safety solenoid.
    The solenoid then unlatches the handle
    --]]
    if prev_retraction_release_airborne ~= retraction_release_airborne then
        local gear_clickable_ref = get_clickable_element_reference("PNT_821")
        prev_retraction_release_airborne = retraction_release_airborne
        if gear_clickable_ref then
            -- gear_clickable_ref:hide(not retraction_release_airborne)  -- make non-clickable if not airborne, and clickable when airborne
        end
    end

    -- landing gear over-speed detection
    ias_knots = sensor_data.getIndicatedAirSpeed() * 3.6 * rate_met2knot
    if ias_knots > 150 then 
        if GEAR_ERR==0 and (GEAR_LEFT_STATE > 0.2 or GEAR_RIGHT_STATE > 0.2  or GEAR_NOSE_STATE > 0.2) then
            -- GEAR_ERR = 1
            -- TODO: maybe some aircraft animation showing gear panels damaged or gear landing light ripped away etc.
            -- TODO: maybe play a metallic "clunk" noise to notify the player that this has happened
            -- print_message_to_user("Landing gear overspeed damage!") -- delete me once we have a sound effect or other notification
        end
    end
	
    -- gear movement is dependent on operational utility hydraulics.
    -- gear will be stuck in transit if hydraulic fails during transit.
    if get_hyd_utility_ok() or GEAR_ERR == 1 then
        -- make primary nosegear adjustments if needed
        if GEAR_TARGET ~= GEAR_NOSE_STATE then
            if GEAR_NOSE_STATE < GEAR_TARGET or GEAR_ERR==1 then
                GEAR_NOSE_STATE = GEAR_NOSE_STATE + gear_nose_extend_increment
                if GEAR_ERR == 1 then -- extend more quickly (drop by gravity and ram air pressure)
                    GEAR_NOSE_STATE = GEAR_NOSE_STATE + 2*gear_nose_extend_increment
                end
            else
                if GEAR_ERR == 0 and allowRetract then
                    GEAR_NOSE_STATE = GEAR_NOSE_STATE - gear_nose_retract_increment
                end
            end
        end

        -- make primary main gear adjustments if needed
        if GEAR_TARGET ~= GEAR_LEFT_STATE or GEAR_TARGET ~= GEAR_RIGHT_STATE then
            -- left gear moves first, both up and down
            if GEAR_LEFT_STATE < GEAR_TARGET or GEAR_ERR==1 then
                -- extending
                GEAR_LEFT_STATE = GEAR_LEFT_STATE + gear_main_increment
                if GEAR_ERR == 1 then -- extend more quickly (drop by gravity and ram air pressure)
                    GEAR_LEFT_STATE = GEAR_LEFT_STATE + 2*gear_main_increment
                end
            else
                if GEAR_ERR == 0 and allowRetract then
                    GEAR_LEFT_STATE = GEAR_LEFT_STATE - gear_main_increment
                end
            end

            -- right gear lags left gear by LeftSideLead seconds
            if GEAR_RIGHT_STATE < GEAR_TARGET or GEAR_ERR==1 then
                if GEAR_LEFT_STATE > LeftSideLead then
                    GEAR_RIGHT_STATE = GEAR_RIGHT_STATE + gear_main_increment
                    if GEAR_ERR == 1 then -- extend more quickly (drop by gravity and ram air pressure)
                        GEAR_RIGHT_STATE = GEAR_RIGHT_STATE + 2*gear_main_increment
                    end
                end
            else
                if GEAR_LEFT_STATE < (1-LeftSideLead) then
                    if GEAR_ERR == 0 and allowRetract then
                        GEAR_RIGHT_STATE = GEAR_RIGHT_STATE - gear_main_increment
                    end
                end
            end
        end
    end

    -- handle rounding errors induced by non-modulo increment remainders
    if GEAR_NOSE_STATE < 0 then
        GEAR_NOSE_STATE = 0
    elseif GEAR_NOSE_STATE > 1 then
        GEAR_NOSE_STATE = 1
    end

    if GEAR_LEFT_STATE < 0 then
        GEAR_LEFT_STATE = 0
    elseif GEAR_LEFT_STATE > 1 then
        GEAR_LEFT_STATE = 1
    end

    if GEAR_RIGHT_STATE < 0 then
        GEAR_RIGHT_STATE = 0
    elseif GEAR_RIGHT_STATE > 1 then
        GEAR_RIGHT_STATE = 1
    end
	
	if not get_hyd_utility_ok() then
		-- efm_data_bus.fm_setNWS(0.0)
	end
	
	-- efm_data_bus.fm_setNoseGear(GEAR_NOSE_STATE)
	-- efm_data_bus.fm_setLeftGear(GEAR_LEFT_STATE)
	-- efm_data_bus.fm_setRightGear(GEAR_RIGHT_STATE)

    set_aircraft_draw_argument_value(0,GEAR_NOSE_STATE) -- nose gear draw angle
    set_aircraft_draw_argument_value(3,GEAR_RIGHT_STATE) -- right gear draw angle
    set_aircraft_draw_argument_value(5,GEAR_LEFT_STATE) -- left gear draw angle

    

    -- reflect gear state on gear-flaps indicator panel
    

	

    if get_elec_primary_dc_ok() then
        if GEAR_NOSE_STATE == 1 and get_elec_emergency_ok() then
            dev_gear_nose:set(1)
        else
            dev_gear_nose:set(0)
        end

        if GEAR_LEFT_STATE == 1 and get_elec_emergency_ok() then
            dev_gear_left:set(1)
        else
            dev_gear_left:set(0)
        end

        if GEAR_RIGHT_STATE == 1 and get_elec_emergency_ok() then
            dev_gear_right:set(1)
        else
            dev_gear_right:set(0)
        end
    end
    if emergency_gear_countdown > 0 then
        emergency_gear_countdown = emergency_gear_countdown - update_time_step
        if emergency_gear_countdown<=0 then
            emergency_gear_countdown = 0
            -- dev:performClickableAction(device_commands.emer_gear_release,0,false)
        end
    end

    if ( ((GEAR_NOSE_STATE+GEAR_LEFT_STATE+GEAR_RIGHT_STATE)/3) ~= gear_handle_pos or PANEL_ALARM_TEST:get() == 1) and get_elec_emergency_ok() then
        gear_light_param:set(1.0)
    else
        gear_light_param:set(0.0)
    end

    if GEAR_ERR==1 and get_elec_external_power() then
        -- pretend ground crew reset gear fault
        GEAR_ERR = 0
        print_message_to_user("Ground crew reset landing gear")
    end
end

local gear_warning = 0
function update()
    update_gear()

    ---- LDG_GEAR Warning
    local throttle_pos = sensor_data.getThrottleLeftPosition()*100
    local ralt = sensor_data.getRadarAltitude() * 3.2808399
    local ias = sensor_data.getIndicatedAirSpeed() * 1.94384
    if gear_warning == 0 and throttle_pos < 50 and ralt < 1000 and ias < 135 and GEAR_NOSE_STATE < 1 and  GEAR_LEFT_STATE < 1 and GEAR_RIGHT_STATE < 1 then 
        gear_warning = 1
        set_warning(WARNING_ID.LDG_GEAR,1)
    elseif gear_warning == 1 and (throttle_pos >= 50 or ralt >= 1000 or ias >= 135 or (GEAR_NOSE_STATE >= 1 and  GEAR_LEFT_STATE >= 1 and GEAR_RIGHT_STATE >= 1) ) then
        gear_warning = 0
        set_warning(WARNING_ID.LDG_GEAR,0)
    end


end

function post_initialize()
    startup_print("gear: postinit start")

	local birth = LockOn_Options.init_conditions.birth_place
	if birth=="GROUND_HOT" or birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.LndGear, 1, true)
        dev:performClickableAction(device_commands.LndGearEmer, 0, true)
        GEAR_NOSE_STATE = 1
        GEAR_RIGHT_STATE = 1
        GEAR_LEFT_STATE = 1
        GEAR_TARGET = 1
	elseif birth=="AIR_HOT" then
        dev:performClickableAction(device_commands.LndGear, 0, true)
        dev:performClickableAction(device_commands.LndGearEmer, 0, true)
		GEAR_NOSE_STATE = 0
       GEAR_RIGHT_STATE = 0
       GEAR_LEFT_STATE = 0
       GEAR_TARGET = 0
	end


    set_aircraft_draw_argument_value(0,GEAR_NOSE_STATE)     -- nose gear draw angle
    set_aircraft_draw_argument_value(3,GEAR_RIGHT_STATE)    -- right gear draw angle
    set_aircraft_draw_argument_value(5,GEAR_LEFT_STATE)     -- left gear draw angle

    -- set_aircraft_draw_argument_value(25,HOOK_TARGET)
    startup_print("gear: postinit end")

end

-- local tail_hook_param = get_param_handle("D_TAIL_HOOK")
-- function update_hook()
    -- NOTE: we do not need to draw this ourselves, SFM always draws it based on built-in capabilities
--set_aircraft_draw_argument_value(25,HOOK_TARGET)

    -- mirror tail_hook to in-cockpit tailhook lever
    -- usually done automatically by clickabledata.lua, but DCS replay issue is forcing us to remove
    -- clickable behavior on the tail hook lever, so now we're implementing it as parametrized gauge
    -- local tail_hook = get_aircraft_draw_argument_value(25)
    -- tail_hook_param:set(tail_hook)
-- end

startup_print("gear: load end")

need_to_be_closed = false -- close lua state after initialization

--[[
NATOPS notes
pg 1-29
To prevent movement of the landing gear handle to
UP when the aircraft is on the ground, the landing
gear handle is latched in the DOWN position. In
normal operation, the retraction release switch
located on the left main landing gear strut, is actuated
when the aircraft becomes airborne and the landing
gear struts extend, energizing the safety solenoid.
The solenoid then unlatches the handle. On emergency
generator power, the retraction release safety
solenoid is deenergized. If it should become necessary
to retract the landing gear while on the ground,
the serrated end of the latch on the landing gear
control panel must be moved aft to unlatch the
landing gear handle.

  gyrovague: however, figure FO-5 for A-4E/F shows RETRACTION RELEASE
    SOLENOID on the primary AC bus for A-4E, and primary AC bus
    does have power on emergency generator. Fig Fo-5 for A-4G shows
    RETRACTION RELEASE SOLENOID on the monitored DC bus, which doesn't
    have power on emergency generator.

pg 1-30
A warning light in the wheel-shaped handle of the
control comes on when the handle is moved to either
of its two positions. The light remains on until the
wheels are locked in either the up or down position.
The position of the wheels is shown on the wheels
and flaps position indicator on the left console. A
flasher-type wheels warning light (figures 1-5 and
1-6) i s installed beneath the upper left side of the
glareshield adjacent to the LABS light. With the
wing flap handle at any position other than the UP
detent and the landing gear up or unsafe, retarding
the throttle below approximately 92 percent rpm
causes the WHEELS warning light to flash, informing
the pilot of a possible unsafe condition.

In the event of utility hydraulic system failure, the
landing gear may be lowered manually by means of
the emergency landing gear release T -handle (figures
1-5 and 1-6) on the extreme left side of the
cockpit, above the left console. When the landing
gear control is moved to DOWN and the emergency
landing gear release handle is pulled, the landing
gear doors are unlatched, allowing the landing gear
to drop into the airstream. The landing gear extends
and locks by a combination of gravity and ram air
force

--]]
