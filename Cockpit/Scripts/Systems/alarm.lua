dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")
-- dofile(LockOn_Options.script_path.."utils.lua")


dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."Systems/engine_api.lua")
dofile(LockOn_Options.script_path.."Systems/alarm_api.lua")

local PANEL_ALARM_TEST = get_param_handle("PANEL_ALARM_TEST")

-- dofile(LockOn_Options.script_path.."Systems/hydraulic_system_api.lua")

local warnings = {}

local cautions = {}

local advices = {}

local function acknowledge_warnings()
    for i,v in pairs(warnings) do
        if v.state ==  1 then
            warnings[i].state = 2
        end
    end
end

local function acknowledge_cautions()
  for i,v in pairs(cautions) do
      if v.state ==  1 then
          cautions[i].state = 2
      end
  end
end

local function clear_warning(id)
    set_warning(id,0)
end

local function set_alert(alerttable, id, state, text)
    local alert = {}
    alert.id = id
    alert.state = state
    alert.text = text
    for i,v in pairs(alerttable) do
        if v.id ==  id then
            if state == 0 then
                table.remove(alerttable, i)
            else 
                alerttable[i].state = state
                state = 0
            end
            break
        end
    end
    if state > 0 then  table.insert(alerttable,alert) end

end

local hud_warning_supress=0

local function set_warning(id, state)
    state = state or 1
    for index, value in pairs(WARNING_ID) do
        if value == id then
            set_alert(warnings, id, state, index:gsub("_"," "))
            if state == 1 then hud_warning_supress = 0 end
        end
    end
end

local function set_caution(id, state)
    for index, value in pairs(CAUTION_ID) do
        if value == id then
            set_alert(cautions, id, state, index:gsub("_"," "))
        end
    end
end

local function set_advice(id, state)
  for index, value in pairs(ADVICE_ID) do
      if value == id then
          set_alert(advices, id, state, index:gsub("_"," "))
      end
  end
end



local dev = GetSelf()

local update_time_step = 0.02
make_default_activity(update_time_step) -- enables call to update

local sensor_data = get_base_data()

function post_initialize()
end

dev:listen_command(74)


dev:listen_command(device_commands.UFCP_WARNRST)


function SetCommand(command,value)
    debug_message_to_user("alarm: " .. tostring(command) .. "=" .. value)
    if command == device_commands.ALERTS_SET_WARNING then  set_warning(value, 1)
    elseif command == device_commands.ALERTS_RESET_WARNING then set_warning(value, 0)
    elseif command == device_commands.ALERTS_ACK_WARNING then set_warning(value, 2)
    elseif command == device_commands.ALERTS_ACK_WARNINGS then acknowledge_warnings()
    elseif command == device_commands.ALERTS_SET_CAUTION then  set_caution(value, 1)
    elseif command == device_commands.ALERTS_RESET_CAUTION then set_caution(value, 0)
    elseif command == device_commands.ALERTS_ACK_CAUTION then set_caution(value, 2)
    elseif command == device_commands.ALERTS_ACK_CAUTIONS then acknowledge_cautions()
    elseif command == device_commands.ALERTS_SET_ADVICE then  set_advice(value, 1)
    elseif command == device_commands.ALERTS_RESET_ADVICE then set_advice(value, 0)
    elseif command == device_commands.WARNING_PRESS then acknowledge_warnings()
    elseif command == device_commands.CAUTION_PRESS then acknowledge_cautions()
    elseif command == device_commands.UFCP_WARNRST and value == 1 then hud_warning_supress = 1
    end
end

function update()
    update_alerts()
end

local flash_period = 0.100
local flash_elapsed = 0
local warning_light = get_param_handle("WARNING_LIGHT")
local caution_light = get_param_handle("CAUTION_LIGHT")
local fire_light = get_param_handle("FIRE_LIGHT")

function update_alerts()
  local i=1
  local warning_flash = 0
  local fire_flash = 0
  for key, value in pairs(warnings) do
      if i >= 10 then  break end
      local text_param = get_param_handle("EICAS_ERROR".. tostring(i) .."_TEXT")
      local color_param = get_param_handle("EICAS_ERROR".. tostring(i) .."_COLOR")
      text_param:set(value.text)
      if value.state == 1 then
          color_param:set(4)
          warning_flash = 1
          if value.id == WARNING_ID.FIRE then fire_flash = 1 end
      elseif value.state == 2 then
          color_param:set(1)
      end
      i = i + 1
  end

  set_hud_warning(warning_flash * (1-hud_warning_supress))

  flash_elapsed = flash_elapsed + update_time_step
  if warning_flash == 1 or PANEL_ALARM_TEST:get() == 1 then
    if flash_elapsed > 2* flash_period or PANEL_ALARM_TEST:get() == 1 then
      if get_elec_emergency_ok() then warning_light:set(1) end
    elseif flash_elapsed > flash_period then 
      warning_light:set(0)
    end
  else
    warning_light:set(0)
  end

  if not get_elec_emergency_ok() then warning_light:set(0) end

  if fire_flash == 1 then
    if flash_elapsed > 2* flash_period then
      if get_elec_emergency_ok() then fire_light:set(1) end
    elseif flash_elapsed > flash_period then 
      fire_light:set(0)
    end
  else
    fire_light:set(0)
  end
  if not get_elec_emergency_ok() then fire_light:set(0) end

  local caution_flash = 0
  for key, value in pairs(cautions) do
      if i >= 10 then  break end
      local text_param = get_param_handle("EICAS_ERROR".. tostring(i) .."_TEXT")
      local color_param = get_param_handle("EICAS_ERROR".. tostring(i) .."_COLOR")
      text_param:set(value.text)
      if value.state == 1 then
          color_param:set(5)
          caution_flash = 1
      elseif value.state == 2 then
          color_param:set(2)
      end
      i = i + 1
  end

  if caution_flash == 1 or PANEL_ALARM_TEST:get() == 1 then
    if flash_elapsed > 2* flash_period or PANEL_ALARM_TEST:get() == 1 then
      if get_elec_emergency_ok() then caution_light:set(1) end
    elseif flash_elapsed > flash_period then 
      caution_light:set(0)
    end
  else
    caution_light:set(0)
  end
  if not get_elec_emergency_ok() then caution_light:set(0) end

  if flash_elapsed > 2* flash_period then
    flash_elapsed = 0
  end

  for key, value in pairs(advices) do
      if i >= 10 then  break end
      local text_param = get_param_handle("EICAS_ERROR".. tostring(i) .."_TEXT")
      local color_param = get_param_handle("EICAS_ERROR".. tostring(i) .."_COLOR")
      text_param:set(value.text)
      if value.state >0 then
          color_param:set(3)
      end
      i = i + 1
  end

  while i <= 10 do
      local text_param = get_param_handle("EICAS_ERROR" .. tostring(i) .. "_TEXT")
      local color_param = get_param_handle("EICAS_ERROR" .. tostring(i) .. "_COLOR")
      text_param:set("")
      color_param:set(0)
      i = i + 1        
  end

end

need_to_be_closed = false -- close lua state after initialization
