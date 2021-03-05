dofile(LockOn_Options.common_script_path .. "elements_defs.lua")
dofile(LockOn_Options.script_path .. "fonts.lua")
dofile(LockOn_Options.script_path .. "materials.lua")

SetScale(FOV)

DEFAULT_LEVEL = 9
default_material = "ufcp_material_def"
stroke_font			= "ufcp_font_def"
stroke_material		= "ufcp_material_def"
stroke_thickness  = 1 --0.25
stroke_fuzziness  = 0.6
additive_alpha		= false
default_element_params={"UFCP_BRIGHT"}
default_controllers={{"opacity_using_parameter", 0}}
collimated = false
use_mip_filter = true


if stringdefs == nil then stringdefs = {} end
STROKE_FNT_UFCP	    		= #stringdefs+1

width = GetHalfWidth()*2
height = GetHalfHeight()*2
stringdefs[STROKE_FNT_UFCP]			    = {height/5, height/5 * 64 / 52, -height/5 * 64 / 52 /2.5, 0}


function create_page_root()
    local page_root = addPlaceholder(nil, {0,0})
    page_root_name = page_root.name
    return page_root
end


