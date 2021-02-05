#!/bin/bash
cd ../android
echo "Cleaning Anroid Project..."
./gradlew clean
cd ..
source ~/.bash_profile
echo "Cleaning Flutter Project..."
flutter clean
echo "Building Driver build..."
flutter build appbundle