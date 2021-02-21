--Ammunition MG 7
local tracer_on_time = 0.01
declare_weapon({category = CAT_SHELLS,name =   "MG_20x64_APT",
  user_name		= _("MG_20x64_APT"),
  model_name    = "tracer_bullet_green",
  v0    		= 890.0,
  Dv0   		= 0.0060,
  Da0    		= 0.0022,
  Da1     		= 0.0,
  mass      	= 0.052,
  round_mass 	= 0.152,
  explosive     = 0.60000,
  life_time     = 30,
  caliber     	= 12.7,
  s         	= 0.0,
  j         	= 0.0,
  l         	= 0.0,
  charTime      = 0,
  cx        	= {0.5,1.27,0.70,0.200,2.30},
  k1        	= 2.0e-08,
  tracer_off    = 3,
  tracer_on		= tracer_on_time,
  smoke_tail_life_time = 0.7,
  scale_tracer  = 1,
  cartridge 	= 0,
})


declare_weapon({category = CAT_SHELLS,name =   "MG_20x64_HEI",
  user_name		= _("MG_20x64_HEI"),
  model_name    = "tracer_bullet_white",
  v0    		= 890.0,
  Dv0   		= 0.0060,
  Da0    		= 0.0022,
  Da1     		= 0.0,
  mass      	= 0.052,
  round_mass 	= 0.152,
  explosive     = 0.60000,
  life_time     = 30,
  caliber     	= 12.7,
  s         	= 0.0,
  j         	= 0.0,
  l         	= 0.0,
  charTime      = 0,
  cx        	= {0.5,1.27,0.70,0.200,2.30},
  k1        	= 2.0e-08,
  tracer_off    = 3,
  tracer_on		= tracer_on_time,
  smoke_tail_life_time = 0.7,
  scale_tracer  = 1,
  cartridge 	= 0,
})

function MG_20(tbl)

	tbl.category = CAT_GUN_MOUNT 
	tbl.name 	 = "MG_20"
	tbl.supply 	 =
	{
		shells = {"MG_20x64_API","MG_20x64_HEI"},
		mixes  = {{1,2,1,1,2,1}},
		count  = 250,
	}
	if tbl.mixes then 
	   tbl.supply.mixes =  tbl.mixes
	   tbl.mixes	    = nil
	end
	tbl.gun = 
	{
		max_burst_length = 250,
		rates 			 = {1025},
		recoil_coeff 	 = 1,
		barrels_count 	 = 1,
	}
	if tbl.rates then 
	   tbl.gun.rates    =  tbl.rates
	   tbl.rates	    = nil
	end	
	tbl.ejector_pos 			= tbl.ejector_pos or {-0.4, -1.2, 0.18}
	tbl.ejector_dir 			= {0,-1,0}
	tbl.supply_position  		= tbl.supply_position   or {0,  0.3, -0.3}
	tbl.aft_gun_mount 			= false
	tbl.effective_fire_distance = 1500
	tbl.drop_cartridge 			= 0
	tbl.muzzle_pos				= tbl.muzzle_pos 		 or  {0,0,0} -- all position from connector
	tbl.muzzle_pos_connector	= tbl.muzzle_pos_connector 		 or  "Gun_point" -- all position from connector
	tbl.azimuth_initial 		= tbl.azimuth_initial    or 0   
	tbl.elevation_initial 		= tbl.elevation_initial  or 0   
	if  tbl.effects == nil then
		tbl.effects = {{ name = "FireEffect"     , arg 		 = tbl.effect_arg_number or 436 },
					   { name = "HeatEffectExt"  , shot_heat = 7.823, barrel_k = 0.462 * 2.7, body_k = 0.462 * 14.3 },
					   { name = "SmokeEffect"}}
	end
	return declare_weapon(tbl)
end
