#!/bin/bash
cd ../android
echo "Cleaning Anroid Project..."
./gradlew clean
cd ..
source ~/.bash_profile
echo "Cleaning Flutter Project..."
fvm flutter clean
echo "Building Framy build..."
fvm flutter build apk framy lib/presentation/nube_app.app.framy.dart 