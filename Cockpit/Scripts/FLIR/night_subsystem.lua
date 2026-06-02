local night_subsystem = {}

local FLIR_DAY_NIGHT = get_param_handle("FLIR_DAY_NIGHT")

local I251_BRIGHTNESS_UP = iCommandPlane_I251_Brightness_Up or 842
local I251_BRIGHTNESS_DOWN = iCommandPlane_I251_Brightness_Down or 843
local I251_CONTRAST_UP = iCommandPlane_I251_Contrast_Up or 844
local I251_CONTRAST_DOWN = iCommandPlane_I251_Contrast_Down or 845
local I251_BACKGROUND_WHITEBLACK = iCommandPlane_I251_Background_WhiteBlack or 846
local last_day_night = nil

local function is_night_mode()
    return FLIR_DAY_NIGHT:get() == 1
end

local function dispatch_i251(command_id)
    if command_id ~= nil then
        dispatch_action(nil, command_id)
        return true
    end
    return false
end

local function dispatch_i251_repeat(command_id, count)
    for _ = 1, count do
        dispatch_i251(command_id)
    end
end

function night_subsystem.initialize()
    last_day_night = FLIR_DAY_NIGHT:get()
end

function night_subsystem.on_mode_changed()
    local current = FLIR_DAY_NIGHT:get()

    if last_day_night == current then
        return
    end

    if current == 1 then
        dispatch_i251(I251_BACKGROUND_WHITEBLACK)
        dispatch_i251_repeat(I251_BRIGHTNESS_DOWN, 3)
        dispatch_i251_repeat(I251_CONTRAST_DOWN, 2)
    end

    last_day_night = current
end

function night_subsystem.handle_command(command, value, flir_commands)
    if value <= 0 or not is_night_mode() then
        return false
    end

    if command == flir_commands.GainUp then
        return dispatch_i251(I251_BRIGHTNESS_UP)
    elseif command == flir_commands.GainDown then
        return dispatch_i251(I251_BRIGHTNESS_DOWN)
    elseif command == flir_commands.LevelUp then
        return dispatch_i251(I251_CONTRAST_UP)
    elseif command == flir_commands.LevelDown then
        return dispatch_i251(I251_CONTRAST_DOWN)
    elseif command == flir_commands.Polarity then
        return dispatch_i251(I251_BACKGROUND_WHITEBLACK)
    end

    return false
end

return night_subsystem
