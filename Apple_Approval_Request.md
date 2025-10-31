# Family Controls (Distribution) Approval Requests

## Submit via: https://developer.apple.com/contact/

**Note:** Apple's Family Controls entitlement enables apps for personal device usage to access the Managed Settings and Device Activity frameworks in the Screen Time API. Daily Bread uses this for personal device usage management (users managing their own screen time).

---

## Request 1: Daily Bread Monitor Extension

**Subject:** Request Family Controls (Distribution) for App Extension: `com.mjhventures.dailybread.Daily-Bread-Monitor`

---

Hello Apple Developer Relations Team,

I am requesting approval to use **Family Controls (Distribution)** capability for personal device usage management in my Device Activity Monitor Extension.

**Extension Details:**
- **App ID:** `com.mjhventures.dailybread.Daily-Bread-Monitor`
- **Extension Type:** Device Activity Monitor Extension
- **Extension Point:** `com.apple.deviceactivity.monitor-extension`
- **Principal Class:** `DeviceActivityMonitorExtension`

**App Information:**
- **Main App ID:** `com.mjhventures.dailybread` (already approved for Family Controls Distribution on October 28, 2025)
- **Main App Name:** Daily Bread
- **Development Team:** MJH VENTURES LLC - W9T8XRTHNS
- **Usage Type:** Personal Device Usage (users managing their own screen time, not parental controls)

**App Purpose (Personal Device Usage):**
Daily Bread helps users manage their own device usage by automatically blocking distracting apps (like social media) at scheduled times. Users must read a daily Bible verse to unlock their apps, encouraging spiritual reflection and intentional device use. This is personal device usage management - users are restricting their own devices to support their spiritual goals.

**Extension Purpose:**
This extension uses the **Device Activity framework** in the Screen Time API to automatically apply shields to selected apps at scheduled times. When a user sets a daily blocking schedule (e.g., 4:20 PM), iOS calls this extension's `intervalDidStart()` method, which applies shields using the **ManagedSettings framework**.

**Technical Implementation:**
- Implements `DeviceActivityMonitor` class (Device Activity framework)
- Responds to `DeviceActivitySchedule` triggers from iOS system
- Uses `ManagedSettingsStore.shield.applications` to apply app blocking
- Uses `FamilyControls` framework for app selection
- Users authorize with `.individual` mode (personal device usage)

**Why Distribution Approval is Required:**
This extension requires Family Controls (Distribution) entitlement because it uses:
- **Device Activity framework** (part of Screen Time API)
- **Managed Settings framework** (`shield.applications` API)

These frameworks are only available with Family Controls entitlement approval. The extension is essential for the automatic scheduled blocking functionality that enables users to manage their personal device usage.

**Justification:**
This extension enables personal device usage management by allowing users to automatically block distracting apps at scheduled times, helping them focus on spiritual reflection. Users control their own restrictions and must actively engage with Bible reading to unlock apps. The extension is embedded within the main app bundle and serves no purpose outside of the approved Daily Bread app.

Thank you for your consideration.

---

## Request 2: Daily Bread Shield Configuration Extension

**Subject:** Request Family Controls (Distribution) for App Extension: `com.mjhventures.dailybread.Daily-Bread-Shield-Configuration`

---

Hello Apple Developer Relations Team,

I am requesting approval to use **Family Controls (Distribution)** capability for my Shield Configuration Extension.

**Extension Details:**
- **App ID:** `com.mjhventures.dailybread.Daily-Bread-Shield-Configuration`
- **Extension Type:** Shield Configuration Extension
- **Extension Point:** `com.apple.ManagedSettingsUI.shield-configuration-service`
- **Principal Class:** `ShieldConfigurationExtension`

**App Information:**
- **Main App ID:** `com.mjhventures.dailybread` (already approved for Family Controls Distribution on October 28, 2025)
- **Main App Name:** Daily Bread
- **Development Team:** MJH VENTURES LLC - W9T8XRTHNS

**Purpose:**
This extension provides custom UI configuration for the shield screen that appears when apps are blocked. It customizes the shield appearance with branded messaging, icons, and colors to guide users toward reading Bible verses.

**Technical Implementation:**
- Implements `ShieldConfigurationDataSource` protocol
- Provides `ShieldConfiguration` objects with custom:
  - Background color (royal blue matching app theme)
  - Custom icon (`DailyBread_Transparent.png`)
  - Custom title: "Your Daily Bread Awaits"
  - Custom subtitle: "Read a Bible verse to unlock your apps for today.\nPut God before social media."
  - Custom button label: "Continue to Daily Bread"
- Uses `ManagedSettingsUI` framework

**Why Distribution Approval is Required:**
This extension uses the `ManagedSettingsUI` framework and `ShieldConfiguration` API, which requires Family Controls (Distribution) entitlement. Without this approval, the extension cannot provide custom shield UI in production builds.

**Justification:**
This extension enhances user experience by providing branded, contextually relevant messaging when apps are blocked. It guides users to the app's primary purpose (reading Bible verses) rather than showing generic iOS restriction messages. It is embedded within the main app bundle and serves no purpose outside of the approved Daily Bread app.

Thank you for your consideration.

---

## Submission Instructions

1. **Go to:** https://developer.apple.com/contact/
2. **Select:** "Capabilities" or "Technical Support"
3. **Submit Request 1 first** (Monitor Extension)
4. **Wait for response** (typically 24-48 hours)
5. **Submit Request 2** (Shield Configuration Extension)

**Note:** You can submit both at the same time, or wait for one approval before submitting the second. Both are required for App Store distribution.

