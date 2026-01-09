// Instagram API Integration Examples
// Use these examples to fetch real follower data

// ============ Instagram Graph API (Recommended) ============
// Requires: Instagram Business Account + Meta App

async function fetchFollowersFromInstagramAPI(userId, accessToken) {
  try {
    const response = await fetch(
      `https://graph.instagram.com/v18.0/${userId}/followers?fields=id,username,ig_id,name,biography,website,profile_picture_url,followers_count,follows_count,media_count&access_token=${accessToken}`
    );

    const data = await response.json();
    
    if (!data.data) {
      throw new Error('No followers data found');
    }

    // Transform to data.json format
    const users = data.data.map(user => ({
      username: user.username,
      profileImageUrl: user.profile_picture_url,
      profileUrl: `https://instagram.com/${user.username}`
    }));

    return {
      lastUpdated: new Date().toISOString().split('T')[0],
      maxPixels: 1000000,
      users: users
    };
  } catch (error) {
    console.error('Error fetching from Instagram API:', error);
    return null;
  }
}

// ============ Instagram Graph API - With Pagination ============
// For accounts with many followers (>100)

async function fetchAllFollowers(userId, accessToken, maxFollowers = 1000000) {
  let allUsers = [];
  let nextUrl = `https://graph.instagram.com/v18.0/${userId}/followers?fields=username,profile_picture_url&limit=100&access_token=${accessToken}`;

  while (nextUrl && allUsers.length < maxFollowers) {
    try {
      const response = await fetch(nextUrl);
      const data = await response.json();

      if (!data.data) break;

      allUsers = allUsers.concat(
        data.data.map(user => ({
          username: user.username,
          profileImageUrl: user.profile_picture_url,
          profileUrl: `https://instagram.com/${user.username}`
        }))
      );

      // Get next page
      nextUrl = data.paging?.cursors?.after 
        ? `https://graph.instagram.com/v18.0/${userId}/followers?fields=username,profile_picture_url&limit=100&after=${data.paging.cursors.after}&access_token=${accessToken}`
        : null;

      console.log(`Fetched ${allUsers.length} followers...`);
    } catch (error) {
      console.error('Error fetching followers:', error);
      break;
    }
  }

  return {
    lastUpdated: new Date().toISOString().split('T')[0],
    maxPixels: 1000000,
    users: allUsers.slice(0, maxFollowers)
  };
}

// ============ Save to data.json ============
// Run this in Node.js environment (not in browser)

const fs = require('fs');

async function saveFollowersToJSON(userId, accessToken) {
  const data = await fetchAllFollowers(userId, accessToken);
  
  fs.writeFileSync(
    'data.json',
    JSON.stringify(data, null, 2)
  );

  console.log(`✅ Saved ${data.users.length} followers to data.json`);
}

// ============ Setup Instructions ============
/*

1. CREATE META APP
   - Go to https://developers.facebook.com/
   - Create new app
   - Add Instagram product
   - Get your App ID & Secret

2. GET ACCESS TOKEN
   - Use Instagram Graph API Explorer
   - https://developers.facebook.com/tools/explorer
   - Select your app
   - Generate User Token (requires Instagram Business Account)

3. FIND YOUR USER ID
   - Replace 'me' with your username:
   https://graph.instagram.com/v18.0/me?fields=id,username&access_token=YOUR_TOKEN

4. FETCH FOLLOWERS
   - Use the functions above
   - Pass User ID and Access Token
   - Save result to data.json

5. AUTOMATE DAILY UPDATES
   - Option A: GitHub Actions workflow
   - Option B: Cloud function (AWS Lambda, Google Cloud Function)
   - Option C: Cron job on your server

*/

// ============ GitHub Actions Workflow ============
/*
Create .github/workflows/update-followers.yml

name: Update Followers Daily

on:
  schedule:
    - cron: '0 0 * * *'  # Run daily at midnight UTC
  workflow_dispatch:     # Manual trigger

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Fetch followers
        env:
          INSTAGRAM_USER_ID: ${{ secrets.INSTAGRAM_USER_ID }}
          INSTAGRAM_ACCESS_TOKEN: ${{ secrets.INSTAGRAM_ACCESS_TOKEN }}
        run: |
          node fetch-followers.js
      
      - name: Commit changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add data.json
          git commit -m "Update followers: $(date -u +'%Y-%m-%d')"
          git push

*/

// ============ Alternative: Simple Instagram Scraper ============
// Warning: Web scraping violates Instagram ToS
// Use official APIs instead

/*
If you need an alternative without authentication:

1. Use unofficial packages at your own risk:
   npm install instagram-scraper

2. Example:
   const scraper = new Scraper();
   const profile = await scraper.getProfile('your_handle');
   const followers = await scraper.getFollowers('your_handle');

Note: Instagram actively blocks scrapers
      Recommend using official Graph API
*/

// ============ Testing ============
// Log sample data structure
const sampleData = {
  lastUpdated: "2026-01-09",
  maxPixels: 1000000,
  users: [
    {
      username: "sample_user",
      profileImageUrl: "https://api.dicebear.com/7.x/avataaars/svg?seed=sample",
      profileUrl: "https://instagram.com/sample_user"
    }
  ]
};

console.log(JSON.stringify(sampleData, null, 2));
