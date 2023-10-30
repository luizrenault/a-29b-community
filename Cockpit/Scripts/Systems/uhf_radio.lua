dofile(LockOn_Options.common_script_path..'Radio.lua')
dofile(LockOn_Options.common_script_path.."mission_prepare.lua")

dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")


debug = false

local gettext = require("i_18n")
_ = gettext.translate

local dev 	    = GetSelf()

local update_time_step = 1 --update will be called once per second
device_timer_dt = update_time_step


innerNoise 			= getInnerNoise(2.5E-6, 10.0)--V/m (dB S+N/N)
frequency_accuracy 	= 500.0				--Hz
band_width			= 12E3				--Hz (6 dB selectivity)
power 				= 10.0				--Watts
goniometer = {isLagElement = true, T1 = 0.3, bias = {{valmin = math.rad(0), valmax = math.rad(360), bias = math.rad(1)}}}

agr = {
	input_signal_deviation		= rangeUtoDb(4E-6, 0.5), --Db
	output_signal_deviation		= 5 - (-4),  --Db
	input_signal_linear_zone 	= 10.0, --Db
	regulation_time				= 0.25, --sec
}

staticNoises = {
    {
        effect = {"Aircrafts/Cockpits/Static"},
    },
    {
        filter = {1, 2, 2e6, 3e6},
        effect = {"Aircrafts/Cockpits/Atmospheric"},
    },
}

local commands = {}
commands[devices["VUHF1_RADIO"]] = {ptt = Keys.COM1, volume = device_commands.AUDIO_COM1_VOL}
commands[devices["VUHF2_RADIO"]] = {ptt = Keys.COM2, volume = device_commands.AUDIO_COM2_VOL}
command = commands[dev:id()];

local displayNames = {}
displayNames[devices["VUHF1_RADIO"]]=_('V/UHF COM1 XT-6013')
displayNames[devices["VUHF2_RADIO"]]=_('V/UHF COM2 XT-6313D')

local radiosOrder = {}
radiosOrder[devices["VUHF1_RADIO"]]=1
radiosOrder[devices["VUHF2_RADIO"]]=2

radioOrder = radiosOrder[dev:id()]

local radioGuardFrequencies = {}
radioGuardFrequencies[devices["VUHF1_RADIO"]] = 121.5e6
radioGuardFrequencies[devices["VUHF2_RADIO"]] = 243.0e6


guard_receiver = {
	default_frequency = radioGuardFrequencies[dev:id()],
	modulation = 0,
}


GUI = {
	-- range = {min = 108E6, max = 399.975E6, step = 25E3}, --Hz
	ranges = {
		{min = 108.0 * 1e6, max = 117.975 * 1e6, step = 25e3},
		{min = 118.0 * 1e6, max = 136.99167 * 1e6, step = 8.33e3},
		{min = 137.0 * 1e6, max = 173.975 * 1e6, step = 25e3},
		{min = 225.0 * 1e6, max = 399.975 * 1e6, step = 25e3},
	},

	displayName = displayNames[dev:id()],
	AM = true,
	FM = true,
}

function post_initialize()
end

need_to_be_closed = false -- close lua state after initialization