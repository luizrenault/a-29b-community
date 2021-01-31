dofile(LockOn_Options.common_script_path.."elements_defs.lua")
-- dofile(LockOn_Options.script_path.."Scripts/symbols.lua")
SetScale(FOV)

DISPLAY_DEFAULT_LEVEL = 4

--BrigtnessController
BCont	=
{
	[1] = {"change_color_when_parameter_equal_to_number", 0, 1.0, 1.0, 1.0, 1.0},
	[2] = {"change_color_when_parameter_equal_to_number", 0, 0.9, 0.9, 0.9, 0.9},
	[3] = {"change_color_when_parameter_equal_to_number", 0, 0.8, 0.8, 0.8, 0.8},
	[4] = {"change_color_when_parameter_equal_to_number", 0, 0.7, 0.7, 0.7, 0.7},
	[5] = {"change_color_when_parameter_equal_to_number", 0, 0.6, 0.6, 0.6, 0.6},
	[6] = {"change_color_when_parameter_equal_to_number", 0, 0.5, 0.5, 0.5, 0.5},
	[7] = {"change_color_when_parameter_equal_to_number", 0, 0.4, 0.4, 0.4, 0.4},
	[8] = {"change_color_when_parameter_equal_to_number", 0, 0.3, 0.3, 0.3, 0.3},
	[9] = {"change_color_when_parameter_equal_to_number", 0, 0.2, 0.2, 0.2, 0.2},
	[10] = {"change_color_when_parameter_equal_to_number", 0, 0.1, 0.1, 0.1, 0.1},
}
						
function AddElement(object)
    object.use_mipfilter    = true
	object.additive_alpha   = true
	object.h_clip_relation  = h_clip_relations.COMPARE
	object.level			= DISPLAY_DEFAULT_LEVEL
	object.blend_mode 	=  blend_mode.IBM_REGULAR
	object.collimated = true
	object.indices = default_box_indices	
    Add(object)
end


function Add_Object_Image(object, objectname, objectparent, objectmaterial, imagepixelsizex, imagepixelsizey, initpixelposx, initpixelposy, objectelementparams, objectcontrollers)
	local object	    = CreateElement "ceTexPoly"
	object.name 		= objectname
	object.material   = objectmaterial	   
	object.vertices  = {{-(0.000244 * imagepixelsizex), (0.0001827 * imagepixelsizey) * GetAspect()},
						{ (0.000244 * imagepixelsizex), (0.0001827 * imagepixelsizey) * GetAspect()},
						{ (0.000244 * imagepixelsizex),-(0.0001827 * imagepixelsizey) * GetAspect()},
						{-(0.000244 * imagepixelsizex),-(0.0001827 * imagepixelsizey) * GetAspect()}}
	object.indices			= default_box_indices	
	object.tex_coords = {{0,0},{1,0},{1,1},{0,1}}
	object.init_pos = {(0.0004883 * initpixelposx) - 1, ((-0.0003654 * initpixelposy) + 1) * GetAspect()}
	object.element_params = objectelementparams
	object.controllers = objectcontrollers
	object.collimated = true
	object.parent_element = objectparent
	object.blend_mode 	=  blend_mode.IBM_REGULAR
	AddElement(object)
end

function Add_Object_Box(object, objectname, objectparent, objectmaterial, imagepixelsizex, imagepixelsizey, initpixelposx, initpixelposy, objectelementparams, objectcontrollers)
	local object	    = CreateElement "ceBoundingMeshBox"
	object.name 		= objectname
	object.primitivetype = "lines"
	object.width			= 0.5
	object.material   = objectmaterial	   
	object.vertices  = {{-(0.000244 * imagepixelsizex), (0.0001827 * imagepixelsizey) * GetAspect()},
						{ (0.000244 * imagepixelsizex), (0.0001827 * imagepixelsizey) * GetAspect()},
						{ (0.000244 * imagepixelsizex),-(0.0001827 * imagepixelsizey) * GetAspect()},
						{-(0.000244 * imagepixelsizex),-(0.0001827 * imagepixelsizey) * GetAspect()}}
	object.init_pos = {(0.0004883 * initpixelposx) - 1, ((-0.0003654 * initpixelposy) + 1) * GetAspect()}
	object.element_params = objectelementparams
	object.controllers = objectcontrollers
	object.h_clip_relation= h_clip_relations.COMPARE
	object.level 		    = DISPLAY_DEFAULT_LEVEL	
	-- object.geometry_hosts		= {PFD_Engine_Status_origin.name}
	object.parent_element = objectparent
	AddElement(object)
end

function Add_Object_Line(object, objectname, objectparent, objectmaterial, imagepixelsizex, imagepixelsizey, initpixelposx, initpixelposy, objectelementparams, objectcontrollers)
	local object	    = CreateElement "ceSimpleLineObject"
	object.name 		= objectname
	object.primitivetype = "lines"
	object.width			= 0.5
	object.material   = objectmaterial	   
	object.vertices  = {{-(0.000244 * imagepixelsizex), (0.0001827 * imagepixelsizey) * GetAspect()},
						{ (0.000244 * imagepixelsizex), (0.0001827 * imagepixelsizey) * GetAspect()}
						-- { (0.000244 * imagepixelsizex),-(0.0001827 * imagepixelsizey) * GetAspect()},
						-- {-(0.000244 * imagepixelsizex),-(0.0001827 * imagepixelsizey) * GetAspect()}
						}
	object.init_pos = {(0.0004883 * initpixelposx) - 1, ((-0.0003654 * initpixelposy) + 1) * GetAspect()}
	object.element_params = objectelementparams
	object.controllers = objectcontrollers
	object.h_clip_relation= h_clip_relations.COMPARE
	object.level 		    = DISPLAY_DEFAULT_LEVEL	
	-- object.geometry_hosts		= {PFD_Engine_Status_origin.name}
	object.parent_element = objectparent
	AddElement(object)
end


function Add_Object_Text_(object, objectname, objectparent, objectmaterial, objectalignment, format_value, stringdefs_value, initpixelposx, initpixelposy, objectelementparams, objectcontrollers)
	local object           = CreateElement "ceStringPoly"
	object.name            = objectname
	object.material        = objectmaterial
	object.element_params = objectelementparams
	object.controllers = objectcontrollers
	object.init_pos = {initpixelposx+stringdefs_value[3], initpixelposy+stringdefs_value[4]}
	object.alignment		= objectalignment
	if format_value ~= nil then
		if type(format_value) == "table" then
			object.formats = format_value
		else
			object.value = format_value
		end
	end
	object.stringdefs		= stringdefs_value--VerticalSize, HorizontalSize, HorizontalSpacing, VerticalSpacing
    object.use_mipfilter    = true
	object.additive_alpha   = true
	object.collimated		= false
	object.h_clip_relation  = h_clip_relations.COMPARE
	object.level			= DISPLAY_DEFAULT_LEVEL
	object.parent_element = objectparent
    Add(object)
end

function Add_Object_Text(object, objectname, objectparent, objectmaterial, objectalignment, format_value, stringdefs_value, initpixelposx, initpixelposy, objectelementparams, objectcontrollers)
	local object           = CreateElement "ceStringPoly"
	object.name            = objectname
	object.material        = objectmaterial
	object.element_params = objectelementparams
	object.controllers = objectcontrollers
	object.init_pos = {(0.0004883 * initpixelposx) - 1, ((-0.0003654 * initpixelposy) + 1) * GetAspect()}
	object.alignment		= objectalignment
	if format_value ~= nil then
		if type(format_value) == "table" then
			object.formats = format_value
		else
			object.value = format_value
		end
	end
	object.stringdefs		= stringdefs_value--VerticalSize, HorizontalSize, HorizontalSpacing, VerticalSpacing
    object.use_mipfilter    = true
	object.additive_alpha   = true
	object.collimated		= false
	object.h_clip_relation  = h_clip_relations.COMPARE
	object.level			= DISPLAY_DEFAULT_LEVEL
	object.parent_element = objectparent
    Add(object)
end

function Add_System_Status_Text(object, messagename, material, alignment, parent, element_param, range_lower, range_upper, format_value, initpixelposx, initpixelposy)
	local object           = CreateElement "ceStringPoly"
	object.name            = messagename
	object.material        = material
	object.element_params   = {
								"hdd_003_brightness",
								element_param,
							} 
	object.controllers 	   = {
									{"opacity_using_parameter",0},
									{"parameter_in_range",1,range_lower,range_upper},
									{"text_using_parameter",1,0},--first index is for element_params (starting with 0) , second for formats ( starting with 0)
								}
	object.init_pos			= {(0.001953 * initpixelposx) - 1, ((-0.001466 * initpixelposy) + 1) * GetAspect()}
	object.alignment		= alignment
	if format_value ~= nil then
		if type(format_value) == "table" then
			object.formats = format_value
		else
			object.value = format_value
		end
	end
	object.stringdefs		= {0.008,0.008,  -0.0048, 0}--VerticalSize, HorizontalSize, HorizontalSpacing, VerticalSpacing
    object.use_mipfilter    = true
	object.additive_alpha   = true
	object.collimated		= false
	object.h_clip_relation  = h_clip_relations.COMPARE
	object.level			= DEFAULT_LEVEL
	object.parent_element = parent
    Add(object)
end






-- foo.element_params = {"FOO_PARAM", "FOO_PARAM2"}
-- foo.controllers = {
    -- {"move_up_down_using_parameter", 0, 0.1 },
    -- {"change_color_when_parameter_equal_to_number", 1, 1, 0.0,1.0,0.0},
	
	
	    -- {"change_color_when_parameter_equal_to_number", 1, 1, 1.0,0.5,0.0},
    -- {"change_color_when_parameter_equal_to_number", 1, 0.9, 0.9,0.45,0.0},
    -- {"change_color_when_parameter_equal_to_number", 1, 0.8, 0.8,0.40,0.0},
    -- {"change_color_when_parameter_equal_to_number", 1, 0.7, 0.7,0.35,0.0},