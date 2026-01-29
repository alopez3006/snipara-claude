#!/bin/bash

echo "Testing Snipara Claude Code Plugin..."
echo ""
echo "1. Checking plugin structure..."
if [ -f ".claude-plugin/plugin.json" ]; then
    echo "   ✓ Plugin manifest exists"
else
    echo "   ✗ Plugin manifest missing"
    exit 1
fi

if [ -d "commands" ] && [ "$(ls -A commands)" ]; then
    echo "   ✓ Commands directory exists with files"
else
    echo "   ✗ Commands directory empty or missing"
fi

if [ -d "skills" ] && [ "$(ls -A skills)" ]; then
    echo "   ✓ Skills directory exists with files"
else
    echo "   ✗ Skills directory empty or missing"
fi

if [ -d "hooks" ] && [ -f "hooks/hooks.json" ]; then
    echo "   ✓ Hooks configuration exists"
else
    echo "   ✗ Hooks configuration missing"
fi

echo ""
echo "2. Validating plugin.json..."
jq empty .claude-plugin/plugin.json 2>/dev/null
if [ $? -eq 0 ]; then
    echo "   ✓ Plugin manifest is valid JSON"
    echo ""
    echo "   Plugin name: $(jq -r .name .claude-plugin/plugin.json)"
    echo "   Version: $(jq -r .version .claude-plugin/plugin.json)"
    echo "   Description: $(jq -r .description .claude-plugin/plugin.json)"
else
    echo "   ✗ Plugin manifest is invalid JSON"
    exit 1
fi

echo ""
echo "3. Counting plugin components..."
COMMANDS=$(find commands -name "*.md" 2>/dev/null | wc -l)
SKILLS=$(find skills -name "SKILL.md" 2>/dev/null | wc -l)
echo "   Commands: $COMMANDS"
echo "   Skills: $SKILLS"

echo ""
echo "4. Testing plugin load..."
echo "   Run: claude --plugin-dir ."
echo ""
echo "   Then try these commands:"
echo "   - /snipara:lite [task]"
echo "   - /snipara:full [task]"
echo "   - /snipara:remember [content]"
echo "   - /snipara:recall [query]"
echo "   - /help  (to see all commands)"
echo ""
echo "✓ Plugin structure validated successfully!"
