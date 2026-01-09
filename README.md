# 1M Follower Pixels - User Profile Edition

A generative art visualization showing Instagram followers as a 1,000×1,000 pixel grid. Each pixel represents a user and displays a thumbnail of their profile picture.

## Features

✨ **User Profile Pictures** - Each pixel shows the profile image of an Instagram follower
🎨 **Deterministic Layout** - Seeded RNG ensures pixel positions are consistent across reloads
🖱️ **Interactive** - Zoom, pan, hover for user info, click to visit profile
⚡ **Animated** - Smooth pixel-by-pixel drawing animation
📊 **Real-time Stats** - Live pixel count and last update timestamp
🌐 **GitHub Pages Compatible** - Pure static site, no backend required

## Data Format

### `data.json` Structure

```json
{
  "lastUpdated": "2026-01-09",
  "maxPixels": 1000000,
  "users": [
    {
      "username": "instagram_handle",
      "profileImageUrl": "https://example.com/profile.jpg",
      "profileUrl": "https://instagram.com/instagram_handle"
    }
  ]
}
```

**Fields:**
- `lastUpdated`: ISO date string (YYYY-MM-DD) when the list was last updated
- `maxPixels`: Maximum pixel capacity (usually 1,000,000)
- `users`: Array of user objects
  - `username`: Instagram handle (shown on hover)
  - `profileImageUrl`: URL to profile picture (1×1 pixel will be extracted for color)
  - `profileUrl`: Link to Instagram profile

## How It Works

1. **Load Users** - Fetches `data.json` containing user list
2. **Generate Positions** - Uses seeded RNG to deterministically place pixels in a 1000×1000 grid
3. **Load Images** - Fetches profile pictures (uses CORS-safe URLs)
4. **Extract Colors** - Takes dominant color from each profile image
5. **Animate Drawing** - Smoothly draws pixels at ~1000 pixels/second
6. **Interact** - Users can zoom, pan, hover, and click

## Usage

### Update Daily

Simply commit a new `data.json` with updated follower list:

```bash
git add data.json
git commit -m "Update followers for 2026-01-10"
git push
```

### Customize Animation Speed

Edit `ANIMATION_SPEED` constant in `index.html`:

```javascript
const ANIMATION_SPEED = 1000; // Pixels to draw per second
```

### Change Grid Size

Edit `GRID_SIZE` constant (default 1000×1000):

```javascript
const GRID_SIZE = 1000;
```

## Interactions

| Action | Effect |
|--------|--------|
| **Scroll** | Zoom in/out (towards cursor) |
| **Drag** | Pan around grid |
| **Hover** | Shows username tooltip |
| **Click** | Opens Instagram profile |

## Image URLs

Profile images should meet these requirements:

- ✅ CORS-enabled (crossOrigin: anonymous)
- ✅ Square format preferred (any dimensions work)
- ✅ HTTP or HTTPS (not data URIs)
- ✅ Fast loading (CDN recommended)

### Example Sources

- **DiceBear Avatars** (auto-generated): `https://api.dicebear.com/7.x/avataaars/svg?seed=username`
- **Instagram Graph API** (real profiles): Requires authentication
- **Any CORS-enabled image service**

## Determinism

The visualization uses a **seeded random number generator** (Mulberry32 with seed=42) to ensure:

- ✅ Same pixel positions across page reloads
- ✅ Consistent layout for all users
- ✅ No backend needed

To change seed, modify `SEED` constant:

```javascript
const SEED = 42; // Change this value
```

## Performance

- **Grid Size**: 1,000×1,000 (1 million pixels)
- **User Limit**: Limited by browser memory and API rate limits
- **Draw Speed**: ~1000 pixels/second
- **Canvas Context**: 2D with `willReadFrequently: true` for optimal performance

## Browser Support

- ✅ Chrome/Brave
- ✅ Firefox
- ✅ Safari
- ✅ Edge

Requires ES6+ and Canvas 2D API

## Limitations

- Limited to CORS-enabled image sources
- Maximum ~1,000,000 pixels (memory constraints)
- No real-time data (requires manual JSON updates)
- No server-side processing

## GitHub Pages Setup

1. Push code to GitHub repo
2. Enable GitHub Pages in repo settings (main branch)
3. Site will be available at `https://username.github.io/repo-name`
4. Update `data.json` daily via commits

## Future Enhancements

- 🎥 PNG export functionality
- 📅 Timeline scrubber to show growth over time
- ✨ Highlight today's new pixels
- 🎨 Color filter/search by username
- 📱 Mobile touch gestures

## License

MIT - Feel free to modify and use for your own projects!
