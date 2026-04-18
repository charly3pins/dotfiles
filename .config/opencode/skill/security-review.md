# security-review Skill

**Trigger**: "auth", "input", "sanitize", "password", "token", "SQL", "XSS"

**Purpose**: Basic security review for common vulnerabilities.

## When to Use

Auto-invoked when Builder works on:
- Authentication/authorization code
- Input handling
- Database queries
- User-facing output

## Severity Levels

### CRITICAL (Must Fix)
- SQL injection (string concatenation in queries)
- Hardcoded secrets (API keys, tokens)
- `eval()` or `Function()` usage
- Unsafe deserialization

### HIGH (Should Fix)
- Missing input validation
- XSS vulnerabilities (innerHTML, document.write)
- Insecure randomness (Math.random for crypto)
- Path traversal

### MEDIUM (Fix if Time)
- Missing rate limiting
- Weak password policies
- Missing CSRF protection

### LOW (Nice to Have)
- HTTP instead of HTTPS
- Missing security headers
- Verbose error messages

## Auto-Fixes (Safe)

Can auto-fix:
- Extract hardcoded secrets to env vars
- Add basic input validation
- Replace HTTP with HTTPS

Cannot auto-fix (manual required):
- SQL injection refactoring
- Complex auth logic
- Cryptographic changes
