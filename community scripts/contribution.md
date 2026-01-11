# Contributing Community Scripts

Thanks for considering a contribution to DeQ's community scripts collection.

## Before You Submit

1. **Test your script** on your own setup. If it only works on your specific configuration, mention that.
2. **Check existing scripts** to avoid duplicates.
3. **Keep it focused.** One script, one purpose.

## Script Requirements

### Header
Every script needs a header block:

```bash
#!/bin/bash
# ------------------------------------------------------------------------------
# Name:        your-script-name.sh
# Description: What this script does (one or two sentences)
# Author:      Your GitHub username
# Tested on:   e.g., Debian 12, Ubuntu 24.04, Raspberry Pi OS
# Requirements: Any dependencies (e.g., rsync, curl)
# ------------------------------------------------------------------------------
```

### Code Quality

**Do:**
- Use variables for paths and values that others might need to change
- Add comments for non-obvious logic
- Handle errors gracefully
- Use `set -e` where appropriate

**Don't:**
- Hardcode paths like `/home/yourname/...`
- Use `curl | bash` from external URLs
- Include credentials, API keys, or tokens
- Submit AI-generated slop without understanding and testing it
- Assume root access without checking

### Example Structure

```bash
#!/bin/bash
set -e

# Configuration (adjust these)
DEQ_HOST="your-deq-server"
DEQ_PORT="5050"

# Script logic
echo "Doing the thing..."
# ... actual code ...

echo "Done."
```

## Submitting

1. Fork the repository
2. Add your script to `/community scripts/`
3. Create a Pull Request with:
   - Brief description of what the script does
   - Why it might be useful for others

## Review Process

We'll review submissions when time allows. Scripts may be:
- **Accepted** as-is
- **Accepted with changes** (We might clean up minor things)
- **Returned for revision** with feedback
- **Declined** if it doesn't fit the collection

Common reasons for decline: too niche, security concerns, better solved differently.

## Disclaimer

All community scripts are provided as-is. Using them is entirely at your own risk. Neither the script authors nor DeQ maintainers are responsible for any damage, data loss, or other issues that may occur.

## Questions?

Open an issue or start a discussion on GitHub.