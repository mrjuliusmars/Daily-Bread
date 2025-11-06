# How to Register Fonts in Xcode

## Steps to Ensure Fonts Are Properly Registered:

1. **In Xcode, select the "Daily Bread" target**
   - Click on the project in the navigator
   - Select the "Daily Bread" target

2. **Go to Build Phases tab**
   - Click on "Build Phases"
   - Expand "Copy Bundle Resources"

3. **Add the font files**
   - Click the "+" button
   - Navigate to "Daily Bread/Lato/" folder
   - Select all the .ttf files (or add them one by one)
   - Make sure they're checked for the "Daily Bread" target

4. **Verify Info.plist registration**
   - The fonts are already registered in `INFOPLIST_KEY_UIAppFonts`
   - The paths should be: `Lato/Lato-Regular.ttf` etc.

5. **Clean and Rebuild**
   - Product > Clean Build Folder (Shift+Cmd+K)
   - Product > Build (Cmd+B)

## Alternative: Check Font Target Membership

1. Select a font file (e.g., Lato-Regular.ttf) in Xcode
2. In the File Inspector (right panel), check "Target Membership"
3. Make sure "Daily Bread" is checked

## Verify Fonts Are Loading

After building, the app should be able to find the fonts. The updated `latoFont()` function will automatically detect them.
