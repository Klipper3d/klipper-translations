# கண்ணோட்டம்

கிளிப்பர் ஆவணத்திற்கு வருக. கிளிப்பருக்கு புதியதாக இருந்தால், [அம்சங்கள்] (அம்சங்கள். எம்.டி) மற்றும் [நிறுவல்] (நிறுவல்.எம்டி) ஆவணங்களுடன் தொடங்கவும்.

## கண்ணோட்டம் செய்தி

- [அம்சங்கள்] (அம்சங்கள். எம்.டி): கிளிப்பரில் அம்சங்களின் உயர் மட்ட பட்டியல்.
- [கேள்விகள்] (கேள்விகள்): அடிக்கடி கேட்கப்படும் கேள்விகள்.
- [வெளியீடுகள்] (வெளியீடுகள். எம்.டி): கிளிப்பர் வெளியீடுகளின் வரலாறு.
- [கட்டமைப்பு மாற்றங்கள்] (கட்டமைப்பு மாற்றங்கள். மற்றும்): பயனர்கள் தங்கள் அச்சுப்பொறி கட்டமைப்பு கோப்பைப் புதுப்பிக்க வேண்டிய அண்மைக் கால மென்பொருள் மாற்றங்கள்.
- [தொடர்பு] (தொடர்பு.

## Installation and Configuration

- [நிறுவல்] (Installation.md): கிளிப்பரை நிறுவுவதற்கான வழிகாட்டி.
   - [Octoprint](OctoPrint.md): Guide பெறுநர் installing Octoprint with Klipper.
- [கட்டமைப்பு குறிப்பு] (config_reference.md): கட்டமைப்பு அளவுருக்களின் விளக்கம்.
   - [சுழற்சி தூரம்] (சுழற்சி_டிச்டன்ச்.
- [கட்டமைப்பு காசோலைகள்] (config_checks.md): கட்டமைப்பு கோப்பில் அடிப்படை முள் அமைப்புகளை சரிபார்க்கவும்.
- [படுக்கை நிலை] (படுக்கை நிலை. மற்றும்): கிளிப்பரில் "படுக்கை சமன் செய்தல்" பற்றிய செய்தி.
   - [Delta calibrate](Delta_Calibrate.md): Calibration of டெல்டா kinematics.
   - [ஆய்வு அளவீடு] (probe_calibrate.md): தானியங்கி சட் ஆய்வுகளின் அளவுத்திருத்தம்.
   - [BL-Touch](BLTouch.md): Configure a "BL-Touch" சட் probe.
   - [Manual level](Manual_Level.md): Calibration of சட் endstops (and similar).
   - [படுக்கை கண்ணி] (BED_MESH.MD): XY இடங்களின் அடிப்படையில் படுக்கை உயர திருத்தம்.
   - [Endstop phase](Endstop_Phase.md): Stepper assisted சட் endstop positioning.
   - [Axis Twist Compensation](Axis_Twist_Compensation.md): A கருவி பெறுநர் compensate க்கு inaccurate தேட்டி readings due பெறுநர் twist in ஃச் gantry.
- [அதிர்வு இழப்பீடு] (அதிர்வு_அம்பென்சேசன்.
   - [Measuring resonances](Measuring_Resonances.md): செய்தி on using adxl345 accelerometer வன்பொருள் பெறுநர் measure resonance.
- [Pressure advance](Pressure_Advance.md): Calibrate extruder pressure.
- [சி-குறியீடுகள்] (சி-கோட்ச்.எம்டி): கிளிப்பர் ஆதரிக்கும் கட்டளைகள் பற்றிய செய்தி.
- [Command Templates](Command_Templates.md): G-Code பெரியவைகள் and conditional evaluation.
   - [Status Reference](Status_Reference.md): செய்தி available பெறுநர் பெரியவைகள் (and similar).
- [TMC Drivers](TMC_Drivers.md): Using Trinamic stepper மின்னோடி drivers with Klipper.
- [Multi-MCU Homing](Multi_MCU_Homing.md): Homing and probing using multiple micro-controllers.
- [Slicers](Slicers.md): Configure "slicer" software க்கு Klipper.
- [Skew correction](Skew_Correction.md): Adjustments க்கு axes not perfectly square.
- [PWM tools](Using_PWM_Tools.md): Guide on how பெறுநர் use PWM controlled கருவிகள் such அச் lasers or spindles.
- [பொருளை விலக்கு] (விலக்கு_ஆப்செக்ட்.

## Developer Documentation

- [குறியீடு கண்ணோட்டம்] (code_overview.md): உருவாக்குபவர்கள் இதை முதலில் படிக்க வேண்டும்.
- [இயக்கவியல்] (இயக்கவியல். எம்.டி): கிளிப்பர் இயக்கத்தை எவ்வாறு செயல்படுத்துகிறது என்பது குறித்த தொழில்நுட்ப விவரங்கள்.
- [நெறிமுறை] (நெறிமுறை.
- [API சேவையகம்] (API_SERVER.MD): கிளிப்பரின் கட்டளை மற்றும் கட்டுப்பாட்டு பநிஇ பற்றிய செய்தி.
- [MCU commands](MCU_Commands.md): A விவரம் of low-level கட்டளைகள் implemented in the micro-controller software.
- [CAN bus protocol](CANBUS_protocol.md): Klipper CAN bus செய்தி format.
- [Debugging](Debugging.md): செய்தி on how பெறுநர் தேர்வு and debug Klipper.
- [Benchmarks](Benchmarks.md): செய்தி on the Klipper benchmark method.
- [பங்களிப்பு] (பங்களிப்பு. எம்.டி): கிளிப்பருக்கு மேம்பாடுகளை எவ்வாறு சமர்ப்பிப்பது என்பது குறித்த செய்தி.
- [பேக்கேசிங்] (பேக்கேசிங்.எம்டி): OS தொகுப்புகளை உருவாக்குவது பற்றிய செய்தி.

## Device Specific Documents

- [Example configs](Example_Configs.md): செய்தி on adding an example கட்டமைப்பு கோப்பு பெறுநர் Klipper.
- [SDCard Updates](SDCard_Updates.md): Flash a micro-controller by copying a இருமம் பெறுநர் an sdcard in the micro-controller.
- [Raspberry Pi அச் Micro-controller](RPi_microcontroller.md): Details க்கு controlling devices wired பெறுநர் the GPIO pins of a புற்றுப்பழம் Pi.
- [Beaglebone](Beaglebone.md): Details க்கு running Klipper on the Beaglebone PRU.
- [துவக்க ஏற்றி] (bootloader.md): மைக்ரோகண்ட்ரோலர் ஒளிரும் உருவாக்குபவர் செய்தி.
- [Bootloader Entry](Bootloader_Entry.md): Requesting the bootloader.
- [CAN bus](CANBUS.md): செய்தி on using CAN bus with Klipper.
   - [பச் சரிசெய்தல் முடியும்] (பச் சரிசெய்தல் செய்யலாம்.
- [TSL1401CL தாள் width sensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall தாள் width sensor](Hall_Filament_Width_Sensor.md)
- [எடி தற்போதைய தூண்டல் ஆய்வு] (EDDY_PROBE.MD)
- [Load Cells](Load_Cell.md)
