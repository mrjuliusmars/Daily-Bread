# Family Controls: Development vs Distribution

## Answer: **You need BOTH for full functionality**

### Development Entitlement:
- ✅ **Required for:** Testing on devices during development
- ✅ **Used by:** Development provisioning profiles
- ✅ **Allows:** Local testing, Xcode device debugging
- ✅ **When needed:** Now, for testing the Monitor extension

### Distribution Entitlement:
- ✅ **Required for:** App Store submission and TestFlight
- ✅ **Used by:** Distribution/App Store provisioning profiles
- ✅ **Allows:** Uploading to App Store Connect, TestFlight distribution
- ✅ **When needed:** When you're ready to submit or distribute via TestFlight

---

## Your Current Situation:

### Main App (`com.mjhventures.dailybread`):
- ✅ Family Controls (Distribution) - Approved
- ❓ Family Controls (Development) - Check if enabled

### Extensions:
- ❌ `Daily-Bread-Monitor` - Needs Development for testing NOW
- ❌ `Daily-Bread-Shield-Configuration` - Needs Development for testing NOW
- Both need Distribution for App Store later

---

## What to Do:

### For Development Testing (Now):
1. **In Developer Portal:**
   - Go to Certificates, Identifiers & Profiles
   - Edit each extension App ID:
     - `com.mjhventures.dailybread.Daily-Bread-Monitor`
     - `com.mjhventures.dailybread.Daily-Bread-Shield-Configuration`
   - Enable **"Family Controls (Development)"** checkbox
   - Save

2. **In Xcode:**
   - Clean build folder
   - Xcode should automatically regenerate provisioning profiles
   - Build and run on device

### For App Store (Later):
- Once Apple approves your Distribution requests for extensions:
  - Enable "Family Controls (Distribution)" for each extension App ID
  - Archive will work for App Store submission

---

## Important Note:

The entitlement in your `.entitlements` files (`com.apple.developer.family-controls` = `true`) is the same for both Development and Distribution. The difference is in the **App ID configuration** in Developer Portal, not in your code files.

---

## Bottom Line:

- **For testing now:** Enable Family Controls (Development) for extensions
- **For App Store later:** You'll have Distribution approval (which you're requesting)
- **Best practice:** Have both enabled so you can test and distribute

