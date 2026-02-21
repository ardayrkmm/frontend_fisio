# 🔧 FIX: FLUTTER LOGIN TIDAK TERHUBUNG KE SERVER

## ✅ Masalah yang Sudah Diidentifikasi

**PENYEBAB UTAMA**: URL API di Flutter tidak sesuai dengan environment yang digunakan

- ❌ Config.dart menggunakan `localhost` → hanya bisa untuk device yang sama
- ❌ Emulator Android tidak bisa akses `localhost` pada host machine

---

## 🛠️ PERBAIKAN YANG SUDAH DILAKUKAN

### 1. ✅ Update Config.dart

- Menggunakan `10.0.2.2:8080` untuk **Emulator Android** (default)
- Menambah comment untuk alternatif IP

### 2. ✅ Tambah Logging di AuthRepository

- Print URL yang dikirm
- Log setiap step login
- Catch & display error details

---

## 🚀 LANGKAH-LANGKAH SETUP

### **CASE 1: Testing dengan Emulator Android**

#### A. Pastikan Server Go Running

```bash
cd c:\Users\LENOVO\Downloads\SKRIPSI\Aplikasi\api_fisioterapi
go run ./cmd/server
```

Lihat output console, catat IP yang ditampilkan (contoh: `192.168.x.x` atau `127.0.0.1`)

#### B. Config.dart Sudah Benar untuk Emulator

```dart
static const String baseUrl = "http://10.0.2.2:8080/api/";
```

**10.0.2.2** = IP loopback khusus emulator Android untuk akses host machine

#### C. Run Flutter App

```bash
flutter run
```

#### D. Lihat Console Output Flutter

Di Visual Studio Code, buka "Debug Console" atau "Console" di bawah
Cari output dengan `[LOGIN]` tag untuk debug:

```
🔗 [LOGIN] Mengirim request ke: http://10.0.2.2:8080/api/auth/login
📧 [LOGIN] Email: user@example.com
✅ [LOGIN] Response diterima: 200
💾 [LOGIN] Token disimpan di local storage
```

---

### **CASE 2: Testing dengan Physical Android Device**

#### A. Cari IP Komputer Anda

**Windows PowerShell:**

```powershell
ipconfig
# Cari IPv4 Address, contoh: 192.168.1.100
```

#### B. Update Config.dart

```dart
// Uncomment line ini dan ganti IP sesuai IPv4 komputer
static const String baseUrl = "http://192.168.1.100:8080/api/";
```

#### C. Pastikan Device & PC di Network yang Sama

- Device terhubung WiFi yang sama dengan PC
- Atau pakai hotspot dari PC

#### D. Run Flutter

```bash
flutter run
```

---

### **CASE 3: Testing dengan Web/Desktop**

```dart
// Gunakan localhost biasa
static const String baseUrl = "http://localhost:8080/api/";
```

---

## 🧪 TEST MANUAL DENGAN cURL

### PowerShell

```powershell
$body = @{
    email = "test@example.com"
    password = "password123"
} | ConvertTo-Json

curl -X POST `
  -H "Content-Type: application/json" `
  -d $body `
  http://localhost:8080/api/auth/login
```

### Expected Success Response

```json
{
  "message": "Login successful",
  "user": {
    "id_user": "a1b2",
    "nama": "John Doe",
    "email": "test@example.com",
    "role": "user",
    "no_telepon": "081234567890"
  },
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
```

---

## 🐛 TROUBLESHOOTING

### ❌ Error: "Connection refused" / "Could not connect"

**Penyebab**: Server Go tidak running atau port salah

**Solusi**:

- Pastikan Go server running (`go run ./cmd/server`)
- Check port di .env file (APP_PORT=8080)
- Check firewall Windows (Allow port 8080)

### ❌ Error: "timeout"

**Penyebab**: Request terlalu lama, biasanya database slow

**Solusi**:

- Check database connection di Go console
- Verify `.env` database config benar

### ❌ Error: "Invalid email or password"

**Penyebab**: User belum terdaftar atau password salah

**Solusi**:

- Test register endpoint dulu
- Verify email & password di database

### ❌ Error: "Token generation failed"

**Penyebab**: JWT_SECRET di .env terlalu pendek

**Solusi**:

- Verify `.env` file sudah updated dengan JWT_SECRET yang panjang

---

## 📱 KONFIGURASI BERDASARKAN ENVIRONMENT

| Environment          | URL                          | Kegunaan                                |
| -------------------- | ---------------------------- | --------------------------------------- |
| **Emulator Android** | `http://10.0.2.2:8080/api/`  | Testing dengan emulator di PC           |
| **Physical Device**  | `http://[PC-IP]:8080/api/`   | Testing dengan smartphone real          |
| **Web/Desktop**      | `http://localhost:8080/api/` | Testing di browser atau Windows desktop |

---

## ✅ CHECKLIST SEBELUM TEST

- [ ] Go server running (`go run ./cmd/server`)
- [ ] Database MySQL connected
- [ ] `.env` file sudah update (JWT_SECRET, DB_CONFIG)
- [ ] `Config.dart` URL sesuai environment
- [ ] User sudah terdaftar di database (atau register dulu)
- [ ] Firebase console terbuka untuk melihat logs

---

## 🔍 DEBUG FLOW

```
User Input Email & Password
            ↓
    LoginBloc Emit LoginLoading()
            ↓
    AuthRepository.login() called
            ↓
    Print URL yang digunakan ← ⭐ CEK INI
            ↓
    Dio POST request dikirim
            ↓
    Go Server menerima ← Check Go console
            ↓
    Response diterima atau Error
            ↓
    LoginBloc Emit LoginSuccess/LoginError ← Lihat Flutter console
```

---

## 💡 TIPS

1. **Jangan lupa save file** setelah edit Config.dart, lalu `hot reload` (R) atau restart
2. **Monitor 2 console sekaligus**: Satu untuk Go console, satu untuk Flutter console
3. **Gunakan Chrome DevTools** untuk Flutter web debugging
4. **Test via cURL dulu** sebelum test dari Flutter, untuk isolate masalah

---

**Last Updated**: 2024-01-19
**Status**: ✅ Ready to Test
