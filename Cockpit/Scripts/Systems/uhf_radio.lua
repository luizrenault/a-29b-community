dofile(LockOn_Options.common_script_path..'Radio.lua')
dofile(LockOn_Options.common_script_path.."mission_prepare.lua")

dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")


local gettext = require("i_18n")
_ = gettext.translate

local dev 	    = GetSelf()

local update_time_step = 1 --update will be called once per second
device_timer_dt = update_time_step

-- avReceiver
innerNoise 				= getInnerNoise(2.5E-6, 10.0) 	-- default 2e-6/pow(10,0.5) 	-- V/m (dB S+N/N)
frequency_accuracy 		= 500.0							-- default 1000 				-- Hz
band_width				= 12E3							-- default 20e3 				-- Hz (6 dB selectivity)
RxfreqResponseQuality 	= 12.0							-- default 12						

agr = {
	input_signal_deviation		= rangeUtoDb(4E-6, 0.5), -- default 50					--Db
	output_signal_deviation		= 5 , 					-- default 5					--Db
	input_signal_linear_zone 	= 10.0, 				-- default 10					--Db
	regulation_time				= 0.25, --sec
}

-- staticNoises = { 
-- 	{
-- 		filter = {},
-- 		effect = {}
-- 	}
-- }

-- l_get_state()

-- avReceiver end

-- avCommunicator
power 				= 10.0								-- default 0 					-- Watts
-- frequency_accuracy
TxBandwidth = 7000										-- default 7000					-- Hz
TxSpectrumPowerFactor = 8								-- default 8					-- 

-- l_get_state()

-- avCommunicator end

-- avBaseRadio
min_search_time = 0										-- default 0					-- second
max_search_time = 0										-- default 0					-- second

GUI = {
	range = {min = 108E6, max = 399.975E6, step = 25E3}, --Hz
	displayName = _('V/UHF XT-6013'),
	AM = true,
	FM = true,
}

-- get_frequency()
-- set_frequency(freq)
-- get_modulation()
-- set_modulation(mod)
-- set_channel(ch)
-- is_on()
-- is_frequency_in_range(freq)

-- avBaseRadio end

-- DynamicRadio
guard_receiver = {
	default_frequency = 224e6,
	modulation = MODULATION_AM,
}

-- get_tuned_frequency()
-- get_commanded_frequency()
-- set_frequency()
-- get_modulation()
-- set_modulation(number)
-- is_on()
-- set_on_off(state)
-- get_volume()
-- set_volume(vol)
-- set_squelch_on_off(state)
-- set_transmitter_power(pwr)
-- set_guard_frequency(freq)
-- set_guard_modulation(mod)
-- set_guard_on_off(state)

-- DynamicRadio end

need_to_be_closed = false -- close lua state after initialization