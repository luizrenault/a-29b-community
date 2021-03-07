start_custom_command   = 10000
local __count_custom = start_custom_command-1
local function __custom_counter()
	__count_custom = __count_custom + 1
	return __count_custom
end


Keys =
{
	PlanePickleOn	                = 350,
	PlanePickleOff	                = 351,
    PlaneChgWeapon                  = 101,
    PlaneChgTargetNext              = 102,    -- iCommandPlaneChangeTarget
    PlaneModeNAV                    = 105,
    PlaneModeBVR                    = 106,
    PlaneModeVS                     = 107,
    PlaneModeBore                   = 108,
    PlaneModeGround                 = 111,

	Canopy                          = 71,
	
	PlaneAirBrake                   = 73,
	PlaneAirBrakeOn                 = 147,
	PlaneAirBrakeOff                = 148,	
	
	PlaneFlaps                      = 72,
	PlaneFlapsOn                    = 145, -- Fully down
	PlaneFlapsOff                   = 146, -- Fully up
    	
	PlaneGear                       = 68,						-- Шасси
	PlaneGearUp	                    = 430,
	PlaneGearDown                   = 431,
    
   
	LeftEngineStart = 311,			-- ?????? ?????? ?????????
	RightEngineStart = 312,			-- ?????? ??????? ?????????

	LeftEngineStop = 313,				-- ?????????? ?????? ?????????
    RightEngineStop = 314,			-- ?????????? ??????? ?????????
    


	PowerOnOff                      = 315,

    AltimeterPressureIncrease = 316,  
    AltimeterPressureDecrease = 317,
    AltimeterPressureStop = 318,       

    PlaneLightsOnOff                = 175,
    PlaneHeadlightOnOff             = 328,

    PowerGeneratorLeft              = 711,
    PowerGeneratorRight             = 712,

    BatteryPower                    = 1073,   -- iCommandBatteryPower

    PlaneChgTargetPrev              = 1315,   -- iCommandPlaneUFC_STEER_DOWN

    -- add custom commands here --

    ---- A-29B
    EngineStart                     = __custom_counter(),
    EngineStartCenter               = __custom_counter(),
    EngineStartInterrupt            = __custom_counter(),

    Engine_Stop                     = __custom_counter(),

	PlaneFireOn		                = __custom_counter(), -- replaces iCommandPlaneFire
	PlaneFireOff	                = __custom_counter(), -- replaces iCommandPlaneFireOff
    PickleOn                        = __custom_counter(), -- replaces iCommandPlanePickleOn
    PickleOff                       = __custom_counter(), -- replaces iCommandPlanePickleOff


    -- Stick
    StickStep		    	 = __custom_counter(),
    StickDesignate        	     = __custom_counter(),
    StickUndesignate      	     = __custom_counter(),
    MasterModeSw      	     = __custom_counter(),
    APDisengage      	     = __custom_counter(),
    APOvrd      	     = __custom_counter(),
    Call      	     = __custom_counter(),
    Trigger      	     = __custom_counter(),
    WeaponRelease			    	 = __custom_counter(),
    DisplayMngt        	     = __custom_counter(),

    -- Throttle
    GunSelDist        	     = __custom_counter(),
    GunRearm        	     = __custom_counter(),
    Cage        	     = __custom_counter(),
    TDCX        	     = __custom_counter(),
    TDCY        	     = __custom_counter(),
}

start_command   = 3000
local __count = start_command-1
local function __counter()
	__count = __count + 1
	return __count
end

device_commands =
{
    Button_Test                     = __counter(),
    arm_gun                         = __counter(),
    arm_master                      = __counter(),
    arm_station1                    = __counter(),
    arm_station2                    = __counter(),
    arm_station3                    = __counter(),
    arm_station4                    = __counter(),
    arm_station5                    = __counter(),
    arm_func_selector               = __counter(),
    gunpod_l                        = __counter(),
    gunpod_c                        = __counter(),
    gunpod_r                        = __counter(),
    gunpod_chargeclear              = __counter(),
	push_starter_switch             = __counter(),
	throttle                        = __counter(),
    flaps                           = __counter(),
	spoiler_cover                   = __counter(),
	spoiler_arm                     = __counter(),
    FuelGaugeExtButton              = __counter(),
    AltPressureKnob                 = __counter(),
    AltPressureStd                  = __counter(),
    Gear                            = __counter(),
    Hook                            = __counter(),
    emer_gen_bypass                 = __counter(),
    emer_gen_deploy                 = __counter(),
    speedbrake                      = __counter(),
    arm_emer_sel                    = __counter(),
    arm_bomb                        = __counter(),
    emer_bomb_release               = __counter(),
    GunsightKnob                    = __counter(),
    GunsightDayNight                = __counter(),
    GunsightBrightness              = __counter(),
    AWRS_quantity                   = __counter(),
    AWRS_drop_interval              = __counter(),
    AWRS_multiplier                 = __counter(),
    AWRS_stepripple                 = __counter(),
    speedbrake_emer                 = __counter(),
    emer_gear_release               = __counter(),
    radar_alt_indexer               = __counter(),
    radar_alt_switch                = __counter(),
    master_test                     = __counter(),
    ias_index_button                = __counter(),
    ias_index_knob                  = __counter(),
    stby_att_index_button           = __counter(),
    stby_att_index_knob             = __counter(),

    bdhi_mode                       = __counter(),

    doppler_select                  = __counter(),
    doppler_memory_test             = __counter(),

    nav_select                      = __counter(),
    asn41_magvar                    = __counter(),
    asn41_windspeed                 = __counter(),
    asn41_winddir                   = __counter(),
    ppos_lat                        = __counter(),
    ppos_lon                        = __counter(),
    dest_lat                        = __counter(),
    dest_lon                        = __counter(),

    radar_planprofile               = __counter(),
    radar_range                     = __counter(),
    radar_storage                   = __counter(),
    radar_brilliance                = __counter(),
    radar_detail                    = __counter(),
    radar_gain                      = __counter(),
    radar_filter                    = __counter(),
    radar_reticle                   = __counter(),
    radar_mode                      = __counter(),
    radar_aoacomp                   = __counter(),
    radar_angle                     = __counter(),
    radar_angle_axis                = __counter(),
    radar_angle_axis_abs            = __counter(),
    radar_volume                    = __counter(),
    tacan_mode                      = __counter(),
    tacan_ch_major                  = __counter(),
    tacan_ch_minor                  = __counter(),
    tacan_volume                    = __counter(),
    extlight_master                 = __counter(),
    extlight_probe                  = __counter(),
    extlight_taxi                   = __counter(),
    extlight_anticoll               = __counter(),
    extlight_fuselage               = __counter(),
    extlight_flashsteady            = __counter(),
    extlight_nav                    = __counter(),
    extlight_tail                   = __counter(),
    intlight_whiteflood             = __counter(),
    intlight_instruments            = __counter(),
    intlight_console                = __counter(),
    intlight_brightness             = __counter(),
    rudder_trim                     = __counter(),
    throttle_axis                   = __counter(),
    throttle_click                  = __counter(),

    afcs_standby                    = __counter(),
    afcs_engage                     = __counter(),
    afcs_hdg_sel                    = __counter(),
    afcs_alt                        = __counter(),
    afcs_hdg_set                    = __counter(),
    afcs_stab_aug                   = __counter(),
    afcs_ail_trim                   = __counter(),

    apc_engagestbyoff               = __counter(),
    apc_hotstdcold                  = __counter(),

    arc51_mode                      = __counter(),
    arc51_xmitmode                  = __counter(),
    arc51_volume                    = __counter(),
    arc51_squelch                   = __counter(),
    arc51_freq_preset               = __counter(),
    arc51_freq_XXxxx                = __counter(),
    arc51_freq_xxXxx                = __counter(),
    arc51_freq_xxxXX                = __counter(),

    clock_stopwatch                 = __counter(),

    cm_bank                         = __counter(),
    cm_auto                         = __counter(),
    cm_adj1                         = __counter(),
    cm_adj2                         = __counter(),
    cm_pwr                          = __counter(),

    accel_reset                     = __counter(),
	
	throttle_axis_mod               = __counter(),
	
	ecm_apr25_off	                = __counter(),
	ecm_apr25_audio	                = __counter(),
	ecm_apr27_off	                = __counter(),
	
	ecm_systest_upper	            = __counter(),
	ecm_systest_lower	            = __counter(),
	
	ecm_msl_alert_axis_inner	    = __counter(),
	ecm_msl_alert_axis_outer	    = __counter(),
	
	ecm_selector_knob               = __counter(),
	
	pitch_axis_mod 	                = __counter(),
	roll_axis_mod 	                = __counter(),
	rudder_axis_mod                 = __counter(),
	wheelbrake_AXIS 	            = __counter(),

    shrike_sidewinder_volume        = __counter(),

    AWRS_drop_interval_AXIS         = __counter(),
    intlight_whiteflood_AXIS        = __counter(),
    intlight_instruments_AXIS       = __counter(),
    intlight_console_AXIS           = __counter(),
    intlight_whiteflood_CHANGE      = __counter(),
    intlight_instruments_CHANGE     = __counter(),
    intlight_console_CHANGE         = __counter(),
    
    cabin_pressure                  = __counter(),
    windshield_defrost              = __counter(),
    cabin_temp                      = __counter(),

    man_flt_control_override        = __counter(),
    
    shrike_selector                 = __counter(),
    oxygen_switch                   = __counter(),
    
    COMPASS_set_heading             = __counter(),
    COMPASS_push_to_sync            = __counter(),
    COMPASS_free_slaved_switch      = __counter(),
    COMPASS_latitude                = __counter(),
    
    ENGINE_wing_fuel_sw             = __counter(),
    ENGINE_drop_tanks_sw            = __counter(),
    ENGINE_fuel_control_sw          = __counter(),
    ENGINE_manual_fuel_shutoff        = __counter(),
    ENGINE_manual_fuel_shutoff_catch  = __counter(),

    CPT_shoulder_harness            = __counter(),
    CPT_secondary_ejection_handle   = __counter(),
    ppos_lat_push                   = __counter(),
    ppos_lon_push                   = __counter(),
    dest_lat_push                   = __counter(),
    dest_lon_push                   = __counter(),
    asn41_magvar_push               = __counter(),
    asn41_windspeed_push            = __counter(),
    asn41_winddir_push              = __counter(),

    throttle_click_ITER             = __counter(),

    JATO_arm                        = __counter(),
    JATO_jettison                   = __counter(),

    GunsightElevationControl_AXIS   = __counter(),
    pilot_salute                    = __counter(),

    left_wheelbrake_AXIS            = __counter(),
    right_wheelbrake_AXIS           = __counter(),

    AOA_dimming_wheel_AXIS          = __counter(),

    EngineStart                     = __counter(),
    EnginePMU                       = __counter(),
    EngineIgnition                  = __counter(),
    EngineInnSep                    = __counter(),

    ExtLightSearch                  = __counter(),
    ExtLightBeacon                  = __counter(),
    ExtLightStrobe                  = __counter(),
    ExtLightInfrared                = __counter(),
    ExtLightNormal                  = __counter(),
    ExtLightNav                     = __counter(),
    ExtLightTaxi                    = __counter(),
    ExtLightLng                     = __counter(),

    ElecBatt                        = __counter(),
    ElecGen                         = __counter(),
    ElecAC                          = __counter(),
    ElecExtPwr                      = __counter(),
    ElecBkp                         = __counter(),
    ElecEmer                        = __counter(),
    ElecAcftIntc                    = __counter(),

    IcePropeller                    = __counter(),
    IceWindshield                   = __counter(),
    IcePitotPri                     = __counter(),
    IcePitotSec                     = __counter(),

    IntLightPnl                     = __counter(),
    IntLightStorm                   = __counter(),
    IntLightCsl                     = __counter(),
    IntLightAlm                     = __counter(),
    IntLightChart                   = __counter(),
    IntLightNvg                     = __counter(),

    AviMdp1                     = __counter(),
    AviMdp2                     = __counter(),
    AviMst                     = __counter(),
    AviSms                     = __counter(),
    AviVuhf                     = __counter(),

    EnvTemp                     = __counter(),
    EnvAC                     = __counter(),
    EnvECS                     = __counter(),
    EnvRecFan                     = __counter(),

    Salvo                     = __counter(),
    LndGear                     = __counter(),
    LndGearBeep                     = __counter(),
    LndGearOvr                     = __counter(),
    LndGearEmer                     = __counter(),
    FuelMain                     = __counter(),
    FuelAux                     = __counter(),
    FuelXfr                     = __counter(),
    SeatAdj                     = __counter(),
    EmerSpdBrk                  = __counter(),
    FuelHydBleed                = __counter(),
    AntiG                       = __counter(),
    TrimEmerAil                 = __counter(),
    TrimEmerElev                = __counter(),
    AutoRudder                  = __counter(),
    Flaps                       = __counter(),
    Friction                    = __counter(),

    EmerParkBrake               = __counter(),

    EltOn                       = __counter(),
    PicNavMan                   = __counter(),
    PicNavSlave               = __counter(),

    Mass               = __counter(),
    LateArm                    = __counter(),
    

    AudioNormal               = __counter(),

    BFI_BRIGHT      = __counter(),
    
    ASICage                     = __counter(),
    ASIAdjust                   = __counter(),

    CMFD1OSS1                 = __counter(),
    CMFD1OSS2                 = __counter(),
    CMFD1OSS3                 = __counter(),
    CMFD1OSS4                = __counter(),
    CMFD1OSS5                 = __counter(),
    CMFD1OSS6                 = __counter(),
    CMFD1OSS7                 = __counter(),
    CMFD1OSS8                 = __counter(),
    CMFD1OSS9                 = __counter(),
    CMFD1OSS10                 = __counter(),
    CMFD1OSS11                 = __counter(),
    CMFD1OSS12                 = __counter(),
    CMFD1OSS13                 = __counter(),
    CMFD1OSS14                = __counter(),
    CMFD1OSS15                 = __counter(),
    CMFD1OSS16                 = __counter(),
    CMFD1OSS17                 = __counter(),
    CMFD1OSS18                 = __counter(),
    CMFD1OSS19                 = __counter(),
    CMFD1OSS20                 = __counter(),
    CMFD1OSS21                 = __counter(),
    CMFD1OSS22                 = __counter(),
    CMFD1OSS23                 = __counter(),
    CMFD1OSS24                = __counter(),
    CMFD1OSS25                 = __counter(),
    CMFD1OSS26                 = __counter(),
    CMFD1OSS27                 = __counter(),
    CMFD1OSS28                 = __counter(),
    CMFD1ButtonOn                 = __counter(),
    CMFD1ButtonGain                 = __counter(),
    CMFD1ButtonSymb                 = __counter(),
    CMFD1ButtonBright                 = __counter(),

    CMFD2OSS1                 = __counter(),
    CMFD2OSS2                 = __counter(),
    CMFD2OSS3                 = __counter(),
    CMFD2OSS4                = __counter(),
    CMFD2OSS5                 = __counter(),
    CMFD2OSS6                 = __counter(),
    CMFD2OSS7                 = __counter(),
    CMFD2OSS8                 = __counter(),
    CMFD2OSS9                 = __counter(),
    CMFD2OSS10                 = __counter(),
    CMFD2OSS11                 = __counter(),
    CMFD2OSS12                 = __counter(),
    CMFD2OSS13                 = __counter(),
    CMFD2OSS14                = __counter(),
    CMFD2OSS15                 = __counter(),
    CMFD2OSS16                 = __counter(),
    CMFD2OSS17                 = __counter(),
    CMFD2OSS18                 = __counter(),
    CMFD2OSS19                 = __counter(),
    CMFD2OSS20                 = __counter(),
    CMFD2OSS21                 = __counter(),
    CMFD2OSS22                 = __counter(),
    CMFD2OSS23                 = __counter(),
    CMFD2OSS24                = __counter(),
    CMFD2OSS25                 = __counter(),
    CMFD2OSS26                 = __counter(),
    CMFD2OSS27                 = __counter(),
    CMFD2OSS28                 = __counter(),
    CMFD2ButtonOn                 = __counter(),
    CMFD2ButtonGain                 = __counter(),
    CMFD2ButtonSymb                 = __counter(),
    CMFD2ButtonBright                 = __counter(),

    ClockSel                      = __counter(),
    ClockCtrl                      = __counter(),

    UFCP_COM1                      = __counter(),
    UFCP_COM2                      = __counter(),
    UFCP_COM3                      = __counter(),
    UFCP_NAVAIDS                      = __counter(),
    UFCP_A_G                      = __counter(),
    UFCP_NAV                      = __counter(),
    UFCP_A_A                      = __counter(),
    UFCP_BARO_RALT                      = __counter(),
    UFCP_IDNT                      = __counter(),
    UFCP_1                      = __counter(),
    UFCP_2                      = __counter(),
    UFCP_3                      = __counter(),
    UFCP_4                      = __counter(),
    UFCP_5                      = __counter(),
    UFCP_6                      = __counter(),
    UFCP_7                      = __counter(),
    UFCP_8                      = __counter(),
    UFCP_9                      = __counter(),
    UFCP_0                      = __counter(),
    UFCP_UP                      = __counter(),
    UFCP_DOWN                      = __counter(),
    UFCP_CLR                      = __counter(),
    UFCP_ENTR                      = __counter(),
    UFCP_CZ                      = __counter(),
    UFCP_AIRSPD                      = __counter(),
    UFCP_WARNRST                      = __counter(),
    UFCP_DAY_NIGHT                      = __counter(),
    UFCP_RALT                      = __counter(),
    UFCP_DVR                      = __counter(),
    UFCP_EGI                      = __counter(),
    UFCP_UFC                      = __counter(),
    UFCP_HUD_TEST                      = __counter(),
    UFCP_SBS_ON                      = __counter(),
    UFCP_HUD_BRIGHT                      = __counter(),
    UFCP_SBS_ADJUST                      = __counter(),
    UFCP_JOY_RIGHT                      = __counter(),
    UFCP_JOY_LEFT                      = __counter(),
    UFCP_JOY_UP                      = __counter(),
    UFCP_JOY_DOWN                      = __counter(),

    ALERTS_SET_WARNING                      = __counter(),
    ALERTS_RESET_WARNING                      = __counter(),
    ALERTS_ACK_WARNING                      = __counter(),
    ALERTS_ACK_WARNINGS                      = __counter(),
    
    ALERTS_SET_CAUTION                      = __counter(),
    ALERTS_RESET_CAUTION                      = __counter(),
    ALERTS_ACK_CAUTION                      = __counter(),
    ALERTS_ACK_CAUTIONS                      = __counter(),

    ALERTS_SET_ADVICE                      = __counter(),
    ALERTS_RESET_ADVICE                      = __counter(),
    
    WARNING_PRESS                      = __counter(),
    CAUTION_PRESS                      = __counter(),

    WPN_SELECT_STO                          = __counter(),
    WPN_AA_STEP                          = __counter(),
    WPN_AA_SIGHT_STEP                    = __counter(),
    WPN_AA_RR_SRC_STEP                    = __counter(),
    WPN_AA_SLV_SRC_STEP                    = __counter(),
    WPN_AA_COOL_STEP                    = __counter(),
    WPN_AA_SCAN_STEP                    = __counter(),
    WPN_AA_LIMIT_STEP                    = __counter(),

    WPN_AG_STEP                          = __counter(),

    STICK_WEAPON_RELEASE                    = __counter(),
    STICK_TRIGGER_2ND_DETENT                    = __counter(),
    STICK_PADDLE                    = __counter(),
    NAV_INC_FYT                    = __counter(),
    NAV_DEC_FYT                    = __counter(),
    
    
    AAA                    = __counter(),
    AAA                    = __counter(),
    AAA                    = __counter(),
    AAA                    = __counter(),
    AAA                    = __counter(),
    AAA                    = __counter(),

    STICK_WEAPON_RELEASE_OFF                = __counter(),
    WPN_AG_LAUNCH_OP_STEP                    = __counter(),

}
