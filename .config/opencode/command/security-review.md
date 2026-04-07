---
description: Basic security review for common vulnerabilities. Run after /validate.
---

# /security-review

Check for SQL injection, XSS, hardcoded secrets, and missing input validation.

## Usage

```
/security-review {change-name}
```

## When to Use

- After `/validate` passes but before `/code-review`
- When working with user input, authentication, or sensitive data
- To catch security issues early (cheaper than post-merge)

## What It Checks

**Critical:**
- SQL injection
- Hardcoded secrets
- eval() usage

**High:**
- Missing input validation
- XSS vulnerabilities
- Insecure randomness

**Medium/Low:**
- HTTP instead of HTTPS
- Verbose error messages
- Missing security headers

## What It Does

1. Reads changed files
2. Runs security checks
3. Generates report with severity levels
4. Offers auto-fixes for obvious issues
5. Provides guidance for complex fixes
