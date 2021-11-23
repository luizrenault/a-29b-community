dofile(LockOn_Options.script_path.."BFI/definitions.lua")

SetScale(METERS)

-- dofile(LockOn_Options.script_path.."Scripts/symbols.lua")

	-- IBM_NO_WRITECOLOR						= 0, -- element will be rendered only to stencil buffer
	-- IBM_REGULAR								= 1, -- regular work with write mask set to RGBA
	-- IBM_REGULAR_ADDITIVE_ALPHA				= 2, -- regular work with write mask set to RGBA , additive alpha for HUD 
	-- IBM_REGULAR_RGB_ONLY					= 3, -- regular work with write mask set to RGB (without alpha)
	-- IBM_REGULAR_RGB_ONLY_ADDITIVE_ALPHA		= 4, -- regular work with write mask set to RGB (without alpha) , additive alpha for HUD 
	-- IBM_ONLY_ALPHA							= 5, -- write mask set only for alpha

-- alignment options:
--"RightBottom"
--"LeftTop"
--"RightTop"
--"LeftCenter"
--"RightCenter"
--"CenterBottom"
--"CenterTop"
--"CenterCenter"
--"LeftBottom"
--[[
SetScale  have generalized form input value : 
SetScale(MILLYRADIANS)
SetScale(FOV)
SetScale(METERS)

in case of FOV , GetScale()  will return half width of your indicator 

MILLYRADIANS :  0.001 * viewDistance , where viewDistance is default distance from pilot eye to indicator projection plane

text_using_parameter
move_up_down_using_parameter
move_left_right_using_parameter
rotate_using_parameter
parameter_in_range

]]--
-------MATERIALS-------
-- materials = {}   
-- materials["WHITE"]  = {255, 255, 255, 255}
-- materials["GREEN"]   = {0, 255, 0, 255}
-- materials["YELLOW"]   = {243, 116, 13, 255}
-- materials["RED"]    = {255, 0, 0, 255}
-- materials["BLACK"]    = {0, 0, 0, 255}
-- materials["AMBER"]    = {255, 194, 0, 255}

-- local aspect       = GetAspect() -- GetHalfHeight()/GetHalfWidth()
local width  	   = 0.088
local height 	   = width * GetAspect()
local initpixelposx
local initpixelposy
local imagepixelsizex
local imagepixelsizey

--------------------------------------------------------------------------------------------------------------------------------------------Flight_Data

-- local Flight_Data_origin	         = CreateElement "ceSimple"
-- Flight_Data_origin.name 		     = "Flight_Data_origin"
-- Flight_Data_origin.init_pos        = {0,0}
-- Flight_Data_origin.element_params   = {
								-- "HDD002_Flight_Data",
										   -- } 
-- Flight_Data_origin.controllers 	   = {
								-- {"parameter_in_range",0,0.95,1.05},
								-- }
-- AddElement(Flight_Data_origin)

-- local Flight_Data_Back	    = CreateElement "ceTexPoly"
-- Flight_Data_Back.name 		= "Flight_Data_Back"
-- Flight_Data_Back.material   = "Flight_Data"   
-- Flight_Data_Back.vertices = {{-width, height},
					  -- { width, height},
					  -- { width,-height},
					  -- {-width,-height}}
-- Flight_Data_Back.indices			= default_box_indices	
-- Flight_Data_Back.tex_coords = {{0,0},{1,0},{1,1},{0,1}}
-- Flight_Data_Back.init_pos   = {0,0} 
-- Flight_Data_Back.element_params   = {
							-- "hdd_002_brightness",
						-- } 
-- Flight_Data_Back.controllers 	   = {
								-- BCont[1],BCont[2],BCont[3],BCont[4],BCont[5],BCont[6],BCont[7],BCont[8],BCont[9],BCont[10],
							-- }
-- Flight_Data_Back.blend_mode = blend_mode.IBM_REGULAR_RGB_ONLY
-- Flight_Data_Back.parent_element = Flight_Data_origin.name
-- AddElement(Flight_Data_Back)

--------------------------------------------------------------------------------------------------------------------------------------------Engine_Status

local fontHeight=GetHalfHeight()*0.25
local fontWidth=GetHalfWidth()*0.175
local fontSpacing=-fontWidth/2.0
local smallFontWidth=fontWidth*0.5
local smallFontHeight=fontHeight*0.5
local smallFontSpacing=-smallFontWidth*0.5



local BFI_origin          = CreateElement "ceMeshPoly"
BFI_origin.name 			= "BFI_origin"
BFI_origin.material			= "BFI_Base"
BFI_origin.primitivetype	= "triangles"
BFI_origin.init_pos   		= {0,0} 
BFI_origin.h_clip_relation 	= h_clip_relations.INCREASE_IF_LEVEL -- this element will sit on level(.level + 1)
BFI_origin.level			= DISPLAY_DEFAULT_LEVEL
BFI_origin.isvisible      	= false -- IMPORTANT: do not show this MeshPoly, used as mask poly
BFI_origin.vertices 		= {{-GetHalfWidth(), GetHalfHeight()}, { GetHalfWidth(), GetHalfHeight()}, { GetHalfWidth(),-GetHalfHeight()}, {-GetHalfWidth(),-GetHalfHeight()}}
BFI_origin.indices			= default_box_indices	
BFI_origin.element_params  = {"BFI_brightness", "ELEC_EMERGENCY_RESERVE_OK"} 
BFI_origin.controllers 	 = 	{
								{"opacity_using_parameter", 0},
								{"parameter_compare_with_number",1,1}
							}
BFI_origin.use_mipfilter    = true
Add(BFI_origin)


-- local BFI_origin	         		 = CreateElement "ceSimple"
-- BFI_origin.name 		     = "BFI_origin"
-- BFI_origin.init_pos        = {0,0}
-- BFI_origin.element_params  = {"BFI",} 
-- BFI_origin.controllers 	 = {
-- 											{"parameter_in_range",0,0.95,1.05},
-- 									   }
-- AddElement(BFI_origin)

local left=GetHalfWidth()
local top=GetHalfHeight()


local BFI_Horiz_origin          = CreateElement "ceMeshPoly"
BFI_Horiz_origin.name 			= "BFI_Horiz_origin"
BFI_Horiz_origin.init_pos   	= {-0.0625*GetHalfWidth(),0} 
BFI_Horiz_origin.element_params  = {"BFI","BFI_ROLL"} 
BFI_Horiz_origin.controllers 	 = {{"parameter_in_range",0,0.95,1.05},{"rotate_using_parameter",1, 1 }}
BFI_Horiz_origin.parent_element 	= "BFI_origin"
BFI_Horiz_origin.level			= DISPLAY_DEFAULT_LEVEL+1
BFI_Horiz_origin.h_clip_relation  = h_clip_relations.COMPARE
BFI_Horiz_origin.use_mipfilter    = true

Add(BFI_Horiz_origin)


local BFIhorizon	    	= CreateElement "ceTexPoly"
BFIhorizon.name 			= "BFIhorizon"
BFIhorizon.material   		= "BFI_Horizon"
BFIhorizon.vertices 		= {{-GetHalfWidth(), 5*GetHalfHeight()}, { GetHalfWidth(), 5*GetHalfHeight()}, { GetHalfWidth(),-5*GetHalfHeight()}, {-GetHalfWidth(),-5*GetHalfHeight()}}
BFIhorizon.indices			= default_box_indices	
BFIhorizon.tex_coords 		= {{0,0},{1,0},{1,1},{0,1}}
BFIhorizon.init_pos   		= {0,0} 
-- BFIhorizon.blend_mode 		= blend_mode.IBM_NO_WRITECOLOR
BFIhorizon.parent_element 	= "BFI_Horiz_origin"
BFIhorizon.element_params 	= {"BFI_brightness", "BFI_PITCH"}
BFIhorizon.controllers 		= {{"opacity_using_parameter", 0}, {"move_up_down_using_parameter",1,-1.5*5*GetHalfHeight()/math.pi}}
BFIhorizon.use_mipfilter    = true
BFIhorizon.additive_alpha   = true
BFIhorizon.h_clip_relation = h_clip_relations.COMPARE
BFIhorizon.level			= DISPLAY_DEFAULT_LEVEL+1
-- BFIhorizon.blend_mode 		= blend_mode.IBM_REGULAR
BFIhorizon.collimated 		= true
Add(BFIhorizon)

local BFIias	    	= CreateElement "ceTexPoly"
BFIias.name 			= "BFIias"
BFIias.material   		= "BFI_Ias"   
BFIias.vertices 		= {{-GetHalfWidth(), 5*GetHalfHeight()}, { -GetHalfWidth()+24/80*GetHalfWidth(), 5*GetHalfHeight()}, { -GetHalfWidth()+24/80*GetHalfWidth(),0}, {-GetHalfWidth(),0}}
BFIias.indices			= default_box_indices	
BFIias.tex_coords 		= {{0,0},{1,0},{1,1},{0,1}}
BFIias.init_pos   		= {0,0} 
-- BFIias.blend_mode 		= blend_mode.IBM_NO_WRITECOLOR
BFIias.parent_element 	= "HDD001_PFD"
BFIias.element_params 	= {"BFI_brightness", "IAS"}
BFIias.controllers 		= {{"opacity_using_parameter", 0},{"move_up_down_using_parameter",1,-1*5*GetHalfHeight()/400}}
BFIias.use_mipfilter    = true
BFIias.additive_alpha   = true
BFIias.h_clip_relation = h_clip_relations.COMPARE
BFIias.level			= DISPLAY_DEFAULT_LEVEL
-- BFIias.blend_mode 		= blend_mode.IBM_REGULAR
BFIias.collimated 		= true
--Add(BFIias)

local BFIbank	    	= CreateElement "ceTexPoly"
BFIbank.name 			= "BFIbank"
BFIbank.material   		= "BFI_Bank"   
BFIbank.vertices 		= {{-GetHalfWidth()+0.0625*GetHalfWidth(), GetHalfHeight()}, { GetHalfWidth()+0.0625*GetHalfWidth(), GetHalfHeight()}, { GetHalfWidth()+0.0625*GetHalfWidth(),-GetHalfHeight()}, {-GetHalfWidth()+0.0625*GetHalfWidth(),-GetHalfHeight()}}
BFIbank.indices			= default_box_indices	
BFIbank.tex_coords 		= {{0,0},{1,0},{1,1},{0,1}}
BFIbank.init_pos   		= {0,0} 
-- BFIbank.blend_mode 		= blend_mode.IBM_REGULAR_RGB_ONLY
BFIbank.parent_element 	= "BFI_Horiz_origin"
BFIbank.level			= DISPLAY_DEFAULT_LEVEL
BFIbank.element_params 	= {"BFI_brightness"}
BFIbank.controllers 		= {{"opacity_using_parameter", 0}}
BFIbank.use_mipfilter    = true
Add(BFIbank)


local HDD001_PFD	    = CreateElement "ceTexPoly"
HDD001_PFD.name 		= "BFIbase"
HDD001_PFD.material   = "BFI_Back"   
HDD001_PFD.vertices = {{-left, top},
					  { left, top},
					  { left,-top},
					  {-left,-top}}
HDD001_PFD.indices			= default_box_indices	
HDD001_PFD.tex_coords = {{0,0},{1,0},{1,1},{0,1}}
HDD001_PFD.init_pos   = {0,0} 
-- HDD001_PFD.blend_mode = blend_mode.IBM_REGULAR_RGB_ONLY
HDD001_PFD.level			= DISPLAY_DEFAULT_LEVEL
HDD001_PFD.h_clip_relation  = h_clip_relations.REWRITE_LEVEL
HDD001_PFD.parent_element = "BFI_origin"
HDD001_PFD.element_params 	= {"BFI_brightness"}
--HDD001_PFD.controllers 		= {{"opacity_using_parameter", 0}}
HDD001_PFD.use_mipfilter    = true
Add(HDD001_PFD)

HDD001_PFD	    = CreateElement "ceTexPoly"
HDD001_PFD.name 		= "BFIbase"
HDD001_PFD.material   = "BFI_Background"   
HDD001_PFD.vertices = {{-left, top},
					  { left, top},
					  { left,-top},
					  {-left,-top}}
HDD001_PFD.indices			= default_box_indices	
HDD001_PFD.tex_coords = {{0,0},{1,0},{1,1},{0,1}}
HDD001_PFD.init_pos   = {0,0} 
-- HDD001_PFD.blend_mode = blend_mode.IBM_REGULAR_RGB_ONLY
HDD001_PFD.level			= DISPLAY_DEFAULT_LEVEL
HDD001_PFD.h_clip_relation  = h_clip_relations.REWRITE_LEVEL
HDD001_PFD.parent_element = "BFI_origin"
HDD001_PFD.element_params 	= {"BFI_brightness"}
HDD001_PFD.controllers 		= {{"opacity_using_parameter", 0}}
HDD001_PFD.use_mipfilter    = true
Add(HDD001_PFD)

Add_Object_Text_(hPa, "hPa", BFI_origin.name,
					"font_Arial_green",--objectmaterial
					"RightCenter",--objectalignment
					{"hPa"},--format_value
					{smallFontHeight,smallFontWidth,  smallFontSpacing, 0},--stringdefs_value
					GetHalfWidth(),--initpixelposx
					GetHalfHeight()-fontHeight*0.5-(fontHeight-smallFontHeight)/4.0,--initpixelposy
					{--params
						"BFI_brightness",
						"",
					},
					{--controllers
						{"opacity_using_parameter",0},
						{"text_using_parameter",1,0},
					}
				)
Add_Object_Text_(hPaValue, "hPaValue", BFI_origin.name,
				"font_Arial_green",--objectmaterial
				"RightCenter",--objectalignment
				{"%04.0f"},--format_value
				{fontHeight,fontWidth,  fontSpacing, 0},--stringdefs_value
				GetHalfWidth()-(smallFontWidth+smallFontSpacing)*3.5,--initpixelposx
				GetHalfHeight()-fontHeight*0.5,--initpixelposy
			{--params
					"BFI_brightness",
					"BFI_MB",
				},
				{--controllers
					{"opacity_using_parameter",0},
					{"text_using_parameter",1,0},
				}
			)

Add_Object_Text_(hdg, "hdg", BFI_origin.name,
		"font_Arial_red",--objectmaterial
		"CenterCenter",--objectalignment
		{"HDG"},--format_value
		{fontHeight,fontWidth,  fontSpacing, 0},--stringdefs_value
		0,--initpixelposx
		GetHalfHeight()-fontHeight*0.5,--initpixelposy
		{--params
			"BFI_brightness",
			"",
		},
		{--controllers
			{"opacity_using_parameter",0},
			{"text_using_parameter",1,0},
		}
	)


Add_Object_Text_(IAS, "IAS", BFI_origin.name,
"font_Bold_Arial_white",--objectmaterial
"RightCenter",--objectalignment
{"%03.0f"},--format_value
{fontHeight,fontWidth,  fontSpacing, 0},--stringdefs_value
4*(fontWidth+fontSpacing)-GetHalfWidth(),--initpixelposx
0,--initpixelposy
{--params
	"BFI_brightness",
	"IAS",
},
{--controllers
	{"opacity_using_parameter",0},
	{"text_using_parameter",1,0},
}
)

Add_Object_Text_(ALT, "ALT", BFI_origin.name,
"font_Bold_Arial_white",--objectmaterial
"RightCenter",--objectalignment
{"%04.0f"},--format_value
{fontHeight, fontWidth,  fontSpacing, 0},--stringdefs_value
GetHalfWidth(),--initpixelposx
0,--initpixelposy
{--params
	"BFI_brightness",
	"ALT",
},
{--controllers
	{"opacity_using_parameter",0},
	{"text_using_parameter",1,0},
}
)





