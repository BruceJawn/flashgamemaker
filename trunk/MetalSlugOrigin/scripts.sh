#!/bin/bash
#ADT AIR SDK 3.4

#ADL debug
"C:\air_sdk_3\bin\adl" -profile mobileDevice -runtime "C:\Documents and Settings\jndoye\Bureau\FGM\MetalSlugOrigin" "C:\Documents and Settings\jndoye\Bureau\FGM\MetalSlugOrigin\swf\application.xml"

#Packaging SWF to AIR
"C:\air_sdk_3\bin\adt" -package -storetype pkcs12 -tsa none -keystore "certificate.p12" swf/MSOrigin.air swf/application.xml swf/MSOrigin.swf swf/MSOrigin.html swf/swfobject.js -C "C:\Documents and Settings\jndoye\Bureau\FGM\MetalSlugOrigin" assets -C "C:\Documents and Settings\jndoye\Bureau\FGM\MetalSlugOrigin" data

#Packaging AIR to APK
"C:\air_sdk_3\bin\adt" -package  -target apk -storetype pkcs12 -keystore "certificate.p12" swf/MSOrigin.apk swf/MSOrigin.air

#Install de l'APK sur l'émulator AVD (Android Virtual Device)
"C:\android_sdk\platform-tools\adb" install swf/MSOrigin.apk 

#Packaging AIR to IPA
"C:\air_sdk_3\bin\adt" -package  -target ipa-test -storetype pkcs12 -keystore "certificate.p12" swf/LittleFighterEvo.ipa swf/LittleFighterEvo.air