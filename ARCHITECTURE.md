# Architecture Overview

## System Design

```
┌─────────────────────────────────────────────────────────────┐
│                    PIXEL PALETTE MOSAIC                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              FRONTEND (index.html)                    │  │
│  │  ┌──────────────────────────────────────────────────┐ │  │
│  │  │ Canvas Rendering (1000x1000 grid)              │ │  │
│  │  │ - Seeded RNG for deterministic layout           │ │  │
│  │  │ - Offscreen buffer for performance              │ │  │
│  │  │ - 60 FPS animation loop                         │ │  │
│  │  └──────────────────────────────────────────────────┘ │  │
│  │                                                        │  │
│  │  ┌──────────────────────────────────────────────────┐ │  │
│  │  │ Interaction Handlers                            │ │  │
│  │  │ - Mouse: Drag (pan), Wheel (zoom)               │ │  │
│  │  │ - Hover: Show username tooltip                  │ │  │
│  │  │ - Click: Open Instagram profile                 │ │  │
│  │  └──────────────────────────────────────────────────┘ │  │
│  │                                                        │  │
│  │  ┌──────────────────────────────────────────────────┐ │  │
│  │  │ Data Management                                 │ │  │
│  │  │ - Load data.json from origin                    │ │  │
│  │  │ - Fetch user profile images                     │ │  │
│  │  │ - Extract pixel color from images               │ │  │
│  │  └──────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
│                              ↓                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │             DATA LAYER (data.json)                   │  │
│  │  ┌──────────────────────────────────────────────────┐ │  │
│  │  │ {                                                │ │  │
│  │  │   "lastUpdated": "2026-01-09",                  │ │  │
│  │  │   "maxPixels": 1000000,                         │ │  │
│  │  │   "users": [                                    │ │  │
│  │  │     {                                           │ │  │
│  │  │       "username": "...",                        │ │  │
│  │  │       "profileImageUrl": "...",                 │ │  │
│  │  │       "profileUrl": "..."                       │ │  │
│  │  │     }                                           │ │  │
│  │  │   ]                                             │ │  │
│  │  │ }                                                │ │  │
│  │  └──────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │        EXTERNAL RESOURCES (CORS-enabled)             │  │
│  │  - Profile Images: Instagram CDN or DiceBear API    │  │
│  │  - Instagram Profiles: instagram.com                │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

```
1. USER OPENS PAGE
   ↓
2. LOAD DATA.JSON
   ├─ Parse JSON
   ├─ Extract users array
   └─ Validate structure
   ↓
3. GENERATE PIXEL POSITIONS
   ├─ Initialize seeded RNG with SEED=42
   ├─ For each user:
   │  ├─ Generate random x,y using RNG
   │  ├─ Check if already occupied
   │  └─ If free, mark position
   └─ Result: pixelList with positions
   ↓
4. LOAD PROFILE IMAGES
   ├─ For each user:
   │  ├─ Fetch image with CORS headers
   │  ├─ Draw to 1×1 canvas
   │  └─ Extract [R,G,B,A] pixel
   └─ Cache in pixelList
   ↓
5. ANIMATE DRAWING
   ├─ On each frame:
   │  ├─ Calculate pixels to draw this frame
   │  ├─ Write pixel data to offscreen canvas
   │  ├─ Update main canvas from offscreen
   │  └─ Draw UI info panel
   └─ Continue until all pixels drawn
   ↓
6. USER INTERACTION
   ├─ Mouse move → Update hover tooltip
   ├─ Mouse click → Open Instagram profile
   ├─ Drag → Pan canvas
   └─ Wheel → Zoom towards cursor
```

## Key Components

### 1. Seeded Random Number Generator
```javascript
function mulberry32(a)  // Deterministic RNG
  → Always generates same sequence for SEED=42
  → Ensures consistent pixel layout across reloads
```

### 2. Pixel Generation Algorithm
```
FOR each user in users[]:
  LOOP:
    x = random(0, 1000)
    y = random(0, 1000)
    IF (x,y) not occupied:
      occupiedSet.add(x,y)
      pixelList.push({x, y, user, imageData})
      BREAK
    ELSE:
      try_again
```

### 3. Canvas Architecture
```
Main Canvas (visible)
    ↓ (scale, translate, rotate)
Offscreen Canvas (1000×1000 pixels)
    ↓ (drawImage)
ImageData (pixel buffer)
    ↓ (per-pixel RGBA)
Profile Image Data
```

### 4. Rendering Pipeline
```
offscreenCtx.getImageData()  // Read current state
    ↓
for each new pixel:
  data[index] = R
  data[index+1] = G
  data[index+2] = B
  data[index+3] = A
    ↓
offscreenCtx.putImageData()  // Write back
    ↓
ctx.drawImage(offscreen)     // Render to screen
```

## Performance Characteristics

### Memory Usage
- Offscreen canvas: 1000×1000×4 bytes = 4MB
- pixelList array: ~10 bytes per user
- Image data cache: ~0.5-1KB per image
- **Total**: ~5-10MB for 1M users

### CPU Usage
- RNG: O(users)
- Image loading: Parallel fetch (limited by browser)
- Pixel rendering: O(ANIMATION_SPEED) per frame
- Hover detection: O(1) with pixelMap

### Network
- data.json: ~10KB per 100 users
- Profile images: CORS-enabled, parallel fetch (10-50 concurrent)
- Total bandwidth: ~100KB-1MB per load

## State Management

```javascript
// Pixel Data
pixelList[]              // Array of pixel objects
pixelMap new Map()       // Lookup: "x,y" → user
drawnPixelCount          // Progress tracking

// View State
scale                    // Zoom level (1 = 1:1)
panX, panY              // Translation offsets
isDragging              // Input state

// Data State
users[]                 // Loaded users
lastUpdated             // Last update timestamp
totalPixels             // Total to draw
```

## Determinism Guarantee

**Problem**: Need same layout every time page loads

**Solution**: Seeded RNG
- Uses Mulberry32 algorithm
- Initialized with fixed SEED=42
- Generates same sequence forever
- No server state needed

**Verification**:
1. Same data.json → Same users array
2. Same users array → Same RNG sequence
3. Same RNG sequence → Same pixel positions
4. Result: **Deterministic, reproducible layout**

## Scalability Limits

| Factor | Limit | Reason |
|--------|-------|--------|
| Users | 1,000,000 | Grid size 1000×1000 |
| Grid size | 10,000×10,000 | Browser canvas limits |
| Simultaneous images | ~50 | Browser connection pool |
| Animation FPS | 60 | Browser refresh rate |
| Draw speed | 50,000 px/s max | Performance target |

## Browser Requirements

✅ **Required APIs**:
- Canvas 2D (`getContext('2d')`)
- Fetch API
- ES6+ (Arrow functions, Promise, async/await)
- Web Events (mousemove, click, wheel)

✅ **Optional Features**:
- CORS support (image loading)
- requestAnimationFrame (smooth animation)

✅ **Browser Support**:
- Chrome/Edge 60+
- Firefox 55+
- Safari 12+
- Any modern browser with ES6

## Security Considerations

✅ **Safe**:
- No user data stored locally
- No backend calls
- Public data only (Instagram profiles)
- No authentication required

⚠️ **Constraints**:
- CORS-enabled images only
- Rate limited by browser
- Content Security Policy may apply

## Future Architecture Improvements

```
Potential enhancements:

1. Web Workers
   ├─ RNG calculation in worker thread
   ├─ Image processing in worker
   └─ Main thread only rendering

2. IndexedDB Caching
   ├─ Cache profile images locally
   ├─ Reduce bandwidth on reload
   └─ Offline support

3. Virtual Scrolling
   ├─ Only render visible pixels
   ├─ Handle 10M+ pixels
   └─ Constant memory usage

4. GPU Acceleration
   ├─ WebGL for rendering
   ├─ Shader-based effects
   └─ Higher performance
```

This architecture ensures:
- ✅ Deterministic, reproducible results
- ✅ High performance (60 FPS)
- ✅ Scalable to 1M+ pixels
- ✅ Pure static site (GitHub Pages compatible)
- ✅ No backend required
