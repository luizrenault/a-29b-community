# DCS World A-29B Super Tucano

This is a free, open source, SFM, A-29B independent module for DCS World. By independent it is meant that it does not require any other modules to work.

The development is in a very early stage, but the author has decided on releasing it in hopes it will help others on the implementation of modern aircraft systems using SFM.

All aircraft systems are implemented in Lua and can be freely used in other non-paid DCS World Modules.


# Download

[Download Latest Release](https://github.com/luizrenault/a-29b-community/archive/refs/heads/main.zip)

[Download Latest Devel](https://github.com/luizrenault/a-29b-community/archive/refs/heads/devel.zip)

[Livery Pack](https://mega.nz/file/UAxUmYAY#0PyL3pO6i5x2QTrBWEkE5LsqeKFW5IuSJG_Er42PAas)

# Tutorial videos 

(Pt-BR by [Lucas Orsi](https://www.youtube.com/user/lucaoorsi)) - English subtitles now available.
- [Startup](https://www.youtube.com/watch?v=9XkSzbTcajE&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=1)
- [Taxi, takeoff and navigation](https://www.youtube.com/watch?v=zL0vY9_0fGU&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=3)
- [Visual landing](https://www.youtube.com/watch?v=0UId68gH33M&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=4)
- [Cutoff](https://www.youtube.com/watch?v=RPF_G8d9tMI&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=2)
- [Waypoints](https://www.youtube.com/watch?v=ZrFa4Mv7TUA&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=5&t=3s)
- [A/G Attack](https://www.youtube.com/watch?v=TyX-CzaA5FM)
- [A/A Attack](https://www.youtube.com/watch?v=m_SypnfGmYI&t=84s)
- [Selective Jettison](https://www.youtube.com/watch?v=TpYuuaqGLNk&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=9)
- [Manual Waypoint Navigation](https://www.youtube.com/watch?v=-cCLETzwebo&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=10&t=9s)
- [CCRP A/G Mode](https://www.youtube.com/watch?v=pwJYzBodbko&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=11)
- [CCRP A/G Mode CBU-97](https://www.youtube.com/watch?v=pQjlXoj7K1I&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=11)
- [HUD Modes](https://www.youtube.com/watch?v=VxT5uo5PYAg&list=PL-ajZ7qxQPDTFGGIr4x7eqEffvYifZbfA&index=12)

(En by [Grim Reapers](https://www.youtube.com/channel/UCZuXjkFY00p1ga3UyCBbR2w))
- [Install, Setup, Startup, Cockpit, Pages, Nav & Weapons Guide](https://youtu.be/gATHRMtI_vM)

(En by [311Gryphon](https://www.youtube.com/channel/UCR0ojtQ0Srh2y2O4pelFrDA))
- [Startup](https://www.youtube.com/watch?v=QbKsh-kPhIA)
- [Adding Waypoints via UFCP](https://www.youtube.com/watch?v=w6eE9TJt06U&list=PLo5YmN6D-iCADAvM0M1KvUKSfJjQYg4gF&index=2)
- [Selective Jettison](https://www.youtube.com/watch?v=OTM4-N1nNzE&list=PLo5YmN6D-iCADAvM0M1KvUKSfJjQYg4gF&index=3)
- [Air to Air Weapons](https://www.youtube.com/watch?v=TumUprFdE6M&list=PLo5YmN6D-iCADAvM0M1KvUKSfJjQYg4gF&index=4)
- [CCIP Weapons](https://www.youtube.com/watch?v=-2gN9zJngLE&list=PLo5YmN6D-iCADAvM0M1KvUKSfJjQYg4gF&index=5)

(En by [sidekick65](https://www.youtube.com/channel/UC4kJt_8Jw9ByL10ar6b8rQg))
- [First Impressions](https://www.youtube.com/watch?v=c6yp--xPpaA)

# ED Forum

[A-29 Super Tucano](https://forums.eagle.ru/topic/265017-a-29-super-tucano/)

# Changelog

## Version 0.3.1b - 15 Nov 2021

### Added
- ILS on HUD.

### Changes

### Fixes
- CMFD and BFI brightness adjustments for NVG compatibility.

## Version 0.3.0b - 15 Nov 2021

### Added
- OAP UFCP menu and HUD cue.
- WPT UTM format. 
- JTAC communication.
- In game Radio.
- CCIP Delayed Mode.
- CCIP Cluster Bomb calculations
- CCIP High Drag Bomb calculations
- QCHK and interactive OSSes to CMFD DTE.
- CMFD FLIR dummy page.
- Working CMFD DVR page.
- Blank submenu pages to checklist.
- UFCP FUEL format.
- Alarm test.
- Time to Impact for bombing.
- A/G mode select with Stick Step button.
- Going out and back to A/G mode uses last selection.
- GBU12, MK20RE, MK81 and MK82SE.

### Changes
- CCIP Bomb calculations for better precision.
- CCIP Rocket calculations for better precision.
- CCIP GUN calculations for better precision.
- Limited CCIP to HUD FOV.
- Set FWD LCMFD as default DOI.
- OSS Stroke Box can now have a width.
- CMFD DTE QCHK will show the loaded values in the aircraft.
- DTE will now look for theatre specific mission files.
- Auto-rudder Engage position is now momentary.
- RALT can now be turned on/off.
- Electric system enhancements:
    - ACFT INTC will show an advice when conditions meet.
    - GEN CAUT will not turn on with aircraft on the ground and engine off.
    - Main Bus and Main Avionics Bus gets disconnected when aircraft is airborne and engine is off.
    - Flaps will only be commanded/change position when Main Bus is connected.
    - Avionics will turn off when there is no Master MDP.
    - Left CMFD will stay on if Right CMFD is off and Avionics Master is off.
    - The MDPs will now take time to warm up.
    - ELEC OVRD switch will now force the electric system into the emergency mode.
- V/UHF Guard will switch the COM frequencies to 121.5 and 243.0.
- Taxi lights should only turn on on auto when in air.
- HSD:
    - Zoom can now be set in manual.
    - Added shortcut to ADHSI format.
    - FYTs are displayed by filled circles and WPs by outlined circles
    - HSD displays the original FYT position when DTK is on.
- ADHSI:
    - FYTs are displayed by filled circles and WPs by outlined circles
    - FYT label is D when DTK is active.

### Fixes
- Remade the UFCP WPT.
- FPM calculation was a little off with high roll angles.
- UFCP LMTs not being highlighted when edited.
- CCIP cue and bomb fall line.
- UFCP COM2 data editing.

### TODO
- Thrust tables of FM
- A/G Profiles
- FIX is only cosmetic because currently there is only pure EGI/GPS navigation.
- Create the alarms for the parameters in the LMT format.
- Set the AA DGFT piper size relative to UFCP_WS (target wingspan in metres)
- EGI state dictates NAV conditions.
- Instant Action for sceneries other than Caucasus missing.
- Warning msg when starting from Instant Action
- Low res interior texture.
- Strobe light in the wingtips has a black glare, while the lights do not glare when on.
- Pilot change when ejecting?
- Stall is weird (freezes in space), same when flying inverted, on apex of looping, etc.
- Stall speeds too high? Even with low fuel and little load, stalls happen above 100 knots
- Stall alarm not working
- Roll speed too low ?
- Parking brake without keyboard binding
- Taxi light turns off when steering/not following nose gear movement
- Taxing too stiff while turning? No effect of different weight loads.
- Night/day switch not working
- Light alarm test not working
- Battery never runs out of juice, generator inoperative 
- fuel pump switch inoperative, start works even when it is "off"
- Gear light indicator too weak (gear maneuvering red light too bright at night)
- Ground effect missing?
- Storm light comes out nowhere/illuminates outside, but not visible when looking from outside view
- Differential brake not working

## Version 0.2.1b - 08 May 2021

### Added
- Several key bindings.
- Added placeholder pages to CMFD.
- Added template CMFD system pages.
- Added UFCP format to CMFD.
- Added DTE format to CMFD.
- HSD Prototype.

### Changes
- Updated BFI.

### Fixes
- DA/H UFCP format will now show the correct QNH.

## Version 0.2.0b - 01 May 2021

### Added
- BARO / RALT submode now remembered with mode changes.
- Cabin Altitude pressurized down to 7000 ft. 
- New CMFD Texture.
- BAL, NAV MISC, EGI, FIX, TIP, LMT, WS, and DTK UFCP formats.
- DTK - Desired Track.
- New Normal Map and RoughMet (by Cubeboy)
- New experimental sounds for canopy, buttons, knobs and switches.
- UFCP EGI-INS format.
- EGI states and alignment timings.
- New Throttle x RPM curve.
- New RPM x Thrust curve.
- New RPM x FF curve.
- New aerodynamic flight model parameters.
- Throttle ST and CUT OFF positions.
- Engine Cutoff key binding.
- Mirrors.
- New DCS propeller technology for AI.

### Changed
- NVG Switch only disables storm light.
- Wingtip position for animation.
- Rockets and Guns CCIP doesn't take wind into consideration.
- Np around 100% when NG > 64%.
- T5 adjustments.
- Several EICAS transient values.
- A/G Weapon selection order now allows any stores combinations.
- Startup procedure: (Throttle CUT OFF -> ST on Ng=13%, ST -> Idle on Np = 40%)
- Propeller rotation animation to match Np.
- Minor tweaks to UFCP formats.
- Lights Bano.
- Brakes efficiency increased.

### Fixes
- UFCP WYPT menu minor bugs.
- Guns reloads to 500 rounds upon rearm.
- Altimeter pressure initial adjustment.
- Flaps, Audio Normal/Bkp and Bleed/Cutoff left/right click behavior.
- "Brake on" indicator still illuminated after battery is set to "off".

## Version 0.1.8b - 04 April 2021 - Happy Easter

### Added
- SRS Integration capability.
- COM 1 and COM 2 UFCP menus.
- COM 1, COM 2, COM 3 volume knobs working.
- UFCP Backlight.
- Night vision goggles (some lights are not compatible yet).
- Autopilot R/P and Alt modes.
- Cold start, Waypoint navigation and VFR Landing training missions (by Rudel_chw)
- UFCP DA/H and Time menus.
- RT and SW time modes on UFCP Main format.
- New UFCP textures.
- UFCP and CMFD key bindings.
- Engine will cut off randomly from 60 to 90kg of fuel.

### Changed
- Brakes efficiency now working as it should, based on velocity and pedal position.
- New Throttle and Stick texture.
- Altitude and Baro adjustments synchronized with DCS.
- UFCP WPT menu can edit data as WP or FYT.
- New FM according to specs for AoA vs KTAS.

### Fixes
- Salvo button now changes to SMS EJ format on CMFD 1.
- Gear Switch LMB/RMB behavior.
- CMFD EICAS Brightness adjustment.
- Fuel flow now more realistic.
- AI can take off, perform mission and land.


## Version 0.1.7b - 24 March 2021

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
- Cold start training mission (by Rudel_chw)
- Pylons are now removable
- New external 3d model with new animations
- New propeller animation
- New suspension parameters
- New external lights (working with AI)
- Speed break now working
- Livery pack download link included

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
- Battery and generator voltages.
- Gear down mapping now working.
- SJ JET and A/A or A/G RDY overlap.
- CHMD NAV A/C TRK no longer oscillates when stopped.
- FYT out of screen side.
- UFCP joystick interaction points.
- E/W buttons for coordinates.

## Version 0.1.6b - 07 March 2021

### Added
- CMFD SMS A/G format partially implemented.
- A/G launch options SGL, PAIR and SALVO.
- HUD A/G Gun piper.

### Fixes
- TTD is now limited to 99:59.
- GEN, MDP 1, MDP 2, AVIONICS MASTER, SMS, BKP, PMU and IGN switches initial positions on cold start.
- Roll rate increased.
- UFCP Up/Down connector size.

## Version 0.1.5b - 06 March 2021

### Added
- UFCP MENU and NAV formats. Now can set NAV MODE and time to destination display mode.
- HUD speed cue for ETA and DT time to destination modes and time to destination for ETA, DT or TTD modes.
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
- Instant action mission details.

### Fixed
- External lights behavior.
- Animations for Multiplayer.


## Version 0.0.5a - 13 February 2021

### Added
- Warning, Caution, Fire and Parking Brakes lights
- Warning, Caution and Advice messages on EICAS.
- Alarm API for warning, caution and advice status update.
- HUD brightness adjust knob working.
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
- Flight model tunning but far from ideal.
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
- Simplified startup procedure: Batt -> On; Main Fuel Pump -> Auto; PMU -> Auto; Ignition -> Auto; Fuel Shutoff -> Off; Starter -> On.
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
- Renault, Milaré, PaKo, Malamem, Athos, Dino, Jorge Rodrigues, Paoladelf, Farias, Skypork, CubeBoy, Rudel_chw, EDAV, Urbi, and many others.


### Changed

  

### Deprecated

  

### Removed

  

### Fixed

