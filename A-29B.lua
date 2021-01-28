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
		M_nominal								=	3900,  -- kg
		M_max									=	5400,  -- kg
		M_fuel_max								=   509 + 239 + 249*2 + 231,   -- kg Asas, Fuselage, Subalar, Ventral,
		H_max									=	10668 , -- m

		average_fuel_consumption 	= 0.302, -- this is highly relative, but good estimates are 36-40l/min = 28-31kg/min = 0.47-0.52kg/s -- 45l/min = 35kg/min = 0.583kg/s
		CAS_min 					= 56, -- if this is not OVERAL FLIGHT TIME, but jus LOITER TIME, than it sholud be 10-15 minutes.....CAS capability in minute (for AI)
		V_opt 						= 67,-- Cruise speed (for AI)
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
		tand_gear_max				=	3.769,
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
		IR_emission_coeff_ab 		= 0, -- With afterburner
		wing_tip_pos 				= {-0.82, -0.250,     5.5},
		nose_gear_wheel_diameter	=	0.754,
		main_gear_wheel_diameter	=	0.972,
		brakeshute_name 			= 0, -- Landing - brake chute visual shape after separation
		engines_count				= 1, -- Engines count
		engines_nozzles = 
		{
			[1] = 
			{
				pos 		=  {1.624990,0.047866,-0.56}, -- nozzle coords
				elevation   =  0, -- AFB cone elevation
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
	
		detection_range_max		 = 0,
		radar_can_see_ground 	 = false, -- this should be examined (what is this exactly?)

		HumanRadio = {
			frequency = 127.5,  -- Radio Freq
			editable = true,
			minFrequency = 100.000,
			maxFrequency = 156.000,
			modulation = MODULATION_AM
		},
	
		

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
      	aircraft_task(CAS),
       	aircraft_task(AFAC),
		aircraft_task(RunwayAttack),
		aircraft_task(AntishipStrike),
   	},	
	DefaultTask = aircraft_task(CAP),



	SFM_Data = {
		aerodynamics = 
		{
			Cy0	=	0,
			Mzalfa	=	6,
			Mzalfadt	=	1,
			kjx = 2.95,
			kjz = 0.00125,
			Czbe = -0.016,
			cx_gear = 0.0268,
			cx_flap = 0.06,
			cy_flap = 0.4,
			cx_brk = 0.085,
			table_data = 
			{
			--      M	 Cx0		 Cya		 B		 B4	      Omxmax	Aldop	Cymax
				{0.0,	0.0185,		0.055,		0.08,		0.22,	0.65,	25.0,	1.2 	},
				{0.2,	0.0185,		0.055,		0.08,		0.22,	1.80,	30.0,	1.2     },
				{0.4,	0.0519,		0.055,		0.08,	   	0.22,	3.00,	30.0,	1.2     },
				{0.6,	0.0510,		0.055,		0.05,		0.28,	4.20,	28.0,	1.2     },
				{0.7,	0.0510,		0.055,		0.05,		0.28,	4.20,	27.0,	1.15    },
				{0.8,	0.115,		0.055,		0.05,		0.28,	4.20,	25.7,	1.1     },
				{0.9,	0.200,		0.058,		0.09,		0.20,	4.20,	23.1,	1.07    },
				{1.0,	0.200,		0.062,		0.17,		0.15,	4.20,	18.9,	1.04    },
				{1.1,	0.200,		0.062,	   	0.235,		0.09,	3.78,	17.4,	1.02    },
				{1.2,	0.200,		0.062,	   	0.285,		0.08,	2.94,	17.0,	1.00 	},		
				{1.3,	0.200,		0.06,	   	0.29,		0.10,	2.10,	16.0,	0.92 	},				
				{1.4,	0.200,		0.056,	   	0.3,		0.136,	1.80,	15.0,	0.80 	},					
				{1.6,	0.200,		0.052,	   	0.34,		0.21,	1.08,	13.0,	0.7 	},					
				{1.8,	0.0400,		0.042,	   	0.34,		2.43,	0.96,	12.0,	0.55 	},		
				{2.2,	0.0400,		0.037,	   	0.49,		3.5,	0.84,	 10.0,	0.37 	},					
				{2.5,	0.0400,		0.033,		0.6,		4.7,	0.84,	 9.0,	0.3 	},		
				{3.9,	0.0400,		0.023,		0.9,		6.0,	0.84,	 7.0,	0.2		},				
			}
		}, -- end of aerodynamics
		engine = 
		{
			Nmg								=	64.6,
			MinRUD	=	0,
			MaxRUD	=	1,
			MaksRUD	=	0.85,
			ForsRUD	=	0.91,
			typeng	=	3,
            --[[
                E_TURBOJET = 0
                E_TURBOJET_AB = 1
                E_PISTON = 2
                E_TURBOPROP = 3
                E_TURBOFAN    = 4
                E_TURBOSHAFT = 5
            --]]
			hMaxEng	=	19.5,
			dcx_eng	=	0.0114,
			cemax	=	1.24,
			cefor	=	2.56,
			dpdh_m	=	7000,
			dpdh_f	=	9000.0,
			table_data = {
			--   M		Pmax		 Pfor
				{0.0,	65000,		112000},
				{0.2,	64000,		100000},
				{0.4,	62000,		105000},
				{0.6,	63000,		107000},
				{0.7,	65000,		110000},
				{0.8,	65000,		120000},
				{0.9,	65000,		135000},
				{1.0,	67000,		150000},
				{1.1,	63000,		158000},
				{1.2,	 94000,		168000},
				{1.3,	 84000,		185000},
				{1.4,	 71000,		100000},
				{1.6,	 34000,		118000},
				{1.8,	 19000,		137000},
				{2.2,	 17000,		170000},
				{2.5,	 19000,		190000},
				{3.9,	 82000,		110000},
				}                 
		}, -- end of engine
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
