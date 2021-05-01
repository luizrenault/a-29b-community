-- rename it to description.lua
livery = 
{
    {"a29b_01.bmp", 0, "a29b_01", false};
    {"a29b_02.bmp", 0, "a29b_02", false};
	{"a29b_01.bmp", ROUGHNESS_METALLIC ,"a29b_RoughMet",false};

   --[[
        uncomment lines for customized dds/tga/bmp files
    --]]
    --{"A-29B Pilot.dds", 0, "a-29b pilot", false};
	--{"a29b_aircrew.bmp", 0, "a29b_aircrew", false};
    --{"A-29b_GLASS.tga.dds", 0, "a-29b_glass.tga", true};
    --{"Material #5217", 0, "flame_14.tga", true};
    --{"Material #5219", 0, "flame_12.tga", true};
    --{"Material #5220", 0, "flame_f14.tga", true};
    --{"Material #5221", 0, "flame_13.tga", true};
    --{"Material #5222", 0, "flame_f12.tga", true};
    --{"Material #5267", 0, "flame_f13.tga", true};
   
    --{"a29b_panels.bmp", 0, "a29b_panels", true};
    --{"a29b_prop.dds", 0, "a29b_prop", true};
    --{"light-green", 0, "bano-green", true};
    --{"light-red", 0, "bano-red", true};
    --{"light-white", 0, "bano-white", true};
    --{"light-yellow", 0, "bano-yellow", true};
    {"a29b_mirror", 0, "mirrors", true}; -- dynamic mirror replacement texture
}
----== below part is not required for cockpit livery ==----
--[[ name your own skin in default language (en)
     meanwhile, you can also name the skin in more than one languages,
     replace xx by [ru, cn, cs, de, es, fr, or it] ]]
name = "USAFAFSOC"
--name_xx = ""
--[[ assign the countries
     if you want no country limitation,
     then comment out below line]]
--countries = {""}
countries = {"USA", "BRA"}
