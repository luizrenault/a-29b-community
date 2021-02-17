dofile(LockOn_Options.script_path .. "HUD/Indicator/HUD_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")

local SHOW_MASKS = false

local hw = GetScale()
local hh = GetAspect() * hw

local num_points = 64
local step       = math.rad(360.0/num_points)
local TFOV       = math.rad(20.0/2) * 1000.0

local CLIPFOV = math.rad(20/2) * 1000.0
local Rs      = 0.955 * CLIPFOV -- side gap
local Rl      = Rs * math.sin(math.rad(44.5))

local verts = {}
local inds = {}


-- verts上半部分
j = 0
for i = 0, num_points do
    verts[j+1] = { Rl * math.cos(i * step), Rs * math.sin(i * step)}
    j = j + 1
end
--[[
-- verts下半部分
j = #verts
for i = num_points/2 +  angle_offset/step , (num_points -  angle_offset/step) do
    verts[j+1] = { Rs * math.cos(i * step), Rl * math.sin(i * step)}
    j = j + 1
end
]]
-- inds

local larg = 110
local alt = 140
local rece = 30

verts = {{-larg, alt-rece}, {-larg+rece, alt }, { larg-rece, alt}, {larg, alt-rece}, {larg, -alt-rece}, {-larg, -alt-rece}}

j = 0
for i = 0, (#verts-3) do
    inds[j+1] = 0
    inds[j+2] = i + 1
    inds[j+3] = i + 2
    j = j + 3
end

local total_field_of_view           = CreateElement "ceMeshPoly"
total_field_of_view.name            = "total_field_of_view"
total_field_of_view.primitivetype   = "triangles"
total_field_of_view.vertices        = verts
total_field_of_view.material        = HUD_MAT_BASE1
total_field_of_view.indices         = inds
total_field_of_view.init_pos        = {0, 0, 0}
total_field_of_view.init_rot        = {0, 0, -44.5} -- degree NOT rad
total_field_of_view.h_clip_relation = h_clip_relations.REWRITE_LEVEL
total_field_of_view.level           = HUD_NOCLIP_LEVEL
total_field_of_view.collimated      = false
total_field_of_view.isvisible       = false
Add(total_field_of_view)

-- Crop Area
local clipPoly               = CreateElement "ceMeshPoly"
clipPoly.name                = "clipPoly-1"
clipPoly.primitivetype       = "triangles"
clipPoly.init_pos            = {0, 0, 0}
clipPoly.init_rot            = {0, 0 , -44.5} -- degree NOT rad
clipPoly.vertices            = verts -- {{TFOV,TFOV},{TFOV,-TFOV-10},{-TFOV,-TFOV-10},{-TFOV,TFOV}}
clipPoly.indices             = inds
clipPoly.material            = HUD_MAT_BASE2
clipPoly.h_clip_relation     = h_clip_relations.INCREASE_IF_LEVEL
clipPoly.level               = HUD_NOCLIP_LEVEL
clipPoly.collimated          = false
clipPoly.isvisible           = false
clipPoly.change_opacity      = true
clipPoly.element_params = {"HUD_ON"}
clipPoly.controllers = {{"parameter_compare_with_number",0,1}}


Add(clipPoly)

-- 伪双眼效果
local fake_double_eye_view           = CreateElement "ceTexPoly"
fake_double_eye_view.material        = HUD_TEX_CLIP
fake_double_eye_view.name            = "fake_double_eye_view"
fake_double_eye_view.tex_coords      = HUD_tex_coord(0, 0, 512, 512, 512, 512)
fake_double_eye_view.init_pos        = {0, -1 * HUD_HALF_HEIGHT/2, 0}
fake_double_eye_view.vertices        = {{ TFOV, TFOV}, { TFOV, -TFOV}, {-TFOV, -TFOV},{-TFOV, TFOV}}
fake_double_eye_view.indices         = DEF_BOX_INDICES
fake_double_eye_view.h_clip_relation = h_clip_relations.COMPARE
fake_double_eye_view.level           = HUD_DEFAULT_LEVEL
-- fake_double_eye_view.controllers     = {{"hud_fake_eye_view"},}
fake_double_eye_view.collimated      = true
fake_double_eye_view.isvisible       = true
fake_double_eye_view.additive_alpha  = true
fake_double_eye_view.use_mipfilter   = true
-- Add(fake_double_eye_view)

