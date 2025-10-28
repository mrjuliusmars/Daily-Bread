# Setup Shield Configuration Extension

To enable custom shield UI, you need to create a **separate Shield Configuration Extension** target in Xcode.

## Steps:

1. **In Xcode, go to File > New > Target**
   - Choose **"App Extension"** category
   - Select **"Shield Configuration Extension"**
   - Click **Next**

2. **Configure the new target:**
   - Product Name: `Daily Bread Shield Configuration`
   - Bundle Identifier: `com.mjhventures.dailybread.ShieldConfiguration`
   - Language: Swift
   - Click **Finish**
   - When prompted, click **Activate** to add the scheme

3. **Replace the auto-generated files:**
   - Delete the auto-generated `ShieldConfigurationExtension.swift` file
   - Copy the files from `Daily Bread Shield Configuration/` folder:
     - `ShieldConfigurationExtension.swift`
     - `Info.plist`
     - `Daily_Bread_Shield_Configuration.entitlements`

4. **Configure the new target:**
   - Select the new target in Xcode
   - Go to **Signing & Capabilities**
   - Add the same App Group: `group.com.mjhventures.dailybread`
   - Ensure Family Controls entitlement is enabled
   - Set the **Info.plist** path in Build Settings

5. **Add the extension to the main app:**
   - Select the "Daily Bread" main app target
   - Go to **General** tab
   - Under **"Frameworks, Libraries, and Embedded Content"**
   - The new extension should auto-embed, but verify it's there

6. **Add the image asset to the extension:**
   - Copy `DailyBread_Transparent` image to the extension's asset catalog OR
   - Ensure the extension can access shared assets via App Groups

7. **Clean and rebuild** the project

## Why Two Extensions?

iOS requires **separate extension targets** for:
- **Shield Action Extension** - Handles button presses on the shield
- **Shield Configuration Extension** - Provides the custom UI design

Each extension has a different `NSExtensionPointIdentifier`:
- Action: `com.apple.ManagedSettings.shield-action-service`
- Configuration: `com.apple.ManagedSettings.shield-configuration`

