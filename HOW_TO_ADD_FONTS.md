# How to Successfully Add Fonts to Your Xcode Project

## Complete Step-by-Step Guide

### Step 1: Add Font Files to Your Project
✅ **Already Done** - Your Lato font files are in `Daily Bread/Lato/` folder

### Step 2: Add Fonts to Target Membership

1. **In Xcode Project Navigator:**
   - Expand "Daily Bread" folder
   - Expand "Lato" folder
   - **Select ALL font files** (`.ttf` files) - you can Cmd+Click to select multiple

2. **In the File Inspector (right panel):**
   - If you don't see it, go to View > Inspectors > File Inspector (or press Cmd+Option+1)
   - Scroll down to **"Target Membership"** section
   - **Check the box** next to "Daily Bread" for all selected fonts
   - This tells Xcode to include these files in your app bundle

### Step 3: Verify Info.plist Registration

Your fonts are already registered in `INFOPLIST_KEY_UIAppFonts`:
```
Lato/Lato-Regular.ttf Lato/Lato-Bold.ttf Lato/Lato-Light.ttf ...
```

This is correct! ✅

### Step 4: Clean and Rebuild

1. **Clean Build Folder:**
   - Product > Clean Build Folder (or press Shift+Cmd+K)
   - This removes old build artifacts

2. **Rebuild:**
   - Product > Build (or press Cmd+B)
   - Wait for build to complete

3. **Run the app:**
   - Product > Run (or press Cmd+R)
   - Check the Xcode console for:
     - ✅ "Found Lato font family: [Lato]" = SUCCESS!
     - ⚠️ "Lato font family not found!" = Still not working

### Step 5: Verify Fonts Are Loading

When you run the app, check the Xcode console. You should see:
```
🔍 Checking for Lato fonts...
✅ Found Lato font family: [Lato]
   Fonts in Lato: [Lato-Regular, Lato-Bold, Lato-Light, ...]
```

If you see this, fonts are working! ✅

---

## Alternative Method: Add to Copy Bundle Resources

If Target Membership doesn't work, try this:

1. **Select your project** (blue icon at top of Project Navigator)
2. **Select "Daily Bread" target** (under TARGETS)
3. **Click "Build Phases" tab**
4. **Expand "Copy Bundle Resources"**
5. **Click the "+" button**
6. **Select all `.ttf` files** from the Lato folder
7. **Click "Add"**
8. **Clean and rebuild** (Step 4 above)

---

## Troubleshooting

### Fonts Still Not Loading?

1. **Check font file names match Info.plist:**
   - Info.plist has: `Lato/Lato-Regular.ttf`
   - File must be: `Daily Bread/Lato/Lato-Regular.ttf`

2. **Verify fonts are in the app bundle:**
   - After building, check: `Products/Daily Bread.app`
   - Fonts should be inside the `.app` bundle

3. **Try removing and re-adding:**
   - Uncheck Target Membership
   - Clean build
   - Re-check Target Membership
   - Rebuild

4. **Check for typos in font names:**
   - PostScript names must match exactly
   - The code tries: "Lato-Regular", "Lato Regular", "LatoRegular"

---

## Quick Checklist

- [ ] Font files are in the project folder
- [ ] All font files have "Daily Bread" checked in Target Membership
- [ ] Fonts are listed in `INFOPLIST_KEY_UIAppFonts` (already done ✅)
- [ ] Cleaned build folder
- [ ] Rebuilt project
- [ ] Console shows "Found Lato font family"

Once all checkboxes are complete, your fonts should work! 🎉

