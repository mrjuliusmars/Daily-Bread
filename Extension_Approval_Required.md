# Extensions CANNOT Inherit Family Controls from Main App

## Answer: **YES, separate requests are required**

---

## Why Extensions Can't Share/Inherit

Apple's official policy (confirmed by forums and documentation):

> **Each app extension that utilizes the Family Controls framework requires its own App ID and must be individually approved by Apple.**

### Reasons:
1. **Separate Executables**: Extensions run as separate processes with their own sandbox environments
2. **Separate Entitlements**: Each extension has its own entitlements file (`.entitlements`)
3. **Separate App IDs**: Each extension must have a unique bundle identifier
4. **Separate Provisioning Profiles**: Xcode generates separate provisioning profiles for each extension App ID

### What This Means:
- Your main app approval (`com.mjhventures.dailybread`) ✅
- Does NOT automatically grant approval to extensions ❌
- Each extension needs its own approval request ✅

---

## Your Current Situation

**Main App:** `com.mjhventures.dailybread`
- ✅ Family Controls (Distribution) - Approved

**Extensions Requiring Approval:**
1. `com.mjhventures.dailybread.Daily-Bread-Monitor` ❌ Needs approval
2. `com.mjhventures.dailybread.Daily-Bread-Shield-Configuration` ❌ Needs approval

**Note:** `com.mjhventures.dailybread.Daily-Bread-Shield` (ShieldActionExtension) does NOT need approval because it doesn't directly use Family Controls APIs.

---

## Next Steps

You'll need to submit **2 separate approval requests** to Apple:

1. One for `Daily-Bread-Monitor`
2. One for `Daily-Bread-Shield-Configuration`

Use the templates in `Apple_Approval_Request.md` that I created earlier.

---

## Why This Limitation Exists

Apple treats extensions as separate security contexts because:
- Extensions are called by iOS system processes (not your app)
- They have access to sensitive user data (app blocking, shield UI)
- Apple needs to audit each extension independently for security/privacy compliance

---

## Bottom Line

**You need separate approval requests for both extensions.** There's no workaround - Apple requires this for security and compliance reasons.

