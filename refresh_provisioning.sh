#!/bin/bash

# Script to help refresh provisioning profiles for Family Controls (Distribution)
# This script verifies configuration and provides instructions

echo "🔍 Checking Daily Bread Project Configuration..."
echo ""

# Check entitlements
echo "✓ Checking entitlements files..."
ENTITLEMENTS=(
    "Daily Bread/Daily Bread.entitlements"
    "Daily Bread Shield/Daily_Bread_Shield.entitlements"
    "Daily Bread Monitor/Daily_Bread_Monitor.entitlements"
    "Daily Bread Shield Configuration/Daily_Bread_Shield_Configuration.entitlements"
)

for ent in "${ENTITLEMENTS[@]}"; do
    if [ -f "$ent" ]; then
        if grep -q "com.apple.developer.family-controls" "$ent"; then
            echo "  ✓ $ent has Family Controls entitlement"
        else
            echo "  ✗ $ent MISSING Family Controls entitlement"
        fi
    else
        echo "  ✗ $ent NOT FOUND"
    fi
done

echo ""
echo "📋 Summary and Next Steps:"
echo ""
echo "1. In Xcode (for each target - Main, Shield, Monitor, Shield Configuration):"
echo "   - Go to Signing & Capabilities"
echo "   - Ensure 'Automatically manage signing' is checked"
echo "   - Ensure Team is set to: W9T8XRTHNS (MJH VENTURES LLC)"
echo ""
echo "2. In Developer Portal (developer.apple.com):"
echo "   - Certificates, Identifiers & Profiles → Identifiers"
echo "   - Edit com.mjhventures.dailybread"
echo "   - Verify 'Family Controls (Distribution)' is enabled ✓"
echo "   - Save"
echo ""
echo "3. In Developer Portal → Profiles:"
echo "   - Find App Store Distribution profile for com.mjhventures.dailybread"
echo "   - Click Edit → Save (regenerates profile)"
echo ""
echo "4. In Xcode:"
echo "   - Xcode → Settings → Accounts"
echo "   - Select your Apple ID → Team W9T8XRTHNS"
echo "   - Click 'Download Manual Profiles'"
echo "   - Quit and restart Xcode"
echo ""
echo "5. Clean and Archive:"
echo "   - Product → Clean Build Folder (Shift + Cmd + K)"
echo "   - Product → Archive"
echo ""
echo "⚠️  Note: Extensions inherit Family Controls (Distribution) from the main app"
echo "   when archiving, so you only need Distribution enabled for the main App ID."
echo ""

