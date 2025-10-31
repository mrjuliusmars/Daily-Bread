# Archive Checklist for Daily Bread

## ✅ Pre-Archive Verification

### 1. Developer Portal Setup
- [x] Family Controls (Distribution) enabled for `com.mjhventures.dailybread`
- [x] Distribution provisioning profile regenerated (Edit → Save)
- [x] Profiles downloaded in Xcode

### 2. Xcode Configuration
- [x] All targets use Automatic signing
- [x] All targets have correct Development Team (W9T8XRTHNS)
- [x] Main app has Family Controls (Distribution) capability
- [x] Extensions have Family Controls (Development) OR inherit Distribution

### 3. Entitlements Files
- [x] All 4 entitlements files include `com.apple.developer.family-controls`
- [x] All have same App Group (`group.com.mjhventures.dailybread`)

## 📦 Archive Steps

1. **Clean Build Folder**
   - Product → Clean Build Folder (Shift + Cmd + K)
   - Wait for completion

2. **Select Archive Scheme**
   - Ensure "Daily Bread" scheme is selected
   - Select "Any iOS Device" (not simulator)

3. **Archive**
   - Product → Archive
   - Wait for build to complete

4. **If Archive Succeeds**
   - You'll see the Organizer window
   - Ready to upload to App Store Connect

5. **If Archive Fails**
   - Check error messages
   - Common issues:
     - Provisioning profiles not refreshed (wait 5-10 min after regenerating)
     - Xcode needs restart after downloading profiles
     - Family Controls capability not properly enabled in Developer Portal

## 🔍 Troubleshooting

If you still see "Family Controls (Development)" errors:
- Extensions should inherit Distribution when archiving
- Verify main app's Distribution profile includes the capability
- Try deleting and recreating Distribution profile

If profile errors persist:
- Xcode → Settings → Accounts → Download Manual Profiles
- Quit and restart Xcode
- Clean build folder again

