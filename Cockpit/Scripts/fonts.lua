dofile(LockOn_Options.common_script_path.."Fonts/symbols_locale.lua")
dofile(LockOn_Options.common_script_path.."Fonts/fonts_cmn.lua")
dofile(LockOn_Options.common_script_path.."tools.lua")


fontdescription = {}

---------------------------------------------------------------Hercules

CMFD_X_PIXEL =  88
CMFD_Y_PIXEL =  144

fontdescription["font_CMFD"] = {
    texture     = LockOn_Options.script_path .. "CMFD/Resources/a29b_font_CMFD.dds",
    size        = {10, 10},
    resolution  = {1440, 1440},
    default     = {CMFD_X_PIXEL, CMFD_Y_PIXEL},
    chars       = {
        {32, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- space
        {48, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- 0
        {49, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- 1
        {50, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- 2
        {51, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- 3
        {52, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- 4
        {53, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- 5
        {54, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- 6
        {55, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- 7
        {56, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- 8
        {57, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- 9

        {64, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- Alpha -> @

        {65, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- A
        {66, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- B
        {67, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- C
        {68, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- D
        {69, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- E
        {70, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- F
        {71, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- G
        {72, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- H
        {73, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- I
        {74, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- J
        {75, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- K
        {76, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- L
        {77, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- M
        {78, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- N
        {79, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- O
        {80, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- P
        {81, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- Q
        {82, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- R
        {83, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- S
        {84, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- T
        {85, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- U
        {86, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- V
        {87, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- W
        {88, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- X
        {89, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- Y
        {90, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- Z
         
        {42, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- *
        {43, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- +
        {45, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- -
        {47, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- /
        {92, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- \
        {40, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- (
        {41, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- )
        {91, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- [
        {93, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- ]
        {123, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- {
        {125, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- }
        {60, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- <
        {62, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- >
        {61, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- =
        {63, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- ?
        {124, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- |
        {33, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- !
        {35, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- #
        {37, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- %
        {94, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- ^
        {38, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- &
        {96, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- o -- degree, change its ascii code to 96 ', original 248 (out of index)
        {46, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- .
        {58, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- :
        {44, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- ,
        {126, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- cursor -> ~
        {95, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- _
        
        {39, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- '
        {34, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- "
        --{32, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- [space]
        
        {127, CMFD_X_PIXEL, CMFD_Y_PIXEL}, -- delta, use last ascii code
    }
}


HUD_xsize = 44 * 2
HUD_ysize = 72.0 * 2 --73.143 * 2
fontdescription["a29b_font_hud"] = {
	texture    = LockOn_Options.script_path.."Resources/Fonts/a29b_font_HUD.tga",
	size      = {7, 7},
	resolution = {1024, 1024},
	default    = {HUD_xsize, HUD_ysize},
	chars	    = {
		 [1]   = {32, HUD_xsize, HUD_ysize}, -- [space]
		 [2]   = {42, HUD_xsize, HUD_ysize}, -- *
		 [3]   = {43, HUD_xsize, HUD_ysize}, -- +
		 [4]   = {45, HUD_xsize, HUD_ysize}, -- -
		 [5]   = {46, HUD_xsize, HUD_ysize}, -- .
		 [6]   = {47, HUD_xsize, HUD_ysize}, -- /
		 [7]   = {48, HUD_xsize, HUD_ysize}, -- 0
		 [8]   = {49, HUD_xsize, HUD_ysize}, -- 1
		 [9]   = {50, HUD_xsize, HUD_ysize}, -- 2
		 [10]  = {51, HUD_xsize, HUD_ysize}, -- 3
		 [11]  = {52, HUD_xsize, HUD_ysize}, -- 4
		 [12]  = {53, HUD_xsize, HUD_ysize}, -- 5
		 [13]  = {54, HUD_xsize, HUD_ysize}, -- 6
		 [14]  = {55, HUD_xsize, HUD_ysize}, -- 7
		 [15]  = {56, HUD_xsize, HUD_ysize}, -- 8
		 [16]  = {57, HUD_xsize, HUD_ysize}, -- 9
		 [17]  = {58, HUD_xsize, HUD_ysize}, -- :
		 [18]  = {65, HUD_xsize, HUD_ysize}, -- A
		 [19]  = {66, HUD_xsize, HUD_ysize}, -- B
		 [20]  = {67, HUD_xsize, HUD_ysize}, -- C
		 [21]  = {68, HUD_xsize, HUD_ysize}, -- D
		 [22]  = {69, HUD_xsize, HUD_ysize}, -- E
		 [23]  = {70, HUD_xsize, HUD_ysize}, -- F
		 [24]  = {71, HUD_xsize, HUD_ysize}, -- G
		 [25]  = {72, HUD_xsize, HUD_ysize}, -- H
		 [26]  = {73, HUD_xsize, HUD_ysize}, -- I
		 [27]  = {74, HUD_xsize, HUD_ysize}, -- J
		 [28]  = {75, HUD_xsize, HUD_ysize}, -- K
		 [29]  = {76, HUD_xsize, HUD_ysize}, -- L
		 [30]  = {77, HUD_xsize, HUD_ysize}, -- M
		 [31]  = {78, HUD_xsize, HUD_ysize}, -- N
		 [32]  = {79, HUD_xsize, HUD_ysize}, -- O
		 [33]  = {80, HUD_xsize, HUD_ysize}, -- P
		 [34]  = {81, HUD_xsize, HUD_ysize}, -- Q
		 [35]  = {82, HUD_xsize, HUD_ysize}, -- R
		 [36]  = {83, HUD_xsize, HUD_ysize}, -- S
		 [37]  = {84, HUD_xsize, HUD_ysize}, -- T
		 [38]  = {85, HUD_xsize, HUD_ysize}, -- U
		 [39]  = {86, HUD_xsize, HUD_ysize}, -- V
		 [40]  = {87, HUD_xsize, HUD_ysize}, -- W
		 [41]  = {88, HUD_xsize, HUD_ysize}, -- X
		 [42]  = {89, HUD_xsize, HUD_ysize}, -- Y
		 [43]  = {90, HUD_xsize, HUD_ysize}, -- Z
		 [44]  = {91, HUD_xsize, HUD_ysize}, -- [
		 [45]  = {93, HUD_xsize, HUD_ysize}, -- ]
		 [46]  = {62, 130, HUD_ysize}, -- |>
		 [47]  = {60, 130, HUD_ysize}, -- <|
		 [48]  = {111, HUD_xsize, HUD_ysize}, -- o
		 [49]  = {94, HUD_xsize, HUD_ysize}} -- ^
}

local xsizep=51.2
local ysizep=51.2
fontdescription["font_Arial"] = {
	texture    = LockOn_Options.script_path.."Resources/Fonts/a29b_font_arial.dds",
	size      = {10, 10},
	resolution = {512, 512},
	default    = {xsizep, ysizep},
	chars	    = {
		 [1]   = {32, xsizep, ysizep}, -- [space]
		 [2]   = {33, xsizep, ysizep}, -- !
		 [3]   = {34, xsizep, ysizep}, -- "
		 [4]   = {35, xsizep, ysizep}, -- #
		 [5]   = {36, xsizep, ysizep}, -- $
		 [6]   = {37, xsizep, ysizep}, -- %
		 -- [7]   = {127, xsizep, ysizep}, -- {38, xsizep, ysizep}, -- &
		 -- [8]   = {128, xsizep, ysizep}, -- {39, xsizep, ysizep}, -- '
		 [7]   = {38, xsizep, ysizep}, -- &
		 [8]   = {39, xsizep, ysizep}, -- '
		 [9]   = {40, xsizep, ysizep}, -- (
		 [10]   = {41, xsizep, ysizep}, -- )
		 
		 [11]   = {42, xsizep, ysizep}, -- *
		 [12]   = {43, xsizep, ysizep}, -- +
		 [13]   = {44, xsizep, ysizep}, -- ,
		 [14]   = {45, xsizep, ysizep}, -- -
		 [15]   = {46, xsizep, ysizep}, -- .
		 [16]   = {47, xsizep, ysizep}, -- /		 
		 [17]   = {48, xsizep, ysizep}, -- 0
		 [18]   = {49, xsizep, ysizep}, -- 1
		 [19]   = {50, xsizep, ysizep}, -- 2
		 [20]  = {51, xsizep, ysizep}, -- 3
		 
		 [21]  = {52, xsizep, ysizep}, -- 4
		 [22]  = {53, xsizep, ysizep}, -- 5
		 [23]  = {54, xsizep, ysizep}, -- 6
		 [24]  = {55, xsizep, ysizep}, -- 7
		 [25]  = {56, xsizep, ysizep}, -- 8
		 [26]  = {57, xsizep, ysizep}, -- 9		 
		 [27]  = {58, xsizep, ysizep}, -- :
		 [28]  = {59, xsizep, ysizep}, -- ;
		 [29]  = {60, xsizep, ysizep}, -- <		 
		 [30]  = {61, xsizep, ysizep}, -- =
		 
		 [31]  = {62, xsizep, ysizep}, -- >
		 [32]  = {63, xsizep, ysizep}, -- ?		 
		 [33]  = {64, xsizep, ysizep}, -- @
		 [34]  = {65, xsizep, ysizep}, -- A
		 [35]  = {66, xsizep, ysizep}, -- B
		 [36]  = {67, xsizep, ysizep}, -- C
		 [37]  = {68, xsizep, ysizep}, -- D
		 [38]  = {69, xsizep, ysizep}, -- E
		 [39]  = {70, xsizep, ysizep}, -- F
		 [40]  = {71, xsizep, ysizep}, -- G
		 
		 [41]  = {72, xsizep, ysizep}, -- H
		 [42]  = {73, xsizep, ysizep}, -- I
		 [43]  = {74, xsizep, ysizep}, -- J
		 [44]  = {75, xsizep, ysizep}, -- K
		 [45]  = {76, xsizep, ysizep}, -- L
		 [46]  = {77, xsizep, ysizep}, -- M
		 [47]  = {78, xsizep, ysizep}, -- N
		 [48]  = {79, xsizep, ysizep}, -- O		 
		 [49]  = {80, xsizep, ysizep}, -- P
		 [50]  = {81, xsizep, ysizep}, -- Q
		 
		 [51]  = {82, xsizep, ysizep}, -- R
		 [52]  = {83, xsizep, ysizep}, -- S		 
		 [53]  = {84, xsizep, ysizep}, -- T
		 [54]  = {85, xsizep, ysizep}, -- U
		 [55]  = {86, xsizep, ysizep}, -- V
		 [56]  = {87, xsizep, ysizep}, -- W
		 [57]  = {88, xsizep, ysizep}, -- X
		 [58]  = {89, xsizep, ysizep}, -- Y
		 [59]  = {90, xsizep, ysizep}, -- Z
		 [60]  = {91, xsizep, ysizep}, -- [
		 
		 [61]  = {92, xsizep, ysizep}, -- \
		 [62]  = {93, xsizep, ysizep}, -- ]
		 [63]  = {94, xsizep, ysizep}, -- ^
		 [64]  = {95, xsizep, ysizep}, -- _		 
		 [65]  = {96, xsizep, ysizep}, -- `
		 [66]  = {97, xsizep, ysizep}, -- a
		 [67]  = {98, xsizep, ysizep}, -- b
		 [68]  = {99, xsizep, ysizep}, -- c
		 [69]  = {100, xsizep, ysizep}, -- d
		 [70]  = {101, xsizep, ysizep}, -- e
		 
		 [71]  = {102, xsizep, ysizep}, -- f
		 [72]  = {103, xsizep, ysizep}, -- g
		 [73]  = {104, xsizep, ysizep}, -- h
		 [74]  = {105, xsizep, ysizep}, -- i
		 [75]  = {106, xsizep, ysizep}, -- j
		 [76]  = {107, xsizep, ysizep}, -- k
		 [77]  = {108, xsizep, ysizep}, -- l
		 [78]  = {109, xsizep, ysizep}, -- m		 
		 [79]  = {110, xsizep, ysizep}, -- n
		 [80]  = {111, xsizep, ysizep}, -- o
		 
		 [81]  = {112, xsizep, ysizep}, -- p
		 [82]  = {113, xsizep, ysizep}, -- q
		 [83]  = {114, xsizep, ysizep}, -- r
		 [84]  = {115, xsizep, ysizep}, -- s
		 [85]  = {116, xsizep, ysizep}, -- t
		 [86]  = {117, xsizep, ysizep}, -- u
		 [87]  = {118, xsizep, ysizep}, -- v
		 [88]  = {119, xsizep, ysizep}, -- w
		 [89]  = {120, xsizep, ysizep}, -- x
		 [90]  = {121, xsizep, ysizep}, -- y
		 
		 [91]  = {122, xsizep, ysizep}, -- z
		 [92]  = {123, xsizep, ysizep}, -- { = Nord
		 [93]  = {124, xsizep, ysizep}, -- | = Sud
		 [94]  = {125, xsizep, ysizep}, -- } = est
		 [95]  = {126, xsizep, ysizep}} -- ~ = west
		 -- [96]  = {38, xsizep, ysizep}, -- & = teta
		 -- [97]  = {39, xsizep, ysizep}} -- ' = ro	 
}

fontdescription["font_stroke_HUD"] = {
	class     = "ceSLineFont",
	symb_storage = "a29b_stroke_font",
	thickness  = 0.25,
	fuzziness  = 0.6,
	draw_as_wire = dbg_drawStrokesAsWire,
	default    = {13, 20},
	chars	   = {
		 [1]   = {latin['A'], "A"},
		 [2]   = {latin['B'], "B"},
		 [3]   = {latin['C'], "C"},
		 [4]   = {latin['D'], "D"},
		 [5]   = {latin['E'], "E"},
		 [6]   = {latin['F'], "F"},
		 [7]   = {latin['G'], "G"},
		 [8]   = {latin['H'], "H"},
		 [9]   = {latin['I'], "I"},
		 [10]  = {latin['J'], "J"},
		 [11]  = {latin['K'], "K"},
		 [12]  = {latin['L'], "L"},
		 [13]  = {latin['M'], "M"},
		 [14]  = {latin['N'], "N"},
		 [15]  = {latin['O'], "O"},
		 [16]  = {latin['P'], "P"},
		 [17]  = {latin['Q'], "Q"},
		 [18]  = {latin['R'], "R"},
		 [19]  = {latin['S'], "S"},
		 [20]  = {latin['T'], "T"},
		 [21]  = {latin['U'], "U"},
		 [22]  = {latin['V'], "V"},
		 [23]  = {latin['W'], "W"},
		 [24]  = {latin['X'], "X"},
		 [25]  = {latin['Y'], "Y"},
		 [26]  = {latin['Z'], "Z"},
		 
		 [27]  = {symbol['0'], "0"},
		 [28]  = {symbol['1'], "1"},
		 [29]  = {symbol['2'], "2"},
		 [30]  = {symbol['3'], "3"},
		 [31]  = {symbol['4'], "4"},
		 [32]  = {symbol['5'], "5"},
		 [33]  = {symbol['6'], "6"},
		 [34]  = {symbol['7'], "7"},
		 [35]  = {symbol['8'], "8"},
		 [36]  = {symbol['9'], "9"},
		 
		 [37]  = {symbol['-'], "symbol-minus"},
		 [38]  = {symbol['+'], "symbol-plus"},
		 [39]  = {symbol['\''], "symbol-apostrophe"},
		 [40]  = {symbol['('], "symbol-parenthesis-left"},
		 [41]  = {symbol[')'], "symbol-parenthesis-right"},
		 [42]  = {symbol['*'], "symbol-asterisk"},
		 [43]  = {symbol['%'], "symbol-percent"},
		 [44]  = {symbol[','], "symbol-comma"},
		 [45]  = {symbol['°'], "symbol-degree"},
		 [46]  = {symbol['.'], "symbol-period"},
		 [47]  = {symbol['/'], "symbol-slash"},
		 [48]  = {symbol['\\'], "symbol-backslash"},
		 [49]  = {symbol['\"'], "symbol-quote"},
		 [50]  = {symbol['?'], "symbol-question"},
		 [51]  = {symbol[':'], "symbol-colon"},
		 [52]  = {symbol['#'], "symbol-octothorpe"},
		 [53]  = {symbol['='], "symbol-equal"},
		 [54]  = {symbol['_'], "symbol-underscore"},
		 [55]  = {symbol['>'], "symbol-greater"},
		 [56]  = {symbol['<'], "symbol-less"},
	}
}
