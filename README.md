# DCS World A-29B Super Tucano

This is a free, opensource, SFM, A-29B independent module for DCS World. By independent it is meant that it does not require any other modules to work.

The development is in a very early stage, but the author has decided on releasing it in hopes it will help others on the implementation of modern aircraft systems using SFM.

All aircraft systems are implemented in Lua and can be freely used in other non-paid DCS World Modules.


# Download

[Latest Release](https://github.com/luizrenault/a-29b-community/releases/latest)

# Tutorial videos 

(Pt-BR by [Lucas Orsi](https://www.youtube.com/user/lucaoorsi)) - English subtitles now available.
- [Startup](https://www.youtube.com/watch?v=9XkSzbTcajE&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=1)
- [Taxi, takeoff and navigation](https://www.youtube.com/watch?v=zL0vY9_0fGU&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=3)
- [Visual landing](https://www.youtube.com/watch?v=0UId68gH33M&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=4)
- [Cutoff](https://www.youtube.com/watch?v=RPF_G8d9tMI&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=2)
- [Waypoints](https://www.youtube.com/watch?v=ZrFa4Mv7TUA&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=5&t=3s)
- [A/G Attack](https://www.youtube.com/watch?v=TyX-CzaA5FM)
- [A/A Attack](https://www.youtube.com/watch?v=m_SypnfGmYI&t=84s)

(En by [Grim Reapers](https://www.youtube.com/channel/UCZuXjkFY00p1ga3UyCBbR2w))
- [Install, Setup, Startup, Cockpit, Pages, Nav & Weapons Guide](https://youtu.be/gATHRMtI_vM)

(En by [311Gryphon](https://www.youtube.com/channel/UCR0ojtQ0Srh2y2O4pelFrDA))
- [Startup](https://www.youtube.com/watch?v=QbKsh-kPhIA)

# ED Forum

[A-29 Super Tucano](https://forums.eagle.ru/topic/265017-a-29-super-tucano/)

# Changelog
 
## Version 0.1.7b - 23 March 2021

### Added
- A/G CCRP mode.
- A/G Ripple Pulses (RP) and Impact Separation (IS)
- UFCP, throttle handle and stick textures.
- UFCP VV/VAH format.
- UFCP VV/VAH now syncs with CMFD ADHSI.
- Livery template (by Cubeboy)
- Argentina liveries (by GOA -_Max_)
- Several UFCP format placeholders
- Livery pack (by Urbi, gheoss)
- Coldstart training mission (by Rudel_chw)
- Pylons are now removable
- New external 3d model with new animations
- New propeller animation
- New suspension parameters
- New external lights
- Speedbreak now working

### Changed
- A/G Weapon selection order (External Pylons > Internal Pylons > Ventral Pylon. Left first.)
- Roll rate reduced.
- VV/VAH default state is now off.
- Cold Start ECS switch default position to MAN.
- Cold Start Avionics Master switch default position to Off.
- Cold Start Emer Speed Break switch default position to Normal.
- Cold Start Flaps switch default position to Down.
- Cold Start Rec switch default position to Stop.
- Cold Start UFCP Brightness knob default position to Max Brt.
- Cold Start EGI switch default position to Off.
- Hot Air/Ground EGI switch default position to Nav.
- Gear drag increased.
- SFM parameters according to pilot feedbacks (PaKo, Leno, Malamem, EDAV, and others).

### Fixes
- FYT 0 selected when no route is pre-loaded on mission.
- Warn and Caut lights now turns off when pressed.
- UFCP Increase Brightness knob rotation to CW.
- UFCP power source is now avionics master main dc bus.
- BFI power source is now the backup battery.
- Rearm / Refuel now sets Fuel Init quantity.
- Battery and gererator voltages.
- Gear down mapping now working.
- SJ JET and A/A or A/G RDY overlap.
- CHMD NAV A/C TRK no loger oscillates when stopped.

## Version 0.1.6b - 07 March 2021

### Added
- CMFD SMS A/G format partially implemented.
- A/G lauch options SGL, PAIR and SALVO.
- HUD A/G Gun piper.

### Fixes
- TTD is now limited to 99:59.
- GEN, MDP 1, MDP 2, AVIONICS MASTER, SMS, BKP, PMU and IGN switches initial positions on cold start.
- Roll rate increased.
- UFCP Up/Down connector size.

## Version 0.1.5b - 06 March 2021

### Added
- UFCP MENU and NAV formats. Now can set NAV MODE and time to destination display mode.
- HUD speed cue for ETA and DT time to destination modes and time to dastination for ETA, DT or TTD modes.
- NAV MODE AUTO.

### Fixes
- A/G mode now selects DRIFT C/O.
- A/G CCIP and CCIP R are working as expected.

## Version 0.1.4b - 05 March 2021

### Added
- UFCP Main format.
- UFCP FYT/WPT format.
- Now is possible to insert and edit waypoints and use them for navigation.
- CMFD NAV MARK, A/C and AFLD formats, which completes CMFD NAV format.

### Fixes
- EDA livery name.
- Texture names to avoid integrity check fail.

## Version 0.1.3b - 01 March 2021

### Added
- EGI waypoint navigation.
- CMFD NAV FYT and ROUT formats.

## Version 0.1.2b - 27 February 2021

### Added
- A/G CCIP Bomb and Missile cues.
- CBU-97.
- CMFDs brightness adjustment.

## Version 0.1.1b - 25 February 2021

### Added
- HUD DGFT modes.
- HUD VV/VAH modes.
- HUD INT modes.
- Weapon related throttle handle buttons and axis.

## Version 0.1.0b - 21 February 2021

### Added
- MK82.

### Fixes
- Wheel brakes
- Firing A/A no longer fires A/G.
- Nose wheel steering limited to 20 degrees
- Selective Jettison Emergency Jettison now can jettison containers / racks.
- Flaps drag reduced.
- External fuel tank weight.
- Fuel consumption reduced to one third.
- .50 bullet weight.
- .50 fire rate.

## Version 0.0.7a - 20 February 2021

### Added
- Trim indication on EICAS is now working.
- A/A INT mode with Sidewinder seek and lock tones.
- A/A DOGFT mode with Sidewinder and guns.
- Simplified A/G mode with bombs, missiles and rockets.
- Selective and Emergency (Salvo) Jettison modes.
- Axis for Wheel Brakes.
- Joystick mapping for all Stick Buttons.

### Changed
- SMS and Weapons systems code refactory.
- Instant Action missions minor changes.
- Rearm/Refuel menu aircraft image.

### Fixed
- Liveries and external cockpit textures.
- Guns pointing elevation.


## Version 0.0.6a - 17 February 2021

### Added
- Landing gear warning.
- Landing gear handle and indication lights.
- HUD WARN message and UFCP WARN RST behavior.
- Smoke pylon with different color options.
- ADHSI CMFD format almost finished.
- SMS CMFD format preview.
- Avionics System and API.

### Changed
- CMFD library.
- Instant action mission detais.

### Fixed
- External lights behavior.
- Animations for Multiplayer.


## Version 0.0.5a - 13 February 2021

### Added
- Warning, Caution, Fire and Parking Brakes lights
- Warning, Caution and Advice messages on EICAS.
- Alarm API for warning, caution and advice status update.
- HUD brightness ajdust knob working.
- Windshield Deice working

### Changed
- Electric system API better implemented.
- Default texture.

### Fixed
- Some night lights were incorrectly displayed.
- Pitot Pri and Sec heat switches electric behavior.

## Version 0.0.4a - 10 February 2021

### Added
- New instrument textures.
- NAV and NAV LANDING HUD modes almost completed.
- UFCP animations.
- Guns working.
- Ground Crew Comm menu working (Rearm and Refuel).

### Changed
- More tunning on the SFM.

### Fixed
- Throttle and other panels scales.

## Version 0.0.3a - 07 February 2021

### Added
- First version of the HUD. NAV mode partially implemented with VV/VAH > Off. Viewing angle is good for VR, but clipped for monitors. Need to move pilot forward (not zooming in).
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
- Renault, Milaré, PaKo, Malamem, Athos, Dino, Jorge Rodrigues, Paoladelf, Farias, Skypork, EDAV, and many others.


### Changed

  

### Deprecated

  

### Removed

  

### Fixed

