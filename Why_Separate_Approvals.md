# Why Extensions Need Separate Approvals

## YES, This is Normal and Required

### Apple's Policy:
**Each app extension that uses Family Controls MUST be approved separately**, even if:
- ✅ The main app is already approved
- ✅ Extensions are part of the same app bundle
- ✅ Extensions share the same purpose

---

## Why Apple Requires This:

### 1. **Security & Privacy**
- Extensions run as separate processes with separate sandboxes
- Apple audits each extension independently for security vulnerabilities
- Each extension has access to sensitive Screen Time data

### 2. **Different Security Contexts**
- Main app: User-facing UI, requests permissions
- Monitor Extension: Called by iOS system processes at scheduled times
- Shield Extension: Called by iOS to render system UI

Each has different access patterns and security implications.

### 3. **Compliance & Accountability**
- Apple needs to approve each piece of code that uses Family Controls APIs
- Extensions are separate executables, not part of the main app binary
- Each extension's App ID is tracked separately for compliance

### 4. **Developer Experience Standard**
- This is the standard process ALL developers follow
- You're not doing anything unusual or extra
- Even major apps submit separate requests for each extension

---

## What This Means for You:

✅ **Normal Process:**
- Submit request for main app → Approved ✅
- Submit request for Monitor extension → Needs approval
- Submit request for Shield Config extension → Needs approval

❌ **NOT an Error:**
- You're not missing a step
- There's no "shortcut" to combine them
- This is Apple's required process

---

## Your Situation:

You need **2 more approval requests**:
1. `com.mjhventures.dailybread.Daily-Bread-Monitor`
2. `com.mjhventures.dailybread.Daily-Bread-Shield-Configuration`

Both extensions must be approved separately before you can archive for App Store distribution.

---

## Timeline Expectation:

- Main app approval: Typically 24-48 hours
- Extension approvals: Typically 24-48 hours each
- You can submit both extension requests at the same time
- Or submit one, wait for approval, then submit the second

---

## Bottom Line:

**Yes, this is completely normal.** Every developer using Family Controls extensions goes through this same process. Apple requires separate approval for security and compliance reasons, not because your setup is incorrect.

