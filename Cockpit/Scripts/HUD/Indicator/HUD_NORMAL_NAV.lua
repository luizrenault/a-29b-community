----------------------------------------------------------------------------------------------------
--- must be loaded in HUD_NORMAL.lua

-- note:
--[[
hdg bar 10-deg distance is 34 mmil

]]

---- AoA bracket symbol
hud_E_indicator             = CreateElement "ceTexPoly"
hud_E_indicator.material    = HUD_TEX_IND1
hud_E_indicator.name        = "hud_E_indicator"
hud_E_indicator.vertices    = {{0, 37.669/2},{0, -37.669/2},{-15.068, -37.669/2},{-15.068, 37.669/2}}
hud_E_indicator.tex_coords  = HUD_tex_coord(128, 192, 96, 240, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_E_indicator.init_pos    = {0, 0, 0}
hud_E_indicator.indices     = DEF_BOX_INDICES
-- hud_E_indicator.controllers = {{"hud_check_power"},{"hud_aoa_bracket", 0.36, 0.6},{"hud_check_declutter"},} --1st: vert coef, 2nd: hori coeff
AddElementObject(hud_E_indicator)



--- 计划空速和高度
local texts ={
    {value="<", alignment="LeftCenter",  formats={"%s"}, init_pos={-97.312, spd_bar_vert_bias}, ctrls={{"hud_fp_spd", 0.03},{"hud_check_declutter"}}},
    {value=">", alignment="RightCenter", formats={"%s"}, init_pos={ 85.38, alt_bar_vert_bias},  ctrls={{"hud_fp_alt", 0.03},{"hud_check_declutter"}} },
}

for i=1, #(texts) do
    text_strpoly                = CreateElement "ceStringPoly"
    text_strpoly.material       = HUD_IND_FONT
    text_strpoly.init_pos       = texts[i].init_pos
    text_strpoly.alignment      = "CenterCenter"
    text_strpoly.stringdefs     = HUD_STRINGDEFS_DEF

    if texts[i].strdef       then text_strpoly.stringdefs    = texts[i].strdef       end
    if texts[i].alignment    then text_strpoly.alignment     = texts[i].alignment    end
    if texts[i].formats      then text_strpoly.formats       = texts[i].formats      end
    if texts[i].ctrls        then text_strpoly.controllers   = texts[i].ctrls        end
    if texts[i].value        then text_strpoly.value         = texts[i].value        end

    AddHUDElement(text_strpoly)
    text_strpoly = nil
end



-- 航向导引相关
hud_wpt_tdc                = CreateElement "ceTexPoly"
hud_wpt_tdc.material       = HUD_TEX_IND1
hud_wpt_tdc.vertices       = {{20.09/2, 20.09/2},{20.09/2, -20.09/2},{-20.09/2, -20.09/2},{-20.09/2, 20.09/2}}
hud_wpt_tdc.tex_coords     = HUD_tex_coord(0, 584, 128, 128, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_wpt_tdc.indices        = DEF_BOX_INDICES
hud_wpt_tdc.init_pos       = {0, 0, 0}
-- hud_wpt_tdc.controllers    = {{"hud_check_power"},{"hud_wpt_tdc"},{"hud_check_declutter"}}
AddHUDElement(hud_wpt_tdc)

hud_brg_indicator             = CreateElement "ceTexPoly"
hud_brg_indicator.material    = HUD_TEX_IND1
hud_brg_indicator.name        = "hud_brg_indicator"
hud_brg_indicator.vertices    = {{9.417,9.417},{9.417,-9.417},{-9.417,-9.417},{-9.417,9.417}}
hud_brg_indicator.tex_coords  = HUD_tex_coord(4, 320, 120, 120, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_brg_indicator.init_pos    = {0, 16.825, 0}
--hud_brg_indicator.init_pos    = {0, 0, 0}
hud_brg_indicator.indices     = DEF_BOX_INDICES
-- hud_brg_indicator.controllers    = {{"hud_check_power"},{"hud_nav_cmd_hdg", 0.034},{"hud_check_declutter"},}
AddElementObject(hud_brg_indicator)

hud_nav_designator_ball             = CreateElement "ceTexPoly"
hud_nav_designator_ball.material    = HUD_TEX_IND1
hud_nav_designator_ball.name        = "hud_nav_designator_ball"
hud_nav_designator_ball.vertices    = {{7.8475, 7.8475},{7.8475,-7.8475},{-7.8475,-7.8475},{-7.8475,7.8475}}
hud_nav_designator_ball.tex_coords  = HUD_tex_coord(0, 0, 100, 100, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_nav_designator_ball.init_pos    = {0, 0, 0}
hud_nav_designator_ball.indices     = DEF_BOX_INDICES
--hud_nav_designator_ball.parent_element = hud_brg_indicator.name
-- hud_nav_designator_ball.controllers    = {{"hud_check_power"},{"hud_nav_cdi", 0.034},{"hud_nav_designator_ball", 0.034},{"hud_check_declutter"},}
AddElementObject(hud_nav_designator_ball)

hud_nav_designator_crs                = CreateElement "ceMeshPoly"
hud_nav_designator_crs.material       = HUD_MAT_DEF
hud_nav_designator_crs.primitivetype  = "triangles"
hud_nav_designator_crs.name           = "hud_nav_designator_crs"
hud_nav_designator_crs.vertices       = {{1.259/2, 49.467},{1.259/2, 2.5115},{-1.259/2, 2.5115},{-1.259/2, 49.467}} -- around 2.5 deg
hud_nav_designator_crs.init_pos       = {0, 0, 0}
hud_nav_designator_crs.indices        = DEF_BOX_INDICES
hud_nav_designator_crs.parent_element = hud_nav_designator_ball.name
-- hud_nav_designator_crs.controllers    = {{"hud_check_power"},{"hud_nav_designator_crs", 0},{"hud_check_declutter"},}
AddElementObject(hud_nav_designator_crs)


hud_nav_designator_dist                = CreateElement "ceMeshPoly"
hud_nav_designator_dist.material       = HUD_MAT_DEF
hud_nav_designator_dist.primitivetype  = "triangles"
hud_nav_designator_dist.name           = "hud_nav_designator_dist"
hud_nav_designator_dist.vertices       = {{5, 1.259/2},{5, -1.259/2},{-5, -1.259/2},{-5, 1.259/2}} -- around 2.5 deg
hud_nav_designator_dist.init_pos       = {0, 0, 0}
hud_nav_designator_dist.indices        = DEF_BOX_INDICES
hud_nav_designator_dist.parent_element = hud_nav_designator_crs.name
-- hud_nav_designator_dist.controllers    = {{"hud_check_power"},{"hud_nav_designator_dist", 0.0025115, 0.0469555},{"hud_check_declutter"},}
AddElementObject(hud_nav_designator_dist)


hud_apr_designator_crs                = CreateElement "ceMeshPoly"
hud_apr_designator_crs.material       = HUD_MAT_DEF
hud_apr_designator_crs.primitivetype  = "triangles"
hud_apr_designator_crs.name           = "hud_apr_designator_crs"
hud_apr_designator_crs.vertices       = {{1.259/2, 22},{1.259/2, 2.5115},{-1.259/2, 2.5115},{-1.259/2, 22}} -- around 2.5 deg
hud_apr_designator_crs.init_pos       = {0, 0, 0}
hud_apr_designator_crs.indices        = DEF_BOX_INDICES
hud_apr_designator_crs.parent_element = hud_nav_designator_ball.name
-- hud_apr_designator_crs.controllers    = {{"hud_check_power"},{"hud_nav_designator_crs", 1},{"hud_check_declutter"},}
AddElementObject(hud_apr_designator_crs)


---- TCN
hud_tcn_mark_left                = CreateElement "ceTexPoly"
hud_tcn_mark_left.material       = HUD_TEX_IND1
hud_tcn_mark_left.tex_coords     = HUD_tex_coord(872, 62, 168, 58, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_tcn_mark_left.indices        = DEF_BOX_INDICES
hud_tcn_mark_left.vertices       = {{26.368/2, 9.104/2},{26.368/2, -9.104/2},{-26.368/2, -9.104/2},{-26.368/2, 9.104/2}}
hud_tcn_mark_left.init_pos       = {-17 * 1.5, 0, 0}
hud_tcn_mark_left.parent_element = fpm_name
-- hud_tcn_mark_left.controllers    = {{"hud_check_power"},{"hud_tcn_mark", -1},{"hud_check_declutter"}}
AddHUDElement(hud_tcn_mark_left)

hud_tcn_mark_right                = CreateElement "ceTexPoly"
hud_tcn_mark_right.material       = HUD_TEX_IND1
hud_tcn_mark_right.tex_coords     = HUD_tex_coord(872, 62, 168, 58, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_tcn_mark_right.indices        = DEF_BOX_INDICES
hud_tcn_mark_right.vertices       = {{26.368/2, 9.104/2},{26.368/2, -9.104/2},{-26.368/2, -9.104/2},{-26.368/2, 9.104/2}}
hud_tcn_mark_right.init_pos       = {17 * 1.5, 0, 0}
hud_tcn_mark_right.parent_element = fpm_name
-- hud_tcn_mark_right.controllers    = {{"hud_check_power"},{"hud_tcn_mark", 1},{"hud_check_declutter"}}
AddHUDElement(hud_tcn_mark_right)


hud_tcn_cdi                = CreateElement "ceTexPoly"
hud_tcn_cdi.material       = HUD_TEX_IND1
hud_tcn_cdi.tex_coords     = HUD_tex_coord(1080, 234, 70, 230, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_tcn_cdi.indices        = DEF_BOX_INDICES
hud_tcn_cdi.vertices       = {{10.987/2, 36.1/2},{10.987/2, -36.1/2},{-10.987/2, -36.1/2},{-10.987/2, 36.1/2}}
hud_tcn_cdi.init_pos       = {0, 0, 0}
hud_tcn_cdi.parent_element = fpm_name
-- hud_tcn_cdi.controllers    = {{"hud_check_power"},{"hud_tcn_cdi", 0.034},{"hud_check_declutter"}}
AddHUDElement(hud_tcn_cdi)

---- ILS
--{8, 8}, {8,-8}, {-8,-8},{-8, 8}
--local gap = 0.25

local _dummyils_loc          = CreateElement "ceSimple"
_dummyils_loc.init_pos       = {0, 0, 0}
_dummyils_loc.parent_element = fpm_name
_dummyils_loc.isvisible      = false
_dummyils_loc.collimated     = true
-- _dummyils_loc.controllers    = {{"hud_check_power"},{"hud_ils_loc", 3.0},{"hud_check_declutter"},}
AddElementObject(_dummyils_loc)

hud_ils_loc_up                 = CreateElement "ceMeshPoly"
hud_ils_loc_up.name            = "hud_ils_loc_up"
hud_ils_loc_up.material        = HUD_MAT_DEF
hud_ils_loc_up.primitivetype   = "triangles"
hud_ils_loc_up.vertices        = {{  1.256/2, 38.631},
                                  {  1.256/2, 14.774},
                                  { -1.256/2, 14.774},
                                  { -1.256/2, 38.631},}
hud_ils_loc_up.indices         = DEF_BOX_INDICES
hud_ils_loc_up.parent_element  = _dummyils_loc.name
hud_ils_loc_up.isdraw          = true
hud_ils_loc_up.isvisible       = true
hud_ils_loc_up.use_mipfilter   = true
hud_ils_loc_up.additive_alpha  = true
hud_ils_loc_up.collimated      = true
AddElementObject(hud_ils_loc_up)

hud_ils_loc_dn                 = CreateElement "ceMeshPoly"
hud_ils_loc_dn.name            = "hud_ils_loc_dn"
hud_ils_loc_dn.material        = HUD_MAT_DEF
hud_ils_loc_dn.primitivetype   = "triangles"
hud_ils_loc_dn.vertices        = {{  1.256/2, -6.572},
                                  {  1.256/2, -30.429},
                                  { -1.256/2, -30.429},
                                  { -1.256/2, -6.572},}
hud_ils_loc_dn.indices         = DEF_BOX_INDICES
hud_ils_loc_dn.parent_element  = _dummyils_loc.name
hud_ils_loc_dn.isdraw          = true
hud_ils_loc_dn.isvisible       = true
hud_ils_loc_dn.use_mipfilter   = true
hud_ils_loc_dn.additive_alpha  = true
hud_ils_loc_dn.collimated      = true
AddElementObject(hud_ils_loc_dn)


local _dummyils_gs          = CreateElement "ceSimple"
_dummyils_gs.init_pos       = {0, 0, 0}
_dummyils_gs.parent_element = fpm_name
_dummyils_gs.isvisible      = false
_dummyils_gs.collimated     = true
-- _dummyils_gs.controllers    = {{"hud_check_power"},{"hud_ils_gs", 0.7},{"hud_check_declutter"},}
AddElementObject(_dummyils_gs)

hud_ils_gs_left                 = CreateElement "ceMeshPoly"
hud_ils_gs_left.name            = "hud_ils_gs_left"
hud_ils_gs_left.material        = HUD_MAT_DEF
hud_ils_gs_left.primitivetype   = "triangles"
hud_ils_gs_left.vertices        = {{-15.068, 1.256/2},
                                   {-15.068, -1.256/2},
                                   { -34.53, -1.256/2},
                                   { -34.53, 1.256/2},}
hud_ils_gs_left.indices         = DEF_BOX_INDICES
hud_ils_gs_left.parent_element  = _dummyils_gs.name
hud_ils_gs_left.isdraw          = true
hud_ils_gs_left.isvisible       = true
hud_ils_gs_left.use_mipfilter   = true
hud_ils_gs_left.additive_alpha  = true
hud_ils_gs_left.collimated      = true
AddElementObject(hud_ils_gs_left)

hud_ils_gs_right                 = CreateElement "ceMeshPoly"
hud_ils_gs_right.name            = "hud_ils_gs_right"
hud_ils_gs_right.material        = HUD_MAT_DEF
hud_ils_gs_right.primitivetype   = "triangles"
hud_ils_gs_right.vertices        = {{15.068, 1.256/2},
                                    {15.068, -1.256/2},
                                    { 34.53, -1.256/2},
                                    { 34.53, 1.256/2},}
hud_ils_gs_right.indices         = DEF_BOX_INDICES
hud_ils_gs_right.parent_element  = _dummyils_gs.name
hud_ils_gs_right.isdraw          = true
hud_ils_gs_right.isvisible       = true
hud_ils_gs_right.use_mipfilter   = true
hud_ils_gs_right.additive_alpha  = true
hud_ils_gs_right.collimated      = true
AddElementObject(hud_ils_gs_right)





----------------------------------------------------------------------------------------------------
-- 以下为可防拥删除部分: pitch ladder / 速度条 / 高度条 / 航向条
----------------------------------------------------------------------------------------------------
local HW = 85.383/2
local HH = 18.834/2

local tex_coord_up      = HUD_tex_coord(328,   0,  544, 120, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
local tex_coord_down    = HUD_tex_coord(328, 192,  544, 120, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
local tex_coord_horizen = HUD_tex_coord(28,  120, 1144,  72, HUD_TEX_IND1_W, HUD_TEX_IND1_H)

--[[
tex_poly            = CreateElement "ceTexPoly"
tex_poly.name       = "hud_ladder_hori"
tex_poly.material   = HUD_TEX_IND1
tex_poly.indices    = DEF_BOX_INDICES
tex_poly.tex_coords = tex_coord_horizen
tex_poly.vertices   = { {86.87, 1}, {86.87,-1}, {-86.87,-1}, {-86.87, 1} }
tex_poly.init_pos = {0, 0, 0}
tex_poly.parent_element = "hud_fpm"
tex_poly.controllers    = { {"hud_pitch_ladder"},}

AddElementObject(tex_poly)
]]

_dummy_pl             = CreateElement "ceSimple"
_dummy_pl.name        = "hud_ladder_hori"
_dummy_pl.init_pos    = {0, 0, 0}
_dummy_pl.isvisible   = false
_dummy_pl.collimated  = true
_dummy_pl.controllers = {{"hud_pitch_ladder"},{"hud_check_declutter"},}
--_dummy_pl.parent_element = fpm_name
AddElementObject(_dummy_pl)


function add_pitch_ladder(tbl, ismain)
    for k,i in pairs(tbl) do
        ishori = 0
        if i == 0 then ishori = 1 end
    
        tex_poly            = CreateElement "ceTexPoly"
        tex_poly.name       = "hud_ladder_main" .. ismain .. "_" .. tostring(k)
        tex_poly.material   = HUD_TEX_IND1
        tex_poly.indices    = DEF_BOX_INDICES
        
        if i > 0 then
            tex_poly.tex_coords = tex_coord_up
            tex_poly.vertices   = {{ HW, HH},
                                   { HW, -HH},
                                   {-HW, -HH},
                                   {-HW, HH},}
        elseif i < 0 then
            tex_poly.tex_coords = tex_coord_down
            tex_poly.vertices   = {{ HW, HH},
                                   { HW, -HH},
                                   {-HW, -HH},
                                   {-HW, HH},}
        else
            tex_poly.tex_coords = tex_coord_horizen
            tex_poly.vertices   = {{ 89.778, 5.6505},
                                   { 89.778,-5.6505}, 
                                   {-89.778,-5.6505}, 
                                   {-89.778, 5.6505},}
        end
        
        tex_poly.init_pos = {0, i * DEGREE_TO_MRAD, 0}

        tex_poly.parent_element = _dummy_pl.name
        tex_poly.controllers    = {{"hud_pitch_ladder_appendix", 6.5, -14.5, ismain, ishori},{"hud_check_declutter"},}
        
        AddElementObject(tex_poly)

        -- 刻度数字
        if i ~= 0 then
            text_strpoly                 = CreateElement "ceStringPoly"
            text_strpoly.material        = HUD_IND_FONT
            text_strpoly.parent_element  = tex_poly.name
            --text_strpoly.init_pos        = {HW+2, i * DEGREE_TO_MRAD, 0}
            if i > 0 then
                text_strpoly.alignment   = "LeftTop"
                text_strpoly.init_pos    = {38, 1.57, 0}
            else
                text_strpoly.alignment   = "LeftBottom"
                text_strpoly.init_pos    = {38, -1.57, 0}
            end
            text_strpoly.value           = tostring(math.abs(i))
            text_strpoly.stringdefs      = HUD_STRINGDEFS_DEF
            AddElementObject(text_strpoly)
            text_strpoly = nil

            text_strpoly                = CreateElement "ceStringPoly"
            text_strpoly.material       = HUD_IND_FONT
            text_strpoly.parent_element = tex_poly.name
            --text_strpoly.init_pos       = {-HW-2, i * DEGREE_TO_MRAD, 0}
            if i > 0 then
                text_strpoly.alignment  = "RightTop"
                text_strpoly.init_pos   = {-38, 1.57, 0}
            else
                text_strpoly.alignment  = "RightBottom"
                text_strpoly.init_pos   = {-38, -1.57, 0}
            end
            text_strpoly.value          = tostring(math.abs(i))
            text_strpoly.stringdefs     = HUD_STRINGDEFS_DEF
            AddElementObject(text_strpoly)
            text_strpoly = nil
        end
        tex_poly = nil
    end
end

-- pitch ladder -90 ~ +90
local ladder_main = {-90,-85,-80,-75,-70,-65,-60,-55,-50,-45,-40,-35,-30,-25,-20,-15,-10,-5,0,
                    5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90}

local ladder_apr = {-87.5,-82.5,-77.5,-72.5,-67.5,-62.5,-57.5,-52.5,-47.5,-42.5,-37.5,-32.5,-27.5,-22.5,-17.5,-12.5,-7.5,-2.5,
                    2.5,7.5,12.5,17.5,22.5,27.5,32.5,37.5,42.5,47.5,52.5,57.5,62.5,67.5,72.5,77.5,82.5,87.5}

add_pitch_ladder(ladder_main, 1)
add_pitch_ladder(ladder_apr, 0)



--- 坡度
local roll_pcenter        = -109.365
local roll_radius         = 69
local roll_mark_width     = 1.259/2
local roll_mark_leng      = 6.295
local hud_roll_mark_angle = {-60, -45, -30, -20, -10, 0, 10, 20, 30, 45, 60}
local hud_roll_mark_scale = {1, 0.6, 1, 0.6, 0.6, 1, 0.6, 0.6, 1, 0.6, 1}

local _dummyroll          = CreateElement "ceSimple"
--_dummyroll.level          = HUD_DEFAULT_LEVEL + 1
_dummyroll.isvisible      = false
_dummyroll.init_pos       = {0, roll_pcenter, 0}
_dummyroll.controllers    = {{"hud_check_power"},{"hud_check_nav"},{"hud_check_declutter"},}
AddElementObject(_dummyroll)

for i = 1, #hud_roll_mark_angle do
    local br_mx = roll_radius * math.sin(math.pi*hud_roll_mark_angle[i]/180)
    local br_my = roll_radius * math.cos(math.pi*hud_roll_mark_angle[i]/180)
    hud_roll_mark_xx                 = CreateElement "ceMeshPoly"
    hud_roll_mark_xx.material        = HUD_MAT_DEF
    hud_roll_mark_xx.primitivetype   = "triangles"
    hud_roll_mark_xx.vertices        = {{  roll_mark_width, hud_roll_mark_scale[i] * roll_mark_leng},
                                        {  roll_mark_width, 0},
                                        { -roll_mark_width, 0},
                                        { -roll_mark_width, hud_roll_mark_scale[i] * roll_mark_leng},}
    hud_roll_mark_xx.indices         = DEF_BOX_INDICES
    hud_roll_mark_xx.init_rot        = {hud_roll_mark_angle[i], 0, 0}
    hud_roll_mark_xx.init_pos        = {br_mx, -br_my, 0}
    hud_roll_mark_xx.parent_element  = _dummyroll.name
    hud_roll_mark_xx.isdraw          = true
    hud_roll_mark_xx.isvisible       = true
    hud_roll_mark_xx.use_mipfilter   = true
    hud_roll_mark_xx.additive_alpha  = true
    hud_roll_mark_xx.collimated      = true
    AddElementObject(hud_roll_mark_xx)
    hud_roll_mark_xx = nil
end

hud_roll_ind                 = CreateElement "ceTexPoly"
hud_roll_ind.material        = HUD_TEX_IND1
hud_roll_ind.vertices        = {{11.301/2, 11.301/2},{11.301/2, -11.301/2},{-11.301/2, -11.301/2},{-11.301/2, 11.301/2}}
hud_roll_ind.tex_coords      = HUD_tex_coord(28, 440, 72, 72, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_roll_ind.indices         = DEF_BOX_INDICES
hud_roll_ind.init_pos        = {0, 0, 0}
hud_roll_ind.parent_element  = _dummyroll.name
hud_roll_ind.controllers     = {{"hud_roll_indicator", -roll_radius*MMIL2MIL},{"hud_check_declutter"},}
hud_roll_ind.isdraw          = true
hud_roll_ind.isvisible       = true
hud_roll_ind.use_mipfilter   = true
hud_roll_ind.additive_alpha  = true
hud_roll_ind.collimated      = true
AddElementObject(hud_roll_ind)


hud_roll_slide                 = CreateElement "ceTexPoly"
hud_roll_slide.material        = HUD_TEX_IND1
hud_roll_slide.vertices        = {{20.09/2, 11.301/2-4.087},{20.09/2, -11.301/2-4.087},{-20.09/2, -11.301/2-4.087},{-20.09/2, 11.301/2-4.087}}
hud_roll_slide.tex_coords      = HUD_tex_coord(0, 512, 128, 72, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_roll_slide.indices           = DEF_BOX_INDICES
hud_roll_slide.init_pos        = {0, 0, 0}
hud_roll_slide.parent_element  = _dummyroll.name
hud_roll_slide.controllers     = {{"hud_slide_indicator", -roll_radius*MMIL2MIL, 0.068},{"hud_check_declutter"},}
hud_roll_slide.isdraw          = true
hud_roll_slide.isvisible       = true
hud_roll_slide.use_mipfilter   = true
hud_roll_slide.additive_alpha  = true
hud_roll_slide.collimated      = true
AddElementObject(hud_roll_slide)
hud_roll_slide = nil



----------------------------------------------------
-- 速度条
local tex_coord_box  = HUD_tex_coord(224, 312, 268, 152, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
local SIDE_OFFSET    = HUD_HALF_WIDTH*5/12
HW = 42.064/2
HH = 23.857/2

--速度框层
tex_poly             = CreateElement "ceTexPoly"
tex_poly.material    = HUD_TEX_IND1
tex_poly.tex_coords  = tex_coord_box
tex_poly.init_pos    = {-113.321, spd_bar_vert_bias, 0}
tex_poly.vertices    = {{ HW, HH}, { HW, -HH}, {-HW, -HH}, {-HW, HH},}
tex_poly.indices     = DEF_BOX_INDICES
tex_poly.controllers = {{"hud_check_power"},{"hud_check_declutter"},}
AddElementObject(tex_poly)
tex_poly = nil

tex_poly             = CreateElement "ceTexPoly"
tex_poly.material    = HUD_TEX_IND1
tex_poly.name        = "SPD_Box"
tex_poly.tex_coords  = tex_coord_box
tex_poly.init_pos    = {-113.625, spd_bar_vert_bias, 0}
tex_poly.vertices    = {{30.845/2, 11.961/2}, {30.845/2,-11.961/2}, {-30.845/2,-11.961/2}, {-30.845/2,11.961/2}}
tex_poly.indices     = DEF_BOX_INDICES
tex_poly.h_clip_relation = h_clip_relations.REWRITE_LEVEL
tex_poly.isvisible       = false
tex_poly.use_mipfilter   = true
tex_poly.additive_alpha  = true
tex_poly.collimated      = true
tex_poly.level           = HUD_DEFAULT_LEVEL + 2
tex_poly.controllers     = {{"hud_check_power"},{"hud_check_declutter"},}
Add(tex_poly)
tex_poly = nil


--速度条clip层
clipPoly                = CreateElement "ceMeshPoly"
clipPoly.name           = "clipPoly-spd"
clipPoly.primitivetype  = "triangles"
clipPoly.init_pos       = {-101.164, spd_bar_vert_bias, 0}
clipPoly.vertices       = {{HW/2, 88.13/2},{HW/2, -88.13/2},{-2*HW, -88.13/2},{-2*HW, 88.13/2}}
clipPoly.indices        = DEF_BOX_INDICES
clipPoly.material       = HUD_MAT_DEF
clipPoly.h_clip_relation= h_clip_relations.INCREASE_IF_LEVEL
clipPoly.level          = HUD_DEFAULT_LEVEL
clipPoly.collimated     = true
clipPoly.isvisible      = false
clipPoly.controllers    = {{"hud_check_power"},{"hud_check_declutter"},}
Add(clipPoly)
clipPoly = nil

--速度条
local _dummyspd          = CreateElement "ceSimple"
_dummyspd.level          = HUD_DEFAULT_LEVEL + 1
_dummyspd.isvisible      = false
_dummyspd.init_pos       = {-98.2, spd_bar_vert_bias, 0}
_dummyspd.controllers    = {{"hud_check_power"},{"hud_move_speedtape", 0.03},{"hud_check_declutter"},}
AddElementObject(_dummyspd)

hud_spd_scale_long0                 = CreateElement "ceMeshPoly"
hud_spd_scale_long0.name            = "hud_spd_scale_long_0"
hud_spd_scale_long0.material        = HUD_MAT_DEF
hud_spd_scale_long0.primitivetype   = "triangles"
hud_spd_scale_long0.vertices        = {{  0, 1.256/2},
                                       {  0, -1.256/2},
                                       { -6.278, -1.256/2},
                                       { -6.278, 1.256/2},}
hud_spd_scale_long0.indices         = DEF_BOX_INDICES
--hud_spd_scale_long0.init_pos        = {adi_spdbar_bias, 0, 0}
--hud_spd_scale_long0.h_clip_relation = h_clip_relations.COMPARE
hud_spd_scale_long0.level           = HUD_DEFAULT_LEVEL + 1
hud_spd_scale_long0.parent_element  = _dummyspd.name
hud_spd_scale_long0.isdraw          = true
hud_spd_scale_long0.isvisible       = true
hud_spd_scale_long0.use_mipfilter   = true
hud_spd_scale_long0.additive_alpha  = true
hud_spd_scale_long0.collimated      = true
--hud_spd_scale_long0.controllers     = {{"adi_spd_boxclip", 0.06},}
AddElementObject(hud_spd_scale_long0)


hud_spd_scale_idx0                 = CreateElement "ceStringPoly"
hud_spd_scale_idx0.name            = "hud_spd_scale_idx_0"
hud_spd_scale_idx0.material        = HUD_IND_FONT
hud_spd_scale_idx0.stringdefs      = HUD_STRINGDEFS_DEF
hud_spd_scale_idx0.init_pos        = {-6.278-0.942, 0, 0}
hud_spd_scale_idx0.alignment       = "RightCenter"
--hud_spd_scale_idx0.formats         = {"%02.0f","%s"}
hud_spd_scale_idx0.value           = "0"
--hud_spd_scale_idx0.h_clip_relation = h_clip_relations.COMPARE
hud_spd_scale_idx0.level           = HUD_DEFAULT_LEVEL + 1
hud_spd_scale_idx0.parent_element  = _dummyspd.name
hud_spd_scale_idx0.isdraw          = true
hud_spd_scale_idx0.isvisible       = true
hud_spd_scale_idx0.use_mipfilter   = true
hud_spd_scale_idx0.additive_alpha  = true
hud_spd_scale_idx0.collimated      = true
--hud_spd_scale_idx0.controllers     = {{"adi_spd_boxclip", 0.06},}
AddElementObject(hud_spd_scale_idx0)
hud_spd_scale_idx0 = nil

for i=-1,120 do
    --for k=0,1 do
    if i ~= 0 then
        local dir = 1
        if i < 0 then dir = -1 end
        i_plus = math.abs(i)
        
        -- short
        for j=1,4 do
            local short_id = (i_plus-1)*5+j
            hud_spd_scale_short0                 = CreateElement "ceMeshPoly"
            --hud_spd_scale_short0.name            = "hud_spd_scale_short_" .. short_id
            hud_spd_scale_short0.material        = HUD_MAT_DEF
            hud_spd_scale_short0.primitivetype   = "triangles"
            hud_spd_scale_short0.vertices        = {{  0, 1.256/2},
                                                    {  0, -1.256/2},
                                                    { -3.767, -1.256/2},
                                                    { -3.767, 1.256/2},}
            hud_spd_scale_short0.indices         = DEF_BOX_INDICES
            hud_spd_scale_short0.init_pos        = {0, dir * short_id * 6, 0}
            --hud_spd_scale_short0.h_clip_relation = h_clip_relations.COMPARE
            hud_spd_scale_short0.level           = HUD_DEFAULT_LEVEL + 1
            hud_spd_scale_short0.parent_element  = _dummyspd.name
            hud_spd_scale_short0.isdraw          = true
            hud_spd_scale_short0.isvisible       = true
            hud_spd_scale_short0.use_mipfilter   = true
            hud_spd_scale_short0.additive_alpha  = true
            hud_spd_scale_short0.collimated      = true
            hud_spd_scale_short0.controllers     = {{"hud_spd_boxclip", 0.045, spd_bar_vert_bias*MMIL2MIL},{"hud_check_declutter"},}
            AddElementObject(hud_spd_scale_short0)
            hud_spd_scale_short0 = nil
        end
        
        hud_spd_scale_long                 = CreateElement "ceMeshPoly"
        --hud_spd_scale_long.name            = "hud_spd_scale_long_" .. i
        hud_spd_scale_long.material        = HUD_MAT_DEF
        hud_spd_scale_long.primitivetype   = "triangles"
        hud_spd_scale_long.vertices        = {{  0, 1.256/2},
                                              {  0, -1.256/2},
                                              { -6.278, -1.256/2},
                                              { -6.278, 1.256/2},}
        hud_spd_scale_long.indices         = DEF_BOX_INDICES
        hud_spd_scale_long.init_pos        = {0, i * 30, 0}
        --hud_spd_scale_long.h_clip_relation = h_clip_relations.COMPARE
        hud_spd_scale_long.level           = HUD_DEFAULT_LEVEL + 1
        hud_spd_scale_long.parent_element  = _dummyspd.name
        hud_spd_scale_long.isdraw          = true
        hud_spd_scale_long.isvisible       = true
        hud_spd_scale_long.use_mipfilter   = true
        hud_spd_scale_long.additive_alpha  = true
        hud_spd_scale_long.collimated      = true
        hud_spd_scale_long.controllers     = {{"hud_spd_boxclip", 0.045, spd_bar_vert_bias*MMIL2MIL},{"hud_check_declutter"},}
        AddElementObject(hud_spd_scale_long)
        hud_spd_scale_long = nil

        hud_spd_scale_idx                 = CreateElement "ceStringPoly"
        --hud_spd_scale_idx.name            = "hud_spd_scale_idx_" .. i
        hud_spd_scale_idx.material        = HUD_IND_FONT
        hud_spd_scale_idx.stringdefs      = HUD_STRINGDEFS_DEF
        hud_spd_scale_idx.init_pos        = {-6.278-0.942, i * 30, 0}
        hud_spd_scale_idx.alignment       = "RightCenter"
        --hud_spd_scale_idx.formats         = {"%02.0f","%s"}
        hud_spd_scale_idx.value           = i
        --hud_spd_scale_idx.h_clip_relation = h_clip_relations.COMPARE
        hud_spd_scale_idx.level           = HUD_DEFAULT_LEVEL + 1
        hud_spd_scale_idx.parent_element  = _dummyspd.name
        hud_spd_scale_idx.isdraw          = true
        hud_spd_scale_idx.isvisible       = true
        hud_spd_scale_idx.use_mipfilter   = true
        hud_spd_scale_idx.additive_alpha  = true
        hud_spd_scale_idx.collimated      = true
        hud_spd_scale_idx.controllers     = {{"hud_spd_boxclip", 0.045, spd_bar_vert_bias*MMIL2MIL},{"hud_check_declutter"},}
        AddElementObject(hud_spd_scale_idx)
        hud_spd_scale_idx = nil
    end
end


---- 高度条
local tex_coord_box  = HUD_tex_coord(716, 312, 364, 152, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
HW = 57.131/2
HH = 23.857/2

-- 高度框层
tex_poly             = CreateElement "ceTexPoly"
tex_poly.material    = HUD_TEX_IND1
tex_poly.tex_coords  = tex_coord_box
tex_poly.init_pos    = {108.298, alt_bar_vert_bias, 0}
tex_poly.vertices    = {{ HW, HH}, { HW, -HH}, {-HW, -HH}, {-HW, HH},}
tex_poly.indices     = DEF_BOX_INDICES
tex_poly.controllers = {{"hud_check_power"},{"hud_check_declutter"},}
AddElementObject(tex_poly)
tex_poly = nil

tex_poly                 = CreateElement "ceTexPoly"
tex_poly.material        = HUD_TEX_IND1
tex_poly.name            = "ALT_Box"
tex_poly.tex_coords      = tex_coord_box
tex_poly.init_pos        = {108.588, alt_bar_vert_bias, 0}
tex_poly.vertices        = {{45.954/2,11.961/2},
                            {45.954/2,-11.961/2},
                            {-45.954/2,-11.961/2},
                            {-45.954/2,11.961/2}}
tex_poly.indices         = DEF_BOX_INDICES
tex_poly.h_clip_relation = h_clip_relations.REWRITE_LEVEL
tex_poly.isvisible       = false
tex_poly.use_mipfilter   = true
tex_poly.additive_alpha  = true
tex_poly.collimated      = true
tex_poly.level           = HUD_DEFAULT_LEVEL + 2
tex_poly.controllers    = {{"hud_check_power"},{"hud_check_declutter"},}
Add(tex_poly)
tex_poly = nil

--高度条clip层
clipPoly                 = CreateElement "ceMeshPoly"
clipPoly.name            = "clipPoly-alt"
clipPoly.primitivetype   = "triangles"
clipPoly.init_pos        = {88.574, alt_bar_vert_bias, 0}
clipPoly.vertices        = {{2*HW, 88.13/2},
                           {2*HW, -88.13/2},
                           {-HW/2, -88.13/2},
                           {-HW/2, 88.13/2}}
clipPoly.indices         = DEF_BOX_INDICES
clipPoly.material        = HUD_MAT_DEF
clipPoly.h_clip_relation = h_clip_relations.INCREASE_IF_LEVEL
clipPoly.level           = HUD_DEFAULT_LEVEL
clipPoly.collimated      = true
clipPoly.isvisible       = false
clipPoly.controllers    = {{"hud_check_power"},{"hud_check_declutter"},}
Add(clipPoly)
clipPoly = nil

--高度条

local _dummyalt          = CreateElement "ceSimple"
_dummyalt.level          = HUD_DEFAULT_LEVEL + 1
_dummyalt.isvisible      = false
_dummyalt.init_pos       = {85.611, alt_bar_vert_bias, 0}
_dummyalt.controllers    = {{"hud_check_power"},{"hud_move_alttape", 0.03},{"hud_check_declutter"},}
AddElementObject(_dummyalt)

hud_alt_scale_long0                 = CreateElement "ceMeshPoly"
hud_alt_scale_long0.name            = "hud_alt_scale_long_0"
hud_alt_scale_long0.material        = HUD_MAT_DEF
hud_alt_scale_long0.primitivetype   = "triangles"
hud_alt_scale_long0.vertices        = {{  0, 1.256/2},
                                       {  0, -1.256/2},
                                       { 6.278, -1.256/2},
                                       { 6.278, 1.256/2},}
hud_alt_scale_long0.indices         = DEF_BOX_INDICES
--hud_alt_scale_long0.init_pos        = {adi_spdbar_bias, 0, 0}
--hud_alt_scale_long0.h_clip_relation = h_clip_relations.COMPARE
hud_alt_scale_long0.level           = HUD_DEFAULT_LEVEL + 1
hud_alt_scale_long0.parent_element  = _dummyalt.name
hud_alt_scale_long0.isdraw          = true
hud_alt_scale_long0.isvisible       = true
hud_alt_scale_long0.use_mipfilter   = true
hud_alt_scale_long0.additive_alpha  = true
hud_alt_scale_long0.collimated      = true
--hud_alt_scale_long0.controllers     = {{"adi_spd_boxclip", 0.06},}
AddElementObject(hud_alt_scale_long0)


hud_alt_scale_idx0                 = CreateElement "ceStringPoly"
hud_alt_scale_idx0.name            = "hud_alt_scale_idx_0"
hud_alt_scale_idx0.material        = HUD_IND_FONT
hud_alt_scale_idx0.stringdefs      = HUD_STRINGDEFS_DEF
hud_alt_scale_idx0.init_pos        = {6.278+0.942, 0, 0}
hud_alt_scale_idx0.alignment       = "LeftCenter"
--hud_alt_scale_idx0.formats         = {"%02.0f","%s"}
hud_alt_scale_idx0.value           = "0"
--hud_alt_scale_idx0.h_clip_relation = h_clip_relations.COMPARE
hud_alt_scale_idx0.level           = HUD_DEFAULT_LEVEL + 1
hud_alt_scale_idx0.parent_element  = _dummyalt.name
hud_alt_scale_idx0.isdraw          = true
hud_alt_scale_idx0.isvisible       = true
hud_alt_scale_idx0.use_mipfilter   = true
hud_alt_scale_idx0.additive_alpha  = true
hud_alt_scale_idx0.collimated      = true
--hud_alt_scale_idx0.controllers     = {{"adi_spd_boxclip", 0.06},}
AddElementObject(hud_alt_scale_idx0)
hud_alt_scale_idx0 = nil

for i=-5,550 do
    --for k=0,1 do
    if i ~= 0 then
        local dir = 1
        if i < 0 then dir = -1 end
        
        i_plus = math.abs(i)
        
        -- short
        for j=1,4 do
            local short_id = (i_plus-1)*5+j
            hud_alt_scale_short0                 = CreateElement "ceMeshPoly"
            --hud_alt_scale_short0.name            = "hud_alt_scale_short_" .. short_id
            hud_alt_scale_short0.material        = HUD_MAT_DEF
            hud_alt_scale_short0.primitivetype   = "triangles"
            hud_alt_scale_short0.vertices        = {{  0, 1.256/2},
                                                    {  0, -1.256/2},
                                                    { 3.767, -1.256/2},
                                                    { 3.767, 1.256/2},}
            hud_alt_scale_short0.indices         = DEF_BOX_INDICES
            hud_alt_scale_short0.init_pos        = {0, dir * short_id * 6, 0}
            --hud_alt_scale_short0.h_clip_relation = h_clip_relations.COMPARE
            hud_alt_scale_short0.level           = HUD_DEFAULT_LEVEL + 1
            hud_alt_scale_short0.parent_element  = _dummyalt.name
            hud_alt_scale_short0.isdraw          = true
            hud_alt_scale_short0.isvisible       = true
            hud_alt_scale_short0.use_mipfilter   = true
            hud_alt_scale_short0.additive_alpha  = true
            hud_alt_scale_short0.collimated      = true
            hud_alt_scale_short0.controllers     = {{"hud_alt_boxclip", 0.045, alt_bar_vert_bias*MMIL2MIL},{"hud_check_declutter"},}
            AddElementObject(hud_alt_scale_short0)
            hud_alt_scale_short0 = nil
        end
        
        hud_alt_scale_long                 = CreateElement "ceMeshPoly"
        --hud_alt_scale_long.name            = "hud_alt_scale_long_" .. i
        hud_alt_scale_long.material        = HUD_MAT_DEF
        hud_alt_scale_long.primitivetype   = "triangles"
        hud_alt_scale_long.vertices        = {{  0, 1.256/2},
                                              {  0, -1.256/2},
                                              { 6.278, -1.256/2},
                                              { 6.278, 1.256/2},}
        hud_alt_scale_long.indices         = DEF_BOX_INDICES
        hud_alt_scale_long.init_pos        = {0, i * 30, 0}
        --hud_alt_scale_long.h_clip_relation = h_clip_relations.COMPARE
        hud_alt_scale_long.level           = HUD_DEFAULT_LEVEL + 1
        hud_alt_scale_long.parent_element  = _dummyalt.name
        hud_alt_scale_long.isdraw          = true
        hud_alt_scale_long.isvisible       = true
        hud_alt_scale_long.use_mipfilter   = true
        hud_alt_scale_long.additive_alpha  = true
        hud_alt_scale_long.collimated      = true
        hud_alt_scale_long.controllers     = {{"hud_alt_boxclip", 0.045, alt_bar_vert_bias*MMIL2MIL},{"hud_check_declutter"},}
        AddElementObject(hud_alt_scale_long)
        hud_alt_scale_long = nil

        
        local p1000 = math.floor(i_plus/10)
        local p100  = i_plus % 10
        local text = p1000 .. "," .. p100
        if dir < 0 then
            text = "-" .. text
        end
        
        hud_alt_scale_idx                 = CreateElement "ceStringPoly"
        --hud_alt_scale_idx.name            = "hud_alt_scale_idx_" .. i
        hud_alt_scale_idx.material        = HUD_IND_FONT
        hud_alt_scale_idx.stringdefs      = HUD_STRINGDEFS_DEF
        hud_alt_scale_idx.init_pos        = {6.278+0.942, i * 30, 0}
        hud_alt_scale_idx.alignment       = "LeftCenter"
        --hud_alt_scale_idx.formats         = {"%02.0f","%s"}
        hud_alt_scale_idx.value           = text
        --hud_alt_scale_idx.h_clip_relation = h_clip_relations.COMPARE
        hud_alt_scale_idx.level           = HUD_DEFAULT_LEVEL + 1
        hud_alt_scale_idx.parent_element  = _dummyalt.name
        hud_alt_scale_idx.isdraw          = true
        hud_alt_scale_idx.isvisible       = true
        hud_alt_scale_idx.use_mipfilter   = true
        hud_alt_scale_idx.additive_alpha  = true
        hud_alt_scale_idx.collimated      = true
        hud_alt_scale_idx.controllers     = {{"hud_alt_boxclip", 0.045, alt_bar_vert_bias*MMIL2MIL},}
        AddElementObject(hud_alt_scale_idx)
        hud_alt_scale_idx = nil
    end
end


-- 航向条
local tex_coord_box  = HUD_tex_coord(492, 312, 224, 152, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
HW = 35.158/2
HH = 23.857/2

current_hdg             = CreateElement "ceMeshPoly"
current_hdg.material    = HUD_MAT_DEF
current_hdg.primitivetype = "triangles"
current_hdg.name        = "current_hdg"
current_hdg.vertices    = {{1.256/2, 0},
                           {1.256/2, -9.5},
                           {-1.256/2, -9.5},
                           {-1.256/2, 0}}
current_hdg.init_pos    = {0, hdg_bar_vert_bias - hud_hdg_txt_pos_y, 0}
current_hdg.indices     = DEF_BOX_INDICES
current_hdg.controllers = {{"hud_check_power"},{"hud_check_declutter"},}
current_hdg.parent_element = "hud_hdg_txt"
AddElementObject(current_hdg)

--航向框层
tex_poly             = CreateElement "ceTexPoly"
tex_poly.material    = HUD_TEX_IND1
tex_poly.tex_coords  = tex_coord_box
tex_poly.init_pos    = {0, 29.382 - hud_hdg_txt_pos_y, 0}
tex_poly.vertices    = {{ HW, HH},
                        { HW, -HH},
                        {-HW, -HH},
                        {-HW, HH},}
tex_poly.indices     = DEF_BOX_INDICES
tex_poly.controllers = {{"hud_check_power"},{"hud_check_declutter"},}
tex_poly.parent_element = "hud_hdg_txt"
AddElementObject(tex_poly)
tex_poly = nil

tex_poly                 = CreateElement "ceTexPoly"
tex_poly.material        = HUD_TEX_IND1
tex_poly.name            = "HDG_Box"
tex_poly.tex_coords      = tex_coord_box
tex_poly.init_pos        = {0, 29.382, 0}
tex_poly.vertices        = {{23.921/2,11.96/2},
                            {23.921/2,-11.96/2},
                            {-23.921/2,-11.96/2},
                            {-23.921/2,11.96/2}}
tex_poly.indices         = DEF_BOX_INDICES
tex_poly.h_clip_relation = h_clip_relations.REWRITE_LEVEL
tex_poly.isvisible       = false
tex_poly.use_mipfilter   = true
tex_poly.additive_alpha  = true
tex_poly.collimated      = true
tex_poly.level           = HUD_DEFAULT_LEVEL + 2
tex_poly.controllers     = {{"hud_check_power"},{"hud_check_declutter"},}
Add(tex_poly)
tex_poly = nil

-- 航向条clip层
clipPoly                = CreateElement "ceMeshPoly"
clipPoly.name           = "clipPoly-hdg"
clipPoly.primitivetype  = "triangles"
clipPoly.init_pos       = {0, 19.965, 0}
clipPoly.vertices       = {{ 113.31/2,  2*HH},
                           { 113.31/2, -HH},
                           {-113.31/2, -HH},
                           {-113.31/2,  2*HH}}
clipPoly.indices        = DEF_BOX_INDICES
clipPoly.material       = HUD_MAT_DEF
clipPoly.h_clip_relation= h_clip_relations.INCREASE_IF_LEVEL
clipPoly.level          = HUD_DEFAULT_LEVEL
clipPoly.controllers    = {{"hud_check_power"},{"hud_check_declutter"},}
clipPoly.isvisible      = false
clipPoly.collimated     = true
Add(clipPoly)
clipPoly = nil

--航向条

local _dummyhdg          = CreateElement "ceSimple"
_dummyhdg.level          = HUD_DEFAULT_LEVEL + 1
_dummyhdg.isvisible      = false
_dummyhdg.init_pos       = {0, hdg_bar_vert_bias, 0}
_dummyhdg.controllers    = {{"hud_check_power"},{"hud_move_headingtape", 0.034},{"hud_check_declutter"},}
AddElementObject(_dummyhdg)

hud_hdg_scale_long0                 = CreateElement "ceMeshPoly"
hud_hdg_scale_long0.name            = "hud_hdg_scale_long_0"
hud_hdg_scale_long0.material        = HUD_MAT_DEF
hud_hdg_scale_long0.primitivetype   = "triangles"
hud_hdg_scale_long0.vertices        = {{  1.256/2, 6.278},
                                       {  1.256/2, 0},
                                       { -1.256/2, 0},
                                       { -1.256/2, 6.278},}
hud_hdg_scale_long0.indices         = DEF_BOX_INDICES
hud_hdg_scale_long0.level           = HUD_DEFAULT_LEVEL + 1
hud_hdg_scale_long0.parent_element  = _dummyhdg.name
hud_hdg_scale_long0.isdraw          = true
hud_hdg_scale_long0.isvisible       = true
hud_hdg_scale_long0.use_mipfilter   = true
hud_hdg_scale_long0.additive_alpha  = true
hud_hdg_scale_long0.collimated      = true
--hud_hdg_scale_long0.controllers     = {{"adi_spd_boxclip", 0.06},}
AddElementObject(hud_hdg_scale_long0)


hud_hdg_scale_idx0                 = CreateElement "ceStringPoly"
hud_hdg_scale_idx0.name            = "hud_hdg_scale_idx_0"
hud_hdg_scale_idx0.material        = HUD_IND_FONT
hud_hdg_scale_idx0.stringdefs      = HUD_STRINGDEFS_DEF
hud_hdg_scale_idx0.init_pos        = {0, 6.278+6.278, 0}
hud_hdg_scale_idx0.alignment       = "CenterCenter"
--hud_hdg_scale_idx0.formats         = {"%02.0f","%s"}
hud_hdg_scale_idx0.value           = "0"
--hud_hdg_scale_idx0.h_clip_relation = h_clip_relations.COMPARE
hud_hdg_scale_idx0.level           = HUD_DEFAULT_LEVEL + 1
hud_hdg_scale_idx0.parent_element  = _dummyhdg.name
hud_hdg_scale_idx0.isdraw          = true
hud_hdg_scale_idx0.isvisible       = true
hud_hdg_scale_idx0.use_mipfilter   = true
hud_hdg_scale_idx0.additive_alpha  = true
hud_hdg_scale_idx0.collimated      = true
--hud_hdg_scale_idx0.controllers     = {{"adi_spd_boxclip", 0.06},}
AddElementObject(hud_hdg_scale_idx0)
hud_hdg_scale_idx0 = nil

for i=1,19 do
    for k=0,1 do
        local dir = 1 - 2 * k
        local val = i
        if dir == -1 then
            val = 36 - val
        end
        if val < 10 then
            val = "0" .. val
        end
        
        -- short
        hud_hdg_scale_short0                 = CreateElement "ceMeshPoly"
        hud_hdg_scale_short0.name            = "hud_hdg_scale_short_" .. i
        hud_hdg_scale_short0.material        = HUD_MAT_DEF
        hud_hdg_scale_short0.primitivetype   = "triangles"
        hud_hdg_scale_short0.vertices        = {{  1.256/2, 3.767 },
                                                {  1.256/2, 0},
                                                { -1.256/2, 0},
                                                { -1.256/2, 3.767},}
        hud_hdg_scale_short0.indices         = DEF_BOX_INDICES
        hud_hdg_scale_short0.init_pos        = {dir * (17 + (i-1) * 34), 0, 0}
        --hud_hdg_scale_short0.h_clip_relation = h_clip_relations.COMPARE
        hud_hdg_scale_short0.level           = HUD_DEFAULT_LEVEL + 1
        hud_hdg_scale_short0.parent_element  = _dummyhdg.name
        hud_hdg_scale_short0.isdraw          = true
        hud_hdg_scale_short0.isvisible       = true
        hud_hdg_scale_short0.use_mipfilter   = true
        hud_hdg_scale_short0.additive_alpha  = true
        hud_hdg_scale_short0.collimated      = true
        --hud_hdg_scale_short0.controllers     = {{"adi_spd_boxclip", 0.06},}
        AddElementObject(hud_hdg_scale_short0)
        hud_hdg_scale_short0 = nil
        
        hud_hdg_scale_long                 = CreateElement "ceMeshPoly"
        hud_hdg_scale_long.name            = "hud_hdg_scale_long_" .. i
        hud_hdg_scale_long.material        = HUD_MAT_DEF
        hud_hdg_scale_long.primitivetype   = "triangles"
        hud_hdg_scale_long.vertices        = {{  1.256/2, 6.278},
                                              {  1.256/2, 0},
                                              { -1.256/2, 0},
                                              { -1.256/2, 6.278},}
        hud_hdg_scale_long.indices         = DEF_BOX_INDICES
        hud_hdg_scale_long.init_pos        = {dir * i * 34, 0, 0}
        --hud_hdg_scale_long.h_clip_relation = h_clip_relations.COMPARE
        hud_hdg_scale_long.level           = HUD_DEFAULT_LEVEL + 1
        hud_hdg_scale_long.parent_element  = _dummyhdg.name
        hud_hdg_scale_long.isdraw          = true
        hud_hdg_scale_long.isvisible       = true
        hud_hdg_scale_long.use_mipfilter   = true
        hud_hdg_scale_long.additive_alpha  = true
        hud_hdg_scale_long.collimated      = true
        AddElementObject(hud_hdg_scale_long)
        hud_hdg_scale_long = nil

        hud_hdg_scale_idx                 = CreateElement "ceStringPoly"
        hud_hdg_scale_idx.name            = "hud_hdg_scale_idx_" .. i
        hud_hdg_scale_idx.material        = HUD_IND_FONT
        hud_hdg_scale_idx.stringdefs      = HUD_STRINGDEFS_DEF
        hud_hdg_scale_idx.init_pos        = {dir * i * 34, 6.278+6.278, 0}
        hud_hdg_scale_idx.alignment       = "CenterCenter"
        --hud_hdg_scale_idx.formats         = {"%02.0f","%s"}
        hud_hdg_scale_idx.value           = val --dir * i * 10
        --hud_hdg_scale_idx.h_clip_relation = h_clip_relations.COMPARE
        hud_hdg_scale_idx.level           = HUD_DEFAULT_LEVEL + 1
        hud_hdg_scale_idx.parent_element  = _dummyhdg.name
        hud_hdg_scale_idx.isdraw          = true
        hud_hdg_scale_idx.isvisible       = true
        hud_hdg_scale_idx.use_mipfilter   = true
        hud_hdg_scale_idx.additive_alpha  = true
        hud_hdg_scale_idx.collimated      = true
        AddElementObject(hud_hdg_scale_idx)
        hud_hdg_scale_idx = nil
    end
end


----------------------------------------------------