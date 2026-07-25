#!/bin/bash

# RallyDeals Repository Clone Script
# Clones all RallyDeals repositories into the current directory

echo "Cloning all RallyDeals repositories..."
echo ""

# Array of repository URLs
repos=(
    "https://github.com/RallyDeals/rally-docs"
    "https://github.com/RallyDeals/rally-order"
    "https://github.com/RallyDeals/rally-payment"
    "https://github.com/RallyDeals/rally-common"
    "https://github.com/RallyDeals/rally-infrastructure"
    "https://github.com/RallyDeals/rally-inventory"
    "https://github.com/RallyDeals/rally-catalog"
    "https://github.com/RallyDeals/rally-notification"
    "https://github.com/RallyDeals/rally-deal"
    "https://github.com/RallyDeals/rally-participation"
    "https://github.com/RallyDeals/.github"
    "https://github.com/RallyDeals/rally-management"
    "https://github.com/RallyDeals/rally-auth"
    "https://github.com/RallyDeals/rally-ui"
)

# Clone each repository
for repo in "${repos[@]}"; do
    echo "Cloning $repo..."
    git clone "$repo"
    if [ $? -eq 0 ]; then
        echo "✓ Successfully cloned $repo"
    else
        echo "✗ Failed to clone $repo"
    fi
    echo ""
done

echo "Done! All repositories have been cloned."