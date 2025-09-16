
# Git Commit Workflow

Intelligently analyze changes and create meaningful commits.

## Command Purpose
Analyze staged and unstaged changes, batch them intelligently, and create meaningful commit messages.

## Actions to Perform

1. **Pre-flight Checks**
   - Scan for secrets or sensitive data
   - Check for debug code and temporary files left behind

2. **Smart Commit Creation**
   - Analyze changes to generate meaningful commit message
   - Follow conventional commit format
   - Group related changes intelligently
   - Include issue references if found

## Why This Command Exists
While Claude can commit, this command:
- Generates better commit messages by analyzing changes
- Prevents common mistakes (secrets, debug code)
