# Contributing Community Extensions

Thanks for considering a contribution to DeQ's extension ecosystem. Extensions let you add custom functionality to DeQ without modifying the core server.

## Before You Submit

1. **Test your extension** on your own setup. If it only works with specific services, mention that.
2. **Check existing extensions** to avoid duplicates.
3. **Keep it focused.** One extension, one purpose.

## Extension Requirements

### File Header
Every extension needs a header block:

```python
# ------------------------------------------------------------------------------
# Name:        your_extension_name.py
# Description: What this extension does (one or two sentences)
# Author:      Your GitHub username
# Requirements: Any dependencies beyond Python standard library
# ------------------------------------------------------------------------------
```

### Code Quality

**Do:**
- Cache API responses with timestamps (avoid rate limits)
- Handle errors gracefully (return old cache instead of None)
- Use DeQ's CSS variables for theming integration
- Document any external API calls or dependencies
- Check device online status before executing commands

**Don't:**
- Hardcode device IDs or paths that others need to change
- Include credentials, API keys, or tokens
- Submit AI-generated code without understanding and testing it
- Cache `None` values (shows errors for 10+ minutes)
- Make blocking HTTP requests without timeout

### Required Functions

Every extension must define:

```python
def register(deq):
    """Called once when extension loads. Register your section here."""
    deq.register_section(
        id="unique_id",              # Must be unique
        title="Display Name",        # Shown in UI
        icon="icon-name",            # Lucide icon
        render=render_function       # Called every 5 seconds
    )

def render_function():
    """Called by frontend every 5 seconds. Must return HTML string."""
    # Your logic here
    return '<div>Your content</div>'
```

### Example Structure

```python
# ------------------------------------------------------------------------------
# Name:        weather.py
# Description: Display current weather from wttr.in API
# Author:      yourusername
# Requirements: urllib (Python standard library)
# ------------------------------------------------------------------------------

import urllib.request
import json
import time

CITY = "Berlin"  # Users can change this
CACHE = {"data": None, "time": 0}

def register(deq):
    """Called once when extension loads."""
    deq.register_section(
        id="weather",
        title="Weather",
        icon="cloud-sun",
        render=render_weather
    )

def render_weather():
    """Called every 5 seconds. Returns HTML string."""
    # Cache for 10 minutes to avoid rate limits
    if CACHE["data"] and time.time() - CACHE["time"] < 600:
        return format_weather(CACHE["data"])

    try:
        url = f"https://wttr.in/{CITY}?format=j1"
        with urllib.request.urlopen(url, timeout=5) as r:
            data = json.loads(r.read())
            CACHE["data"] = data
            CACHE["time"] = time.time()
            return format_weather(data)
    except Exception as e:
        # On error, return old cache if available
        if CACHE["data"]:
            return format_weather(CACHE["data"])
        return '<div style="padding:1rem;opacity:0.5">Weather unavailable</div>'

def format_weather(data):
    """Format data into HTML string."""
    current = data["current_condition"][0]
    return f'''
        <div style="text-align:center;padding:1rem;">
            <div style="font-size:2rem;font-weight:600">{current["temp_C"]}°C</div>
            <div style="opacity:0.7">{CITY}</div>
        </div>
    '''
```

### Styling Guidelines

Extensions should integrate with DeQ's theming:

```css
/* Use CSS variables */
background: var(--bg-secondary);
color: var(--text-primary);
border: 1px solid var(--border);

/* Card pattern */
background: var(--bg-secondary);
border: 1px solid var(--border);
border-radius: 12px;
padding: 16px;

/* Glass effect (optional) */
backdrop-filter: blur(var(--glass-blur, 0px));
```

## Available DeQ API Methods

The `deq` object passed to your register function provides:

### Properties (Read-only)
- `deq.devices` - List of all devices from config
- `deq.config` - Full config dict (read-only copy)

### Device Status
- `deq.device_status(device_id)` - Get cached status dict for a device
- `deq.is_online(device_id)` - Returns True/False/None

### Device Actions
- `deq.wol(device_id)` - Send Wake-on-LAN packet
- `deq.shutdown(device_id)` - Shutdown device via SSH
- `deq.suspend(device_id)` - Suspend device via SSH
- `deq.docker(device_id, container, action)` - Control Docker (action: "start", "stop", "status")

### SSH Execution
- `deq.ssh(device_id, command)` - Execute command via SSH. Returns (success: bool, stdout: str, stderr: str)

## Submitting

1. Fork the repository
2. Add your extension to `/community extensions/`
3. Create a Pull Request with:
   - Brief description of what the extension does
   - Any external dependencies or requirements
   - Why it might be useful for others

## Review Process

We'll review submissions when time allows. Extensions may be:
- **Accepted** as-is
- **Accepted with changes** (We might suggest improvements)
- **Returned for revision** with feedback
- **Declined** if it doesn't fit the collection

Common reasons for decline: too niche, security concerns, better solved differently.

## Security Considerations

Extensions run with full server privileges. They can:
- Execute arbitrary commands on configured devices via SSH
- Read/write files as the DeQ user (root)
- Access all configuration data

**Only install extensions from trusted sources.**

## Disclaimer

All community extensions are provided as-is. Using them is entirely at your own risk. Neither the extension authors nor DeQ maintainers are responsible for any damage, data loss, or other issues that may occur.

## Questions?

Open an issue or start a discussion on GitHub.
