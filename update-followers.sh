#!/bin/bash
# Script to help generate data.json with Instagram followers
# This is a template - you'll need to fetch real user data from Instagram API

# Usage: ./update-followers.sh

# Example: Replace this with actual Instagram API calls
# For now, this creates a template

CURRENT_DATE=$(date +%Y-%m-%d)
OUTPUT_FILE="data.json"

cat > "$OUTPUT_FILE" << EOF
{
  "lastUpdated": "$CURRENT_DATE",
  "maxPixels": 1000000,
  "users": [
    {
      "username": "follower_1",
      "profileImageUrl": "https://api.dicebear.com/7.x/avataaars/svg?seed=follower_1",
      "profileUrl": "https://instagram.com/follower_1"
    }
  ]
}
EOF

echo "✅ Template created: $OUTPUT_FILE"
echo ""
echo "📝 To populate with real followers:"
echo "1. Use Instagram Graph API or instagram-scraper"
echo "2. Replace usernames with real Instagram handles"
echo "3. Use real profile image URLs"
echo "4. Commit and push to GitHub"
echo ""
echo "Example using instagram-scraper (Python):"
echo "  pip install instagram-scraper"
echo "  instagram-scraper <username> --maximum 1000000"
