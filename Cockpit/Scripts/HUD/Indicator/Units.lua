-- Set screen units and indicator scale

-- MFD screen units definitions, also units conversion
-- PX - F-16 - raster indicator pixel

function roundDI(value)
	if value > 0 then
		return math.floor(value + 0.5)
	else
		return math.ceil(value - 0.5)
	end
end

MeterToIn					= 39.3701
InToMeter					= 1 / MeterToIn

local PixelsPerSide			= 480
local HalfPixelsPerSide		= PixelsPerSide / 2

local ScreenSizeInch		= 4		-- inches

-- Currently this values are used
local PXtoIn_		= ScreenSizeInch / PixelsPerSide
local InToPX_		= 1.0 / PXtoIn_

local DegToRad_		= math.rad(1)
local RadToDeg_		= 1.0 / DegToRad_

local DegToMil_		= math.rad(1) * 1000
local MilToDeg_		= 1.0 / DegToMil_

local RadToMil_		= 1000
local MilToRad_		= 1.0 / RadToMil_

-- PX is a pixel in MFD indicators.
function PXtoIn(param) return (param or 1) * PXtoIn_ end						-- PX to inches
function InToPX(param) return (param or 1) * InToPX_ end						-- inches to PX

function DegToRad(param) return (param or 1) * DegToRad_ end
function RadToDeg(param) return (param or 1) * RadToDeg_ end

function DegToMil(param) return (param or 1) * DegToMil_ end
function MilToDeg(param) return (param or 1) * MilToDeg_ end

function RadToMil(param) return (param or 1) * RadToMil_ end
function MilToRad(param) return (param or 1) * MilToRad_ end
