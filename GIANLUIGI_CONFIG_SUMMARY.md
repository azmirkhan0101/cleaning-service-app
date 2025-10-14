# ✅ App Configuration Updated - Gianluigi Company

## Updated: October 13, 2025

---

## 🎯 Configuration Changes Summary

### **Company Rebranding Complete**

All app configurations have been updated from **Spark Tech Agency** to **Gianluigi Company**.

---

## 📋 Changes Made

### 1. ✅ Package Name

- **OLD:** `com.sparktechagency.cleaningservice`
- **NEW:** `com.gianluigi.cleaningservice`
- **Files Updated:**
  - `android/app/build.gradle.kts` (namespace & applicationId)
  - `android/app/src/main/kotlin/com/gianluigi/cleaningservice/MainActivity.kt`

### 2. ✅ App Display Name

- **OLD:** "Spark Cleaning"
- **NEW:** "Cleaning Service"
- **File Updated:** `android/app/src/main/AndroidManifest.xml`

### 3. ✅ Keystore Configuration

- **OLD Keystore:** `cleaningservice-key` (Spark Tech Agency)
- **NEW Keystore:** `gianluigi-key` (Gianluigi Company)
- **Files Updated:**
  - `android/app-release-key.jks` (regenerated)
  - `android/key.properties`

### 4. ✅ MainActivity Package Structure

- **OLD Path:** `com/sparktechagency/cleaningservice/MainActivity.kt`
- **NEW Path:** `com/gianluigi/cleaningservice/MainActivity.kt`
- **Package Declaration:** `package com.gianluigi.cleaningservice`

---

## 🔐 New Keystore Credentials

**⚠️ CRITICAL - BACKUP THESE FILES:**

### Keystore Details

- **File:** `/android/app-release-key.jks`
- **Alias:** `gianluigi-key`
- **Store Password:** `gian2025`
- **Key Password:** `gian2025`
- **Validity:** 10,000 days (~27 years)
- **Owner:** CN=Gianluigi, OU=Mobile Development, O=Gianluigi Company

### Files to Backup

```
/android/app-release-key.jks
/android/key.properties
```

**📌 Important:** Without these files, you cannot update the app on Google Play Store!

---

## 📦 Release APK Details

**✅ Build Status:** Successfully Built

- **Location:** `build/app/outputs/flutter-apk/app-release.apk`
- **Size:** 72.5 MB
- **Package Name:** `com.gianluigi.cleaningservice`
- **App Name:** Cleaning Service
- **Signed:** ✅ Yes (Production keystore)
- **Ready to Share:** ✅ Yes

---

## 🚀 Installation & Sharing

### App Display

When installed, the app will appear as:

- **Name:** "Cleaning Service"
- **Package:** com.gianluigi.cleaningservice

### Sharing Methods

1. **Google Drive** (should work without flags now)
2. **Firebase App Distribution** (recommended)
3. **Dropbox / OneDrive**
4. **Direct Email** (if file size allows)
5. **WeTransfer / Send Anywhere**

### Installation Instructions for Users

1. Enable "Install from Unknown Sources" on Android device
2. Download the APK
3. Tap to install
4. App will appear as "Cleaning Service"

---

## 🔄 Future Builds

To rebuild with current configuration:

```bash
cd /Users/mukarrom/Desktop/STA/cleaning-service-app
flutter clean
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📝 Version Control

### Current Configuration

- **Version:** 1.0.0+1 (from pubspec.yaml)
- **Package:** com.gianluigi.cleaningservice
- **Company:** Gianluigi
- **App Name:** Cleaning Service

### For Next Release

Update version in `pubspec.yaml`:

```yaml
version: 1.0.1+2  # Increment before next build
```

---

## 🔧 Technical Details

### Package Structure

```
android/app/src/main/kotlin/
└── com/
    └── gianluigi/
        └── cleaningservice/
            └── MainActivity.kt
```

### Build Configuration Files

- ✅ `android/app/build.gradle.kts` - Updated
- ✅ `android/app/src/main/AndroidManifest.xml` - Updated
- ✅ `android/key.properties` - Updated
- ✅ `android/app-release-key.jks` - Regenerated

### Git Protection

Files protected in `.gitignore`:

```
*.jks
*.keystore
key.properties
```

---

## ⚠️ Important Notes

### Google Play Store

If you plan to publish on Google Play:

1. Use this exact keystore for all future updates
2. Keep the keystore password secure
3. Never share the keystore publicly

### Google Maps API

Current API key in `android/local.properties`:

```
MAPS_API_KEY=AIzaSyBjXcqOT4CPR-xseDQjhJYUY0_JtlAjXRE
```

**Recommended:** Restrict this key to package `com.gianluigi.cleaningservice` in Google Cloud Console:
<https://console.cloud.google.com/google/maps-apis>

---

## 🎨 Next Steps (Optional)

### 1. Custom App Icon

Replace default icons at:

```
/android/app/src/main/res/mipmap-*/ic_launcher.png
```

Tools: <https://icon.kitchen>

### 2. Splash Screen

Customize in:

```
/android/app/src/main/res/drawable/launch_background.xml
```

### 3. Update iOS Configuration (if needed)

Current changes only affect Android. For iOS:

- Update `ios/Runner/Info.plist`
- Update bundle identifier
- Regenerate signing certificates

---

## ✅ Verification Checklist

- [x] Package name: `com.gianluigi.cleaningservice`
- [x] App name: "Cleaning Service"
- [x] New keystore generated
- [x] MainActivity moved to new package
- [x] Old package directories removed
- [x] Release APK built successfully
- [x] Keystore credentials documented
- [x] Files protected in .gitignore

---

## 📞 Support Information

**Configuration Owner:** Gianluigi  
**Build Date:** October 13, 2025  
**APK Location:** `build/app/outputs/flutter-apk/app-release.apk`  
**Keystore:** `android/app-release-key.jks`

---

**🎉 Your app is now fully configured for Gianluigi Company and ready to share!**
