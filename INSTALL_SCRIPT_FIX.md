# ZaneyOS Install Script Bug Fix

## Problem Description
User reported that the `install-zaneyos.sh` script was failing on physical servers with different usernames because hardcoded values for `dwilliams` username and `vm` GPU profile were not being properly updated during installation.

## Root Cause Analysis
The installation script had faulty pattern matching in the flake.nix update section (lines 283-286):

### Issues Identified:

1. **Incorrect AWK pattern matching**: 
   - Script looked for patterns like `^profile = ` (start of line)
   - Actual patterns in flake.nix have leading whitespace: `    profile = "vm";`

2. **Inconsistent sed/awk usage**:
   - Used sed for hostname but awk for profile and username
   - Mixed approaches caused maintenance issues

3. **Silent failures**:
   - Pattern matching failed silently, leaving hardcoded values
   - Users got build errors but no indication why

4. **Invalid hybrid profile**:
   - Script detected "hybrid" for nvidia+intel systems
   - No "hybrid" flake configuration exists, should use "nvidia-laptop"

## Solution Implemented

### 1. Fixed Pattern Matching
```bash
# Before (broken):
awk -v newprof="$profile" '/^profile = / { gsub(/"[^"]*"/, "\"" newprof "\""); } { print }'

# After (fixed):
awk -v newprof="$profile" '/^[[:space:]]*profile[[:space:]]*=/ { gsub(/"[^"]*"/, "\"" newprof "\""); } { print }'
```

### 2. Standardized Approach
- All flake.nix updates now use consistent awk pattern matching
- Handles leading whitespace properly with `^[[:space:]]*`
- Allows flexible spacing around the `=` sign

### 3. Added Verification Output
```bash
echo -e "Verifying configuration updates:"
echo -e "  Host: $(grep -E '^[[:space:]]*host[[:space:]]*=' ./flake.nix | head -1 | sed 's/.*"\([^"]*\)".*/\1/')"
echo -e "  Profile: $(grep -E '^[[:space:]]*profile[[:space:]]*=' ./flake.nix | head -1 | sed 's/.*"\([^"]*\)".*/\1/')"
echo -e "  Username: $(grep -E '^[[:space:]]*username[[:space:]]*=' ./flake.nix | head -1 | sed 's/.*"\([^"]*\)".*/\1/')"
```

### 4. Fixed Hybrid Detection
```bash
# Changed from "hybrid" to "nvidia-laptop"
elif $has_nvidia && $has_intel; then
  DETECTED_PROFILE="nvidia-laptop"  # Hybrid systems typically use nvidia-laptop profile
```

### 5. Added Profile Validation
```bash
valid_profiles=("amd" "nvidia" "nvidia-laptop" "intel" "vm")
if [[ ! " ${valid_profiles[@]} " =~ " ${profile} " ]]; then
  print_error "Invalid profile '$profile'. Valid options are: ${valid_profiles[*]}"
  exit 1
fi
```

## Testing Performed
- Verified pattern matching works correctly:
  ```bash
  echo '  host = "zaneyos-23-vm";' | awk -v newhost="test-host" '/^[[:space:]]*host[[:space:]]*=/ { gsub(/"[^"]*"/, "\"" newhost "\""); } { print }'
  # Output: '  host = "test-host";'
  ```

- Confirmed verification output extracts values properly:
  ```bash
  grep -E '^[[:space:]]*host[[:space:]]*=' ./flake.nix | head -1 | sed 's/.*"\([^"]*\)".*/\1/'
  # Output: zaneyos-23-vm
  ```

## Benefits of Fix
1. **Resolves build failures** - Users with different usernames will no longer get build errors
2. **Better feedback** - Verification output shows users exactly what values were set
3. **Robust detection** - Proper hybrid system detection maps to nvidia-laptop profile
4. **Input validation** - Invalid profiles are caught before build attempts
5. **Consistent approach** - All pattern matching uses same methodology

## Impact
This fix resolves the core issue reported by users where the install script would:
- Fail to update hardcoded `dwilliams` username
- Fail to update hardcoded `vm` profile  
- Result in build errors due to mismatched hostnames and missing host directories
- Provide no feedback about configuration update failures

The fix ensures that all user-provided values (hostname, username, profile) are correctly applied to the configuration files, enabling successful installations on any system.
