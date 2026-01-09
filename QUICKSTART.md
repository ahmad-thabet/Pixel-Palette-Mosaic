# Quick Start Guide

## What You Now Have

A beautiful 1M Pixel visualization where:
- Each pixel = 1 Instagram follower
- Each pixel shows the follower's profile picture
- Hover on a pixel to see their username
- Click to visit their Instagram profile
- Zoom & pan to explore

## How to Use

### 1. **Add Your Instagram Followers**

Edit `data.json` and add user objects:

```json
{
  "lastUpdated": "2026-01-09",
  "maxPixels": 1000000,
  "users": [
    {
      "username": "john_doe",
      "profileImageUrl": "https://instagram.com/john_doe/profile.jpg",
      "profileUrl": "https://instagram.com/john_doe"
    }
  ]
}
```

### 2. **Fetch Real Data**

You can get follower data from Instagram via:

**Option A: Instagram Graph API** (requires Instagram Business Account)
```bash
curl -X GET "https://graph.instagram.com/v18.0/{ig-user-id}/followers?fields=username,profile_picture_url&access_token={access-token}"
```

**Option B: Manual JSON file**
Update `data.json` daily with your followers

**Option C: Python Script** (using instagram-scraper)
```bash
pip install instagram-scraper
instagram-scraper your_handle --maximum 1000
```

### 3. **Deploy to GitHub Pages**

```bash
git add data.json
git commit -m "Update followers: 2026-01-09"
git push origin main
```

Visit: `https://your-username.github.io/Pixel-Palette-Mosaic`

## Customization

### Change Animation Speed
In `index.html`, find:
```javascript
const ANIMATION_SPEED = 1000; // pixels per second
```

### Change Grid Dimensions
```javascript
const GRID_SIZE = 1000; // 1000x1000 pixels
```

### Use Real Instagram Profile Images
Replace `profileImageUrl` with actual Instagram CDN links:
```
https://scontent.cdninstagram.com/v/t51.2885-19/XXX_n.jpg
```

## Data Structure

```json
{
  "lastUpdated": "ISO-8601 date",
  "maxPixels": 1000000,
  "users": [
    {
      "username": "instagram_handle",
      "profileImageUrl": "URL to profile image",
      "profileUrl": "https://instagram.com/handle"
    }
  ]
}
```

## Features

✅ **Deterministic** - Same pixel positions every time  
✅ **No Backend** - Pure static site  
✅ **Interactive** - Zoom, pan, hover, click  
✅ **Fast** - Animated pixel-by-pixel drawing  
✅ **GitHub Pages** - Free hosting  

## Troubleshooting

**Q: Images not loading?**
- Make sure image URLs are CORS-enabled
- Check browser console for CORS errors
- Use CDN with public access

**Q: Pixels not showing?**
- Check `data.json` syntax (use JSON validator)
- Verify `users` array is not empty
- Check console logs (F12 → Console)

**Q: Wrong grid size?**
- Edit `GRID_SIZE` constant
- Reload page

**Q: Want to reset pixel positions?**
- Change `SEED` constant to different number
- New deterministic layout will be generated

## Next Steps

1. ✅ Set up daily follower update workflow
2. 🎨 Customize colors/styling
3. 📊 Add statistics dashboard
4. 📱 Add mobile responsiveness
5. 🔍 Add search/filter functionality

Enjoy! 🎉
