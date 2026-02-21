# 📊 Fitur Akurasi Gerakan - Implementation Guide

## ✅ Fitur yang Ditambahkan

Pengguna sekarang dapat melihat **akurasi real-time** gerakan mereka saat melakukan latihan. Fitur ini menunjukkan seberapa baik gerakan pengguna sesuai dengan model AI.

---

## 🎯 Komponen Akurasi

### 1. **Current Accuracy (Akurasi Saat Ini)**

- Persentase akurasi gerakan real-time (0-100%)
- Progress bar visual yang berubah warna:
  - 🟢 **Hijau (≥80%)**: Sempurna/Bagus
  - 🟠 **Orange (60-79%)**: Cukup
  - 🔴 **Merah (<60%)**: Perlu Perbaikan

### 2. **Average Accuracy (Rata-rata Akurasi)**

- Akurasi rata-rata selama seluruh latihan
- Diupdate setiap kali pose terdeteksi

### 3. **Correct Pose Count**

- Jumlah deteksi pose yang benar
- Format: `X/Y` (jumlah benar / total deteksi)

### 4. **Status Badge**

- Feedback visual langsung: "Sempurna ✓", "Bagus ✓", "Cukup", "Perlu Perbaikan"

---

## 📝 Perubahan File

### 1. **State Management** (`Latihan_state.dart`)

```dart
// Field baru di ExerciseState:
final double currentAccuracy;        // Akurasi saat ini (0.0-1.0)
final double averageAccuracy;        // Rata-rata akurasi
final List<double> accuracyHistory;  // History akurasi
final int correctPoseCount;          // Jumlah pose benar
final int totalPoseCount;            // Total deteksi pose
```

### 2. **Events** (`Latihan_event.dart`)

```dart
// Event baru:
class UpdateAccuracy extends ExerciseEvent {
  final double accuracy;          // Current accuracy (0.0-1.0)
  final bool isCorrectPose;       // Apakah pose benar?
}
```

### 3. **BLoC Logic** (`Latihan_bloc.dart`)

```dart
// Handler baru:
void _onUpdateAccuracy(UpdateAccuracy event, Emitter<ExerciseState> emit)
  // Update state dengan accuracy baru
  // Hitung rata-rata dari history
  // Update correct pose count
```

### 4. **UI Components** (`LatihanPages.dart`)

```dart
// Widget baru:
class _AccuracyCard          // Kartu akurasi visual
class _TriggerAccuracyUpdate // Helper untuk trigger event

// Diletakkan di:
- _BottomInfo widget (tampilan info bawah)
- Setelah timer, sebelum repetisi/set counter
```

---

## 🔄 Data Flow

```
Pose Detection (PoseResult)
    ↓
_TriggerAccuracyUpdate widget mendeteksi perubahan
    ↓
Emit UpdateAccuracy event
    ↓
ExerciseBloc._onUpdateAccuracy() handler
    ↓
Hitung average dari accuracy history
    ↓
Update state dengan nilai akurasi baru
    ↓
_AccuracyCard widget rebuild dengan data baru
    ↓
UI menampilkan akurasi real-time
```

---

## 🎨 Visual Design

### \_AccuracyCard Layout:

```
┌─────────────────────────────────────┐
│ 📊 Akurasi Gerakan  [Status Badge]  │
├─────────────────────────────────────┤
│ Akurasi Saat Ini                    │
│ XX.X%  / 100%                       │
│ [████████░░░░░░░░░] Progress Bar    │
├─────────────────────────────────────┤
│  Rata-rata  │  Gerakan Benar        │
│  XX.X%      │  X/Y                  │
└─────────────────────────────────────┘
```

### Warna Status:

- **🟢 Sempurna ✓** (85%+): Green
- **🟢 Bagus ✓** (70-84%): Green
- **🟠 Cukup** (50-69%): Orange
- **🔴 Perlu Perbaikan** (<50%): Red

---

## 💡 Integrasi dengan Pose Detection

Akurasi diambil dari `PoseResult.confidence` yang berasal dari:

1. **MediaPipe Pose Detection** - Mendeteksi keypoints
2. **TFLite Model Classifier** - Mengklasifikasi pose
3. **Confidence Score** - Tingkat kepercayaan deteksi (0.0-1.0)

Akurasi otomatis di-update setiap kali:

- Pose terdeteksi dengan confidence value
- `PoseResult.isCorrect` menandakan apakah pose sesuai target

---

## 🚀 Cara Menggunakan

### Di Halaman Latihan:

1. User memulai latihan
2. Pose detection secara otomatis aktif
3. `_AccuracyCard` akan muncul di bawah timer
4. Akurasi real-time ditampilkan dan di-update otomatis
5. User dapat melihat:
   - Current accuracy saat ini
   - Average accuracy selama latihan
   - Jumlah gerakan yang benar

### Completion Summary:

Saat latihan selesai, summary menampilkan:

```
Total waktu: XX.Xs
Rata-rata Akurasi: XX.X%
```

---

## 📊 Data Persistence

Accuracy data tersimpan dalam:

- **State**: `accuracyHistory` (List<double>)
- **Calculation**: Average = sum(history) / history.length

Untuk menyimpan ke database, bisa ditambahkan di:

```dart
// Di CompleteExercise handler
// Save averageAccuracy ke database
```

---

## 🔧 Customization

### Mengubah Threshold Warna:

Di `_AccuracyCard._getAccuracyColor()`:

```dart
if (accuracy >= 0.8) return Colors.green;  // Ubah threshold di sini
```

### Mengubah Status Text:

Di `_AccuracyCard._getAccuracyStatus()`:

```dart
if (accuracy >= 0.85) return 'Sempurna ✓';  // Ubah text
```

### Update Frequency:

`_TriggerAccuracyUpdate` trigger ketika `poseResult` berubah
Bisa dioptimalkan dengan debounce jika terlalu sering update

---

## ⚠️ Notes

1. **Accuracy Source**: Bergantung pada `PoseResult.confidence` dari pose detection service
2. **Real-time**: Update terjadi setiap frame pose terdeteksi (±500ms)
3. **Averaging**: Semua accuracy readings di-average, tidak ada weighting khusus
4. **Correct Count**: Menghitung jumlah deteksi dengan `isCorrect = true`

---

## 🐛 Troubleshooting

### Akurasi tidak terupdate:

- Pastikan `isPoseDetectionEnabled = true`
- Cek apakah pose detection service sudah initialized
- Verify bahwa `PoseResult` berisi confidence value

### Warna tidak berubah:

- Check `_getAccuracyColor()` thresholds
- Verify accuracy value dalam range 0.0-1.0

### Average tidak akurat:

- `accuracyHistory` menyimpan semua reading
- Jika ingin weighted average, modifikasi `_onUpdateAccuracy()`

---

## ✨ Fitur Baru yang Bisa Ditambahkan di Masa Depan

1. **Accuracy Graph**: Visualisasi akurasi over time
2. **Rep-by-rep Accuracy**: Akurasi per repetisi
3. **Target Accuracy**: Alert jika akurasi < threshold
4. **AI Feedback**: Saran perbaikan berdasarkan accuracy
5. **Accuracy History**: Tracking progress antar sesi
