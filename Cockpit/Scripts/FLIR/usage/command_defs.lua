local start_command   = 3000
local count = 0
local function counter()
	count = count + 1
	return count
end

count = start_command
flir_commands = 
{
	WFOV				= counter();
	NFOV				= counter();
	Menu				= counter();
	Hook				= counter();
	Lock				= counter();
	Freeze				= counter();
	TrackBrk			= counter();
    Power               = counter();
	FocusOut			= counter();
	FocusIn				= counter();
    Cage                = counter();
	IPHH				= counter();
	Polarity			= counter();
	SlewLeft			= counter();
	SlewRight			= counter();
	SlewUp				= counter();
    SlewDown			= counter();
	GainUp				= counter();
	GainDown			= counter();
	LevelDown			= counter();
	LevelUp				= counter();
	AutoGain			= counter();
}
