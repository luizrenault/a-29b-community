----------------------------------------------------------------------------------------------------
--- must be loaded in HUD_NORMAL.lua

-- RDYX
tex_poly             = CreateElement "ceTexPoly"
tex_poly.material    = HUD_TEX_IND1
tex_poly.name        = "hud_wpn_rdyx"
tex_poly.vertices    = {{30.135/2,18.834/2},{30.135/2,-18.834/2},{-30.135/2,-18.834/2},{-30.135/2,18.834/2}}
tex_poly.tex_coords  = HUD_tex_coord(872, 192, 192, 120, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
tex_poly.init_pos    = {-87.894, -133.223, 0}
tex_poly.indices     = DEF_BOX_INDICES
tex_poly.controllers = {{"hud_wpn_rdyx"}}
AddElementObject(tex_poly)


-- 机炮十字
tex_poly             = CreateElement "ceTexPoly"
tex_poly.material    = HUD_TEX_IND1
tex_poly.name        = "hud_gun_cross"
tex_poly.vertices    = {{10.045,10.045},{10.045,-10.045},{-10.045,-10.045},{-10.045,10.045}}
tex_poly.tex_coords  = HUD_tex_coord(0, 192, 128, 128, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
tex_poly.init_pos    = {0, vert_bias, 0}
tex_poly.indices     = DEF_BOX_INDICES
AddElementObject(tex_poly)

range_l  = -4.6
range_r  =  4.4
range_u  =  0.005
range_d  = -9.5
range_d2 = -11

-- 目标框 
tex_poly             = CreateElement "ceTexPoly"
tex_poly.material    = HUD_TEX_IND1
tex_poly.name        = 'target_designator'
tex_poly.vertices    = {{25.113/2, 25.113/2},{25.113/2, -25.113/2},{-25.113/2, -25.113/2},{-25.113/2, 25.113/2}}
--tex_poly.tex_coords  = HUD_tex_coord(528, 464, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
tex_poly.state_tex_coords = {
    HUD_tex_coord( 528, 624, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H), --0 四角方框: 不明目标
    HUD_tex_coord( 528, 464, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H), --1 封闭方框: 确认敌机
    HUD_tex_coord( 368, 624, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H), --2 带x四角: 确认友机
    HUD_tex_coord( 368, 464, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H), --3 菱形: 面目标
    HUD_tex_coord( 120, 712, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H), --4 下划线: 丢失目标记忆
    HUD_tex_coord( 688, 624, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H), --5 圆形: OAP参考点
}
tex_poly.init_pos    = {0, 0, 0}
tex_poly.indices     = DEF_BOX_INDICES
tex_poly.controllers = {{"hud_SPI_target", range_l, range_r, range_u, range_d, range_d2}}
AddElementObject(tex_poly)

tgt_heading_poly                = CreateElement "ceTexPoly"
tgt_heading_poly.material       = HUD_TEX_IND1
tgt_heading_poly.vertices       = {{18.834/2, 68.746/2+31.391},{18.834/2, -68.746/2+31.391},{-18.834/2, -68.746/2+31.391},{-18.834/2, 68.746/2+31.391}}
tgt_heading_poly.tex_coords     = HUD_tex_coord(0, 712, 120, 438, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
tgt_heading_poly.init_pos       = {0, 0, 0}
tgt_heading_poly.indices        = DEF_BOX_INDICES
tgt_heading_poly.controllers    = {{"hud_SPI_direction", range_l, range_r, range_u, range_d, range_d2}}
tgt_heading_poly.parent_element = 'target_designator'
AddElementObject(tgt_heading_poly)

local text_strpoly          = CreateElement "ceStringPoly"
text_strpoly.parent_element = 'target_designator'
text_strpoly.material       = HUD_IND_FONT
text_strpoly.init_pos       = {0, 0, 0}
text_strpoly.alignment      = "CenterCenter"
text_strpoly.controllers    = {{"hud_txt_AA_TOF_TOA"},} --TODO
text_strpoly.value          = "60"
text_strpoly.stringdefs     = HUD_STRINGDEFS_DEF_X08
AddElementObject(text_strpoly)


-- OAP 菱形标记
hud_oap_tdc                = CreateElement "ceTexPoly"
hud_oap_tdc.material       = HUD_TEX_IND1
hud_oap_tdc.vertices       = {{25.113/2, 25.113/2},{25.113/2, -25.113/2},{-25.113/2, -25.113/2},{-25.113/2, 25.113/2}}
hud_oap_tdc.tex_coords     = HUD_tex_coord(368, 464, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_oap_tdc.indices        = DEF_BOX_INDICES
hud_oap_tdc.init_pos       = {0, 0, 0}
hud_oap_tdc.controllers    = {{"hud_oap_tdc"},{"hud_check_declutter"},{"hud_check_power"}}
AddHUDElement(hud_oap_tdc)


----------------------------------------------------------------------------------------------------
-- AA
----------------------------------------------------------------------------------------------------

-- AA DLZ
tex_poly             = CreateElement "ceTexPoly"
tex_poly.material    = HUD_TEX_IND1
tex_poly.vertices    = {{25.113/2 ,25.113/2},{25.113/2, -25.113/2},{-25.113/2, -25.113/2},{-25.113/2, 25.113/2}}
--tex_poly.tex_coords  = HUD_tex_coord(33, 373, 92-33, 425 - 373, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
tex_poly.state_tex_coords = {
    HUD_tex_coord(1008, 944, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H), --0 顶 v
    HUD_tex_coord( 848, 624, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H), --1 左 >
    HUD_tex_coord(1008, 784, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H), --2 下 ^
    HUD_tex_coord(1008, 624, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H), --3 右 < 
}
tex_poly.init_pos    = {0, 0, 0}
tex_poly.indices     = DEF_BOX_INDICES
tex_poly.controllers = {{"hud_AA_dlz_caret", 25.113/2}}
tex_poly.parent_element = 'target_designator'
AddElementObject(tex_poly)

-- AA ASE环
ase_circle             = CreateElement "ceSimpleLineObject"
ase_circle.material    = HUD_MAT_DEF
ase_circle.width       = 1.0/2 -- 1.256/2
ase_circle.init_pos    = {0, general_vert_bias, 0} -- vert_bias
ase_circle.controllers = {{"hud_AA_ase_circle", 72}}
AddElementObject(ase_circle)


-- AA PIP点
tex_poly             = CreateElement "ceTexPoly"
tex_poly.material    = HUD_TEX_IND2
tex_poly.name        = "hud_AA_pip_dot"
tex_poly.vertices    = {{25.113/2,25.113/2},{25.113/2,-25.113/2},{-25.113/2,-25.113/2},{-25.113/2,25.113/2}}
tex_poly.tex_coords  = HUD_tex_coord(780,   0, 160, 160, HUD_TEX_IND2_W, HUD_TEX_IND2_H)
tex_poly.init_pos    = {0, 0, 0}
tex_poly.controllers = { {"hud_AA_pip_dot"},}
tex_poly.indices     = DEF_BOX_INDICES
AddElementObject(tex_poly)

-- 红外弹导引头**
tex_poly             = CreateElement "ceTexPoly"
tex_poly.material    = HUD_TEX_IND1
tex_poly.name        = "hud_irseeker"
tex_poly.vertices    = {{25.113/2,25.113/2},{25.113/2,-25.113/2},{-25.113/2,-25.113/2},{-25.113/2,25.113/2}}
tex_poly.tex_coords  = HUD_tex_coord(688, 624, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
tex_poly.init_pos    = {0, 0, 0}
tex_poly.controllers = { {"hud_irseeker"},}
tex_poly.indices     = DEF_BOX_INDICES
AddElementObject(tex_poly)


-- CAC模式雷达扫描边界
rdr_ant_scan_zone                = CreateElement "ceSimpleLineObject"
rdr_ant_scan_zone.name           = "rdr_cac_ant_scan_zone"
--rdr_ant_scan_zone.material       = HUD_MAT_DEF
rdr_ant_scan_zone.material       = HUD_LINE_DEF
rdr_ant_scan_zone.tex_params     = {{0, 0.5}, {1, 0.5}, {1 / (1024 * 100 / 275), 1}}
rdr_ant_scan_zone.width          = 1.256/2
rdr_ant_scan_zone.controllers    = {{"rdr_cac_ant_scan_zone"}}
AddToGunCross(rdr_ant_scan_zone)


----------------------------------------------------------------------------------------------------
-- AG
----------------------------------------------------------------------------------------------------

function AG_Bomb_CCIP_Solution()
    local ccip_base = CreateElement "ceSimple"
    ccip_base.controllers = {{"hud_AG_CCIP_bomb_pipper_presence"}}
    AddToFPM(ccip_base)

    -- CCIP瞄准环
    local ccip           = CreateElement "ceTexPoly"
    ccip.material        = HUD_TEX_IND2
    ccip.name            = "ccip_pipper"
    --ccip.parent_element  = ccip_base.name
    ccip.init_pos        = {0,0}
    ccip.vertices        = {{25.113/2, 25.113/2},{25.113/2, -25.113/2},{-25.113/2, -25.113/2},{-25.113/2, 25.113/2}}
    ccip.tex_coords      = HUD_tex_coord(435, 390, 120, 120, HUD_TEX_IND2_W, HUD_TEX_IND2_H)
    ccip.indices         = DEF_BOX_INDICES
    ccip.controllers     = {{"hud_AG_CCIP_bomb_pipper"}}
    
    AddHUDElement(ccip)

    local ccip_bomb_fall_line_solid          = CreateElement "ceSimpleLineObject"
    ccip_bomb_fall_line_solid.material       = HUD_MAT_DEF
    ccip_bomb_fall_line_solid.width          = 1.256/2
    ccip_bomb_fall_line_solid.vertices       = {{0,0},{0,-80}}
    ccip_bomb_fall_line_solid.controllers    = {{"hud_AG_CCIP_bomb_fall_line", 0}}
    AddHUDElement(ccip_bomb_fall_line_solid)
    
    local ccip_bomb_fall_line_dash           = CreateElement "ceSimpleLineObject"
    ccip_bomb_fall_line_dash.material        = HUD_LINE_DEF
    ccip_bomb_fall_line_dash.tex_params      = {{0, 0.5}, {1, 0.5}, {1 / (1024 * 100 / 275), 1}}
    ccip_bomb_fall_line_dash.width           = 1.256/2
    ccip_bomb_fall_line_dash.vertices        = {{0,0},{0,-80}}
    ccip_bomb_fall_line_dash.controllers     = {{"hud_AG_CCIP_bomb_fall_line", 1}}
    AddHUDElement(ccip_bomb_fall_line_dash)
end

AG_Bomb_CCIP_Solution()
------------------------------

-- AG GUN CCIP瞄准环
local gun_AG_pipper          = CreateElement "ceTexPoly"
gun_AG_pipper.material       = HUD_TEX_IND1
gun_AG_pipper.name           = "AG_gun_pipper"
gun_AG_pipper.init_pos       = {0,-50}
gun_AG_pipper.vertices       = {{25.113/2, 25.113/2},{25.113/2, -25.113/2},{-25.113/2, -25.113/2},{-25.113/2, 25.113/2}}
gun_AG_pipper.tex_coords     = HUD_tex_coord(368, 784, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
gun_AG_pipper.indices        = DEF_BOX_INDICES
gun_AG_pipper.controllers    = {{"hud_AG_gun_pipper"}}
    
AddToGunCross(gun_AG_pipper)

----------------------------------------------------------------------------------------------------
-- AG ROCKET CCIP瞄准环
local AG_rocket_pipper           = CreateElement "ceTexPoly"
AG_rocket_pipper.material        = HUD_TEX_IND1
AG_rocket_pipper.name            = "AG_rocket_pipper"
AG_rocket_pipper.init_pos        = {0,0}

AG_rocket_pipper.vertices        = {{25.113/2, 25.113/2},{25.113/2, -25.113/2},{-25.113/2, -25.113/2},{-25.113/2, 25.113/2}}
AG_rocket_pipper.tex_coords      = HUD_tex_coord(1008, 464, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
AG_rocket_pipper.indices         = DEF_BOX_INDICES
AG_rocket_pipper.controllers     = {{"hud_AG_rocket_pipper"}}
    
AddHUDElement(AG_rocket_pipper)

-- AG BRM1 ROCKET ASE环
brm1_ase_circle             = CreateElement "ceSimpleLineObject"
brm1_ase_circle.material    = HUD_MAT_DEF
brm1_ase_circle.width       = 1.0/2 -- 1.256/2
brm1_ase_circle.init_pos    = {0, general_vert_bias, 0} -- vert_bias
brm1_ase_circle.controllers = {{"hud_AG_brm1_ase_circle", 72}}
AddElementObject(brm1_ase_circle)

----------------------------------------------------------------------------------------------------
-- AG TDC 指示
local AG_tdc           = CreateElement "ceTexPoly"
AG_tdc.material        = HUD_TEX_IND1
AG_tdc.name            = "AG_tdc"
AG_tdc.init_pos        = {0,0}
AG_tdc.vertices        = {{25.113/2, 25.113/2},{25.113/2, -25.113/2},{-25.113/2, -25.113/2},{-25.113/2, 25.113/2}}
AG_tdc.tex_coords      = HUD_tex_coord(368, 464, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
AG_tdc.indices         = DEF_BOX_INDICES
AG_tdc.controllers     = {{"hud_TDC", range_l, range_r, range_u, range_d2}}
AG_tdc.isdraw          = false
AddHUDElement(AG_tdc)

-- DTOS瞄准环
function AG_Bomb_DTOS_Solution()
    local AG_DTOS           = CreateElement "ceTexPoly"
    AG_DTOS.material        = HUD_TEX_IND2
    AG_DTOS.name            = "AG_DTOS"
    AG_DTOS.init_pos        = {0,0}
    AG_DTOS.vertices        = {{25.113/2, 25.113/2},{25.113/2, -25.113/2},{-25.113/2, -25.113/2},{-25.113/2, 25.113/2}}
    AG_DTOS.tex_coords      = HUD_tex_coord(435, 390, 120, 120, HUD_TEX_IND2_W, HUD_TEX_IND2_H)
    AG_DTOS.indices         = DEF_BOX_INDICES
    AG_DTOS.controllers     = {{"hud_DTOS", range_l, range_r, range_u, range_d2}}
    AG_DTOS.isdraw          = true
    AddHUDElement(AG_DTOS)

    local dtos_fall_line_solid          = CreateElement "ceSimpleLineObject"
    dtos_fall_line_solid.material       = HUD_MAT_DEF
    dtos_fall_line_solid.width          = 1.256/2
    dtos_fall_line_solid.vertices       = {{0,0},{0,-80}}
    dtos_fall_line_solid.controllers    = {{"hud_DTOS_fall_line", 0, range_l, range_r, range_u, range_d2}}
    AddHUDElement(dtos_fall_line_solid)
    
    local dtos_fall_line_dash           = CreateElement "ceSimpleLineObject"
    dtos_fall_line_dash.material        = HUD_LINE_DEF
    dtos_fall_line_dash.tex_params      = {{0, 0.5}, {1, 0.5}, {1 / (1024 * 100 / 275), 1}}
    dtos_fall_line_dash.width           = 1.256/2
    dtos_fall_line_dash.vertices        = {{0,0},{0,-80}}
    dtos_fall_line_dash.controllers     = {{"hud_DTOS_fall_line", 1, range_l, range_r, range_u, range_d2}}
    AddHUDElement(dtos_fall_line_dash)
end

AG_Bomb_DTOS_Solution()


-- DIR瞄准环
function AG_Bomb_DIR_Solution()
    local AG_DIR           = CreateElement "ceTexPoly"
    AG_DIR.material        = HUD_TEX_IND2
    AG_DIR.name            = "AG_DIR"
    AG_DIR.init_pos        = {0,0}
    AG_DIR.vertices        = {{25.113/2, 25.113/2},{25.113/2, -25.113/2},{-25.113/2, -25.113/2},{-25.113/2, 25.113/2}}
    AG_DIR.tex_coords      = HUD_tex_coord(435, 390, 120, 120, HUD_TEX_IND2_W, HUD_TEX_IND2_H)
    AG_DIR.indices         = DEF_BOX_INDICES
    AG_DIR.controllers     = {{"hud_DIR", range_l, range_r, range_u, range_d2}}
    AG_DIR.isdraw          = true
    AddHUDElement(AG_DIR)

    local dis_fall_line_dash           = CreateElement "ceSimpleLineObject"
    dis_fall_line_dash.material        = HUD_LINE_DEF
    dis_fall_line_dash.tex_params      = {{0, 0.5}, {1, 0.5}, {1 / (1024 * 100 / 275), 1}}
    dis_fall_line_dash.width           = 1.256/2
    dis_fall_line_dash.vertices        = {{0,0},{0,-80}}
    dis_fall_line_dash.controllers     = {{"hud_DIR_fall_line", range_l, range_r, range_u, range_d2}}
    AddHUDElement(dis_fall_line_dash)
end

AG_Bomb_DIR_Solution()

----------------------------------------------------------------------------------------------------
local function CCRP_PipperAndCue()
    -- bind to pipper
    local CCRP_pipper_line           = CreateElement "ceSimpleLineObject"
    CCRP_pipper_line.material        = HUD_MAT_DEF
    CCRP_pipper_line.width           = 1.256/2
    CCRP_pipper_line.vertices        = {{0,HUD_HALF_HEIGHT},{0, -1 * HUD_HALF_HEIGHT}}
    CCRP_pipper_line.controllers     = {{"hud_CCRP_pipper_line", HUD_HALF_HEIGHT * GetScale()}}
    CCRP_pipper_line.parent_element  = fpm_name -- in HUD_NORMAL.lua
    AddHUDElement(CCRP_pipper_line)

    local CCRP_cue          = CreateElement "ceTexPoly"
    CCRP_cue.material       = HUD_TEX_IND1
    CCRP_cue.vertices       = {{20.09 /2, 20.09/2},{20.09/2, -20.09/2},{-20.09/2, -20.09/2},{-20.09/2, 20.09/2}}
    CCRP_cue.tex_coords     = HUD_tex_coord(0, 584, 128, 128, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
    CCRP_cue.indices        = DEF_BOX_INDICES
    CCRP_cue.controllers    = {{"hud_CCRP_Cue", HUD_HALF_HEIGHT * GetScale()}}
    CCRP_cue.parent_element = CCRP_pipper_line.name
    AddHUDElement(CCRP_cue)

end

local function CCRP_PipperAndCue_New()
    local ccrp_sol_bar_len = 40 -- mr
    local bar_bias = 15
    
    local ccrp_line_base          = CreateElement "ceSimple"
    ccrp_line_base.name           = "ccrp_line_base"
    ccrp_line_base.controllers    = {{"hud_CCRP_pipper_line", 2 * HUD_HALF_HEIGHT * GetScale(), 1}}
    ccrp_line_base.parent_element = fpm_name
    AddHUDElement(ccrp_line_base)
    
    -- bind to pipper
    local CCRP_pipper_line_up           = CreateElement "ceSimpleLineObject"
    CCRP_pipper_line_up.material        = HUD_MAT_DEF
    CCRP_pipper_line_up.width           = 1.256/2
    CCRP_pipper_line_up.vertices        = {{0,HUD_HALF_HEIGHT},{0, 0.25 * HUD_HALF_HEIGHT}}
    CCRP_pipper_line_up.vertices        = {{0,HUD_HALF_HEIGHT},{0, ccrp_sol_bar_len + bar_bias}}
    CCRP_pipper_line_up.parent_element  = ccrp_line_base.name -- in HUD_NORMAL.lua
    AddHUDElement(CCRP_pipper_line_up)
    
    local CCRP_pipper_line_dn           = CreateElement "ceSimpleLineObject"
    CCRP_pipper_line_dn.material        = HUD_MAT_DEF
    CCRP_pipper_line_dn.width           = 1.256/2
    CCRP_pipper_line_dn.vertices        = {{0,0},{0, -1 * HUD_HALF_HEIGHT}}
    CCRP_pipper_line_dn.parent_element  = ccrp_line_base.name -- in HUD_NORMAL.lua
    AddHUDElement(CCRP_pipper_line_dn)

    local ccrp_sol_line_solid          = CreateElement "ceSimpleLineObject"
    ccrp_sol_line_solid.material       = HUD_MAT_DEF
    ccrp_sol_line_solid.width          = 1.256/2
    ccrp_sol_line_solid.vertices       = {{0,0},{0, ccrp_sol_bar_len}}
    ccrp_sol_line_solid.controllers    = {{"hud_CCRP_sol_line", 0, ccrp_sol_bar_len * GetScale(), bar_bias * GetScale()}}
    AddHUDElement(ccrp_sol_line_solid)
    
    local ccrp_sol_line_dash           = CreateElement "ceSimpleLineObject"
    ccrp_sol_line_dash.material        = HUD_LINE_DEF
    ccrp_sol_line_dash.tex_params      = {{0, 0.5}, {1, 0.5}, {1 / (1024 * 100 / 275), 1}}
    ccrp_sol_line_dash.width           = 1.256/2
    ccrp_sol_line_dash.vertices        = {{0,0},{0, ccrp_sol_bar_len}}
    ccrp_sol_line_dash.controllers     = {{"hud_CCRP_sol_line", 1, ccrp_sol_bar_len * GetScale(), bar_bias * GetScale()}}
    AddHUDElement(ccrp_sol_line_dash)

end

--CCRP_PipperAndCue()
CCRP_PipperAndCue_New()
----------------------------------------------------------------------------------------------------


---- AG sensor etc
-- WMD7 指向指示符号
hud_wmd7             = CreateElement "ceTexPoly"
hud_wmd7.material    = HUD_TEX_IND1
hud_wmd7.name        = "hud_wmd7"
hud_wmd7.vertices    = {{25.113/2,25.113/2},{25.113/2,-25.113/2},{-25.113/2,-25.113/2},{-25.113/2,25.113/2}}
hud_wmd7.tex_coords  = HUD_tex_coord(688, 464, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_wmd7.init_pos    = {0, 0, 0}
hud_wmd7.controllers = { {"hud_wmd7"},}
hud_wmd7.indices     = DEF_BOX_INDICES
AddElementObject(hud_wmd7)

-- TVIR传感器(C-701T) 指向指示符号
hud_tvir             = CreateElement "ceTexPoly"
hud_tvir.material    = HUD_TEX_IND1
hud_tvir.name        = "hud_tvir"
hud_tvir.vertices    = {{25.113/2,25.113/2},{25.113/2,-25.113/2},{-25.113/2,-25.113/2},{-25.113/2,25.113/2}}
hud_tvir.tex_coords  = HUD_tex_coord(368, 784, 160, 160, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
hud_tvir.init_pos    = {0, 0, 0}
hud_tvir.controllers = {{"hud_tvir"},}
hud_tvir.indices     = DEF_BOX_INDICES
AddElementObject(hud_tvir)


----------------------------------------------------------------------------------------------------
-- Gun
----------------------------------------------------------------------------------------------------

-- AA gun line, NO LOCK
local feds_line_snake        = CreateElement "ceSimpleLineObject"
feds_line_snake.name         = "feds_line_snake"
feds_line_snake.material     = HUD_MAT_DEF
feds_line_snake.width        = 1.256/2
feds_line_snake.controllers  = {{"hud_feds_line"}}
AddToGunCross(feds_line_snake)

-- 600m标识
local feds_line_snake_mark_600        = CreateElement "ceSimpleLineObject"
feds_line_snake_mark_600.material     = HUD_MAT_DEF
feds_line_snake_mark_600.vertices     = {{-12,0},{12,0}}
feds_line_snake_mark_600.width        = 1.256/2
feds_line_snake_mark_600.controllers  = {{"hud_feds_line_mark_600"}}
AddToGunCross(feds_line_snake_mark_600)

-- 1000m标识
local feds_line_snake_mark_1000        = CreateElement "ceSimpleLineObject"
feds_line_snake_mark_1000.material     = HUD_MAT_DEF
feds_line_snake_mark_1000.vertices     = {{-12,0},{12,0}}
feds_line_snake_mark_1000.width        = 1.256/2
feds_line_snake_mark_1000.controllers  = {{"hud_feds_line_mark_1000"}}
AddToGunCross(feds_line_snake_mark_1000)


local gun_AA_lcos_line          = CreateElement "ceSimpleLineObject"
gun_AA_lcos_line.name           = "gun_AA_lcos_line"
gun_AA_lcos_line.material       = HUD_MAT_DEF
gun_AA_lcos_line.width          = 1.256/2
gun_AA_lcos_line.controllers    = {{"gun_AA_lcos_line", vert_bias/1000}}
AddToGunCross(gun_AA_lcos_line)


local gun_AA_pipper          = CreateElement "ceTexPoly"
gun_AA_pipper.name           = "AA_gun_pipper"
gun_AA_pipper.material       = HUD_TEX_IND1
gun_AA_pipper.tex_coords     = HUD_tex_coord(640, 784, 360, 360, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
gun_AA_pipper.indices        = DEF_BOX_INDICES
gun_AA_pipper.vertices       = {{54.62/2, 54.62/2},{54.62/2, -54.62/2},{-54.62/2, -54.62/2},{-54.62/2, 54.62/2}}
gun_AA_pipper.init_pos       = {0, 0, 0}
gun_AA_pipper.controllers    = {{"hud_AA_gun_pipper"}}
AddToGunCross(gun_AA_pipper)


local gun_AA_pipper_dist_arc          = CreateElement "ceSimpleLineObject"
gun_AA_pipper_dist_arc.name           = "gun_AA_pipper_dist_arc"
gun_AA_pipper_dist_arc.material       = HUD_MAT_DEF
gun_AA_pipper_dist_arc.width          = 1.2
gun_AA_pipper_dist_arc.controllers    = {{"gun_AA_pipper_dist_arc", 100/180*54.62/2/1000}}
gun_AA_pipper_dist_arc.parent_element = gun_AA_pipper.name
AddToGunCross(gun_AA_pipper_dist_arc)

local gun_AA_pipper_appr          = CreateElement "ceTexPoly"
gun_AA_pipper_appr.material       = HUD_TEX_IND2
gun_AA_pipper_appr.name           = "gun_AA_pipper_appr"
gun_AA_pipper_appr.vertices       = {{54.62/2, 54.62/2},{54.62/2, -54.62/2},{-54.62/2, -54.62/2},{-54.62/2, 54.62/2}}
gun_AA_pipper_appr.tex_coords     = HUD_tex_coord(75, 390, 360, 360, HUD_TEX_IND1_W, HUD_TEX_IND1_H)
gun_AA_pipper_appr.indices        = DEF_BOX_INDICES
gun_AA_pipper_appr.controllers    = {{"hud_AA_gun_pipper_appr", 600}}
gun_AA_pipper_appr.parent_element = gun_AA_pipper.name
AddToGunCross(gun_AA_pipper_appr)

