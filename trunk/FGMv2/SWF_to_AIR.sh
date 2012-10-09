#!/bin/bash
#ADT AIR SDK 3.4

#ADL debug
adl "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2\swf\application.xml"

#Packaging SWF to AIR
adt -package -storetype pkcs12 -keystore "certificate.p12" swf/FlashGameMaker.air swf/application.xml swf/FlashGameMaker.swf swf/FlashGameMaker.html swf/swfobject.js -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" assets\LittleFighterEvo -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" \classes\script\game\littleFighterEvo\data

#Packaging SWF to APK Emulator
adt -package -target apk-emulator -storetype pkcs12 -keystore "certificate.p12" swf/FlashGameMaker.apk swf/application.xml swf/FlashGameMaker.swf swf/FlashGameMaker.html swf/swfobject.js -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" assets\LittleFighterEvo -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" \classes\script\game\littleFighterEvo\data  

#Packaging SWF to APK
adt -package -target apk -storetype pkcs12 -keystore "certificate.p12" swf/FlashGameMaker.apk swf/application.xml swf/FlashGameMaker.swf swf/FlashGameMaker.html swf/swfobject.js -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" assets\LittleFighterEvo -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" \classes\script\game\littleFighterEvo\data  

#Packaging AIR to APK
adt -target apk -storetype pkcs12 -keystore "certificate.p12" swf/FlashGameMaker.apk swf/FlashGameMaker.air

#Install de l'APK sur l'�mulator AVD (Android Virtual Device)
adb install FlashGameMaker.apk

#Packaging SWF to Apple Store
adt -package -target ipa-app-store -storetype pkcs12 -keystore "certificate.p12" -provisioning-profile AppleDistribution.mobileprofile swf/FlashGameMaker.ipa swf/application.xml swf/FlashGameMaker.swf swf/FlashGameMaker.html swf/swfobject.js -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" assets\LittleFighterEvo -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" \classes\script\game\littleFighterEvo\data  

#Packaging SWF to Ipa Debug
adt -package -target ipa-debug -storetype pkcs12 -keystore "certificate.p12" -provisioning-profile AppleDevelopment.mobileprofile -connect 192.168.0.12 | -listen swf/FlashGameMaker.ipa swf/application.xml swf/FlashGameMaker.swf swf/FlashGameMaker.html swf/swfobject.js -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" assets\LittleFighterEvo -C "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2" \classes\script\game\littleFighterEvo\data  

#Lauch FDB (Flash Debuger)
fdb -p [port]

#Launch ADL
adl "C:\Users\NDOYEA\Adobe Flash Builder 4\FGMv2\swf\application.xml"