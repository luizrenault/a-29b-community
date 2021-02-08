
# Changelog
 

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),

and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## Version 0.0.3a - 07 February 2021

### Added
- First version of the HUD. NAV mode partially implemented with VV/VAH > Off. Viewing angle is goot for VR, but clipped for monitors. Need to move pilot forward (not zooming in).
- Free flight instant action mission.

### Changed
- Throttle scale. Still need to be fixed.

## Version 0.0.2a - 04 February 2021

### Added
- New 3D Models: CMFD #1 and #2.
- CMFD #1 and #2 working properly.
    - EICAS format finished. Not all values are shown properly because the aircraft systems are not implemented yet.
- ADHSI format as a static image. Will be implemented soon.

### Changed
- BFI background color from blue to black.
- ASI, VSI, BFI, Throttle, Warning, Caution, Fire and Brake indicators 3D models by new ones.
- Fligh model tunning but far from ideal.
- Flaps with only two positions UP and DOWN (20 deg).

### Deprecated

  

### Removed

  

### Fixed

- Left mirror texture.
- VSI scale.
- Backlight color to green
- Front glass missing frame. 


## Version 0.0.1a - 27 January 2021

### Added

- Added 3D model for aircraft and cockpit based on [Tim Conrad's A-29 FSX module](https://flyawaysimulation.com/downloads/files/24093/fsx-tim-conrad-embraer-29b-super-tucano-updated/).
- Refactor of lua files based on A-29B DCS Mod provided by Malamen, and several other DCS modules.
- Added new cockpit instruments by Milaré.
- Basic textures for new cockpit instruments.
- Basic aircraft controls working - Aileron, Elevator, Throttle, Flaps, Gear, Brakes, Parking Brakes.
- Ground Cold, Ground Hot or Air Hot start modes working correctly.
- Simplified startup procerure: Batt -> On; Main Fuel Pump -> Auto; PMU -> Auto; Ignition -> Auto; Fuel Shutoff -> Off; Starter -> On.
- External lights are working but with wrong visual representations.
- Internal lights are working but maybe with wrong colors.
- BFI (Basic Flight Instruments) partially implemented.
- ASI (Attitude Standby Indicator) partially implemented.
- VSI( Vertical Velocity Indicator) partially implemented (wrong scale).
- Canopy animations.
- Currently working clickable cockpit panels: 
    - Gear;
    - External Lights;
    - Flaps;
    - Engine;
    - Electrical;
    - Internal Lights;
    - Fuel;
    - Avionics;
    - BFI;
- All other switches and indicator are only cosmetic at the time:
    - Late Arm / Mass;
    - Clock;
    - Salvo;
    - ELT / PICNAV;
    - GPS;
    - Audio;
    - HF Radio;
    - CMFD #1 and #2;
    - Brakes, Fire, Warning and Caution indicators;
    - UFCP;
    - TRIMS;
- Simplified Flight Model with some real parameters. TODO: Add real engine and aerodynamics coefficients.
- Throttle and Stick are inconsistent with the real ones;

### Contributors
- Renault, Milaré, Malamem, Marvila, Cavanha, Risali, Jorge Rodrigues and many others.


### Changed

  

### Deprecated

  

### Removed

  

### Fixed

