--mounting 3d model paths and texture paths 

mount_vfs_model_path	(current_mod_path.."/Shapes")
mount_vfs_liveries_path (current_mod_path.."/Liveries")
mount_vfs_texture_path  (current_mod_path.."/Textures/A-29B.zip")
mount_vfs_texture_path  (current_mod_path.."/Textures/")
mount_vfs_sound_path    (current_mod_path.."/Sounds")

A_29B =  {
	Name 				=   'A-29B',
	DisplayName			= _('A-29B'),
	Cannon 				= "yes",
	HumanCockpit 		= false,
	HumanCockpitPath    = current_mod_path..'/Cockpit/',
	Picture 			= "A-29B.png",
	Rate 				= 40, -- RewardPoint in Multiplayer
	Shape 				= "A-29B",

	shape_table_data 	= 
	{
		{
			file  	 	= 'A-29B';
			life  	 	= 20; -- lifebar
			vis   	 	= 3; -- visibility gain.
			desrt    	= 'A-29B-collision'; -- Name of destroyed object file name
			fire  	 	= { 300, 2}; -- Fire on the ground after destoyed: 300sec 2m
			username	= 'A-29B';
			--index    	=  WSTYPE_PLACEHOLDER;---------------------------------------------------------------------------------------
			--index    	=  A-29B;---------------------------------------------------------------------------------------
		},
		{
			name  = "A-29B-collision";
			file  = "A-29B-collision";
			fire  = { 240, 2};
		},

	},
	mapclasskey 		= "P0091000024",
	
	
--WorldID      = 54,
--index          =  A_29B;
--attribute     = {wsType_Air, wsType_Airplane, wsType_Fighter, A_29B, Su_25T, "Fighters", "Refuelable",},
--Categories= {"{78EFB7A2-FD52-4b57-A6A6-3BF0E1D6555F}", "Interceptor",},


		
    index       =  WSTYPE_PLACEHOLDER;
	attribute  	= {wsType_Air, wsType_Airplane, wsType_Fighter, WSTYPE_PLACEHOLDER ,A_29B,"Fighters", "Refuelable",},
	Categories	= {"{78EFB7A2-FD52-4b57-A6A6-3BF0E1D6555F}", "Interceptor",},	
	    M_empty									=	3356,  -- kg
		M_nominal								=	3900,  -- kg  -- kg ~ %50 fuel, combat load
		M_max									=	5400,  -- kg
		M_fuel_max								=   509 + 239 + 249*2 + 231,   -- kg Asas, Fuselage, Subalar, Ventral,
		H_max									=	10668 , -- m

		average_fuel_consumption 	= 0.302, -- this is highly relative, but good estimates are 36-40l/min = 28-31kg/min = 0.47-0.52kg/s -- 45l/min = 35kg/min = 0.583kg/s
		CAS_min 					= 56, -- if this is not OVERAL FLIGHT TIME, but jus LOITER TIME, than it sholud be 10-15 minutes.....CAS capability in minute (for AI)
		V_opt 						= 67,-- Cruise speed (for AI) –- Assume Mach 0.80 at 20000 ft as optimal. See -- http://www.nasa.gov/centers/dryden/pdf/87789main_H-636.pdf and		–- http://www.hochwarth.com/misc/AviationCalculator.html 		–- Mach 0.8 at 20000 = XXX kts TAS = XXX m / s
		V_take_off 					= 28, -- Take off speed in m/s (for AI)
		V_land 						= 46, -- Land speed in m/s (for AI)
		V_max_sea_level 			= 165, -- Max speed at sea level in m/s (for AI)
		V_max_h 					= 75, -- Max speed at max altitude in m/s (for AI)
		Vy_max 						= 15, -- Max climb speed in m/s (for AI)
		Mach_max 					= 0.562, -- Max speed in Mach (for AI)
		Ny_min 						= -4, -- Min G (for AI)
		Ny_max 						= 8.0,  -- Max G (for AI)
		Ny_max_e 					= 8.0,  -- Max G (for AI)
		AOA_take_off 				= 0.14, -- AoA in take off (for AI)
		bank_angle_max 				= 60, -- Max bank angle (for AI)
	
		has_afteburner 				= false, -- AFB yes/no
		has_speedbrake 				= true, -- Speedbrake yes/no
		has_differential_stabilizer	= false, -- differential stabilizers

		main_gear_pos 				= 	{-1,	-2.03,	2.},
		nose_gear_pos 				= 	{2.808,	-2.09,	0},
		tand_gear_max				=	3.769, -- tangent of degrees of rotation max of nose wheel steering
		wing_area 					= 19.4, -- wing area in m2
		wing_span 					= 11.135, -- wing spain in m
		wing_type 					= 0,

		thrust_sum_max 				= 8224, -- thrust in kg (44kN)
		thrust_sum_ab 				= 8224, -- thrust inkg (71kN)
		length 						= 11.332, -- full lenght in m
		height 						= 3.974, -- height in m
		flaps_maneuver 				= 0.5, -- Max flaps in take-off and maneuver (0.5 = 1st stage; 1.0 = 2nd stage) (for AI)
		range 						= 1568, -- Max range in km (for AI)
		RCS 						= 2.5, -- Radar Cross Section m2
		IR_emission_coeff 			= 0.1, -- Normal engine -- IR_emission_coeff = 1 is Su-27 without afterburner. It is reference.
		IR_emission_coeff_ab 		= 0.1, -- With afterburner
		wing_tip_pos 				= {-0.82, -0.250,     5.5}, -- wingtip coords for visual effects
		nose_gear_wheel_diameter	=	0.754, --in m
		main_gear_wheel_diameter	=	0.972, -- in m
		brakeshute_name 			= 0, -- Landing - brake chute visual shape after separation
		
		-- The following is used for graphical AB effects
		engines_count				= 1, -- Engines count
		engines_nozzles = 
		{
			[1] = 
			{
				pos 		=  {1.624990,0.047866,-0.56}, -- nozzle coords
				elevation   =  0, -- AFB cone elevation –- for engines mounted at an angle to fuselage, change elevation
				diameter	 = 0*0.1, -- AFB cone diameter
				exhaust_length_ab   = -3.0, -- lenght in m
				exhaust_length_ab_K = 0.3, -- AB animation
				engine_number  = 1, --both to first engine
				smokiness_level     = 	0.1,  --both to first engine
			},
	
			[2] = 
			{
				pos 		=  {1.624990,0.047866,0.56}, -- nozzle coords
				elevation   =  0, -- AFB cone elevation
				diameter	 = 0*0.1, -- AFB cone diameter
				exhaust_length_ab   = -3.0, -- lenght in m
				exhaust_length_ab_K = 0.3, -- AB animation
				engine_number  = 1, --both to first engine
				smokiness_level     = 	0.1,  --both to first engine
			},
			
		
		}, -- end of engines_nozzles
		crew_size	 = 2,
		crew_members = 
		{
				[1] = 
				{	pilot_name            = "pilot_f86",
					ejection_seat_name	=	17,
					drop_canopy_name	=	'A-29B CANOPY',
					pos = 	{0,	0.3,	0},
				}, -- end of [1]
				
				[2] = 
				{	pilot_name            = "pilot_f86",
					ejection_seat_name	=	17,
					drop_canopy_name	=	0,
					pos = 	{-1.4,	0.5,	0},
				}, -- end of [2]
		}, -- end of crew_members
	
		fires_pos = 
		{
			[1] = 	{-2.117,	-0.9,	0},
			[2] = 	{0.500,	0.213,	0},
			[3] = 	{0.500,	0.213,	-2.182},
			[4] = 	{-0.82,	0.265,	2.774},
			[5] = 	{-0.82,	0.265,	-2.774},
			[6] = 	{-0.82,	0.255,	2.7274},
			[7] = 	{-0.82,	0.255,	-2.7274},
			[8] = 	{0.5,	-0.5,	2.7578},
			[9] = 	{0.5,	-0.5,	-2.578},
			[10] = 	{0.50,	0.084,	2.754},
			[11] = 	{0.50,	0.084,	-2.7534},
		}, -- end of fires_pos
	
		detection_range_max		 = 0, --is the max range in kilometers that the radar can see something large (e.g. a bomber, tanker, AWACS, etc.).
		radar_can_see_ground 	 = false, -- ground target identification capability, but this has not been verified

		CanopyGeometry = { -- Mk1 eyeball sensor for visual spotting targets
			azimuth = {-160.0, 160.0}, -- pilot view horizontal (AI)
			elevation = {-40.0, 90.0} -- pilot view vertical (AI)
		},

		Sensors = {
		},

		HumanRadio = {
			frequency = 127.5,  -- Radio Freq
			editable = true,
			minFrequency = 100.000,
			maxFrequency = 156.000,
			modulation = MODULATION_AM
		},
	
		-- Countermeasures
		SingleChargeTotal = 60,
		CMDS_Incrementation = 15,
		ChaffDefault = 30,
		ChaffChargeSize = 1,
		FlareDefault = 15,
		FlareChargeSize = 2,
		CMDS_Edit = false,
		chaff_flare_dispenser = {
			[1] =
			{
				dir = {-1, 0, 0}, -- dispenses to rear
				pos = {-6, 0, -0.8}, -- left rear of fuselage
			}, -- end of [1]
		}, -- end of chaff_flare_dispenser

		Pylons =     {
			pylon(1, 0, -0.200, -0.90, -3.230000,
				{
					arg = 308 ,arg_value = 0,
					use_full_connector_position = true,
				},
				{
					{ CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}" }, -- AIM-9P
								
					{ CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}" }, --GBU12
					{ CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}" }, --GBU16
	
					{ CLSID = "{4F977A2A-CD25-44df-90EF-164BFA2AE72F}" }, --LAU68-MK156
					{ CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}" }, -- LAU-61 - 19
	
					{ CLSID	= "AGM114x2_OH_58" }, --"AGM-114K * 2"
	
					{ CLSID = "{00F5DAC4-0466-4122-998F-B1A298E34113}" }, -- M-117
	
					{ CLSID = "{GBU_49}" ,arg_increment = 0.10 }, --FRENCH GBU-49
				}
			),
			pylon(2, 0, -0.200, -1.0, -2.3900,
				{
					use_full_connector_position = true,
				},
				{
					{ CLSID = "{A-29B TANK}" },
	
					{ CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}" }, --GBU12
					{ CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}" }, --GBU16
	
					{ CLSID = "{4F977A2A-CD25-44df-90EF-164BFA2AE72F}" }, --LAU68-MK156
					{ CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}" }, -- LAU-61 - 19
	
					{ CLSID	= "AGM114x2_OH_58" }, --"AGM-114K * 2"
	
	
					{ CLSID = "{00F5DAC4-0466-4122-998F-B1A298E34113}" }, -- M-117
	
	
					{ CLSID = "{CBU_105}" ,arg_increment = 0.0}, -- CBU-105	
					{ CLSID = "{GBU_49}" ,arg_increment = 0.10 }, --FRENCH GBU-49
				}
			),
			pylon(3, 0, -0.66, -1.2000, 0,
				{
					use_full_connector_position = true,
				},
				{
					{ CLSID = "{A-29B TANK}" },
					{ CLSID = "{00F5DAC4-0466-4122-998F-B1A298E34113}" }, -- M-117
					{ CLSID = "{GBU_49}" ,arg_increment = 0.10 }, --FRENCH GBU-49
	
				}
			),
			pylon(4, 0, -0.200, -1.0, 2.39,
				{
					use_full_connector_position = true,
				 },
				{
					{ CLSID = "{A-29B TANK}" },
	
					{ CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}" }, --GBU12
					{ CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}" }, --GBU16
	
					{ CLSID = "{4F977A2A-CD25-44df-90EF-164BFA2AE72F}" }, --LAU68-MK156
					{ CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}" }, -- LAU-61 - 19
	
					{ CLSID	= "AGM114x2_OH_58" }, --"AGM-114K * 2"
	
					{ CLSID = "{00F5DAC4-0466-4122-998F-B1A298E34113}" }, -- M-117
	
	
					{ CLSID = "{CBU_105}" ,arg_increment = 0.0}, -- CBU-105	
					{ CLSID = "{GBU_49}" ,arg_increment = 0.10 }, --FRENCH GBU-49
				}
			),
			pylon(5, 0, -0.20, -0.9, 3.23,
				{
					use_full_connector_position = true,
				 },
				{
					{ CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}" }, -- AIM-9P
	
					{ CLSID = "{DB769D48-67D7-42ED-A2BE-108D566C8B1E}" }, --GBU12
					{ CLSID = "{0D33DDAE-524F-4A4E-B5B8-621754FE3ADE}" }, --GBU16
	
					{ CLSID = "{4F977A2A-CD25-44df-90EF-164BFA2AE72F}" }, --LAU68-MK156
					{ CLSID = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}" }, -- LAU-61 - 19
	
					{ CLSID	= "AGM114x2_OH_58" }, --"AGM-114K * 2"
									
					{ CLSID = "{00F5DAC4-0466-4122-998F-B1A298E34113}" }, -- M-117
					{ CLSID = "{GBU_49}" ,arg_increment = 0.10 }, --FRENCH GBU-49
				}
			),
	},
	
	Tasks = {
        aircraft_task(CAP),
		aircraft_task(Escort),
      	aircraft_task(FighterSweep),
		aircraft_task(GroundAttack),
		aircraft_task(PinpointStrike),
      	aircraft_task(CAS),
       	aircraft_task(AFAC),
		aircraft_task(RunwayAttack),
		aircraft_task(AntishipStrike),
		aircraft_task(Intercept),
   	},	
	DefaultTask = aircraft_task(Intercept),



	SFM_Data = {
		aerodynamics = 
		{
			Cy0	=	0.1, -- Coefficient of lift at zero angle of attack -- Always 0 for symmetrical airfoil
			Mzalfa	=	4.355, -- Horizontal tail pitch coefficient
			Mzalfadt	=	1,  -- Wing pitch coefficient
			kjx = 2.25, -- Roll rate acceleration constant in radians / second  -- Inertia parametre X - Dimension (clean) airframe drag coefficient at X (Top) Simply the wing area in square meters (as that is a major factor in drag calculations) - smaller = massive inertia
			kjz = 0.00125,  -- Unknown pitch constant. All planes use 0.00125 -- -- Inertia parametre Z - Dimension (clean) airframe drag coefficient at Z (Front) Simply the wing area in square meters (as that is a major factor in drag calculations)
			Czbe = -0.016, -- Directional stability coefficient  -- coefficient, along Z axis (perpendicular), affects yaw, negative value means force orientation in FC coordinate system
			cx_gear = 0.0277, -- Additional coefficient of drag for gear extended
			cx_flap = 0.095, -- Additional coefficient of drag for flap extended
			cy_flap = 0.31, -- Additional coefficient of lift for flap extended
			cx_brk = 0.06, -- Additional coefficient of drag for air brakes
			table_data = 
			{
			-- Cx0 - Coefficient of drag for zero lift
			-- Cya - Coefficient of lift for angle of attack
			-- B - Induced drag factor
			-- B4 - Viscous drag factor
			-- Omxmax - Roll rate
			-- Aldop - Visual effects settings for stability / controlability
			-- Cymax - Maximum coefficient of lift, corresponding to αstall
			-- 
			--      M	 Cx0		 Cya		 B		 B4	      Omxmax	Aldop	Cymax
					{0.0,	0.0187,	0.0746,		0.052,	0.012,	0.15,		22.0,		1.45,	},
					{0.2,	0.0187,	0.0746,		0.052,	0.012,	0.796144,	22.0,		1.45,   },
					{0.3,	0.0187,	0.0722,		0.052,	0.015,	1.24,		19.0,		1.2,    },
					{0.5,	0.0187,	0.0798,		0.045,	0.025,	1.323,		17.0,		1.08,   },
					{0.59,	0.0187,	0.084,		0.047,	0.026,	1.129077,	17.0,		1.07,   },
					{0.67,	0.0187,	0.0907,		0.047,	0.021,	0.943,		14.5,		0.98,   },
					{0.74,	0.0227,	0.0855,		0.08,	0.16,	0.675,		10.0,	  	0.72,   },
					{0.76,	0.032,	0.078,		0.1,	0.25,	0.577,		9.0,  		0.6,    },
					{0.8,	0.063,	0.072,		0.2,	0.36,	0.456,		6.0,	    0.4,	},
					{0.83,	0.1,	0.0725,		0.34,	2.4,	0.32,		4.5,		0.3,	},
					{0.9,	0.126,	0.073,		0.56,	3.0,	0.076,		3.0,	    0.2,	},
					{1.1,	0.16,	0.03,		0.56,	3.0,	0.076,		1.0,		0.3		},
			}
		}, -- end of aerodynamics
		engine = 
		{
			Nmg		=	64.6, -- % RPM at idle
			MinRUD	=	0, -- always 0 in current modeled aircraft -- Min state of the throttle
			MaxRUD	=	1, -- always 1 in current modeled aircraft -- Max state of the throttle
			MaksRUD	=	1, -- .85 for afterburning, 1 for non-afterburning engine. -- Military power state of the throttle
			ForsRUD	=	1, -- .91 for afterburning, 1 for non-afterburning -- Afterburner state of the throttle
			typeng	=	3, -- E_TURBOJET = 0, E_TURBOJET_AB = 1, E_PISTON = 2, E_TURBOPROP = 3,	E_TURBOFAN    = 4,	E_TURBOSHAFT = 5
			hMaxEng	=	19.5, -- maximum operating altitude for the engine in km -- typically higher than service ceiling of the aircraft
			dcx_eng	=	0.0114, -- drag coefficient for the engine -- no correlation found -- most common values are 0.0085 and 0.0144
			cemax	=	1.24, -- kg / sec - fuel consumption for a single engine in dry configuration
			cefor	=	2.56, -- kg / sec - fuel consumption for a single engine in afterburner configuration
			dpdh_m	=	7000, --  altitude coefficient for max thrust -- altitude effects to thrust -- The best recommendation at this point is to start with these values between 2000 and 3000 and adjust as needed after initial flight testing
			dpdh_f	=	9000.0, --  altitude coefficient for AB thrust ???? or altitude effects to fuel rate -- The best recommendation at this point is to start with these values between 2000 and 3000 and adjust as needed after initial flight testing
			table_data = {
			-- Pmax - total thrust in Newtons (kN * 1000) for all engines
			-- Pfor - total thrust in Newtons (kN * 1000) for all engines
			--   M		Pmax		 Pfor
				{0.0,		16620.0},
				{0.1,		15600.0},
				{0.2,		14340.0},
				{0.3,		13320.0},
				{0.4,		12230.0},
				{0.5,		11300.0},
				{0.6,		10600.0},
				{0.7,		10050.0},
				{0.8,		 9820.0},
				{0.9,		 5902.0},
				{1.0,		 3469.0}
			}                 
		}, -- end of engine
		-- thrust_max = -- thrust interpolation table by altitude and mach number, 2d table.  Modified for carrier takeoffs at/around 71 foot deck height
        --         {
        --             M       =   {0, 0.1, 0.225, 0.23, 0.3, 0.5, 0.7, 0.8, 0.9, 1.1},
        --             H       =   {0, 19, 20, 23, 24, 250, 4572, 7620, 10668, 13716, 16764, 19812},
        --             thrust  =  {-- M    0     0.1    0.225   0.23,   0.3    0.5     0.7     0.8     0.9     1.1
        --                         {   41370,  39460,  38060,  38056,  37023,  36653,  36996,  37112,  36813,  34073 },--H = 0 (sea level)
        --                         {   41370,  39460,  38060,  38056,  37023,  36653,  36996,  37112,  36813,  34073 },--H = 19 (~62.3 feet)
        --                         {   41370,  39460,  38060,  38056,  37023,  36653,  36996,  37112,  36813,  34073 },--H = 20 (~66.6 feet)
        --                         {   41370,  39460,  38060,  38056,  37023,  36653,  36996,  37112,  36813,  34073 },--H = 23 (~75.5 feet)
        --                         {   41370,  39460,  38060,  38056,  37023,  36653,  36996,  37112,  36813,  34073 },--H = 24 (~78.7 feet)
        --                         {   41370,  39460,  38060,  38056,  37023,  36653,  36996,  37112,  36813,  34073 },--H = 250 (820 feet)
        --                         {   27254,  25799,  24765,  24761,  24203,  24599,  26227,  27254,  28353,  29785 },--H = 4572 (15kft)
        --                         {   20818,  19203,  18130,  18127,  17548,  17473,  18638,  19608,  20684,  22873 },--H = 7620 (25kft)
        --                         {   10876,  11076,  11128,  11130,  11556,  12193,  13024,  13674,  14434,  16098 },--H = 10668 (35kft)
        --                         {   6025,   6379,    6676,   6680,  6837,   7433,   8194,   8603,   9101,   10075 },--H = 13716 (45kft)
        --                         {   3336,   3554,    3837,   3840,  3990,   4484,   5000,   5307,   5596,   6232  },--H = 16764 (55kft)
        --                         {   1904,   2042,    2296,   2300,  2433,   2798,   3212,   3483,   3639,   4097  },--H = 19812 (65kft)
        --                        },
        --         },
		-- extended =
		-- {
		--   Cx0 = -- Interpolierung von Cx0 bei Geschwindikeit M und HÃ¶he H
		--   {-- minimum Cx0 ist xxx maximum Cx0 ist yyy
		-- 	M       = {0, 0.2, 0.4, 0.6, 0.7, 0.8, 0.9, 1, 1.05, 1.1, 1.2, 1.3, 1.5, 1.7, 1.8, 2, 2.1, 2.2, 3.9},--Machnumber as above
		-- 	H       = {0, 4572, 10668, 13716, 16764}, --HÃ¶he = SeaLevel, 15kft, 35kft, 45kft, 55kft
		-- 	Cdmin   = {--M    0     0.2     0.4     0.6     0.7     0.8     0.9     1       1.05    1.1     1.2     1.3     1.5     1.7     1.8       2      2.1     2.2     3.9
		-- 			   {    0.015,  0.5,    0.04,   0.019, 0.018,  0.015,  0.018,  0.045,   0.048,  0.05,   0.048,  0.047,  0.046,  0.046,  0.046,   0.046,  0.046,  0.046,  0.046,}, --SeaLevel 0
		-- 			   {    0.015,  0.015,  0.1,    0.027, 0.02,   0.019,  0.02,   0.045,   0.048,  0.05,   0.048,  0.047,  0.046,  0.046,  0.046,   0.046,  0.046,  0.046,  0.046,},-- 15kft
		-- 			   {    0.015,  0.015,  0.015,  0.12,  0.08,   0.04,   0.035,  0.05,    0.055,  0.06,   0.065,  0.06,   0.05,   0.04,   0.035,   0.025,  0.02,   0.015,  0.015,},-- 35kft
		-- 			   {    0.015,  0.015,  0.015,  0.015, 0.12,   0.1,    0.07,   0.075,   0.077,  0.08,   0.075,  0.07,   0.055,  0.05,   0.049,   0.0475, 0.045,  0.035,  0.031,},-- 45kft
		-- 			   {    0.015,  0.015,  0.015,  0.015, 0.05,   0.09,   0.11,   0.14,    0.13,   0.12,   0.1,    0.09,   0.07,   0.06,   0.055,   0.05,   0.0475, 0.042,  0.035,},-- 55kft
		-- 			  },
		--   },
		-- }, -- end of Cx0
	
		-- 	extended = -- added new abilities for engine performance setup. thrust data now can be specified as 2d table by Mach number and altitude. thrust specific fuel consumption tuning added as well
		-- 	{
		-- 		-- matching TSFC to mil thrust consumption at altitude at mach per NATOPS navy trials
		-- 		TSFC_max =  -- thrust specific fuel consumption by altitude and Mach number for RPM  100%, 2d table
		-- 		{
		-- 			M 		 = {0, 0.5, 0.8, 0.9, 1.0},
		-- 			H		 = {0, 3048, 6096, 9144, 12192},
		-- 			TSFC	 = {-- M 0      0.5     0.8       0.9     1.0
		-- 						{   0.86,  0.92,  1.012,    1.012,  1.003},--H = 0       -- SL
		-- 						{   0.86,  0.99,  1.025,    1.025,  1.016},--H = 3048    -- 10000'
		-- 						{   0.86,  0.96,  1.008,    1.008,  0.999},--H = 6096    -- 20000'
		-- 						{   0.86,  0.95,  0.984,    0.984,  0.974},--H = 9144    -- 30000'
		-- 						{   0.86,  0.94,  0.976,    0.976,  0.967},--H = 12192   -- 40000'
		-- 			}
		-- 		},
		-- },              


	},

	--damage , index meaning see in  Scripts\Aircrafts\_Common\Damage.lua
	Damage = {
		[0]		= {critical_damage = 5, args = {146}},
		[3]		= {critical_damage = 20,args = {65}}  ,
		[4]		= {critical_damage = 20, args = {150}},
		[5]		= {critical_damage = 20, args = {147}},
		[7]		= {critical_damage = 4, args = {249}} ,
		[9]		= {critical_damage = 3, args = {154}},
		[10]	= {critical_damage = 3, args = {153}},
		[11]	= {critical_damage = 3, args = {167}},
		[12]	= {critical_damage = 3, args = {161}},
		[15]	= {critical_damage = 5, args = {267}},
		[16]	= {critical_damage = 5, args = {266}},
		[23]	= {critical_damage = 8, args = {223}, deps_cells = {25}},
		[24]	= {critical_damage = 8, args = {213}, deps_cells = {26, 60}},
		[25]	= {critical_damage = 3, args = {226}},
		[26]	= {critical_damage = 3, args = {216}},
		[29]	= {critical_damage = 9, args = {224}, deps_cells = {31, 25, 23}},
		[30]	= {critical_damage = 9, args = {214}, deps_cells = {32, 26, 24, 60}},
		[31]	= {critical_damage = 4, args = {229}},
		[32]	= {critical_damage = 4, args = {219}},
		[35]	= {critical_damage = 10, args = {225}, deps_cells = {29, 31, 25, 23}},
		[36]	= {critical_damage = 10, args = {215}, deps_cells = {30, 32, 26, 24, 60}} ,
		[37]	= {critical_damage = 4, args = {227}},
		[38]	= {critical_damage = 4, args = {217}},
		[39]	= {critical_damage = 7,	args = {244}, deps_cells = {53}},
		[40]	= {critical_damage = 7, args = {241}, deps_cells = {54}},
		[45]	= {critical_damage = 9, args = {235}, deps_cells = {39, 51, 53}},
		[46]	= {critical_damage = 9, args = {233}, deps_cells = {40, 52, 54}},
		[51]	= {critical_damage = 3, args = {239}},
		[52]	= {critical_damage = 3, args = {237}},
		[53]	= {critical_damage = 3, args = {248}},
		[54]	= {critical_damage = 3, args = {247}},
		[55]	= {critical_damage = 20, args = {81}, deps_cells = {39, 40, 45, 46, 51, 52, 53, 54}},
		[59]	= {critical_damage = 5, args = {148}},
		[60]	= {critical_damage = 1, args = {144}},

		[83]	= {critical_damage = 3, args = {134}} ,-- nose wheel
		[84]	= {critical_damage = 3, args = {136}}, -- left wheel
		[85]	= {critical_damage = 3, args = {135}} ,-- right wheel
	},

	DamageParts = 
	{  
		[1] = "A-29B-collision", -- wing R
	},

	Failures = {
		{ id = 'asc', 		label = _('ASC'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'autopilot', label = _('AUTOPILOT'), enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'hydro',  	label = _('HYDRO'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'l_engine',  label = _('L-ENGINE'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'r_engine',  label = _('R-ENGINE'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'radar',  	label = _('RADAR'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'eos',  		label = _('EOS'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'helmet',  	label = _('HELMET'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		--{ id = 'mlws',  	label = _('MLWS'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'rws',  		label = _('RWS'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'ecm',   	label = _('ECM'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'hud',  		label = _('HUD'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'mfd',  		label = _('MFD'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },		
	},

	lights_data = {
        typename = "collection",
        lights = {
        [1] = { typename = "collection",
                lights = {
                    -- Top Anticollision Light (red)
                    --[1] = { typename = "strobelight", connector = "RED_BEACON_T", argument = 198, color = {1, 0, 0}, period = 1.2, phase_shift = 0 },
                    [1] = { typename = "strobelight", connector = "RED_BEACON_T", color = {1, 0, 0}, period = 1.2, phase_shift = 0 },
                    -- Bottom Anticollision Light (red)
                    --[2] = { typename = "strobelight", connector = "RED_BEACON_B", argument = 199, color = {1, 0, 0}, period = 1.2, phase_shift = 0 },
                    [2] = { typename = "strobelight", connector = "RED_BEACON_B", color = {1, 0, 0}, period = 1.2, phase_shift = 0 },
                    }
              },
        [2] = { typename = "collection",
                lights = {
                    -- Taxi Light
                    --[1] = { typename = "spotlight", connector = "MAIN_SPOT_PTR_01", argument = 208, dir_correction = {elevation = math.rad( 3)} },
                    [1] = { typename = "spotlight", connector = "MAIN_SPOT_PTR_01", dir_correction = {elevation = math.rad( 3)} },
                    }
              },
        [3] = { typename = "collection",
                lights = { --[[
                    -- Left Position Light (red)
                    [1] = { typename = "omnilight", connector = "RED_NAV_L", color = {1, 0, 0}, pos_correction  = {0.0, 0, -0.2}, argument  = 190 },
                    -- Right Position Light (green)
                    [2] = { typename = "omnilight", connector = "GREEN_NAV_R", color = {0, 1, 0}, pos_correction = {0.0, 0, 0.2}, argument  = 191 },
                    -- Tail Position Light (white)
                    [3] = { typename = "omnilight", connector = "WHITE_NAV_T", color = {1, 1, 1}, pos_correction  = {0, 0, 0}, argument  = 192 },   --]]
                    -- Left Position Light (red)
                    [1] = { typename = "omnilight", connector = "RED_NAV_L", color = {1, 0, 0}, pos_correction  = {0.0, 0, -0.2} },
                    -- Right Position Light (green)
                    [2] = { typename = "omnilight", connector = "GREEN_NAV_R", color = {0, 1, 0}, pos_correction = {0.0, 0, 0.2} },
                    -- Tail Position Light (white)
                    [3] = { typename = "omnilight", connector = "WHITE_NAV_T", color = {1, 1, 1}, pos_correction  = {0, 0, 0} },
                    }
              },
        }
    },

	stores_number	=	10,

	LandRWCategories = 
        {
            [1] = 
            {
                Name = "AircraftCarrier",
            }, -- end of [1]
        }, -- end of LandRWCategories
		MaxFuelWeight = "15245",
        MaxHeight = "20000",
        MaxSpeed = "3000",
        MaxTakeOffWeight = "41200",
        Picture = "A-29B.png",
        Rate = "30",
        Shape = "A-29B",
        TakeOffRWCategories = 
        {
            [1] = 
            {
                Name = "AircraftCarrier With Catapult",
            }, -- end of [1]
			[2] = 
            {
				Name = "AircraftCarrier With Tramplin",
            }, -- end of [2]
        }, -- end of TakeOffRWCategories
	
	

		Countermeasures = {
			ECM = "AN/ALQ-165"
		},

	passivCounterm = {
		CMDS_Edit = true,
		SingleChargeTotal = 2000,
		chaff = {default = 1000, increment = 1, chargeSz = 1},
		flare = {default = 1000,  increment = 1, chargeSz = 1},
	},

	chaff_flare_dispenser 	= {
			
		{ dir =  {0, -1, 0}, pos =   {-3.027,  0.35, -0.3}, }, -- Chaff L
		{ dir =  {0, -1, 0}, pos =   {-3.727,  0.35, 0.3}, },  -- Chaff R
	    { dir =  {0, -1,  0}, pos =  {-3.032,  0.35, -0.32}, }, -- Flares L	
		{ dir =  {0, -1,  0}, pos =  {-3.732,  0.35,  0.32}, }, -- Flares R
	},
		

	mapclasskey = "P0091000024",

	Guns = {
		MG_20({muzzle_pos = {0.96,-0.68, 2.32},_connector =  "Point_Gun_01_R",rates = {688},effect_arg_number = 350,mixes = {{1,2,2,3,3}},azimuth_initial = 0.0,elevation_initial = 0,supply_position = {4.5,0.22, 0.3}}),-- MITRAIL AVR 1 
		MG_20({muzzle_pos = {0.96, -0.68, -2.32},_connector =  "Point_Gun_01_L",rates = {688},effect_arg_number = 436,mixes = {{1,2,2,3,3}},azimuth_initial = 0.0,elevation_initial = 0,supply_position = {2.0, -0.25, 0.8}}),-- MITRAIL AVR 2 B
	},
}

add_aircraft(A_29B)
