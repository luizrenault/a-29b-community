--ANDR0ID Added 

--dofile("CoreMods/aircraft/AircraftWeaponPack/AS_Missiles.lua")
--dofile("CoreMods/aircraft/SA342/SA342_Weapons.lua")
dofile("Scripts/Database/Weapons/warheads.lua")
dofile("Scripts/Database/wsTypes.lua")
dofile("CoreMods/aircraft/AircraftWeaponPack/common_definitions.lua")

local GALLON_TO_KG 		= 3.785 * 0.8
local INCHES_TO_M 		= 0.0254
local POUNDS_TO_KG 		= 0.453592

local GIAT_ammo_weight 	= 0.349
local GIAT_NC621_cx 	= 0.000240703125	--0.001220703125
local FN_ammo_weight 	= 0.117
local FN_cx				= 0.000240703125	--0.001220703125

local DAP_cx = 0.00015
local DAP6_Ammo_Weight = 0.00933

local A_29B_APKWS =
{
	category		= CAT_MISSILES,
	name			= "A_29B_APKWS_M282",
	user_name		= "A_29B_APKWS_M282",
	scheme			= "AGM-114K",
	class_name		= "wAmmunitionLaserHoming",
	model			= "AGR_20",
	wsTypeOfWeapon 	= {wsType_Weapon, wsType_Missile, wsType_AS_Missile, WSTYPE_PLACEHOLDER},
	
  Escort = 1,
    Head_Type = 4,
	sigma = {1, 1, 1},
	mass = 17,
    M = 15,
    H_max = 5000.0,
    H_min = 1.0,
    Diam = 70.0,
	Cx_pil			= 0.00244140625,
	D_max			= 5000.0,
	D_min			= 1000.0,
	Head_Form		= 1,
	Life_Time		= 90.0,
	Nr_max			= 25,
	v_min			= 140.0,
	v_mid			= 350.0,
	Mach_max		= 3.0,
	t_b				= 0.0,
	t_acc			= 0.0,
	t_marsh			= 1.1,
	Range_max		= 5000.0,
	H_min_t			= 15.0,
	Fi_start		= 0.4,
	Fi_rak			= 3.14152,
	Fi_excort		= 1.05,
	Fi_search		= 0.7,
	OmViz_max		= 0.35,
	exhaust			= {0.78, 0.78, 0.78, 0.3};
	X_back			= -2.0,
	Y_back			= -0.0,
	Z_back			= 0.0,
	Reflection		= 0.01,
	KillDistance	= 0.0,
	
	warhead		= predefined_warhead("HYDRA_70_M282"),
	warhead_air = predefined_warhead("HYDRA_70_M282"),

	controller = {
		boost_start = 0, --Start time for boose phase of rocket motor, 0 = immediate start 
		march_start = 0, --Start time for the march phase of the rocket motor, 0 = immediate start 
	},
	
	boost = {
		impulse								= 0, --Impulse by the boost phase of the rocket motor 
		fuel_mass							= 0, --Mass of fuel for boost phase 
		work_time							= 0.1, --Duration of boost phase in seconds 
		nozzle_position						= {{-0.95, 0, 0}}, --Position of rocket nozzle in local cord system 
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}}, --Nozzle orienation in degrees 
		nozzle_exit_area 					= 0.0132, --Exit area of the nozzle 
		tail_width							= 0.052, -- Width of rocket tail 
		smoke_color							= {0.5, 0.474, 0.443},
		smoke_transparency					= 0.5,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	march = {
		fuel_mass   			= 3.175, -- Fuel mass of march phase of rocket motor 
		impulse     			= 210, --Impulse generate by the march phase of rocket motor 
		boost_time  			= 0, --Time to wait before starting the march phase 
		work_time   			= 1.1, --Duration of march phase  
		boost_factor			= 1,
		nozzle_position 	    = {{-0.95, 0, 0}},
		nozzle_orientationXYZ   = {{0, 0, 0}},
		tail_width  			= 0.052,
		boost_tail  			= 1,
		work_tail   			= 1,
		smoke_color				= {0.5, 0.474, 0.443},
		smoke_transparency		= 0.5,
		custom_smoke_dissipation_factor		= 0.2,		
	},
	
	fm = {
		mass				= 17,  
		caliber				= 0.07,  
		wind_sigma			= 5.0,
		wind_time			= 1.1,
		tail_first			= 0,
		fins_part_val		= 0,
		rotated_fins_inp	= 0,
		delta_max			= math.rad(20),
		draw_fins_conv		= {math.rad(90),1,1},
		L					= 0.181,
		S					= 0.04,
		Ix					= 0.24,
		Iy					= 9.8,
		Iz					= 9.8,
		
		Mxd					= 0.04 * 57.3,
		Mxw					= -15.8,

		table_scale	= 0.2,
		table_degree_values = 1,
	--	Mach	  | 0.0		0.2		0.4		0.6		0.8		1.0		1.2		1.4		1.6		1.8		2.0		2.2	  |
		Cx0 	= {	0.1,	0.1,	0.1,	0.1,	0.12,	0.3,	0.45,	0.45,	0.451,	0.456,	0.44,	0.4 }, --Drag coefficient
		CxB 	= {	0.019,	0.019,	0.019,	0.019,	0.02,	0.066,	0.081,	0.072,	0.072,	0.061,	0.051,	0.057 }, --Induced drag coefficient 
		K1		= { 0.00041,0.00041,0.00041,0.00041,0.00041,0.00052,0.00044,0.00042,0.0004,0.0003,0.0002,0.00015 }, --Lift curve slope 
		K2		= {-0.00024,-0.00024,-0.00024,-0.00024,-0.00018,0.00005,0.0001,0.0001,0.0001,0.0001,0.0001,0.0001 }, --Lift curve curvature
		Cya		= { 0.209,	0.209,	0.209,	0.209,	0.209,	0.244,	0.224,	0.205,	0.191,	0.178,	0.169,	0.161 }, --Side force coefficient
		Cza		= { 0.209,	0.209,	0.209,	0.209,	0.209,	0.244,	0.224,	0.205,	0.191,	0.178,	0.169,	0.161 }, --Vertical force coefficient 
		Mya		= {-0.185,	-0.185,	-0.185,	-0.185,	-0.19,	-0.2,	-0.211,	-0.21,	-0.2,	-0.19,	-0.17,	-0.15 }, --Roll moment coefficient
		Mza		= {-0.185,	-0.185,	-0.185,	-0.185,	-0.19,	-0.2,	-0.211,	-0.21,	-0.2,	-0.19,	-0.17,	-0.15 }, --Pitch moment coefficient
		Myw		= {-15.556,	-15.556,-15.556,-15.556,-16.321,-19.722,-19.702,-19.65,-19.515,-18.88,-17.748,-16.224 }, --Roll damping moment due to angualar velocity 
		Mzw		= {-15.556,	-15.556,-15.556,-15.556,-16.321,-19.722,-19.702,-19.65,-19.515,-18.88,-17.748,-16.224 }, --Pitch damping moment due to annular velocity 
		A1trim	= { 14.1,	14.1,	14.1,	14.1,	14.1,	15.1,	12.6,	10.8,	9.8,	9.1,	8.6,	8.3 }, --Pith trim coefficient 
		A2trim	= { 14.1,	14.1,	14.1,	14.1,	14.1,	15.1,	12.6,	10.8,	9.8,	9.1,	8.6,	8.3 }, --Roll trim coefficient
		
		model_roll = math.rad(45),
		fins_stall = 0,
	},
	
	sensor = {
		FOV					= math.rad(10),
		max_seeker_range	= 13000,
	},
	
	gimbal = {
		delay				= 0,
		op_time				= 45,
		pitch_max			= math.rad(30), --30
		yaw_max				= math.rad(30), --30
		max_tracking_rate	= math.rad(15), --15
		tracking_gain		= 50, --50
	},

	autopilot = {
		delay				= 0.2, --0.2 --Autopilot delay 
		op_time				= 45, --Operating time of autopilot 
		dV_dt				= 20, --Rate of change of velociy 
		Knav				= 12, --Navigation gain 
		Kbias				= 2, --Bias gain 
		Kloft				= 2, --Loft gain
		Kloss				= 2, --Loss gain 
		Tf					= 0.2, -- time constant 
		Kd					= 150, --Derivative gain 
		Ki					= 1, --Integral gain 
		Kdx					= 0.2, --Detivative crossfeed gain 
		Kix					= 0.8, --Integral crossfeed gain
		null_roll			= math.rad(45),
		gload_limit			= 10,
		fins_limit			= math.rad(20),
		fins_limit_x		= math.rad(10),
	},
	
	actuator = {
		Tf					= 0.1,--0.005
		D					= 250.0,
		T1					= 0.002,
		T2					= 0.006,
		max_omega			= math.rad(400),
		max_delta			= math.rad(20),
		fin_stall			= 1,
		sim_count			= 4,
	},
}
declare_weapon(A_29B_APKWS)

declare_loadout({
	category 			= CAT_MISSILES,
	CLSID	 			= "{A29B_LAU_61_AGR_20_APKWS}",
	Picture				= "lau61.png",
	Cx_pil				= 0.00146484375,
	displayName			= "LAU-61 pod - 19 x 2.75'' Hydra, Laser Guided Rkts, M282, MPP APKWS",
	Weight				= (205 + (32*19)) * POUNDS_TO_KG,
	Weight_Empty		= 205 * POUNDS_TO_KG,
	Count				= 19,
	kind_of_shipping	= 0,
	attribute			= {wsType_Weapon, wsType_Missile, wsType_Container, WSTYPE_PLACEHOLDER},
	wsTypeOfWeapon = A_29B_APKWS.wsTypeOfWeapon,
	Elements			= {	{ ShapeName = "lau-61", IsAdapter = true, },
	{ ShapeName = "AGR_20", connector_name = "tube_01", },
	{ ShapeName = "AGR_20", connector_name = "tube_02", },
	{ ShapeName = "AGR_20", connector_name = "tube_03", },
	{ ShapeName = "AGR_20", connector_name = "tube_04", },
	{ ShapeName = "AGR_20", connector_name = "tube_05", },
	{ ShapeName = "AGR_20", connector_name = "tube_06", },
	{ ShapeName = "AGR_20", connector_name = "tube_07", },
	{ ShapeName = "AGR_20", connector_name = "tube_08", },
	{ ShapeName = "AGR_20", connector_name = "tube_09", },
	{ ShapeName = "AGR_20", connector_name = "tube_10", },
	{ ShapeName = "AGR_20", connector_name = "tube_11", },
	{ ShapeName = "AGR_20", connector_name = "tube_12", },
	{ ShapeName = "AGR_20", connector_name = "tube_13", },
	{ ShapeName = "AGR_20", connector_name = "tube_14", },
	{ ShapeName = "AGR_20", connector_name = "tube_15", },
	{ ShapeName = "AGR_20", connector_name = "tube_16", },
	{ ShapeName = "AGR_20", connector_name = "tube_17", },
	{ ShapeName = "AGR_20", connector_name = "tube_18", },
	{ ShapeName = "AGR_20", connector_name = "tube_19", },
	}
})

declare_loadout({
	category 			= CAT_MISSILES,
	CLSID	 			= "{A29B_LAU68_M282__APKWS_MPP}",
	Picture				= "LAU68.png",
	Cx_pil				= 0.0015869140625,
	displayName			= "LAU-68 pod - 7 x 2.75'' Hydra, Laser Guided Rkts, M282, MPP APKWS",
	Weight				= (92 + (32*7)) * POUNDS_TO_KG,
	Weight_Empty		= 92 * POUNDS_TO_KG,
	Count				= 7,
	kind_of_shipping	= 0,
	attribute			= {wsType_Weapon, wsType_Missile, wsType_Container, WSTYPE_PLACEHOLDER},
	wsTypeOfWeapon = A_29B_APKWS.wsTypeOfWeapon,
	Elements			= {{ ShapeName = "lau-68", IsAdapter = true, },
	{ ShapeName = "AGR_20", connector_name = "tube_01", },
	{ ShapeName = "AGR_20", connector_name = "tube_02", },
	{ ShapeName = "AGR_20", connector_name = "tube_03", },
	{ ShapeName = "AGR_20", connector_name = "tube_04", },
	{ ShapeName = "AGR_20", connector_name = "tube_05", },
	{ ShapeName = "AGR_20", connector_name = "tube_06", },
	{ ShapeName = "AGR_20", connector_name = "tube_07", },
	}
})



--END PHASE 4: MAVERICK LASER

--END ANDR0ID Added

--START gun pods by XENO426
local function GIATNC261(tbl)
	tbl.category	= CAT_GUN_MOUNT 
	tbl.name		= "GIAT_NC261"
	tbl.supply		= 
	{
		shells	= {"M61_20_HE_INVIS","M61_20_HE","M61_20_AP","M61_20_TP_T","M61_20_PGU28"},
		mixes	= {{1},{2},{3},{4},{5},}, 
		count	= 180,
	}
	if tbl.mixes then 
	   tbl.supply.mixes =  tbl.mixes
	   tbl.mixes	    = nil
	end
	if tbl.count then 
	   tbl.supply.count =  tbl.count
	   tbl.count	    = nil
	end
	tbl.gun = 
	{
		max_burst_length = 15,
		rates 			 = {740},
		recoil_coeff 	 = 0.5,
		barrels_count 	 = 1,
	}
	if tbl.rates then 
	   tbl.gun.rates    =  tbl.rates
	   tbl.rates	    = nil
	end	
	tbl.ejector_pos 			= tbl.ejector_pos or {0.0, 0.05, 0.0}
	tbl.ejector_dir 			= {0, -1, 0}
	tbl.supply_position  		= tbl.supply_position or {0, 0.3, -0.3}
	tbl.aft_gun_mount 			= false
	tbl.effective_fire_distance = 1200
	tbl.drop_cartridge 			= 204
	tbl.muzzle_pos				= tbl.muzzle_pos or  {2.244,-0.387,1.029} -- all position from connector
	tbl.muzzle_pos_connector	= tbl.muzzle_pos_connector or  "GUN_POINT" -- all position from connector
	tbl.azimuth_initial 		= tbl.azimuth_initial    or 0   
	tbl.elevation_initial 		= tbl.elevation_initial  or -2   
	if  tbl.effects == nil then
		tbl.effects = {
			{ name = "FireEffect"     , arg = tbl.effect_arg_number or 436 },
			{ name = "HeatEffectExt"  , shot_heat = 7.823, barrel_k = 0.462 * 2.7, body_k = 0.462 * 14.3 },
			{ name = "SmokeEffect"}
		}
	end
	return declare_weapon(tbl)
end

declare_loadout(
	{
		category			=  CAT_PODS,
		CLSID				= "{GIAT_NC621_APHE_A29B}",
		displayName			= _("GIAT NC621 (180x Combat mix 4x AP 1x HE)"),
		Picture				=	"AKANM55.png",
		attribute			= {wsType_Weapon, wsType_GContainer, wsType_Cannon_Cont, WSTYPE_PLACEHOLDER},
		wsTypeOfWeapon		= {wsType_Weapon, wsType_Shell, wsType_Shell_A, wsType_Shell_SPPU},
		Weight				= 49 + (180 * GIAT_ammo_weight), -- INCLUDE AMMO FOR FULL WEIGHT
        Weight_Empty        = 49,
		Cx_pil				= GIAT_NC621_cx,
		kind_of_shipping	= 2,--SOLID_MUNITION
		count				= 180,
		gun_mounts  = { GIATNC261({ 
									mixes					= {{3,3,3,3,2}},
									muzzle_pos_connector   = "Point_Gun",
									 effect_arg_number 	   = 433,
									 ejector_pos_connector  = "eject 2",
									 effects = {{name = "FireEffect", arg = 433 , attenuation = 1.0 , light_pos = {0.5,0.5,0} , light_time = 0.1},
												{name = "SmokeEffect"},
									 },
						}, true)
		},
		shape_table_data =
		{
			{
				name		= "GIAT_NC261_APHE_A29B";
				file		= "AKANM55";
				life		= 1;
				fire		= {0, 1};
				username	= "GIAT_NC261_APHE_A29B";
				index		= WSTYPE_PLACEHOLDER;
			},
		},
		Elements = {
			[1]	= {
				Position	=	{0, 0, 0},
				ShapeName	=	"AKANM55",
			}, 
		}, -- end of Elements
	
	--m3_browing({muzzle_pos = {2.91,   0.42,  -0.5 }  	, rates = {1249},mixes = {{2,1,1,1,1,1}},effect_arg_number = 434,azimuth_initial = 0,elevation_initial = 0,supply_position = {2, -0.3, -0.4}}), --up
	}
)

declare_loadout(
	{
		category			=  CAT_PODS,
		CLSID				= "{GIAT_NC621_HEAP_A29B}",
		displayName			= _("GIAT NC621 (180x combat mix 4x HE 1x AP)"),
		Picture				=	"AKANM55.png",
		attribute			= {wsType_Weapon, wsType_GContainer, wsType_Cannon_Cont, WSTYPE_PLACEHOLDER},
		wsTypeOfWeapon		= {wsType_Weapon, wsType_Shell, wsType_Shell_A, wsType_Shell_SPPU},
		Weight				= 49 + (180 * GIAT_ammo_weight), -- INCLUDE AMMO FOR FULL WEIGHT
        Weight_Empty        = 49,
		Cx_pil				= GIAT_NC621_cx,
		kind_of_shipping	= 2,--SOLID_MUNITION
		count				= 180,
		gun_mounts			= {
			GIATNC261(
				{
					mixes					= {{1,1,1,1,4}},
					muzzle_pos_connector   = "Point_Gun",
					effect_arg_number 	   = 433,
					ejector_pos_connector  = "eject 2",
					effects = {{name = "FireEffect", arg = 433 , attenuation = 1.0 , light_pos = {0.5,0.5,0} , light_time = 0.1},
						{name = "SmokeEffect"},
					},
				}, true)
		},
		shape_table_data =
		{
			{
				name		= "GIAT_NC621_HEAP_A29B";
				file		= "AKANM55";
				life		= 1;
				fire		= {0, 1};
				username	= "GIAT_NC621_HEAP_A29B";
				index		= WSTYPE_PLACEHOLDER;
			},
		},
		Elements = {
			[1]	= {
				Position	=	{0, 0, 0},
				ShapeName	=	"AKANM55",
			}, 
		}, -- end of Elements
	
	--m3_browing({muzzle_pos = {2.91,   0.42,  -0.5 }  	, rates = {1249},mixes = {{2,1,1,1,1,1}},effect_arg_number = 434,azimuth_initial = 0,elevation_initial = 0,supply_position = {2, -0.3, -0.4}}), --up
	}
)

declare_loadout(
	{
		category			=  CAT_PODS,
		CLSID				= "{GIAT_NC621_HE_A29B}",
		displayName			= _("GIAT NC621 (180x HE)"),
		Picture				=	"AKANM55.png",
		attribute			= {wsType_Weapon, wsType_GContainer, wsType_Cannon_Cont, WSTYPE_PLACEHOLDER},
		wsTypeOfWeapon		= {wsType_Weapon, wsType_Shell, wsType_Shell_A, wsType_Shell_SPPU},
		Weight				= 49 + (180 * GIAT_ammo_weight), -- INCLUDE AMMO FOR FULL WEIGHT
        Weight_Empty        = 49,
		Cx_pil				= GIAT_NC621_cx,
		kind_of_shipping	= 2,--SOLID_MUNITION
		count				= 180,
		gun_mounts			= {
			GIATNC261(
				{
					mixes					= {{1,1,1,1,2}},
					muzzle_pos_connector   = "Point_Gun",
					effect_arg_number 	   = 433,
					ejector_pos_connector  = "eject 2",
					effects = {{name = "FireEffect", arg = 433 , attenuation = 1.0 , light_pos = {0.5,0.5,0} , light_time = 0.1},
						{name = "SmokeEffect"},
					},
				}, true)
		},
		shape_table_data =
		{
			{
				name		= "GIAT_NC621_HE_A29B";
				file		= "AKANM55";
				life		= 1;
				fire		= {0, 1};
				username	= "GIAT_NC621_HE_A29B";
				index		= WSTYPE_PLACEHOLDER;
			},
		},
		Elements = {
			[1]	= {
				Position	=	{0, 0, 0},
				ShapeName	=	"AKANM55",
			}, 
		}, -- end of Elements
	
	--m3_browing({muzzle_pos = {2.91,   0.42,  -0.5 }  	, rates = {1249},mixes = {{2,1,1,1,1,1}},effect_arg_number = 434,azimuth_initial = 0,elevation_initial = 0,supply_position = {2, -0.3, -0.4}}), --up
	}
)

declare_loadout(
	{
		category			=  CAT_PODS,
		CLSID				= "{GIAT_NC621_SAPHEI_A29B}",
		displayName			= _("GIAT NC621 (180x SAPHEI)"),
		Picture				=	"AKANM55.png",
		attribute			= {wsType_Weapon, wsType_GContainer, wsType_Cannon_Cont, WSTYPE_PLACEHOLDER},
		wsTypeOfWeapon		= {wsType_Weapon, wsType_Shell, wsType_Shell_A, wsType_Shell_SPPU},
		Weight				= 49 + (180 * GIAT_ammo_weight), -- INCLUDE AMMO FOR FULL WEIGHT
        Weight_Empty        = 49,
		Cx_pil				= GIAT_NC621_cx,
		kind_of_shipping	= 2,--SOLID_MUNITION
		count				= 180,
		gun_mounts			= {
			GIATNC261(
				{
					mixes					= {{5,5,5,5,4}},
					muzzle_pos_connector   = "Point_Gun",
					effect_arg_number 	   = 433,
					ejector_pos_connector  = "eject 2",
					effects = {{name = "FireEffect", arg = 433 , attenuation = 1.0 , light_pos = {0.5,0.5,0} , light_time = 0.1},
						{name = "SmokeEffect"},
					},
				}, true)
		},
		shape_table_data =
		{
			{
				name		= "GIAT_NC621_SAPHEI_A29B";
				file		= "AKANM55";
				life		= 1;
				fire		= {0, 1};
				username	= "GIAT_NC621_SAPHEI_A29B";
				index		= WSTYPE_PLACEHOLDER;
			},
		},
		Elements = {
			[1]	= {
				Position	=	{0, 0, 0},
				ShapeName	=	"AKANM55",
			}, 
		}, -- end of Elements
	
	--m3_browing({muzzle_pos = {2.91,   0.42,  -0.5 }  	, rates = {1249},mixes = {{2,1,1,1,1,1}},effect_arg_number = 434,azimuth_initial = 0,elevation_initial = 0,supply_position = {2, -0.3, -0.4}}), --up
	}
)

declare_loadout(
	{
		category			=  CAT_PODS,
		CLSID				= "{GIAT_NC621_AP_A29B}",
		displayName			= _("GIAT NC621 (180x AP)"),
		Picture				=	"AKANM55.png",
		attribute			= {wsType_Weapon, wsType_GContainer, wsType_Cannon_Cont, WSTYPE_PLACEHOLDER},
		wsTypeOfWeapon		= {wsType_Weapon, wsType_Shell, wsType_Shell_A, wsType_Shell_SPPU},
		Weight				= 49 + (180 * GIAT_ammo_weight), -- INCLUDE AMMO FOR FULL WEIGHT
        Weight_Empty        = 49,
		Cx_pil				= GIAT_NC621_cx,
		kind_of_shipping	= 2,--SOLID_MUNITION
		count				= 180,
		gun_mounts			= {
			GIATNC261(
				{
					mixes					= {{3,3,3,3,4}},
					muzzle_pos_connector   = "Point_Gun",
					effect_arg_number 	   = 433,
					ejector_pos_connector  = "eject 2",
					effects = {{name = "FireEffect", arg = 433 , attenuation = 1.0 , light_pos = {0.5,0.5,0} , light_time = 0.1},
						{name = "SmokeEffect"},
					},
				}, true)
		},
		shape_table_data =
		{
			{
				name		= "GIAT_NC621_AP_A29B";
				file		= "AKANM55";
				life		= 1;
				fire		= {0, 1};
				username	= "GIAT_NC621_AP_A29B";
				index		= WSTYPE_PLACEHOLDER;
			},
		},
		Elements = {
			[1]	= {
				Position	=	{0, 0, 0},
				ShapeName	=	"AKANM55",
			}, 
		}, -- end of Elements
	
	--m3_browing({muzzle_pos = {2.91,   0.42,  -0.5 }  	, rates = {1249},mixes = {{2,1,1,1,1,1}},effect_arg_number = 434,azimuth_initial = 0,elevation_initial = 0,supply_position = {2, -0.3, -0.4}}), --up
	}
)
---end GIAT

--FN pod

local function HMP400_A29B(tbl)

	tbl.category	= CAT_GUN_MOUNT 
	tbl.name		= "HMP400_A29B"
	tbl.supply		= 
	{
		shells	= {
					"M2_12_7",
					"M2_12_7_T"--, 
					--"M242_25_HE_M792" -- ANDR0ID Removed 25mm HE from .50 loadout
				 },
		mixes	= {
					{1},
					{2},
					--{3},
				}, 
		count	= 400,
	}
	if tbl.mixes then 
	   tbl.supply.mixes =  tbl.mixes
	   tbl.mixes	    = nil
	end
	if tbl.count then 
	   tbl.supply.count =  tbl.count
	   tbl.count	    = nil
	end
	tbl.gun = 
	{
		max_burst_length = 20,
		rates 			 = {1025},
		recoil_coeff 	 = 1,
		barrels_count 	 = 1,
	}
	if tbl.rates then 
	   tbl.gun.rates    =  tbl.rates
	   tbl.rates	    = nil
	end	
	tbl.ejector_pos 			= tbl.ejector_pos or {0.0, 0.0, 0.0}
	tbl.ejector_dir 			= {0,0,0}
	tbl.supply_position  		= tbl.supply_position or {0,  0.3, -0.3}
	tbl.aft_gun_mount 			= false
	tbl.effective_fire_distance = 3000
	tbl.drop_cartridge 			= 0
	tbl.muzzle_pos				= tbl.muzzle_pos or  {0,0,0} -- all position from connector
	tbl.muzzle_pos_connector	= tbl.muzzle_pos_connector or  "Point_Gun" -- all position from connector
	tbl.azimuth_initial 		= tbl.azimuth_initial    or 0   
	tbl.elevation_initial 		= tbl.elevation_initial  or 0   
	if  tbl.effects == nil then
		tbl.effects = {
			{ name = "FireEffect"     , arg = tbl.effect_arg_number or 436 },
			{ name = "HeatEffectExt"  , shot_heat = 7.823, barrel_k = 0.462 * 2.7, body_k = 0.462 * 14.3 },
			{ name = "SmokeEffect"}
		}
	end
	return declare_weapon(tbl)
end

declare_loadout(
	{
		category			=  CAT_PODS,
		CLSID				= "{FN_HMP400_A29B}",
		displayName			= _("FN HMP400 (400rnds .50 cal)"),
		Picture				=	"l081.png",
		attribute			= {wsType_Weapon, wsType_GContainer, wsType_Cannon_Cont, WSTYPE_PLACEHOLDER},
		wsTypeOfWeapon		= {wsType_Weapon, wsType_Shell, wsType_Shell_A, wsTypeVulkan},
		Weight				= 89 + (400 * FN_ammo_weight), -- INCLUDE AMMO FOR FULL WEIGHT
        Weight_Empty        = 89,
		Cx_pil				= FN_cx,
		kind_of_shipping	= 2,--SOLID_MUNITION
		gun_mounts			= {
			HMP400_A29B(
				{
					mixes					= {{1, 1, 2}},
					muzzle_pos				= {0.0, 0.0, 0.0},
					muzzle_pos_connector	= "Point_Gun",
					azimuth_initial			= 0.0, -- -0.04363323, -- 2.5 degs to the left
					effect_arg_number		= 433,
				}
			)
		},
		shape_table_data =
		{
			{
				name		= "HMP400_A29B";
				file		= "HMP400";
				life		= 1;
				fire		= {0, 1};
				username	= "HMP400";
				index		= WSTYPE_PLACEHOLDER;
			},
		},
		Elements = {
			[1]	= {
				Position	=	{0, 0, 0},
				ShapeName	=	"HMP400",
			}, 
		}, -- end of Elements
	
	--m3_browing({muzzle_pos = {2.91,   0.42,  -0.5 }  	, rates = {1249},mixes = {{2,1,1,1,1,1}},effect_arg_number = 434,azimuth_initial = 0,elevation_initial = 0,supply_position = {2, -0.3, -0.4}}), --up
	}
)

declare_loadout(
	{
		category			=  CAT_PODS,
		CLSID				= "{FN_HMP400_200_A29B}",
		displayName			= _("FN HMP400 (200rnds .50 cal)"),
		Picture				=	"l081.png",
		attribute			= {wsType_Weapon, wsType_GContainer, wsType_Cannon_Cont, WSTYPE_PLACEHOLDER},
		wsTypeOfWeapon		= {wsType_Weapon, wsType_Shell, wsType_Shell_A, wsTypeVulkan},
		Weight				= 89 + (200 * FN_ammo_weight), -- INCLUDE AMMO FOR FULL WEIGHT
        Weight_Empty        = 89,
		Cx_pil				= FN_cx,
		kind_of_shipping	= 2,--SOLID_MUNITION
		count				= 200,
		gun_mounts			= {
			HMP400_A29B(
				{
					mixes					= {{1, 1, 2}},
					muzzle_pos				= {0.0, 0.0, 0.0},
					count					= 200,
					muzzle_pos_connector	= "Point_Gun",
					azimuth_initial			= 0.0, -- -0.04363323, -- 2.5 degs to the left
					effect_arg_number		= 433,
				}
			)
		},
		shape_table_data =
		{
			{
				name		= "HMP400200_A29B";
				file		= "HMP400";
				life		= 1;
				fire		= {0, 1};
				username	= "HMP400200";
				index		= WSTYPE_PLACEHOLDER;
			},
		},
		Elements = {
			[1]	= {
				Position	=	{0, 0, 0},
				ShapeName	=	"HMP400",
			}, 
		}, -- end of Elements
	
	--m3_browing({muzzle_pos = {2.91,   0.42,  -0.5 }  	, rates = {1249},mixes = {{2,1,1,1,1,1}},effect_arg_number = 434,azimuth_initial = 0,elevation_initial = 0,supply_position = {2, -0.3, -0.4}}), --up
	}
)

declare_loadout(
	{
		category			=  CAT_PODS,
		CLSID				= "{FN_HMP400_100_A29B}",
		displayName			= _("FN HMP400 (100rnds .50 cal)"),
		Picture				=	"l081.png",
		attribute			= {wsType_Weapon, wsType_GContainer, wsType_Cannon_Cont, WSTYPE_PLACEHOLDER},
		wsTypeOfWeapon		= {wsType_Weapon, wsType_Shell, wsType_Shell_A, wsTypeVulkan},
		Weight				= 89 + (100 * FN_ammo_weight), -- INCLUDE AMMO FOR FULL WEIGHT
        Weight_Empty        = 89,
		Cx_pil				= FN_cx,
		kind_of_shipping	= 2,--SOLID_MUNITION
		count				= 100,
		gun_mounts			= {
			HMP400_A29B(
				{
					mixes					= {{1, 1, 2}},
					muzzle_pos				= {0.0, 0.0, 0.0},
					count					= 100,
					muzzle_pos_connector	= "Point_Gun",
					azimuth_initial			= 0.0, -- -0.04363323, -- 2.5 degs to the left
					effect_arg_number		= 433,
				}
			)
		},
		shape_table_data =
		{
			{
				name		= "HMP400100_A29B";
				file		= "HMP400";
				life		= 1;
				fire		= {0, 1};
				username	= "HMP400100";
				index		= WSTYPE_PLACEHOLDER;
			},
		},
		Elements = {
			[1]	= {
				Position	=	{0, 0, 0},
				ShapeName	=	"HMP400",
			}, 
		}, -- end of Elements
	
	--m3_browing({muzzle_pos = {2.91,   0.42,  -0.5 }  	, rates = {1249},mixes = {{2,1,1,1,1,1}},effect_arg_number = 434,azimuth_initial = 0,elevation_initial = 0,supply_position = {2, -0.3, -0.4}}), --up
	}
)
--END FN pod

--DAP6 GunPod by ANDR0ID
local function DAP6_A29B(tbl)

	tbl.category	= CAT_GUN_MOUNT 
	tbl.name		= "DAP6_A29B"
	tbl.supply		= 
	{
		shells	= {
					"M134_7_62_T"
				 },
		mixes	= {
					{1},
				}, 
		count	= 1000,
	}
	if tbl.mixes then 
	   tbl.supply.mixes =  tbl.mixes
	   tbl.mixes	    = nil
	end
	if tbl.count then 
	   tbl.supply.count =  tbl.count
	   tbl.count	    = nil
	end
	tbl.gun = 
	{
		max_burst_length = 60,
		rates 			 = {3000},
		recoil_coeff 	 = 1,
		barrels_count 	 = 1,
	}
	if tbl.rates then 
	   tbl.gun.rates    =  tbl.rates
	   tbl.rates	    = nil
	end	
	tbl.ejector_pos 			= tbl.ejector_pos or {0.0, 0.0, 0.0}
	tbl.ejector_dir 			= {0,0,0}
	tbl.supply_position  		= tbl.supply_position or {0,  0.3, -0.3}
	tbl.aft_gun_mount 			= false
	tbl.effective_fire_distance = 3000
	tbl.drop_cartridge 			= 0
	tbl.muzzle_pos				= tbl.muzzle_pos or  {0,0,0} -- all position from connector
	tbl.muzzle_pos_connector	= tbl.muzzle_pos_connector or  "Point_Gun" -- all position from connector
	tbl.azimuth_initial 		= tbl.azimuth_initial    or 0   
	tbl.elevation_initial 		= tbl.elevation_initial  or 0   
	if  tbl.effects == nil then
		tbl.effects = {
			{ name = "FireEffect"     , arg = tbl.effect_arg_number or 436 },
			{ name = "HeatEffectExt"  , shot_heat = 5.823, barrel_k = 0.462 * 2.7, body_k = 0.462 * 14.3 },
			{ name = "SmokeEffect"}
		}
	end
	return declare_weapon(tbl)
end

declare_loadout(
	{
		category			=  CAT_PODS,
		CLSID				= "{DAP_6_A29B}",
		displayName			= _("DAP-6 (1000rnds 7.62mm)"),
		Picture				=	"l081.png",
		attribute			= {wsType_Weapon, wsType_GContainer, wsType_Cannon_Cont, WSTYPE_PLACEHOLDER},
		wsTypeOfWeapon	= 	{wsType_Weapon,wsType_Shell,wsType_Shell,WSTYPE_PLACEHOLDER},
		Weight				= 5, --Will need to update in a later version
        Weight_Empty        = 5,
		Cx_pil				= DAP_cx,
		kind_of_shipping	= 2,--SOLID_MUNITION
		gun_mounts			= {
			DAP6_A29B(
				{
					mixes					= {{1,}},
					muzzle_pos				= {0.0, 0.0, 0.0},
					muzzle_pos_connector	= "Point_Gun",
					azimuth_initial			= 0.0, -- -0.04363323, -- 2.5 degs to the left
					effect_arg_number		= 433,
				}
			)
		},
		shape_table_data =
		{
			{
				name		= "DAP6_A29B";
				file		= "HMP400";
				life		= 1;
				fire		= {0, 1};
				username	= "HMP400";
				index		= WSTYPE_PLACEHOLDER;
			},
		},
		Elements = {
			[1]	= {
				Position	=	{0, 0, 0},
				ShapeName	=	"HMP400",
			}, 
		}, -- end of Elements
	}
)