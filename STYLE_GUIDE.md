# Black Don OS - Nix Code Style Guide

This document defines the code style conventions for this NixOS configuration. These rules ensure consistency across the codebase and make it easier for AI agents to audit compliance.

## Function Parameters

### Parameter Formatting
- **Single-line format**: All function parameters should be on a single line
- **Spacing**: Include a space after the opening `{` and before the closing `}`
- **Multi-line continuation**: Anything after the colon (`:`) other than ` {` should go on the next line

**Correct:**
```nix
{ pkgs, lib, config, ... }: {
  # configuration here
}

{ pkgs, lib, ... }:
let
  variables = import ./variables.nix;
in
{
  # configuration here
}
```

**Incorrect:**
```nix
{
  pkgs,
  lib,
  config,
  ...
}: {
  # configuration here
}

{pkgs, lib, config, ...}: {  # missing spaces around braces
  # configuration here
}

{ pkgs, lib, ... }: let  # 'let' should be on next line
  variables = import ./variables.nix;
in
{
  # configuration here
}
```

## Comments

### Capitalization
- All comments should be lowercase
- Exception: The word "TODO" should remain uppercase for visibility
- Exception: If the capitalization is in a shell command, keep it

### Multi-sentence Comments
- When a comment contains multiple complete sentences, separate them with semicolons (`;`) instead of periods
- Do not add a semicolon at the end of the comment

**Correct:**
```nix
# this is a single-sentence comment
some.config = true;

# this is the first sentence; this is the second sentence
another.config = false;

# TODO: this needs to be fixed later
temporary.workaround = true;

# lowercase except for TODO items
```

**Incorrect:**
```nix
# This is a single-sentence comment.  # starts with capital
some.config = true;

# this is the first sentence. this is the second sentence  # uses period instead of semicolon
another.config = false;

# this is a comment;  # semicolon at end
final.config = true;

# todo: this needs fixing  # 'todo' should be uppercase
```

## Purpose

This style guide is designed to:
1. Maintain consistency across the entire codebase
2. Make code more readable and maintainable
3. Enable automated auditing by AI agents
4. Simplify code reviews and contributions

## Auditing

To audit the codebase for style compliance, an AI agent should check:

1. **Function parameters**: 
   - Verify all parameters are on one line
   - Check for spaces after `{` and before `}`
   - Ensure content after `:` (except ` {`) is on the next line

2. **Comments**:
   - Verify comments are lowercase (except TODO and shell commands)
   - Check multi-sentence comments use semicolons between sentences
   - Confirm no semicolons at the end of comments
   - Verify TODO is always uppercase

## Examples from Codebase

### Good Examples

```nix
# function with proper parameter formatting
{ pkgs, lib, host, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    # terminal emulators and launchers
    fuzzel
  ];
}

# multi-sentence comment with semicolon separator
{ config, lib, pkgs, username, ... }:
{
  # configure greetd unconditionally; it will be enabled by default only when other
  # display managers (sddm, ly) are not enabled
  services.greetd = {
    enable = lib.mkDefault (
      !config.services.displayManager.sddm.enable
    );
  };
}

# TODO comment remains uppercase
{
  # TODO: this was required for dms, is it still needed for noctalia?
  upower.enable = true;
}
```

### Common Mistakes to Avoid

```nix
# ❌ Multi-line parameters
{
  pkgs,
  lib,
  ...
}:

# ❌ Missing spaces in braces
{pkgs, lib, ...}:

# ❌ Capitalized comment start
# This is a comment

# ❌ Period between sentences
# this is first sentence. this is second sentence

# ❌ Semicolon at end
# this is a comment;

# ❌ Lowercase todo
# todo: fix this later
```

## Notes

- Function parameter rules apply to `.nix` files only
- Comment rules apply to all files except markdown (.md) files
- Config files have a variety of conventions for marking comments
- Generated files (like `hardware.nix`) may not follow these rules and should not be edited manually
