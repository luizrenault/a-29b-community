dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
dofile(LockOn_Options.script_path.."Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")
dofile(LockOn_Options.script_path.."Systems/weapon_system_api.lua")

startup_print("avionics: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()


local iCommandPlaneTrimLeft = 93
local iCommandPlaneTrimRight = 94
local iCommandPlaneTrimUp = 95
local iCommandPlaneTrimDown = 96
local iCommandPlaneTrimLeftRudder = 98
local iCommandPlaneTrimRightRudder = 99
local iCommandPlaneTrimStop = 215

local avionics_trim_updown = 0
local avionics_trim_wingleftright = 0
local avionics_trim_rudderleftright = 0


AVIONICS_TRIM_UPDOWN = get_param_handle("AVIONICS_TRIM_UPDOWN")
AVIONICS_TRIM_WINGLEFTRIGHT = get_param_handle("AVIONICS_TRIM_WINGLEFTRIGHT")
AVIONICS_TRIM_RUDDERLEFTRIGHT = get_param_handle("AVIONICS_TRIM_RUDDERLEFTRIGHT")

AVIONICS_MASTER_MODE:set(AVIONICS_MASTER_MODE_ID.NAV)
AVIONICS_MASTER_MODE_LAST:set(-1)

local master_mode = -1
local master_mode_last = -1

local function master_mode_state_machine()
    master_mode = get_avionics_master_mode()
    if master_mode == AVIONICS_MASTER_MODE_ID.NAV and get_avionics_gear_down() then set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.LANDING) end
    if master_mode == AVIONICS_MASTER_MODE_ID.LANDING and not get_avionics_gear_down() then set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.NAV) end
end

local function master_mode_changed()
    master_mode = get_avionics_master_mode()
    if master_mode == master_mode_last then return 0 end

    if master_mode == AVIONICS_MASTER_MODE_ID.NAV and master_mode_last == AVIONICS_MASTER_MODE_ID.LANDING then
    end
    AVIONICS_MASTER_MODE_TXT:set(AVIONICS_MASTER_MODE_STR[master_mode])
    master_mode_last = master_mode
end

function update()
    master_mode_state_machine()
    master_mode_changed()

    -- IAS
    local ias = sensor_data.getIndicatedAirSpeed() * 1.94384
    local iasx, iasy, iasz = sensor_data.getSelfAirspeed()
    if ias == 0 then ias = math.sqrt(iasx * iasx + iasy * iasy + iasz * iasz )  * 1.94384 end
    if ias < 30 then
        ias = 0
    end

    -- ALT
    local altitude = round_to(sensor_data.getBarometricAltitude()*3.2808399,10)

    -- RALT
    local radar_alt = sensor_data.getRadarAltitude() * 3.2808399
    if radar_alt > 0 and radar_alt < 5000 then radar_alt = round_to(radar_alt, 10) else radar_alt = -1 end

    -- VV
    local vv = sensor_data.getVerticalVelocity() * 3.2808399 * 60
    vv = round_to(vv, 10)
    
    -- HDG
    local hdg = math.deg(-sensor_data.getHeading())
    if hdg < 0 then hdg = 360 + hdg end
    hdg = hdg % 360

    -- Turn Rate (deg/min)
    local turn_rate = math.deg(sensor_data.getRateOfYaw())*60


    AVIONICS_IAS:set(ias)
    AVIONICS_ALT:set(altitude)
    AVIONICS_VV:set(vv)
    AVIONICS_HDG:set(hdg)
    AVIONICS_RALT:set(radar_alt)
    AVIONICS_TURN_RATE:set(turn_rate)
    AVIONICS_TRIM_UPDOWN:set(avionics_trim_updown)
    AVIONICS_TRIM_WINGLEFTRIGHT:set(avionics_trim_wingleftright)
    AVIONICS_TRIM_RUDDERLEFTRIGHT:set(avionics_trim_rudderleftright)

    local value = get_cockpit_draw_argument_value(901)
    if value == 1 then 
        dispatch_action(nil,iCommandPlaneTrimRight)
        dev:performClickableAction(iCommandPlaneTrimRight)
    elseif value == -1 then
        dispatch_action(nil,iCommandPlaneTrimLeft)
        dev:performClickableAction(iCommandPlaneTrimLeft)
    end

    value = get_cockpit_draw_argument_value(902)
    if value == 1 then 
        dispatch_action(nil,iCommandPlaneTrimDown)
        dev:performClickableAction(iCommandPlaneTrimDown)
    elseif value == -1 then
        dispatch_action(nil,iCommandPlaneTrimUp)
        dev:performClickableAction(iCommandPlaneTrimUp)
    end


end

function post_initialize()
    startup_print("avionics: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" then
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
        -- dev:performClickableAction(device_commands.EnvRecFan, 0, true)
    end
    startup_print("avionics: postinit end")
end



dev:listen_command(iCommandPlaneTrimLeft)
dev:listen_command(iCommandPlaneTrimRight)
dev:listen_command(iCommandPlaneTrimUp)
dev:listen_command(iCommandPlaneTrimDown)
dev:listen_command(iCommandPlaneTrimLeftRudder)
dev:listen_command(iCommandPlaneTrimRightRudder)
dev:listen_command(Keys.MasterModeSw)


function SetCommand(command,value)
    debug_message_to_user("avionics: command "..tostring(command).." = "..tostring(value))
    if command==Keys.MasterModeSw then
        if value == 1 then set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.NAV)
        elseif value == 2 then 
            if not get_avionics_master_mode_ag() then
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.A_G)
            end
        elseif value == 3 then 
            local param = get_param_handle("WPN_AA_SLV_SRC")
            local slv_src = param:get()
            if slv_src == WPN_AA_SLV_SRC_IDS.BST then 
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.INT_B)
            else
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.INT_L)
            end
        elseif value == 4 then
            local param = get_param_handle("WPN_AA_SLV_SRC")
            local slv_src = param:get()
            if slv_src == WPN_AA_SLV_SRC_IDS.BST then 
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DGFT_B)
            else 
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DGFT_L)
            end
        end
    elseif command==iCommandPlaneTrimUp then
        if avionics_trim_updown < 10 then 
            avionics_trim_updown = avionics_trim_updown + 0.01
        else
            dispatch_action(nil,iCommandPlaneTrimDown)
        end
    elseif command == iCommandPlaneTrimDown then
        if avionics_trim_updown > -10 then 
            avionics_trim_updown = avionics_trim_updown - 0.01
        else
            dispatch_action(nil,iCommandPlaneTrimUp)
        end
    elseif command == iCommandPlaneTrimLeft then
        if avionics_trim_wingleftright < 45 then 
            avionics_trim_wingleftright = avionics_trim_wingleftright + 0.05
        else
            dispatch_action(nil,iCommandPlaneTrimRight)
        end
    elseif command == iCommandPlaneTrimRight then
        if avionics_trim_wingleftright > -45 then 
            avionics_trim_wingleftright = avionics_trim_wingleftright - 0.05
        else
            dispatch_action(nil,iCommandPlaneTrimLeft)
        end
    elseif command == iCommandPlaneTrimLeftRudder then
        if avionics_trim_rudderleftright > -10 then 
            avionics_trim_rudderleftright = avionics_trim_rudderleftright - 0.01
        else
            dispatch_action(nil,iCommandPlaneTrimRightRudder)
        end
    elseif command == iCommandPlaneTrimRightRudder then
        if avionics_trim_rudderleftright < 10 then 
            avionics_trim_rudderleftright = avionics_trim_rudderleftright + 0.01
        else
            dispatch_action(nil,iCommandPlaneTrimLeftRudder)
        end
    elseif command == device_commands.TrimEmerAil then
        if value == 0 then dispatch_action(nil,iCommandPlaneTrimStop) end
    elseif command == device_commands.TrimEmerElev then
        if value == 0 then dispatch_action(nil,iCommandPlaneTrimStop) end
    elseif command == device_commands.AutoRudder then
        if value == -1 then set_caution(CAUTION_ID.MAN_RUD_T, 1)
        else set_caution(CAUTION_ID.MAN_RUD_T, 0)
        end
    end
end

startup_print("avionics: load end")
need_to_be_closed = false -- close lua state after initialization


