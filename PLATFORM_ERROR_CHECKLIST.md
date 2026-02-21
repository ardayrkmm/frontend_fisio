# ✅ Quick Checklist: Platform Error Video Fix

## 📋 Status Perbaikan:

### **Code Level (✅ DONE):**

- ✅ MulaiLatihan_bloc.dart - Updated SelectVideoEvent handler
  - ✅ 3-format URL support (full URL, relative uploads/, filename only)
  - ✅ URL validation dengan Uri.parse
  - ✅ 10-second timeout on initialize()
  - ✅ Video duration logging
  - ✅ Comprehensive error classification
  - ✅ User-friendly error messages
  - ✅ Step-by-step logging

### **Configuration Level (❌ NEEDS USER ACTION):**

- ⚠️ **Config.dart - CRITICAL** - IP masih hardcoded `192.168.1.23`
  - MUST update ke IP yang benar sesuai network user
  - File: `lib/service/Config.dart`
  - Line: `static const String baseUrl = "http://...";`

---

## 🧪 Testing Procedure:

### **Stage 1: Fix Configuration**

```
1. Open: lib/service/Config.dart
2. Find: static const String baseUrl = "http://192.168.1.23:8080/api/";
3. Get your PC IP:
   - Command: ipconfig (di PowerShell)
   - Look for: IPv4 Address under Ethernet/WiFi adapter
4. Update Config.dart dengan IP yang benar
5. Save file
```

### **Stage 2: Run App & Monitor Logs**

```
1. Run: flutter run -v
2. Select video di MulaiLatihan page
3. Check console output untuk:
   - 🔗 URL yang digunakan
   - ✅ URL validation passed
   - ⏳ Initializing... message
   - ✅ atau ❌ success/error
4. Screenshots console output jika error
```

### **Stage 3: Manual URL Test (if still fails)**

```powershell
# Copy URL dari console log, contoh:
$url = "http://192.168.1.23:8080/uploads/videos/latihan1.mp4"

# Test dengan curl:
curl -I $url

# Should return: HTTP/1.1 200 OK
# If 404: file not found di server
# If Connection refused: server tidak running/IP salah
```

### **Stage 4: Check Backend**

```bash
# SSH ke backend server atau check locally
cd api_fisioterapi

# Verify uploads folder ada
ls uploads/
# Should see: images/ videos/

# Check video file ada
ls uploads/videos/
# Should see: actual video files (*.mp4, *.mov, etc)
```

---

## 🎯 Expected Behavior After Fix:

✅ **Console Output Should Show:**

```
📝 [MULAI_LATIHAN] Original videoUrl: videos/latihan1.mp4
🔗 [MULAI_LATIHAN] Constructed URL with uploads folder: http://YOUR_IP:8080/uploads/videos/latihan1.mp4
✅ [MULAI_LATIHAN] URL format valid
⏳ [MULAI_LATIHAN] Creating VideoPlayerController...
⏳ [MULAI_LATIHAN] Initializing VideoPlayerController (waiting for network)...
✅ [MULAI_LATIHAN] VideoPlayerController initialized successfully
📊 [MULAI_LATIHAN] Video duration: 0:02:35.000000
⏳ [MULAI_LATIHAN] Creating FlickManager...
✅ [MULAI_LATIHAN] FlickManager created and ready to play
```

✅ **UI Should:**

- Show loading spinner briefly
- Play video dengan controls (play/pause/seek/fullscreen)
- Auto-play when video ready

✅ **Error Cases Should Show:**

- "Video timeout - periksa koneksi internet" → Network issue
- "Video tidak ditemukan di server" → File missing (404)
- "Server tidak bisa dihubungi" → Connection refused (wrong IP, server down)
- "Error platform - cek URL dan server availability" → Other platform errors

---

## 🚨 Most Common Issues & Solutions:

| Issue              | Console Output     | Solution                                |
| ------------------ | ------------------ | --------------------------------------- |
| Wrong IP           | Connection refused | Update Config.dart IP                   |
| File not found     | 404 error          | Check `/uploads/` folder di server      |
| Server not running | Connection refused | `go run ./cmd/server` di backend folder |
| Firewall blocking  | Connection timeout | Check Windows firewall allow port 8080  |
| Old cached config  | URL mismatch       | Hot restart Flutter (not hot reload)    |

---

## 📞 Contact Points:

**Files to check if issues persist:**

1. `lib/service/Config.dart` - Base URL configuration
2. `lib/features/Pages/MulaiLatihan/bloc/MulaiLatihan_bloc.dart` - SelectVideoEvent handler
3. `lib/features/Pages/MulaiLatihan/MulaiLatihan.dart` - UI & error display
4. `/api_fisioterapi/uploads/` - Server file storage

**Logs to check:**

1. Flutter console (`flutter run -v`)
2. Go server logs
3. Network monitor (to verify requests being made)

---

**Status**: 🔴 **WAITING FOR USER** - Config.dart IP needs updating
**Next Step**: Update Config.dart, run app, share console output if error persists
