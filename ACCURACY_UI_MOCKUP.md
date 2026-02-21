# 📸 ACCURACY FEATURE - UI MOCKUP & VISUAL GUIDE

## 🎬 Screen Layout

### Exercise Screen dengan Accuracy Card

```
┌─────────────────────────────────────────────────────┐
│                    STATUS BAR                       │
├─────────────────────────────────────────────────────┤
│                                                     │
│              CAMERA PREVIEW                        │
│         (Menampilkan pose skeleton)                │
│                                                     │
│     👤  👤  👤  (3 contoh poses)                    │
│     /|\  /|\  /|\                                  │
│    / \  / \  / \                                   │
│                                                     │
│         [🔍] [🎯] [▶️]  (Top Controls)           │
│                                                     │
│                                                     │
├─────────────────────────────────────────────────────┤
│  ⏱️  48.5s                       (TIMER)           │
│                                                     │
│  ┌─────────────────────────────────────────────┐  │
│  │ 📊 Akurasi Gerakan    [Bagus ✓]             │  │
│  ├─────────────────────────────────────────────┤  │
│  │ Akurasi Saat Ini                            │  │
│  │                                             │  │
│  │  85.3%        / 100%                        │  │
│  │ ████████████░░░░░░░░ (Progress Bar)        │  │
│  ├─────────────────────────────────────────────┤  │
│  │   Rata-rata  │  Gerakan Benar              │  │
│  │    82.5%     │      12/15                  │  │
│  └─────────────────────────────────────────────┘  │
│                                                     │
│  ✅ Pose Benar!  [87.2%]                          │
│  Terdeteksi: Standing Wall                         │
│  Target:     Standing Wall                         │
│                                                     │
│  ┌────────────────────────┬────────────────────┐  │
│  │  Repetisi  │   Set    │     Berjalan        │  │
│  │    8/10    │   2/4    │  [Play Icon]        │  │
│  └────────────────────────┴────────────────────┘  │
│                                                     │
│  [+ Repetisi]          [Berhenti]                  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 🎨 Component Breakdown

### A. ACCURACY CARD (Baru)

#### Layout:

```
┌─────────────────────────────────────┐
│ 📊 Akurasi Gerakan  [Status Badge]  │
├─────────────────────────────────────┤
│ Akurasi Saat Ini                    │
│ XX.X%  / 100%                       │
│ [Progress Bar dengan warna dinamis] │
├─────────────────────────────────────┤
│  Rata-rata  │  Gerakan Benar        │
│   XX.X%     │  X/Y                  │
└─────────────────────────────────────┘
```

#### Colors & States:

**State 1: Sempurna (85%+)**

```
┌──────────────────────────────────────┐
│ 📊 Akurasi Gerakan  [Sempurna ✓]    │
├──────────────────────────────────────┤
│ Akurasi Saat Ini                     │
│ 92.5%       / 100%                   │
│ █████████████░░░░░░░ (GREEN)        │
├──────────────────────────────────────┤
│  Rata-rata  │  Gerakan Benar         │
│   89.3%     │  14/15                 │
└──────────────────────────────────────┘
```

**State 2: Bagus (70-84%)**

```
┌──────────────────────────────────────┐
│ 📊 Akurasi Gerakan  [Bagus ✓]       │
├──────────────────────────────────────┤
│ Akurasi Saat Ini                     │
│ 78.5%       / 100%                   │
│ ███████████░░░░░░░░░ (GREEN)        │
├──────────────────────────────────────┤
│  Rata-rata  │  Gerakan Benar         │
│   75.2%     │  11/15                 │
└──────────────────────────────────────┘
```

**State 3: Cukup (50-69%)**

```
┌──────────────────────────────────────┐
│ 📊 Akurasi Gerakan  [Cukup]         │
├──────────────────────────────────────┤
│ Akurasi Saat Ini                     │
│ 62.3%       / 100%                   │
│ ██████░░░░░░░░░░░░░ (ORANGE)        │
├──────────────────────────────────────┤
│  Rata-rata  │  Gerakan Benar         │
│   65.1%     │  9/15                  │
└──────────────────────────────────────┘
```

**State 4: Perlu Perbaikan (<50%)**

```
┌──────────────────────────────────────┐
│ 📊 Akurasi Gerakan  [Perlu Perbaiki]│
├──────────────────────────────────────┤
│ Akurasi Saat Ini                     │
│ 38.5%       / 100%                   │
│ ████░░░░░░░░░░░░░░░░ (RED)         │
├──────────────────────────────────────┤
│  Rata-rata  │  Gerakan Benar         │
│   42.7%     │  5/15                  │
└──────────────────────────────────────┘
```

---

## 📊 Accuracy Metrics Explanation

### Current Accuracy (Akurasi Saat Ini)

- **Definisi**: Confidence score dari pose terakhir yang terdeteksi
- **Range**: 0% - 100%
- **Update**: Real-time, setiap kali pose terdeteksi
- **Source**: `PoseResult.confidence` dari ML model
- **Meaning**:
  - 85% = Model 85% confident this is correct pose
  - Semakin tinggi = semakin baik match dengan target

### Average Accuracy (Rata-rata Akurasi)

- **Definisi**: Rata-rata dari semua pembacaan akurasi
- **Formula**: Sum(all readings) / Count(readings)
- **Update**: Real-time setiap pose baru terdeteksi
- **Contoh**:
  - Readings: [85%, 87%, 82%, 84%]
  - Average: (85+87+82+84)/4 = 84.5%

### Correct Pose Count (Gerakan Benar)

- **Definisi**: Jumlah pose yang match dengan target
- **Format**: X/Y (X correct, Y total)
- **Update**: Increment ketika `isCorrect = true`
- **Contoh**:
  - 12/15 = 12 gerakan benar dari 15 total deteksi
  - Success rate ≈ 80%

---

## 🎯 Visual State Transitions

### During Exercise Session:

**Detik ke-0**: Mulai latihan

```
Current:  ----    Average:  ----    Count: 0/0
(Menunggu pose pertama terdeteksi)
```

**Detik ke-5**: Pose pertama terdeteksi

```
Current:  85%    Average:  85%     Count: 1/1
```

**Detik ke-10**: Pose kedua terdeteksi (salah)

```
Current:  45%    Average:  65%     Count: 1/2
(Color berubah jadi orange karena current accuracy rendah)
```

**Detik ke-15**: Pose ketiga terdeteksi (benar)

```
Current:  89%    Average:  73%     Count: 2/3
(Color kembali hijau karena current accuracy tinggi)
```

**Detik ke-30**: Banyak pose terdeteksi

```
Current:  84%    Average:  78%     Count: 8/11
(Average stabil di sekitar 78% dari semua pembacaan)
```

---

## 🎨 Color State Chart

```
Accuracy Range    Color      Status Text           Icon
────────────────────────────────────────────────────────
85-100%          🟢GREEN     Sempurna ✓           ✓
70-84%           🟢GREEN     Bagus ✓              ✓
60-69%           🟠ORANGE    Cukup                ⊘
50-59%           🟠ORANGE    Perlu Perbaikan      !
40-49%           🔴RED       Perlu Perbaikan      !
0-39%            🔴RED       Perlu Perbaikan      ✗
```

---

## 📱 Mobile Layout Optimization

### Full Width Display:

```
┌─────────────────────────────────────┐
│         Mobile Screen (360px)       │
├─────────────────────────────────────┤
│  📊 Akurasi  [Status]  (Compact)    │
│  ────────────────────────────────   │
│  85.3% / 100%  Progress: ████░░░░  │
│  ────────────────────────────────   │
│  Rata: 82.5%  |  Benar: 12/15     │
└─────────────────────────────────────┘
```

### Tablet Display:

```
┌──────────────────────────────────────────────┐
│           Tablet Screen (600px+)             │
├──────────────────────────────────────────────┤
│  📊 Akurasi Gerakan          [Bagus ✓]      │
│  ──────────────────────────────────────────  │
│  Akurasi Saat Ini:                          │
│  85.3%  /  100%                             │
│  ████████████░░░░░░░░ Progress Bar          │
│  ──────────────────────────────────────────  │
│   Rata-rata Akurasi  │  Gerakan Benar      │
│        82.5%        │      12/15           │
└──────────────────────────────────────────────┘
```

---

## 🔄 Animation Transitions

### Progress Bar Animation:

```
Previous: ████░░░░░░░░  (50%)
    ↓    (Animate over 300ms)
Current:  █████░░░░░░░  (51%)
    ↓
    ↓
Final:    ██████░░░░░░  (60%)
```

### Color Transition:

```
Orange bar → 200ms easing → Green bar
(Smooth color transition saat threshold berubah)
```

---

## 📊 Data Visualization Examples

### Example Session Accuracy Pattern:

```
Time:     0s    5s    10s   15s   20s   25s   30s
Accuracy: --    85%   45%   89%   82%   87%   84%

Graph:
100%  ┤
 80%  ├  •         •    •    •    •    •
 60%  ├        •
 40%  ├
      └──────────────────────────────────────

Average = (85+45+89+82+87+84)/6 = 78.7%
Correct = 5/6 = 83% correct
```

---

## 🎬 Completion Screen

### Exercise Completed:

```
┌─────────────────────────────────────┐
│                                     │
│            ✅ ICON BIG              │
│                                     │
│      Latihan Selesai!               │
│      Total waktu: 125.3s            │
│      Rata-rata Akurasi: 78.5%       │
│                                     │
│      [Kembali] button               │
│                                     │
└─────────────────────────────────────┘
```

### Exercise Cancelled:

```
┌─────────────────────────────────────┐
│                                     │
│            ❌ ICON BIG              │
│                                     │
│      Latihan Dibatalkan             │
│      Akurasi terakhir: 65.3%        │
│                                     │
│      [Kembali] button               │
│                                     │
└─────────────────────────────────────┘
```

---

## 🎯 User Experience Flow

### Optimal Path:

```
Start Exercise
    ↓
Pose Detected (85%)
    ↓ Display: 85% current, 85% average
Good Form Maintained (87%)
    ↓ Display: 87% current, 86% average
Minor deviation (62%)
    ↓ Display: 62% current (orange), 78% average
Correction (84%)
    ↓ Display: 84% current, 79% average
    ↓
    ↓ (repeat...)
Complete Exercise
    ↓ Show: Final Average 78.5%
```

---

## 📐 Component Specifications

### \_AccuracyCard Dimensions:

```
Width: Full parent width - padding
Height: Auto (content-based)
Padding: 16px all sides
Border: 2px, colored by state
Border-radius: 16px
Gradient background: color.withOpacity(0.1)

Inner elements padding: 12px
Icon size: 20px
Progress bar height: 8px
Font sizes: 24px (big), 14px (medium), 12px (small)
```

### Progress Bar:

```
Height: 8px
Border-radius: 8px
Background: Colors.grey[300]
Filled: State color
Animation: Smooth 300ms easing
Clipped to minHeight
```

---

## ✨ Visual Polish Details

### Status Badge:

- Background: State color
- Text color: White
- Padding: 8px horizontal, 4px vertical
- Border-radius: 12px
- Font weight: Bold
- Font size: 12px

### Info Chips (Rata-rata & Gerakan):

- Background: Colors.grey[100]
- Padding: 12px all
- Border-radius: 12px
- Divider: 1px grey[300]
- Height: 40px (divider)

### Icon Sizing:

- Main: 20px (header)
- Status: 24px
- Detail: Small, integrated

---

## 🎨 Typography

```
Component           Font Size   Weight      Color
──────────────────────────────────────────────────
Header             14px        w600        State color
Current Big        24px        bold        State color
Current Label      12px        regular     grey[600]
Progress Label     11px        regular     grey[600]
Stats Number       18px        bold        Color specific
Stats Label        11px        regular     grey[600]
Average/Correct    18px        bold        Specific
```

---

## 📊 Responsive Behavior

### Small Phone (320px):

- Compact layout
- Single column stats
- Smaller fonts
- Minimal padding

### Normal Phone (360-400px):

- Optimal layout (designed for)
- Two column stats
- Clear spacing
- Good readability

### Large Phone (500px+):

- Same as normal, slight padding increase
- All text fully readable

### Tablet (600px+):

- Wider padding
- Larger fonts possible
- Spacious layout
- Enhanced visual hierarchy

---

## 🔍 Accessibility Features

- ✅ Color-blind safe (not only color for status)
- ✅ Text contrast meets WCAG standards
- ✅ Icon + text labels for clarity
- ✅ Status badge provides alternative to color
- ✅ Large touch targets (48px+)
- ✅ Semantic HTML structure

---

## 📝 Summary

Accuracy feature provides:

- ✅ Real-time visual feedback
- ✅ Clear status indication
- ✅ Historical tracking
- ✅ Responsive design
- ✅ Mobile optimized
- ✅ Accessible interface
