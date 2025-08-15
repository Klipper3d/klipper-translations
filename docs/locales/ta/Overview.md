# கண்ணோட்டம்

Klipper ஆவணங்களுக்கு வரவேற்கிறோம். Klipper-க்கு புதியவராக இருந்தால், [features](Features.md) மற்றும் [installation](Installation.md) ஆவணங்களுடன் தொடங்கவும்.

## கண்ணோட்டம் செய்தி

- [அம்சங்கள்](Features.md): கிளிப்பரில் உள்ள அம்சங்களின் உயர் மட்ட பட்டியல்.
- [கேள்விகள்](FAQ.md): அடிக்கடி கேட்கப்படும் கேள்விகள்.
- [வெளியீடுகள்](Releases.md): கிளிப்பர் வெளியீடுகளின் வரலாறு.
- [கட்டமைப்பு மாற்றங்கள்](Config_Changes.md): பயனர்கள் தங்கள் அச்சுப்பொறி கட்டமைப்பு கோப்பைப் புதுப்பிக்க வேண்டிய அண்மைக் கால மென்பொருள் மாற்றங்கள்.
- [தொடர்பு](Contact.md): பிழை அறிக்கையிடல் மற்றும் கிளிப்பர் டெவலப்பர்களுடனான பொதுவான தொடர்புபற்றிய தகவல்.

## நிறுவல் மற்றும் உள்ளமைவு

- [நிறுவல்](Installation.md): கிளிப்பரை நிறுவுவதற்கான வழிகாட்டி.
   - [Octoprint](OctoPrint.md): Guide பெறுநர் installing Octoprint with Klipper.
- [கட்டமைப்புக் குறிப்பு](config_reference.md): கட்டமைப்பு அளவுருக்களின் விளக்கம்.
   - [சுழற்சி தூரம்](Rotation_Distance.md): சுழற்சி_தூரம் ஸ்டெப்பர் அளவுருவைக் கணக்கிடுதல்.
- [கட்டமைப்பு காசோலைகள்](config_checks.md): கட்டமைப்பு கோப்பில் அடிப்படை முள் அமைப்புகளைச் சரிபார்க்கவும்.
- [படுக்கை நிலை](Bed_Level.md): கிளிப்பரில் "படுக்கை நிலைப்படுத்தல்" பற்றிய தகவல்.
   - [Delta calibrate](Delta_Calibrate.md): Calibration of டெல்டா kinematics.
   - [ஆய்வு அளவீடு](probe_calibrate.md): தானியங்கி சட் ஆய்வுகளின் அளவுத்திருத்தம்.
   - [BL-Touch](BLTouch.md): Configure a "BL-Touch" சட் probe.
   - [Manual level](Manual_Level.md): Calibration of சட் endstops (and similar).
   - [படுக்கை கண்ணி](BED_MESH.MD): XY இடங்களின் அடிப்படையில் படுக்கை உயர திருத்தம்.
   - [Endstop phase](Endstop_Phase.md): Stepper assisted சட் endstop positioning.
   - [Axis Twist Compensation](Axis_Twist_Compensation.md): A கருவி பெறுநர் compensate க்கு inaccurate தேட்டி readings due பெறுநர் twist in ஃச் gantry.
- [அதிர்வு இழப்பீடு](Resonance_Compensation.md): அச்சுகளில் ஒலிப்பதைக் குறைப்பதற்கான ஒரு கருவி.
   - [Measuring resonances](Measuring_Resonances.md): செய்தி on using adxl345 accelerometer வன்பொருள் பெறுநர் measure resonance.
- [அழுத்த முன்னோக்கு](Pressure_Advance.md): எக்ஸ்ட்ரூடர் அழுத்தத்தை அளவீடு செய்யவும்.
- [சி-குறியீடுகள்](G-Codes.md): கிளிப்பரால் ஆதரிக்கப்படும் கட்டளைகள்பற்றிய தகவல்.
- [Command Templates](Command_Templates.md): G-Code பெரியவைகள் and conditional evaluation.
   - [Status Reference](Status_Reference.md): செய்தி available பெறுநர் பெரியவைகள் (and similar).
- [TMC Drivers](TMC_Drivers.md): Using Trinamic stepper மின்னோடி drivers with Klipper.
- [மல்டி-எம்சியூ ஹோமிங்](Multi_MCU_Homing.md): பல மைக்ரோ-கண்ட்ரோலர்களைப் பயன்படுத்தி ஹோமிங் மற்றும் ஆய்வு செய்தல்.
- [Slicers](Slicers.md): Configure "slicer" software க்கு Klipper.
- [Skew correction](Skew_Correction.md): Adjustments க்கு axes not perfectly square.
- [PWM tools](Using_PWM_Tools.md): Guide on how பெறுநர் use PWM controlled கருவிகள் such அச் lasers or spindles.
- [பொருளை விலக்கு](Exclude_Object.md): Exclude Objects செயல்படுத்தலுக்கான வழிகாட்டி.

## டெவலப்பர் ஆவணங்கள்

- [குறியீடு கண்ணோட்டம்](code_overview.md): உருவாக்குபவர்கள் இதை முதலில் படிக்க வேண்டும்.
- [இயக்கவியல்](Kinematics.md): கிளிப்பர் இயக்கத்தை எவ்வாறு செயல்படுத்துகிறது என்பது குறித்த தொழில்நுட்ப விவரங்கள்.
- [நெறிமுறை](Protocol.md): ஹோஸ்டுக்கும் மைக்ரோ-கட்டுப்படுத்திக்கும் இடையிலான குறைந்த-நிலை செய்தியிடல் நெறிமுறைபற்றிய தகவல்.
- [API சேவையகம்](API_Server.md): கிளிப்பரின் கட்டளை மற்றும் கட்டுப்பாட்டு பநிஇ பற்றிய செய்தி.
- [MCU commands](MCU_Commands.md): A விவரம் of low-level கட்டளைகள் implemented in the micro-controller software.
- [CAN bus protocol](CANBUS_protocol.md): Klipper CAN bus செய்தி format.
- [Debugging](Debugging.md): செய்தி on how பெறுநர் தேர்வு and debug Klipper.
- [Benchmarks](Benchmarks.md): செய்தி on the Klipper benchmark method.
- [பங்களிப்பு](CONTRIBUTING.md): கிளிப்பருக்கு மேம்பாடுகளை எவ்வாறு சமர்ப்பிப்பது என்பது குறித்த செய்தி.
- [பேக்கேசிங்](Packaging.md): OS தொகுப்புகளை உருவாக்குவது பற்றிய செய்தி.

## சாதனம் குறிப்பிட்ட ஆவணங்கள்

- [Example configs](Example_Configs.md): செய்தி on adding an example கட்டமைப்பு கோப்பு பெறுநர் Klipper.
- [SDCard Updates](SDCard_Updates.md): Flash a micro-controller by copying a இருமம் பெறுநர் an sdcard in the micro-controller.
- [Raspberry Pi அச் Micro-controller](RPi_microcontroller.md): Details க்கு controlling devices wired பெறுநர் the GPIO pins of a புற்றுப்பழம் Pi.
- [Beaglebone](Beaglebone.md): Details க்கு running Klipper on the Beaglebone PRU.
- [துவக்க ஏற்றி](Bootloaders.md): மைக்ரோகண்ட்ரோலர் ஒளிரும் உருவாக்குபவர் செய்தி.
- [Bootloader Entry](Bootloader_Entry.md): துவக்க ஏற்றியைக் கோருதல்.
- [CAN bus](CANBUS.md): செய்தி on using CAN bus with Klipper.
   - [CAN பஸ் சரிசெய்தல்](CANBUS_Troubleshooting.md): CAN பஸ் சரிசெய்தலுக்கான உதவிக்குறிப்புகள்.
- [TSL1401CL தாள் width sensor](TSL1401CL_Filament_Width_Sensor.md)
- [Hall தாள் width sensor](Hall_Filament_Width_Sensor.md)
- [எடி கரண்ட் இண்டக்டிவ் புரோப்](Eddy_Probe.md)
- [கலங்களை ஏற்று](Load_Cell.md)
