# Panduan Pemula iOS: State Management & Manajemen Memori

Dokumen ini dibuat untuk membantu Anda memahami konsep penting dalam pengembangan iOS modern menggunakan SwiftUI, secara khusus berkaca pada perbaikan yang baru saja kita lakukan di aplikasi **MyVaultApp**.

---

## 1. State Management: `@StateObject` vs `@EnvironmentObject`

Dalam SwiftUI, aplikasi seringkali diibaratkan seperti sebuah "Pohon" (View Tree). Data mengalir dari batang (Aplikasi Utama) ke ranting dan daun (Halaman/View).

### Apa itu `@StateObject`?
Bayangkan `@StateObject` sebagai **Sang Pencipta**.
Ketika Anda menggunakan `@StateObject`, Anda sedang memberitahu SwiftUI: *"Hei, buatkan objek data ini BARU untukku, dan tolong jaga agar objek ini tidak hilang selama halaman (View) ini masih hidup."*
- **Aturan Emas:** Gunakan `@StateObject` HANYA untuk **membuat** instansiasi objek pertama kali.

### Apa itu `@EnvironmentObject`?
Bayangkan `@EnvironmentObject` sebagai **Kartu Akses VIP**.
Objek ini tidak membuat data baru. Alih-alih, ia memberitahu SwiftUI: *"Hei, aku butuh data ini. Tolong carikan di lingkungan sekitarku (yang sudah diciptakan oleh halaman indukku)."*
- **Aturan Emas:** Gunakan `@EnvironmentObject` jika Anda ingin **berbagi data yang sama** (satu sumber kebenaran) melintasi banyak halaman tanpa harus mem-passing data satu per satu.

### 🐛 Studi Kasus di MyVaultApp:
Sebelumnya di file `MyVaultApp.swift`, Anda sudah membuat `JournalViewModel` sebagai **Sang Pencipta** (`@StateObject`) dan membagikannya ke seluruh aplikasi menggunakan `.environmentObject()`.

Namun, di dalam `DashboardView.swift`, Anda menggunakan `@StateObject private var journalVM = JournalViewModel()` lagi.
**Apa akibatnya?**
Alih-alih menggunakan data global yang sudah ada, `DashboardView` malah *menciptakan data jurnalnya sendiri yang benar-benar baru dan terpisah*. Akibatnya, jika Anda mengisi jurnal di halaman A, halaman B tidak akan tahu karena mereka membaca dari "buku jurnal" yang berbeda! 

**Solusinya:** Kita mengganti `@StateObject` di `DashboardView` menjadi `@EnvironmentObject` agar ia menggunakan "buku jurnal" yang sama dengan halaman lainnya.

---

## 2. Memory Leak (Kebocoran Memori) & `deinit`

Aplikasi iOS menggunakan sistem bernama **ARC (Automatic Reference Counting)** untuk mengatur memori. Sederhananya, ARC menghitung berapa banyak yang "memegang" atau "membutuhkan" suatu data. Jika hitungannya 0, data itu dibuang dari memori (RAM).

### Apa itu Memory Leak?
Memory leak terjadi ketika ada data yang sudah **tidak dipakai lagi, tapi tertinggal di RAM** karena sistem (ARC) mengira data itu masih dibutuhkan. Jika dibiarkan, RAM akan penuh dan aplikasi Anda bisa **Crash** (keluar sendiri).

Salah satu penyebab paling umum kebocoran memori adalah **Timer** atau **Combine Subscriptions** (`AnyCancellable`).
Ketika Anda membuat `Timer`, Timer tersebut akan terus berjalan dan "memegang erat" halaman Anda agar tidak hancur.

### Apa itu `deinit`?
`deinit` (Deinitialization) adalah kebalikan dari `init`. `init` adalah kode yang dijalankan saat objek **lahir**, sedangkan `deinit` adalah pesan wasiat terakhir yang dijalankan tepat sebelum objek **mati/dihancurkan**.

### 🐛 Studi Kasus di MyVaultApp:
Di `DashboardViewModel`, Anda menjalankan `Timer` yang terus berdetak setiap detik. 
Namun, jika pengguna pindah ke halaman lain atau halaman Dashboard dihancurkan, Timer tersebut **tidak pernah disuruh berhenti**. Timer itu akan terus berjalan seperti zombie di latar belakang, memakan baterai dan memori.

**Solusinya:** Kita menambahkan blok `deinit`.
```swift
deinit {
    // Pesan terakhir: "Tolong matikan timernya sebelum aku mati"
    timerCancellable?.cancel()
}
```
Dengan ini, saat ViewModel dihapus dari memori, Timer otomatis dibatalkan, menyelamatkan aplikasi dari Memory Leak.

---

## 3. Bahayanya Inisialisasi `@StateObject` di dalam `init`

Dalam pengembangan SwiftUI awal, banyak developer (termasuk yang berpengalaman) sering terjebak melakukan hal ini:

```swift
// CONTOH KODE YANG SALAH (Anti-Pattern)
struct TimeoutView: View {
    @StateObject var viewModel: TimeoutViewModel

    init(item: VaultItem) {
        // Bahaya! Membuat StateObject di dalam init View
        self._viewModel = StateObject(wrappedValue: TimeoutViewModel(item: item))
    }
}
```

### Kenapa Ini Berbahaya?
SwiftUI mendesain View agar sangat ringan. `init` pada View bisa dipanggil **berkali-kali dalam satu detik** oleh sistem untuk mengecek perubahan UI. 
Jika Anda meletakkan pembuatan `StateObject` di dalam `init` View, SwiftUI bisa jadi bingung. Terkadang, ia akan mengabaikan objek baru yang Anda buat dan tetap menampilkan data lama, yang mengakibatkan aplikasi terlihat "nge-bug" (Data tidak berubah saat Anda berpindah barang).

### 🐛 Studi Kasus di MyVaultApp:
Anda sebelumnya melempar `VaultItem` langsung ke dalam `init` milik `TimeoutViewModel` menggunakan `StateObject(wrappedValue:)`.

**Solusinya (Praktik Terbaik SwiftUI):**
1. Buat `StateObject` secara standar tanpa memasukkan data dinamis.
2. Gunakan *modifier* `.onAppear` di SwiftUI untuk memasukkan datanya setelah halaman dipastikan tampil.

```swift
// CONTOH PRAKTIK TERBAIK
struct TimeoutView: View {
    @StateObject private var viewModel = TimeoutViewModel() // 1. Buat standar
    let item: VaultItem // Simpan datanya di View
    
    var body: some View {
        VStack { ... }
        .onAppear {
            // 2. Berikan datanya ke ViewModel saat View muncul di layar
            viewModel.setup(with: item) 
        }
    }
}
```
Pendekatan ini jauh lebih aman, bebas dari crash tak terduga, dan sangat disukai oleh arsitektur SwiftUI.

---
*Tetap semangat belajar iOS! Kesalahan-kesalahan arsitektur ini sangat wajar dijumpai di awal pembelajaran. Memahaminya sekarang akan membuat Anda menjadi Senior Engineer yang handal di masa depan.* 🚀# Panduan Pemula iOS: Optimalisasi SwiftData & Enum

Dokumen ini menjelaskan mengapa kita mengubah tipe data `currency` dari `String` menjadi `Enum` pada `VaultItem` dan bagaimana SwiftData menangani tipe data tersebut.

---

## 1. Mengapa Memilih Enum daripada String?

Sebelumnya, model Anda menyimpan mata uang sebagai teks biasa:
```swift
var currency: String = "IDR"
```
Meskipun ini berfungsi, menggunakan tipe `String` sangat rentan terhadap **kesalahan ketik (typo)**. Pengembang bisa saja secara tidak sengaja menulis `"idr"`, `" IDR "`, atau `"Idr"`. Ketidakkonsistenan ini bisa membuat logika format angka atau pemrosesan mata uang menjadi berantakan.

Dengan **Enum** (Enumeration), kita mendaftarkan secara kaku pilihan apa saja yang diizinkan.
```swift
enum Currency: String, CaseIterable, Identifiable, Codable {
    case rm = "RM"
    case idr = "IDR"
    case usd = "USD"
    // ...
}

var currency: Currency = .idr
```
**Keuntungan Pendekatan Ini:**
1. **Type-Safety (Aman dari Typo):** Compiler Swift tidak akan mengizinkan Anda memasukkan nilai selain `.rm`, `.idr`, atau `.usd`.
2. **Auto-Complete:** Xcode akan memberikan saran otomatis (autocomplete) untuk `.idr`, yang mempercepat proses coding.
3. **Mudah Di-Refactor:** Jika Anda ingin mengganti `"IDR"` menjadi `"Rupiah"`, Anda hanya perlu mengubahnya di satu tempat (pada Enum), dan seluruh kode akan mengikuti tanpa perlu mencari/mengganti (Find & Replace) teks di banyak file.

---

## 2. Bagaimana SwiftData Menyimpan Enum?

SwiftData dirancang untuk menyimpan tipe data *primitif* seperti `String`, `Int`, `Double`, dan `Date`. Namun, SwiftData juga cukup pintar untuk menyimpan tipe data kustom seperti Enum, dengan satu syarat mutlak:

**Enum tersebut harus mengadopsi protokol `Codable`.**

Ketika Anda menambahkan `, Codable` pada definisi `enum Currency`, di belakang layar, SwiftData akan menerjemahkan `.idr` menjadi String (karena *raw type* dari enum tersebut adalah String), menyimpannya di dalam database (SQLite), dan menerjemahkannya kembali menjadi tipe `Currency` saat diambil.

### 🐛 Studi Kasus di MyVaultApp:
Pada aplikasi Anda, properti `currency` ada di `VaultItem` yang merupakan model `@Model`.
- **Sebelum Fase 2:** Kita mengoper `selectedCurrency.rawValue` (String) setiap kali membuat item.
- **Sesudah Fase 2:** Kita langsung mengoper `selectedCurrency` (Enum). 

Bila UI (seperti `Text()`) membutuhkan bentuk tulisan/String dari nilai tersebut, kita tinggal memanggil `item.currency.rawValue`.

---

## 3. Penyesuaian Realisme "Cooling Down"

Di `ReviewJournalView.swift`, pada saat pengguna pertama kali menyimpan entri jurnal (menekan tombol konfirmasi/centang), aplikasi kita menyisipkan item tersebut ke dalam basis data SwiftData:

```swift
finalItemToSave.targetDate = Date().addingTimeInterval(86400) // 24 jam
modelContext.insert(finalItemToSave)
```
Sebelumnya rentang waktu diatur menjadi 60 detik (`TimeInterval(60)`) untuk mempermudah saat Anda melakukan pengujian (testing) dan *debugging* antarmuka. 

Dalam skenario dunia nyata untuk aplikasi **kontrol impulsivitas**, keputusan pembelian tidak mungkin hilang hambatannya hanya dalam 1 menit. Kita menaikkan nilai ini ke **86400 detik (24 jam)** untuk menyesuaikan dengan logika *cooling down* standar di *production*. 

---
*Menggunakan enum untuk mendefinisikan opsi state yang terbatas adalah praktik terbaik (best practice) yang dapat menghemat berjam-jam waktu debugging. Terus terapkan Type-Safety!* 🚀# Panduan Pemula iOS: Mengatasi Over-Rendering dengan TimelineView

Dokumen ini menjelaskan mengapa kita mengubah pendekatan penghitungan waktu dari timer berbasis `ViewModel` menjadi `TimelineView` bawaan SwiftUI di MyVaultApp.

---

## 1. Masalah: Over-Rendering (Re-render Berlebihan)

Awalnya, di `DashboardViewModel`, kita memiliki variabel yang terus berubah setiap detiknya:
```swift
@Published var currentTime: Date = Date()
```
Dan di `DashboardView`, kita memantau (observe) perubahan tersebut.

**Bagaimana SwiftUI Bekerja:**
Setiap kali nilai `@Published` di dalam sebuah `ObservableObject` / `EnvironmentObject` berubah, SwiftUI akan melihat *View* mana saja yang membacanya, dan **menggambar ulang (re-render) seluruh *View* tersebut** dari awal untuk memastikan data yang ditampilkan selalu terbaru.

**Mengapa Ini Buruk di Kasus Kita?**
Karena `currentTime` berubah **setiap 1 detik**, maka `DashboardView` (yang mencakup gambar latar belakang, navigasi, dan banyak kartu barang) akan digambar ulang setiap detiknya. Ini sangat membebani *processor* (CPU) iPhone dan bisa membuat baterai cepat habis.

---

## 2. Solusi Awal yang Kurang Tepat: Timer di `.onReceive`

Beberapa orang mencoba mengakali ini dengan membuat timer langsung di dalam View:
```swift
.onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
    // Lakukan update UI di sini
}
```
*Catatan: Menggunakan `.autoconnect()` memerlukan `import Combine` di bagian atas file Anda.*

Namun, jika timer ini mengubah properti `@State` di *View* induk, hal itu akan tetap memicu re-render besar-besaran.

---

## 3. Solusi Elegan: `TimelineView`

Apple memperkenalkan `TimelineView` untuk menangani kasus spesifik seperti "tampilan yang berubah berdasarkan waktu" (seperti jam tangan atau *countdown*).

```swift
TimelineView(.periodic(from: .now, by: 1.0)) { context in
    // UI yang akan berubah setiap 1 detik
    let remaining = targetDate.timeIntervalSince(context.date)
    Text("\(remaining) detik tersisa")
}
```

**Kenapa `TimelineView` Sangat Bagus?**
Alih-alih menyuruh *seluruh halaman* (Dashboard) untuk menggambar ulang dirinya, `TimelineView` mengisolasi perubahan tersebut. Ia hanya akan menggambar ulang **apa yang ada di dalam kurung kurawalnya sendiri**.

### 🐛 Studi Kasus di MyVaultApp:
1. Kita membuat komponen mandiri `LiveTimerView` yang isinya hanyalah `TimelineView` dan teks penghitung waktu.
2. Kita menghapus timer `@Published var currentTime` dari `DashboardViewModel`.
3. Kita tetap menggunakan `Timer.publish` di `DashboardView`, TETAPI timer tersebut berjalan secara "diam-diam" (silent timer). Ia hanya mengecek *(checkAlertStatus)* apakah ada barang yang waktunya baru saja menyentuh 0. Jika ada yang menyentuh 0, barulah ia memperbarui properti khusus (`zeroCount`), yang akhirnya memerintahkan Dashboard untuk melakukan sorting animasi "jatuh".

Dengan arsitektur ini, UI Anda menjadi efisien:
- **Teks jam** diperbarui setiap detik secara lokal, murah, dan ringan.
- **Kartu dan Layout utama** hanya diperbarui jika Anda menambah barang baru atau jika ada timer yang habis!

---
*Mengelola re-render adalah salah satu kunci utama membedakan aplikasi pemula dengan aplikasi berskala industri (production) yang terasa ringan dan hemat baterai.* 🚀# Panduan Pemula iOS: Navigasi & Siklus Hidup Modal Sheet

Dokumen ini membahas prinsip penting terkait manajemen tumpukan navigasi (Navigation Stack) saat bekerja dengan tampilan modal (`.sheet`) di SwiftUI.

---

## 1. Konsep Dasar Navigasi SwiftUI

Di iOS 16+, SwiftUI memperkenalkan `NavigationStack` dan `NavigationPath`. 
Bayangkan `NavigationStack` sebagai sebuah rak piring, dan `NavigationPath` adalah daftar urutan piring yang ditumpuk.
- Ketika Anda menekan menu, Anda **menambah (append)** piring baru.
- Ketika Anda menekan 'Back', Anda **membuang (removeLast)** piring paling atas.

Di aplikasi MyVaultApp, alur utamanya diatur oleh satu `NavigationPath` besar yang dimiliki oleh `DashboardView`. Path ini dilempar (passed as Binding `$navPath`) ke semua halaman anak agar halaman anak bisa mengontrol navigasi (misalnya: "Kembali langsung ke layar utama").

---

## 2. Masalah dengan Modal Sheet

Modal sheet (`.sheet` atau `.fullScreenCover`) adalah halaman yang melayang **di atas** layar saat ini.
Ketika Anda membuat modal sheet, Anda biasanya membuat dunia baru untuknya dengan memberikannya `NavigationStack` miliknya sendiri (agar sheet tersebut punya judul dan tombolnya sendiri di atas).

### 🐛 Masalah yang Ditemukan di Kode Lama:
Di `TimeoutView.swift`, ketika pengguna menekan tombol "Read Initial Thoughts", Anda memunculkan `.sheet` berisi `ReviewJournalView`.

```swift
// KODE LAMA YANG BERBAHAYA
.sheet(isPresented: $showJournalSheet) {
    NavigationStack { // <-- Membuat dunia navigasi baru untuk sheet
        ReviewJournalView(
            navPath: $navPath, // <-- BAHAYA! Meneruskan remot kontrol dari dunia lama!
            isPresentedAsSheet: true, 
            canEdit: !viewModel.isTimerFinished
        )
    }
}
```

**Mengapa ini disebut *Anti-Pattern*?**
Anda menggabungkan dua "dunia" navigasi. `ReviewJournalView` berada di dalam *Stack Baru*, tapi ia memegang *remot kontrol* (`$navPath`) milik *Stack Lama*.
Jika pengguna mencoba mengontrol `$navPath` (seperti me-reset rute) dari dalam *sheet*, SwiftUI akan kebingungan: *"Tunggu, rute siapa yang harus saya ubah? Rute yang sedang melayang ini, atau rute utama di baliknya?"*. 

Hal ini dapat menyebabkan **Crash** diam-diam, peringatan di konsol (purple warnings), atau layar yang nyangkut (blank) ketika sheet ditutup secara paksa dengan cara digeser (swipe down).

---

## 3. Solusi: Isolasi Dunia Navigasi

Karena `ReviewJournalView` sudah memiliki properti `isPresentedAsSheet: true` yang berfungsi untuk menutup layar menggunakan perintah `@Environment(\.dismiss)` (yang merupakan cara paling tepat menutup sheet), maka kita **tidak perlu** mengizinkannya memegang kontrol navigasi dari halaman induk.

Kita memutus hubungannya dengan cara memberikan "remot kontrol palsu/kosong":

```swift
// KODE BARU YANG AMAN
.sheet(isPresented: $showJournalSheet) {
    NavigationStack {
        ReviewJournalView(
            navPath: .constant(NavigationPath()), // <-- AMAN! Memberi rute kosong yang statis
            isPresentedAsSheet: true, 
            canEdit: !viewModel.isTimerFinished
        )
    }
}
```
Dengan menggunakan `.constant(NavigationPath())`, kita melindungi `navPath` utama agar tidak terganggu gugat oleh aksi apapun di dalam Sheet. Kini, *Sheet* tersebut sepenuhnya mandiri dan akan ditutup dengan elegan menggunakan `dismiss()`.

---
*Selalu ingat aturan emas ini: Jangan pernah melemparkan (passing) Binding milik `NavigationPath` induk ke dalam tumpukan `NavigationStack` baru yang dirender secara modal!* 🚀

# Panduan Pemula iOS: Dependency Injection (DI) Sederhana di SwiftUI

Dokumen ini menjelaskan kenapa kita menambahkan DI sederhana melalui `Environment` untuk haptics dan penyimpanan data di MyVaultApp.

---

## 1. Masalah: Singleton dan Context Langsung Sulit Dites

Sebelumnya, view memanggil `HapticManager.shared` secara langsung dan menyentuh `ModelContext` di dalam view. Ini membuat:
- **Unit test sulit** karena ketergantungan hard-coded.
- **Preview sulit diatur** karena tidak bisa mengganti implementasi dengan versi mock.

---

## 2. Solusi: Inject Dependency via Environment

Kita membuat protokol sederhana untuk haptics dan repository untuk SwiftData, lalu memasukkannya ke `Environment`.
Dengan cara ini, production default tetap sama, tetapi kita bisa mengganti implementasi saat testing.

```swift
protocol HapticProviding {
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
    func notification(type: UINotificationFeedbackGenerator.FeedbackType)
}

protocol VaultItemRepository {
    func insert(_ item: VaultItem)
    func delete(_ item: VaultItem)
    func save() throws
}
```

View cukup mengambilnya dari `Environment`:

```swift
@Environment(\.hapticProvider) private var hapticProvider
@Environment(\.vaultItemRepositoryFactory) private var repositoryFactory
```

---

## 3. Contoh Pemakaian di View

```swift
// Haptics
hapticProvider.notification(type: .success)

// SwiftData melalui repository
let repository = repositoryFactory(modelContext)
repository.insert(item)
try repository.save()
```

---

## 4. Keuntungan Praktis

- **Testability:** mudah membuat mock provider untuk unit test.
- **Preview-friendly:** bisa menggunakan dummy provider di preview.
- **Scalability:** jika nanti berpindah storage, hanya repository yang diganti.

---
*DI tidak harus rumit. Untuk SwiftUI, `Environment` sudah cukup kuat untuk kebutuhan aplikasi skala kecil sampai menengah.*