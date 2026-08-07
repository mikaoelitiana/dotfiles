# Agent Manager - Mistral Vibe Configuration

This configuration adds [Mistral Vibe](https://github.com/mistralai/mistral-vibe) support to [agent-manager](https://github.com/YoanWai/agent-manager).

## Installation

Copy or symlink this directory to your agent-manager configuration location:

- **macOS**: `~/Library/Application Support/agent-manager/`
- **Linux**: `~/.config/agent-manager/`
- **Windows**: `%APPDATA%\agent-manager\`

## Features

- ✅ **Status Detection**: Identifies when Mistral Vibe is working, waiting for approval, or has encountered an error
- ✅ **Session Management**: Supports resuming previous sessions with `--resume`
- ✅ **Prompt Handling**: Takes prompts positionally (no flag required)

## Status States

The configuration detects four states:

| State | Trigger Examples |
|-------|-----------------|
| **idle** | Default state when no other pattern matches |
| **waiting** | Tool approval prompts (`approve? (y/n)`), permission requests |
| **working** | Spinners (▀▀▀, ███, │), keywords like "thinking", "generating", "executing" |
| **errored** | Error symbols (✗, ❌), error messages, exceptions, tracebacks |

## Configuration Details

- **Polling Interval**: 2 seconds (default)
- **Command**: `vibe`
- **Activity Cutoff**: Lines starting with `> ` are considered the input prompt
- **Resume Command**: `vibe --resume {id}`

## Version Compatibility

- **Mistral Vibe**: 2.24.0+
- **Agent Manager**: Latest version

## Contributing

This profile is tagged with `agent-manager-tool` on GitHub for discoverability. If you improve the patterns or add new features, consider:

1. Forking and creating a pull request
2. Adding the `agent-manager-tool` topic to your repository
3. Submitting your improvements to the official agent-manager profiles

## License

This configuration is provided under the same license as agent-manager (Apache-2.0).