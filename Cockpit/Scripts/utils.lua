function basic_dump (o)
  if type(o) == "number" then
    return tostring(o)
  elseif type(o) == "string" then
    return string.format("%q", o)
  else -- nil, boolean, function, userdata, thread; assume it can be converted to a string
    return tostring(o)
  end
end


function dump (name, value, seen, result)
  local seen = seen or {}       -- initial value
  local result = result or ""
  result=result..name.." = "
  if type(value) ~= "table" then
    result=result..basic_dump(value).."\n"
  elseif type(value) == "table" then
    -- if seen[value] then    -- value already saved?
    --   result=result.."->"..seen[value].."\n"  -- use its previous name
    -- else
      seen[value] = name   -- save name for next time
      result=result.."{}\n"     -- create a new table
      for k,v in pairs(value) do      -- save its fields
        local fieldname = string.format("%s[%s]", name,
                                        basic_dump(k))
        -- if fieldname~="_G[\"seen\"]" then
          result=dump(fieldname, v, seen, result)
        -- end
      end
    -- end
  end
  return result
end


function dump1 (name, value, saved, result)
  seen = seen or {}       -- initial value
  result = result or ""
  result=result..name.." = "
  if type(value) ~= "table" then
    result=result..basic_dump(value).."\n"
    log.info(result)
    result = ""
  elseif type(value) == "table" then
    if seen[value] then    -- value already saved?
      result=result.."->"..seen[value].."\n"  -- use its previous name
      log.info(result)
      result = ""
      else
      seen[value] = name   -- save name for next time
      result=result.."{}\n"     -- create a new table
      log.info(result)
      result = ""
        for k,v in pairs(value) do      -- save its fields
        local fieldname = string.format("%s[%s]", name,
                                        basic_dump(k))
        if fieldname~="_G[\"seen\"]" then
          result=dump1(fieldname, v, seen, result)
        end
      end
    end
  end
  return result
end

-- log.info("=====================================================")
-- param = list_cockpit_params()
-- dump("_G", _G)
-- dump("_G", getmetatable(_G))

-- dump("GetSelf", GetSelf())
-- dump("GetSelf", getmetatable(GetSelf()))

-- dump("GetRenderTarget", GetRenderTarget())
-- dump("GetRenderTarget", getmetatable(GetRenderTarget()))

-- dump("ccIndicator", ccIndicator)


-- Utility functions/classes

function startup_print(...)
    print(...)
end


-- rounds the number 'num' to the number of decimal places in 'idp'
--
-- print(round(107.75, -1))     : 110.0
-- print(round(107.75, 0))      : 108.0
-- print(round(107.75, 1))      : 107.8
function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function clamp(value, minimum, maximum)
	return math.max(math.min(value,maximum),minimum)
end

-- calculates the x,y,z in russian coordinates of the point that is 'radius' distance away
-- from px,py,pz using the x,z angle of 'hdg' and the vertical slant angle
-- of 'slantangle'
function pointFromVector( px, py, pz, hdg, slantangle, radius )
    local x = px + (radius * math.cos(hdg) * math.cos(slantangle))
    local z = pz + (radius * math.sin(-hdg) * math.cos(slantangle))  -- pi/2 radians is west
    local y = py + (radius * math.sin(slantangle))

    return x,y,z
end
 
-- return GCD of m,n
function gcd(m, n)
    while m ~= 0 do
        m, n = math.fmod(n, m), m;
    end
    return n;
end


function LinearTodB(value)
    return math.pow(value, 3)
end


-- jumpwheel()
-- 
-- utility function to generate an animation argument for numberwhels that animate from 0.x11 to 0.x19
-- useful for "whole number" output dials, or any case where the decimal component determines when to
-- do the rollover.  All digits will roll at the same time as the ones digit, if they should roll.
--
-- input 'number' is the original raw number (e.g. 397.3275) and which digit position you want to draw
-- input 'position' is which digit position you want to generate an animation argument
--
-- technique: for aBcc.dd, where B is the position we're asking about, we break the number up into
--            component parts:
--            
--            a is throwaway.
--            B will become the first digit of the output.
--            cc tells us whether we're rolling or not.  All digits in cc must be "9".
--            dd is used for 0.Bdd as the return if we're going to be rolling B.
--
function jumpwheel(number, position)
    local rolling = false
    local a,dd = math.modf( number )                -- gives us aBcc in a, and .dd in dd

    a = math.fmod( a, 10^position )                 -- strips a to give us Bcc in a
    local B = math.floor( a / (10^(position-1)) )   -- gives us B by itself
    local cc = math.fmod( a, 10^(position-1) )      -- gives us cc by itself

    if cc == (10^(position-1)-1) then
        rolling = true                              -- if all the digits to the right are 9, then we are rolling based on the decimal component
    end

    if rolling then
        return( (B+dd)/10 )
    else
        return B/10
    end
end

---------------------------------------------
--[[
Function to recursively dump a table to a string, can be used to gain introspection into _G too
Usage:
str=dump("_G",_G)
print(str)  -- or log to DCS log file (log.alert), or print_message_to_user etc.
--]]
function basic_dump (o)
  if type(o) == "number" then
    return tostring(o)
  elseif type(o) == "string" then
    return string.format("%q", o)
  else -- nil, boolean, function, userdata, thread; assume it can be converted to a string
    return tostring(o)
  end
end


function dump (name, value, saved, result)
  seen = seen or {}       -- initial value
  result = result or ""
  result=result..name.." = "
  if type(value) ~= "table" then
    result=result..basic_dump(value).."\n"
  elseif type(value) == "table" then
    if seen[value] then    -- value already saved?
      result=result.."->"..seen[value].."\n"  -- use its previous name
    else
      seen[value] = name   -- save name for next time
      result=result.."{}\n"     -- create a new table
      for k,v in pairs(value) do      -- save its fields
        local fieldname = string.format("%s[%s]", name,
                                        basic_dump(k))
        if fieldname~="_G[\"seen\"]" then
          result=dump(fieldname, v, seen, result)
        end
      end
    end
  end
  return result
end

function strsplit(delimiter, text)
  local list = {}
  local pos = 1
  if string.find("", delimiter, 1) then
    return {}
  end
  while 1 do
    local first, last = string.find(text, delimiter, pos)
    if first then -- found?
      table.insert(list, string.sub(text, pos, first-1))
      pos = last+1
    else
      table.insert(list, string.sub(text, pos))
      break
    end
  end
  return list
end

---------------------------------------------
---------------------------------------------
--[[
PID Controller class (Proportional-Integral-Derivative Controller)
(backward Euler discrete form)
--]]

PID = {} -- the table representing the class, which will double as the metatable for the instances
PID.__index = PID -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(PID, {
  __call = function( cls, ... )
    return cls.new(...) -- automatically call constructor when class is called like a function, e.g. a=PID() is equivalent to a=PID.new()
  end,
})

function PID.new( Kp, Ki, Kd, umin, umax, uscale )
    local self = setmetatable({}, PID)

    self.Kp = Kp or 1   -- default to a weight=1 "P" controller
    self.Ki = Ki or 0
    self.Kd = Kd or 0

    self.k1 = self.Kp + self.Ki + self.Kd
    self.k2 = -self.Kp - 2*self.Kd
    self.k3 = self.Kd

    self.e2 = 0     -- error term history for I/D functions
    self.e1 = 0
    self.e = 0

    self.du = 0     -- delta U()
    self.u = 0      -- U() term for output

    self.umax = umax or 999999  -- allow bounding of e for PID output limits
    self.umin = umin or -999999
    self.uscale = uscale or 1   -- allow embedded output scaling and range limiting

    return self
end

-- used to tune Kp on the fly
function PID:set_Kp( val )
    self.Kp = val
    self.k1 = self.Kp + self.Ki + self.Kd
    self.k2 = -self.Kp - 2*self.Kd
end

-- used to tune Kp on the fly
function PID:get_Kp()
    return self.Kp
end

-- used to tune Ki on the fly
function PID:set_Ki( val )
    self.Ki = val
    self.k1 = self.Kp + self.Ki + self.Kd
end

-- used to tune Ki on the fly
function PID:get_Ki()
    return self.Ki
end

-- used to tune Kd on the fly
function PID:set_Kd( val )
    self.Kd = val
    self.k1 = self.Kp + self.Ki + self.Kd
    self.k2 = -self.Kp - 2*self.Kd
    self.k3 = self.Kd
end

-- used to tune Kd on the fly
function PID:get_Kd()
    return self.Kd
end

function PID:run( setpoint, mv )
    self.e2 = self.e1
    self.e1 = self.e
    self.e = setpoint - mv

    -- backward Euler discrete PID function
    self.du = self.k1*self.e + self.k2*self.e1 + self.k3*self.e2
    self.u = self.u + self.du

    if self.u < self.umin then
        self.u = self.umin
    elseif self.u > self.umax then
        self.u = self.umax
    end

    return self.u*self.uscale
end

-- reset dynamic state
function PID:reset(u)
    self.e2 = 0
    self.e1 = 0
    self.e = 0

    self.du = 0
    if u then
        self.u = u/self.uscale
    else
        self.u = 0
    end
end


---------------------------------------------
---------------------------------------------
--[[
Weighted moving average class, useful for supplying values to gauges in an exponential decay/growth form (avoid instantaneous step values)
It keeps only a single previous value, the pseudocode is:
  prev_value = (weight*new_value + (1-weight)*prev_value)
Example usage:
myvar=WMA(0.15,0)   -- create the object (once off), first param is weight for newest values, second param is initial value, both params optional
-- use the object repeatedly, the value passed is stored internally in the object and the return value is the weighted moving average
gauge_param:set(myvar:get_WMA(new_val))

0.15 is a good value to use for gauges, it takes about 20 steps to achieve 95% of a new set point value
--]]

WMA = {} -- the table representing the class, which will double as the metatable for the instances
WMA.__index = WMA -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(WMA, {
  __call = function (cls, ...)
    return cls.new(...) -- automatically call constructor when class is called like a function, e.g. a=WMA() is equivalent to a=WMA.new()
  end,
})

-- Create a new instance of the object.
-- latest_weight must be between 0.01 and 1,  defaults to 0.5 if not supplied.
-- init_val sets the initial value, if not supplied it will be initialized the first time get_WMA() is called
function WMA.new (latest_weight, init_val)
  local self = setmetatable({}, WMA)

  self.cur_weight=latest_weight or 0.5 -- default to 0.5 if not passed as param
  if self.cur_weight>1.0 then
  	self.cur_weight=1.0
  end
  if self.cur_weight<0.01 then
  	self.cur_weight=0.01
  end
  self.cur_val = init_val  -- can be nil if not passed, will be initialized first time get_WMA() is called
  self.target_val = self.cur_val
  return self
end

-- this updates current value based on weighted moving average with new value v, and returns the weighted moving average
-- the target value v is kept internally and can be retrieved with the get_target_val() function
function WMA:get_WMA (v)
  self.target_val = v
  if not self.cur_val then
  	self.cur_val=v
  	return self.cur_val
  end
  self.cur_val = self.cur_val+(v-self.cur_val)*self.cur_weight
  return self.cur_val
end

-- if necessary to update the current value instantaneously (bypass weighted moving average)
function WMA:set_current_val (v)
    self.cur_val = v
    self.target_val = v
end

-- if necessary to read the current weighted average value (without updating the weighted moving average with a new value)
function WMA:get_current_val ()
    return self.cur_val
end

-- read the target value (latest value passed to the get_WMA() function)
function WMA:get_target_val ()
    return self.target_val
end

--[[
-- test code
target_cur={}
table.insert(target_cur, {600,0})
table.insert(target_cur, {0,600})

for k,v in ipairs(target_cur) do
	target=v[1]
	cur=v[2]

	print("--- "..cur,target)
	myvar=WMA(0.15,cur)
	for j=1,20 do
		print(myvar:get_WMA(target))
	end
end
--]]

---------------------------------------------


---------------------------------------------
--[[
Weighted moving average class that treats [range_min,range_max] as wraparound, useful for supplying values to circular gauges in an exponential decay/growth form (avoid instantaneous step values)
It keeps only a single previous value, the pseudocode is:
  prev_value = ((prev_value+weight*(wrapped(new_value-old_value)))
Example usage:
myvar=WMA_wrap(0.15,0)   -- create the object (once off), first param is weight for newest values, second param is initial value, both params optional
-- use the object repeatedly, the value passed is stored internally in the object and the return value is the weighted moving average wrapped between range_min and range_max
gauge_param:set(myvar:get_WMA_wrap(new_val))

0.15 is a good value to use for gauges, it takes about 20 steps to achieve 95% of a new set point value
--]]

WMA_wrap = {} -- the table representing the class, which will double as the metatable for the instances
WMA_wrap.__index = WMA_wrap -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(WMA_wrap, {
  __call = function (cls, ...)
    return cls.new(...) -- automatically call constructor when class is called like a function, e.g. a=WMA_wrap() is equivalent to a=WMA_wrap.new()
  end,
})

-- Create a new instance of the object.
-- latest_weight must be between 0.01 and 1,  defaults to 0.5 if not supplied.
-- init_val sets the initial value, if not supplied it will be initialized the first time get_WMA_wrap() is called
-- range_min defaults to 0, range_max defaults to 1
function WMA_wrap.new (latest_weight, init_val, range_min, range_max)
  local self = setmetatable({}, WMA_wrap)

  self.cur_weight=latest_weight or 0.5 -- default to 0.5 if not passed as param
  if self.cur_weight>1.0 then
  	self.cur_weight=1.0
  end
  if self.cur_weight<0.01 then
  	self.cur_weight=0.01
  end
  self.cur_val = init_val  -- can be nil if not passed, will be initialized first time get_WMA_wrap() is called
  self.target_val = self.cur_val
  self.range_min=math.min(range_min or 0.0, range_max or 1.0)
  self.range_max=math.max(range_min or 0.0, range_max or 1.0)
  self.range_delta=range_max-range_min;
  self.range_thresh=self.range_delta/8192
  return self
end

-- this can almost certainly be simplified, but I was lazy and did it the straightforward way
local function get_shortest_delta(target,cur,min,max)
	local d1,d2,delta
	if target>=cur then
		d1=target-cur
		d2=cur-min+(max-target)
		if d2<d1 then
			delta=-d2
		else
			delta=d1
		end
	else
		d1=cur-target
		d2=target-min+(max-cur)
		if d1<d2 then
			delta=-d1
		else
			delta=d2
		end
	end
	return delta
end

-- this updates current value based on weighted moving average with new value v, and returns the weighted moving average
-- the target value v is kept internally and can be retrieved with the get_target_val() function
-- it wraps within [range_min,range_max] and also moves in the shortest direction (clockwise or anticlockwise) between two points
function WMA_wrap:get_WMA_wrap (v)
  self.target_val = v
  if not self.cur_val then
  	self.cur_val=v
  	return self.cur_val
  end
  delta=get_shortest_delta(v, self.cur_val, self.range_min, self.range_max)
  self.cur_val=self.cur_val+(delta*self.cur_weight)
  if math.abs(delta)<self.range_thresh then
    self.cur_val=self.target_val
  end
  if self.cur_val>self.range_max then
  	self.cur_val=self.cur_val-self.range_delta
  elseif self.cur_val<self.range_min then
  	self.cur_val=self.cur_val+self.range_delta
  end
  return self.cur_val
end

-- if necessary to update the current value instantaneously (bypass weighted moving average)
function WMA_wrap:set_current_val (v)
    self.cur_val = v
    self.target_val = v
end

-- if necessary to read the current weighted average value (without updating the weighted moving average with a new value)
function WMA_wrap:get_current_val ()
    return self.cur_val
end

-- read the target value (latest value passed to the get_WMA_wrap() function)
function WMA_wrap:get_target_val ()
    return self.target_val
end

--------------------------------------------------------------------

Constant_Speed_Controller = {}
Constant_Speed_Controller.__index = Constant_Speed_Controller
setmetatable(Constant_Speed_Controller,
  {
    __call = function(cls, ...)
        return cls.new(...) --call constructor if someone calls this table
    end
  }
)

function Constant_Speed_Controller.new(speed, min, max, pos)
  local self = setmetatable({}, Constant_Speed_Controller)
  self.speed = speed
  self.min = min
  self.max = max
  self.pos = pos
  return self
end

function Constant_Speed_Controller:update(target)

  local p = self.pos
  local direction = target - self.pos

  if math.abs(direction) <= self.speed then
    self.pos = target
  elseif direction < 0.0 then
    self.pos = self.pos - self.speed
  elseif direction > 0.0 then
    self.pos = self.pos + self.speed
  end

end

function Constant_Speed_Controller:get_position()
  return self.pos
end










--------------------------------------------------------------------

--[[
Description
Recursively descends both meta and regular tables and prints their key : value pairs until
limits are reached or the table is exhausted.

@param[in] table_to_print 		root of the tables to recursively explore
@param[in] max_depth				how many levels are recursion (not function recursion) are allowed.
@param[in] max_number_tables		how many different tables are allowed to be processed in total
@param[in] filepath				path to put this data

@return VOID
]]--
function recursively_print(table_to_print, max_depth, max_number_tables, filepath)
	file = io.open(filepath, "w")
	file:write("Key,Value\n")
	
	stack = {}
	
	table.insert(stack, {key = "start", value = table_to_print, level = 0})
	
	total = 0
	
	hash_table = {}

	hash_table[tostring(hash_table)] = 2
	hash_table[tostring(stack)] = 2
	
	item = true
	while (item) do
		item = table.remove(stack)
		
		if (item == nil) then
			break
		end
		key = item.key
		value = item.value
		level = item.level
		
		file:write(string.rep("\t", level)..tostring(key).." = "..tostring(value).."\n")
		
		hash = hash_table[tostring(value)]
		valid_table = (hash == nil or hash < 2)
		
		if (type(value) == "table" and valid_table) then
			for k,v in pairs(value) do
				if (v ~= nil and level <= max_depth and total < max_number_tables) then
					table.insert(stack, {key = k, value = v, level = level+1})
					if (type(v) == "table") then
						if (hash_table[tostring(v)] == nil) then
							hash_table[tostring(v)] = 1
						elseif (hash_table[tostring(v)] < 2) then
							hash_table[tostring(v)] = 2
						end
						total = total + 1
					end
				end
			end
		end
		
		if (getmetatable(value) and valid_table) then
			for k,v in pairs(getmetatable(value)) do
				if (v ~= nil and level <= max_depth and total < max_number_tables) then
					table.insert(stack, {key = k, value = v, level = level+1})
					if (type(v) == "table") then
						if (hash_table[tostring(v)] == nil) then
							hash_table[tostring(v)] = 1
						elseif (hash_table[tostring(v)] < 2) then
							hash_table[tostring(v)] = 2
						end
						total = total + 1
					end
				end
			end
		end
	end
	
	file:close()
end

--[[
-- test code
target_cur={}
table.insert(target_cur, {350,10})
table.insert(target_cur, {10,350})
table.insert(target_cur, {280,90})
table.insert(target_cur, {90,280})

for k,v in ipairs(target_cur) do
	target=v[1]
	cur=v[2]

	print("--- "..cur,target)
	myvar=WMA_wrap(0.15,cur,0,360)
	for j=1,20 do
		print(myvar:get_WMA_wrap(target))
	end
end
--]]
---------------------------------------------


-- _G = {}
-- _G["basic_dump"] = function: 000002D28527FAB0
-- _G["dofile"] = function: 000002D2872717A0
-- _G["_G"] = ->_G
-- _G["dump"] = function: 000002D28527FB70
-- _G = {}
-- _G["__index"] = {}
-- _G["__index"]["get_aircraft_mission_data"] = function: 000002D271B7D530
-- _G["__index"]["MakeFont"] = function: 000002D271B7D440
-- _G["__index"]["tostring"] = function: 000002D271B77AD0
-- _G["__index"]["get_player_crew_index"] = function: 000002D271B7CDB0
-- _G["__index"]["set_crew_member_seat_adjustment"] = function: 000002D271B7D5C0
-- _G["__index"]["create_guid_string"] = function: 000002D271B7D380
-- _G["__index"]["os"] = {}
-- _G["__index"]["os"]["getpid"] = function: 000002D271B7A0E0
-- _G["__index"]["os"]["date"] = function: 000002D271B7A3E0
-- _G["__index"]["os"]["getenv"] = function: 000002D276FCD890
-- _G["__index"]["os"]["difftime"] = function: 000002D271B79FF0
-- _G["__index"]["os"]["remove"] = function: 000002D271B7A080
-- _G["__index"]["os"]["time"] = function: 000002D271B7A3B0
-- _G["__index"]["os"]["run_process"] = function: 000002D271B79A50
-- _G["__index"]["os"]["clock"] = function: 000002D271B77920
-- _G["__index"]["os"]["open_uri"] = function: 000002D271B7A230
-- _G["__index"]["os"]["rename"] = function: 000002D271B79AE0
-- _G["__index"]["os"]["execute"] = function: 000002D276FCD4D0
-- _G["__index"]["USE_TERRAIN4"] = true
-- _G["__index"]["list_cockpit_params"] = function: 000002D271B7CCC0
-- _G["__index"]["pairs"] = function: 000002D276FCCD10
-- _G["__index"]["get_param_handle"] = function: 000002D271B7C810
-- _G["__index"]["get_mission_route"] = function: 000002D271B7C360
-- _G["__index"]["get_random_orderly"] = function: 000002D271B7BF10
-- _G["__index"]["get_input_devices"] = function: 000002D271B7C090
-- _G["__index"]["get_cockpit_draw_argument_value"] = function: 000002D271B7D500
-- _G["__index"]["get_terrain_related_data"] = function: 000002D271B7C6F0
-- _G["__index"]["UTF8_substring"] = function: 000002D271B7C4B0
-- _G["__index"]["coroutine_create"] = function: 000002D271B7B400
-- _G["__index"]["set_aircraft_draw_argument_value"] = function: 000002D271B7D0E0
-- _G["__index"]["ED_PUBLIC_AVAILABLE"] = true
-- _G["__index"]["get_random_evenly"] = function: 000002D271B7C8D0
-- _G["__index"]["Copy"] = function: 000002D271B7D0B0
-- _G["__index"]["coroutine"] = {}
-- _G["__index"]["coroutine"]["resume"] = function: 000002D271B78850
-- _G["__index"]["coroutine"]["yield"] = function: 000002D271B78490
-- _G["__index"]["coroutine"]["status"] = function: 000002D271B78910
-- _G["__index"]["coroutine"]["wrap"] = function: 000002D271B78310
-- _G["__index"]["coroutine"]["create"] = function: 000002D271B77770
-- _G["__index"]["coroutine"]["running"] = function: 000002D271B78D00
-- _G["__index"]["get_plugin_option_value"] = function: 000002D271B7C000
-- _G["__index"]["copy_to_mission_and_dofile"] = function: 000002D271B7C750
-- _G["__index"]["loadstring"] = function: 000002D271B77C50
-- _G["__index"]["string"] = {}
-- _G["__index"]["string"]["sub"] = function: 000002D271B7A500
-- _G["__index"]["string"]["upper"] = function: 000002D271B79D50
-- _G["__index"]["string"]["len"] = function: 000002D271B79F00
-- _G["__index"]["string"]["gfind"] = function: 000002D271B79E70
-- _G["__index"]["string"]["rep"] = function: 000002D271B79FC0
-- _G["__index"]["string"]["find"] = function: 000002D271B7A470
-- _G["__index"]["string"]["match"] = function: 000002D271B7A0B0
-- _G["__index"]["string"]["char"] = function: 000002D271B78970
-- _G["__index"]["string"]["dump"] = function: 000002D271B78CA0
-- _G["__index"]["string"]["gmatch"] = function: 000002D271B79E70
-- _G["__index"]["string"]["reverse"] = function: 000002D271B79C00
-- _G["__index"]["string"]["byte"] = function: 000002D271B77D40
-- _G["__index"]["string"]["format"] = function: 000002D271B7A290
-- _G["__index"]["string"]["gsub"] = function: 000002D271B79C60
-- _G["__index"]["string"]["lower"] = function: 000002D271B7A380
-- _G["__index"]["a_cockpit_lock_player_seat"] = function: 000002D271B7CE40
-- _G["__index"]["mount_vfs_path_to_mount_point"] = function: 000002D271B7C0F0
-- _G["__index"]["print"] = function: 000002D271B78820
-- _G["__index"]["get_option_value"] = function: 000002D271B7C840
-- _G["__index"]["a_cockpit_highlight_position"] = function: 000002D271B7CA80
-- _G["__index"]["table"] = {}
-- _G["__index"]["table"]["setn"] = function: 000002D271B799C0
-- _G["__index"]["table"]["insert"] = function: 000002D271B79930
-- _G["__index"]["table"]["getn"] = function: 000002D271B78CD0
-- _G["__index"]["table"]["foreachi"] = function: 000002D271B78400
-- _G["__index"]["table"]["maxn"] = function: 000002D271B79540
-- _G["__index"]["table"]["foreach"] = function: 000002D271B78670
-- _G["__index"]["table"]["concat"] = function: 000002D271B784F0
-- _G["__index"]["table"]["sort"] = function: 000002D271B791E0
-- _G["__index"]["table"]["remove"] = function: 000002D271B78FD0
-- _G["__index"]["_ARCHITECTURE"] = "x86_64"
-- _G["__index"]["c_cockpit_param_equal_to"] = function: 000002D271B7CB70
-- _G["__index"]["get_absolute_model_time"] = function: 000002D271B7C990
-- _G["__index"]["_ED_VERSION"] = "DCS/2.5.6.60966 (x86_64; Windows NT 10.0.18363)"
-- _G["__index"]["ipairs"] = function: 000002D276FCCE90
-- _G["__index"]["collectgarbage"] = function: 000002D271B77C20
-- _G["__index"]["c_cockpit_param_in_range"] = function: 000002D271B7D2F0
-- _G["__index"]["Add"] = function: 000002D271B7D200
-- _G["__index"]["print_message_to_user"] = function: 000002D271B7C8A0
-- _G["__index"]["c_start_wait_for_user"] = function: 000002D271B7CD20
-- _G["__index"]["track_is_reading"] = function: 000002D271B7C240
-- _G["__index"]["math"] = {}
-- _G["__index"]["math"]["log"] = function: 000002D271B7ADD0
-- _G["__index"]["math"]["max"] = function: 000002D271B7B0A0
-- _G["__index"]["math"]["acos"] = function: 000002D271B7A1A0
-- _G["__index"]["math"]["huge"] = inf
-- _G["__index"]["math"]["ldexp"] = function: 000002D271B7AC20
-- _G["__index"]["math"]["pi"] = 3.1415926535898
-- _G["__index"]["math"]["cos"] = function: 000002D271B7A680
-- _G["__index"]["math"]["tanh"] = function: 000002D271B7AF50
-- _G["__index"]["math"]["pow"] = function: 000002D271B7AD70
-- _G["__index"]["math"]["deg"] = function: 000002D271B7AE30
-- _G["__index"]["math"]["tan"] = function: 000002D271B7AFB0
-- _G["__index"]["math"]["cosh"] = function: 000002D271B7AE60
-- _G["__index"]["math"]["sinh"] = function: 000002D271B7A6E0
-- _G["__index"]["math"]["random"] = function: 000002D271B7A8F0
-- _G["__index"]["math"]["randomseed"] = function: 000002D271B7AF20
-- _G["__index"]["math"]["frexp"] = function: 000002D271B7AA10
-- _G["__index"]["math"]["ceil"] = function: 000002D271B7A950
-- _G["__index"]["math"]["floor"] = function: 000002D271B7A830
-- _G["__index"]["math"]["rad"] = function: 000002D271B7AD40
-- _G["__index"]["math"]["abs"] = function: 000002D271B7A140
-- _G["__index"]["math"]["sqrt"] = function: 000002D271B7A7D0
-- _G["__index"]["math"]["modf"] = function: 000002D271B7B1F0
-- _G["__index"]["math"]["asin"] = function: 000002D271B7A620
-- _G["__index"]["math"]["min"] = function: 000002D271B7B0D0
-- _G["__index"]["math"]["mod"] = function: 000002D271B7AE90
-- _G["__index"]["math"]["fmod"] = function: 000002D271B7AE90
-- _G["__index"]["math"]["log10"] = function: 000002D271B7AE00
-- _G["__index"]["math"]["atan2"] = function: 000002D271B7ABF0
-- _G["__index"]["math"]["exp"] = function: 000002D271B7ACE0
-- _G["__index"]["math"]["sin"] = function: 000002D271B7A9E0
-- _G["__index"]["math"]["atan"] = function: 000002D271B7ABC0
-- _G["__index"]["pcall"] = function: 000002D271B77E90
-- _G["__index"]["type"] = function: 000002D271B78130
-- _G["__index"]["a_cockpit_remove_highlight"] = function: 000002D271B7D290
-- _G["__index"]["lfs"] = {}
-- _G["__index"]["lfs"]["normpath"] = function: 000002D271B79600
-- _G["__index"]["lfs"]["locations"] = function: 000002D271B79450
-- _G["__index"]["lfs"]["dir"] = function: 000002D271B79090
-- _G["__index"]["lfs"]["tempdir"] = function: 000002D271B79330
-- _G["__index"]["lfs"]["realpath"] = function: 000002D271B79780
-- _G["__index"]["lfs"]["writedir"] = function: 000002D271B792D0
-- _G["__index"]["lfs"]["mkdir"] = function: 000002D271B79960
-- _G["__index"]["lfs"]["currentdir"] = function: 000002D271B796F0
-- _G["__index"]["lfs"]["add_location"] = function: 000002D271B79510
-- _G["__index"]["lfs"]["attributes"] = function: 000002D271B796C0
-- _G["__index"]["lfs"]["create_lockfile"] = function: 000002D271B7A200
-- _G["__index"]["lfs"]["md5sum"] = function: 000002D271B79840
-- _G["__index"]["lfs"]["del_location"] = function: 000002D271B79720
-- _G["__index"]["lfs"]["chdir"] = function: 000002D271B79210
-- _G["__index"]["lfs"]["rmdir"] = function: 000002D271B79A20
-- _G["__index"]["copy_to_mission_and_get_buffer"] = function: 000002D271B7C9F0
-- _G["__index"]["GetHalfWidth"] = function: 000002D271B7D1D0
-- _G["__index"]["get_model_time"] = function: 000002D271B7C870
-- _G["__index"]["GetHalfHeight"] = function: 000002D271B7CED0
-- _G["__index"]["loadfile"] = function: 000002D271B78430
-- _G["__index"]["log"] = {}
-- _G["__index"]["log"]["FULL"] = 263
-- _G["__index"]["log"]["TIME_LOCAL"] = 129
-- _G["__index"]["log"]["ALL"] = 255
-- _G["__index"]["log"]["set_output"] = function: 000002D271B7BD90
-- _G["__index"]["log"]["LEVEL"] = 2
-- _G["__index"]["log"]["DEBUG"] = 128
-- _G["__index"]["log"]["IMMEDIATE"] = 1
-- _G["__index"]["log"]["ASYNC"] = 0
-- _G["__index"]["log"]["MODULE"] = 4
-- _G["__index"]["log"]["ALERT"] = 2
-- _G["__index"]["log"]["RELIABLE"] = 32768
-- _G["__index"]["log"]["warning"] = function: 000002D276FCD850
-- _G["__index"]["log"]["debug"] = function: 000002D276FCD910
-- _G["__index"]["log"]["write"] = function: 000002D271B7BA00
-- _G["__index"]["log"]["printf"] = function: 000002D271B7BBE0
-- _G["__index"]["log"]["TIME_UTC"] = 1
-- _G["__index"]["log"]["TIME"] = 1
-- _G["__index"]["log"]["WARNING"] = 16
-- _G["__index"]["log"]["INFO"] = 64
-- _G["__index"]["log"]["error"] = function: 000002D276FCD490
-- _G["__index"]["log"]["info"] = function: 000002D276FCD390
-- _G["__index"]["log"]["ERROR"] = 8
-- _G["__index"]["log"]["TIME_RELATIVE"] = 128
-- _G["__index"]["log"]["TRACE"] = 256
-- _G["__index"]["log"]["alert"] = function: 000002D276FCD450
-- _G["__index"]["log"]["MESSAGE"] = 0
-- _G["__index"]["gcinfo"] = function: 000002D271B780A0
-- _G["__index"]["LockOn_Options"] = {}
-- _G["__index"]["LockOn_Options"]["script_path"] = "C:\\Users\\cadre\\Saved Games\\DCS\\Mods/aircraft/A-29B/Cockpit/Scripts/"
-- _G["__index"]["LockOn_Options"]["cockpit_language"] = "russian"
-- _G["__index"]["LockOn_Options"]["common_script_path"] = "Scripts/Aircrafts/_Common/Cockpit/"
-- _G["__index"]["LockOn_Options"]["date"] = {}
-- _G["__index"]["LockOn_Options"]["date"]["year"] = 2236
-- _G["__index"]["LockOn_Options"]["date"]["day"] = 22
-- _G["__index"]["LockOn_Options"]["date"]["month"] = 4
-- _G["__index"]["LockOn_Options"]["flight"] = {}
-- _G["__index"]["LockOn_Options"]["flight"]["unlimited_fuel"] = false
-- _G["__index"]["LockOn_Options"]["flight"]["g_effects"] = "realistic"
-- _G["__index"]["LockOn_Options"]["flight"]["radio_assist"] = false
-- _G["__index"]["LockOn_Options"]["flight"]["unlimited_weapons"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["external_view"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["easy_radar"] = false
-- _G["__index"]["LockOn_Options"]["flight"]["easy_flight"] = false
-- _G["__index"]["LockOn_Options"]["flight"]["external_labels"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["crash_recovery"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["immortal"] = false
-- _G["__index"]["LockOn_Options"]["flight"]["tool_tips_enable"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["padlock"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["aircraft_switching"] = true
-- _G["__index"]["LockOn_Options"]["screen"] = {}
-- _G["__index"]["LockOn_Options"]["screen"]["height"] = 1080
-- _G["__index"]["LockOn_Options"]["screen"]["aspect"] = 1.7777777910233
-- _G["__index"]["LockOn_Options"]["screen"]["width"] = 1920
-- _G["__index"]["LockOn_Options"]["cockpit"] = {}
-- _G["__index"]["LockOn_Options"]["cockpit"]["mirrors"] = false
-- _G["__index"]["LockOn_Options"]["cockpit"]["reflections"] = false
-- _G["__index"]["LockOn_Options"]["cockpit"]["use_nightvision_googles"] = false
-- _G["__index"]["LockOn_Options"]["cockpit"]["render_target_resolution"] = 1024
-- _G["__index"]["LockOn_Options"]["time"] = {}
-- _G["__index"]["LockOn_Options"]["time"]["hours"] = 12
-- _G["__index"]["LockOn_Options"]["time"]["seconds"] = 0
-- _G["__index"]["LockOn_Options"]["time"]["minutes"] = 0
-- _G["__index"]["LockOn_Options"]["avionics_language"] = "native"
-- _G["__index"]["LockOn_Options"]["measurement_system"] = "imperial"
-- _G["__index"]["LockOn_Options"]["init_conditions"] = {}
-- _G["__index"]["LockOn_Options"]["init_conditions"]["birth_place"] = "AIR_HOT"
-- _G["__index"]["LockOn_Options"]["mission"] = {}
-- _G["__index"]["LockOn_Options"]["mission"]["file_path"] = "stub"
-- _G["__index"]["LockOn_Options"]["mission"]["description"] = "stub"
-- _G["__index"]["LockOn_Options"]["mission"]["title"] = "stub"
-- _G["__index"]["LockOn_Options"]["mission"]["campaign"] = ""
-- _G["__index"]["mount_vfs_model_path"] = function: 000002D271B7C720
-- _G["__index"]["getfenv"] = function: 000002D271B77710
-- _G["__index"]["a_cockpit_unlock_player_seat"] = function: 000002D271B7CBD0
-- _G["__index"]["dbg_print"] = function: 000002D271B7C2D0
-- _G["__index"]["c_indication_txt_equal_to"] = function: 000002D271B7CF90
-- _G["__index"]["module"] = function: 000002D271B78AF0
-- _G["__index"]["MakeMaterial"] = function: 000002D271B7D3B0
-- _G["__index"]["_G"] = ->_G["__index"]
-- _G["__index"]["list_indication"] = function: 000002D271B7CBA0
-- _G["__index"]["geo_to_lo_coords"] = function: 000002D271B7C7E0
-- _G["__index"]["a_cockpit_param_save_as"] = function: 000002D271B7D590
-- _G["__index"]["switch_labels_off"] = function: 000002D271B7CC90
-- _G["__index"]["ED_FINAL_VERSION"] = true
-- _G["__index"]["get_aircraft_property_or_nil"] = function: 000002D271B7D140
-- _G["__index"]["get_aircraft_type"] = function: 000002D271B7CD80
-- _G["__index"]["c_cockpit_highlight_visible"] = function: 000002D271B7CB40
-- _G["__index"]["xpcall"] = function: 000002D271B78790
-- _G["__index"]["package"] = {}
-- _G["__index"]["package"]["preload"] = {}
-- _G["__index"]["package"]["loadlib"] = function: 000002D271B78B50
-- _G["__index"]["package"]["loaded"] = {}
-- _G["__index"]["package"]["loaded"]["string"] = ->_G["__index"]["string"]
-- _G["__index"]["package"]["loaded"]["debug"] = {}
-- _G["__index"]["package"]["loaded"]["debug"]["getupvalue"] = function: 000002D271B7BDC0
-- _G["__index"]["package"]["loaded"]["debug"]["debug"] = function: 000002D271B7B010
-- _G["__index"]["package"]["loaded"]["debug"]["sethook"] = function: 000002D271B7B580
-- _G["__index"]["package"]["loaded"]["debug"]["getmetatable"] = function: 000002D271B7BAF0
-- _G["__index"]["package"]["loaded"]["debug"]["gethook"] = function: 000002D271B7AAA0
-- _G["__index"]["package"]["loaded"]["debug"]["setmetatable"] = function: 000002D271B7B910
-- _G["__index"]["package"]["loaded"]["debug"]["setlocal"] = function: 000002D271B7B820
-- _G["__index"]["package"]["loaded"]["debug"]["traceback"] = function: 000002D271B7B5E0
-- _G["__index"]["package"]["loaded"]["debug"]["setfenv"] = function: 000002D271B7BD30
-- _G["__index"]["package"]["loaded"]["debug"]["getinfo"] = function: 000002D271B7A650
-- _G["__index"]["package"]["loaded"]["debug"]["setupvalue"] = function: 000002D271B7B310
-- _G["__index"]["package"]["loaded"]["debug"]["getlocal"] = function: 000002D271B7B070
-- _G["__index"]["package"]["loaded"]["debug"]["getregistry"] = function: 000002D271B7AB60
-- _G["__index"]["package"]["loaded"]["debug"]["getfenv"] = function: 000002D271B7B130
-- _G["__index"]["package"]["loaded"]["lfs"] = ->_G["__index"]["lfs"]
-- _G["__index"]["package"]["loaded"]["_G"] = ->_G["__index"]
-- _G["__index"]["package"]["loaded"]["i_18n"] = {}
-- _G["__index"]["package"]["loaded"]["i_18n"]["set_locale_dir"] = function: 000002D28714D0B0
-- _G["__index"]["package"]["loaded"]["i_18n"]["set_locale"] = function: 000002D28714D2C0
-- _G["__index"]["package"]["loaded"]["i_18n"]["init"] = function: 000002D271B6F2B0
-- _G["__index"]["package"]["loaded"]["i_18n"]["attach"] = function: 000002D29ABF4100
-- _G["__index"]["package"]["loaded"]["i_18n"]["get_locale"] = function: 000002D28714D0E0
-- _G["__index"]["package"]["loaded"]["i_18n"]["add_package"] = function: 000002D29ABF3FE0
-- _G["__index"]["package"]["loaded"]["i_18n"]["dtranslate"] = function: 000002D271B7D800
-- _G["__index"]["package"]["loaded"]["i_18n"]["remove_package"] = function: 000002D29ABF4310
-- _G["__index"]["package"]["loaded"]["i_18n"]["get_localized_filename"] = function: 000002D28714D140
-- _G["__index"]["package"]["loaded"]["i_18n"]["translate"] = function: 000002D28714D350
-- _G["__index"]["package"]["loaded"]["i_18n"]["set_package"] = function: 000002D28714D890
-- _G["__index"]["package"]["loaded"]["i_18n"]["get_localized_foldername"] = function: 000002D28714D620
-- _G["__index"]["package"]["loaded"]["io"] = {}
-- _G["__index"]["package"]["loaded"]["io"]["read"] = function: 000002D271B797B0
-- _G["__index"]["package"]["loaded"]["io"]["write"] = function: 000002D271B79120
-- _G["__index"]["package"]["loaded"]["io"]["close"] = function: 000002D271B799F0
-- _G["__index"]["package"]["loaded"]["io"]["lines"] = function: 000002D271B79180
-- _G["__index"]["package"]["loaded"]["io"]["flush"] = function: 000002D271B79900
-- _G["__index"]["package"]["loaded"]["io"]["open"] = function: 000002D271B78EE0
-- _G["__index"]["package"]["loaded"]["io"]["__gc"] = function: 000002D271B795A0
-- _G["__index"]["package"]["loaded"]["os"] = ->_G["__index"]["os"]
-- _G["__index"]["package"]["loaded"]["table"] = ->_G["__index"]["table"]
-- _G["__index"]["package"]["loaded"]["math"] = ->_G["__index"]["math"]
-- _G["__index"]["package"]["loaded"]["log"] = ->_G["__index"]["log"]
-- _G["__index"]["package"]["loaded"]["coroutine"] = ->_G["__index"]["coroutine"]
-- _G["__index"]["package"]["loaded"]["package"] = ->_G["__index"]["package"]
-- _G["__index"]["package"]["loaders"] = {}
-- _G["__index"]["package"]["loaders"][1] = function: 000002D271B788B0
-- _G["__index"]["package"]["loaders"][2] = function: 000002D276FCD0D0
-- _G["__index"]["package"]["loaders"][3] = function: 000002D271B78B20
-- _G["__index"]["package"]["loaders"][4] = function: 000002D271B783A0
-- _G["__index"]["package"]["loaders"][5] = function: 000002D271B78640
-- _G["__index"]["package"]["cpath"] = ".\\lua-?.dll;.\\?.dll;C:\\DCS World\\bin\\lua-?.dll;C:\\DCS World\\bin\\?.dll;"
-- _G["__index"]["package"]["config"] = "\\\




-- _G["__index"]["package"]["path"] = ".\\?.lua;C:\\DCS World\\bin\\lua\\?.lua;C:\\DCS World\\bin\\lua\\?\\init.lua;C:\\DCS World\\bin\\?.lua;C:\\DCS World\\bin\\?\\init.lua"
-- _G["__index"]["package"]["seeall"] = function: 000002D271B78DC0
-- _G["__index"]["_VERSION"] = "Lua 5.1"
-- _G["__index"]["i_18n"] = ->_G["__index"]["package"]["loaded"]["i_18n"]
-- _G["__index"]["get_aircraft_property"] = function: 000002D271B7D020
-- _G["__index"]["unpack"] = function: 000002D271B77B30
-- _G["__index"]["GetSelf"] = function: 000002D28527DEF0
-- _G["__index"]["get_plugin_option"] = function: 000002D271B7C330
-- _G["__index"]["require"] = function: 000002D271B785B0
-- _G["__index"]["find_viewport"] = function: 000002D271B7C570
-- _G["__index"]["debug"] = ->_G["__index"]["package"]["loaded"]["debug"]
-- _G["__index"]["GetAspect"] = function: 000002D271B7CC00
-- _G["__index"]["setmetatable"] = function: 000002D271B77F50
-- _G["__index"]["next"] = function: 000002D271B77D10
-- _G["__index"]["GetScale"] = function: 000002D271B7D350
-- _G["__index"]["assert"] = function: 000002D271B776E0
-- _G["__index"]["tonumber"] = function: 000002D271B77F80
-- _G["__index"]["io"] = ->_G["__index"]["package"]["loaded"]["io"]
-- _G["__index"]["SetCustomScale"] = function: 000002D271B7CAE0
-- _G["__index"]["SetScale"] = function: 000002D271B7D1A0
-- _G["__index"]["rawequal"] = function: 000002D271B778C0
-- _G["__index"]["elementmeta"] = {}
-- _G["__index"]["elementmeta"]["__index"] = function: 000002D271B7CEA0
-- _G["__index"]["elementmeta"]["__newindex"] = function: 000002D271B7CA50
-- _G["__index"]["get_dcs_plugin_path"] = function: 000002D271B7D2C0
-- _G["__index"]["load_mission_file"] = function: 000002D271B7C420
-- _G["__index"]["newproxy"] = function: 000002D276FCD710
-- _G["__index"]["load"] = function: 000002D271B779B0
-- _G["__index"]["a_cockpit_highlight_indication"] = function: 000002D271B7CDE0
-- _G["__index"]["CreateElement"] = function: 000002D271B7D080
-- _G["__index"]["get_aircraft_draw_argument_value"] = function: 000002D271B7BF70
-- _G["__index"]["a_cockpit_pop_actor"] = function: 000002D271B7CE10
-- _G["__index"]["a_cockpit_push_actor"] = function: 000002D271B7D5F0
-- _G["__index"]["rawset"] = function: 000002D271B77E00
-- _G["__index"]["get_base_data"] = function: 000002D271B7C2A0
-- _G["__index"]["mount_vfs_texture_archives"] = function: 000002D271B7C5A0
-- _G["__index"]["c_cockpit_param_is_equal_to_another"] = function: 000002D271B7CC60
-- _G["__index"]["a_start_listen_event"] = function: 000002D271B7CE70
-- _G["__index"]["save_to_mission"] = function: 000002D271B7C780
-- _G["__index"]["GetRenderTarget"] = function: 000002D271B7D260
-- _G["__index"]["c_stop_wait_for_user"] = function: 000002D271B7D170
-- _G["__index"]["get_non_sim_random_evenly"] = function: 000002D271B7BF40
-- _G["__index"]["c_argument_in_range"] = function: 000002D271B7D3E0
-- _G["__index"]["a_cockpit_perform_clickable_action"] = function: 000002D271B7CFF0
-- _G["__index"]["a_cockpit_highlight"] = function: 000002D271B7CCF0
-- _G["__index"]["do_mission_file"] = function: 000002D271B7C690
-- _G["__index"]["get_UIMainView"] = function: 000002D271B7BFD0
-- _G["__index"]["get_multimonitor_preset_name"] = function: 000002D271B7BFA0
-- _G["__index"]["select"] = function: 000002D271B780D0
-- _G["__index"]["get_clickable_element_reference"] = function: 000002D271B7CD50
-- _G["__index"]["getmetatable"] = function: 000002D271B78160
-- _G["__index"]["rawget"] = function: 000002D271B78010
-- _G["__index"]["lo_to_geo_coords"] = function: 000002D271B7BE50
-- _G["__index"]["a_start_listen_command"] = function: 000002D271B7CFC0
-- _G["__index"]["dispatch_action"] = function: 000002D271B7C1E0
-- _G["__index"]["dofile"] = function: 000002D271B78880
-- _G["__index"]["mount_vfs_texture_path"] = function: 000002D271B7C0C0
-- _G["__index"]["track_is_writing"] = function: 000002D271B7C480
-- _G["__index"]["error"] = function: 000002D271B77980
-- _G["__index"]["setfenv"] = function: 000002D271B77A70
-- GetSelf = {}
-- GetSelf["link"] = userdata: 000002D1CD9C8CB0
-- GetSelf = {}
-- GetSelf["__index"] = {}
-- GetSelf["__index"]["set_page"] = function: 000002D285284EB0
-- GetSelf["__index"]["add_purpose"] = function: 000002D285284E80
-- GetSelf["__index"]["remove_purpose"] = function: 000002D285284F40
-- GetRenderTarget = -1
-- GetRenderTarget = nil


-- _G["__index"]["LockOn_Options"]["screen"]["oculus_rift"] = true


-- The DCS A-10 uses GetRenderTarget() == 1 to determine if it is the left display, else it is the right display.  I don't know what the function is supposed to return, but it is not working for me.
-- AHA got it.  In case anyone is trying to do something similar, you define the render target ID in the indicators[] definition right after the position corrections