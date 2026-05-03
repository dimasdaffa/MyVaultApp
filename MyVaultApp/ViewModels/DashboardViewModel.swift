//
//  DashboardViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 02/05/26.
//
import SwiftUI
import SwiftData
import Combine

class DashboardViewModel: ObservableObject {
    // 1. STATE YANG DIPUBLIKASIKAN KE VIEW
    @Published var hasReadyItem: Bool = false
    @Published var currentTime: Date = Date()
    
    private var timerCancellable: AnyCancellable?
    
    init() {
        startTimer()
    }
    
    // 2. ENGINE WAKTU: Berdetak setiap 1 detik untuk memperbarui UI
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                // Setiap detik, kita hanya perlu memperbarui currentTime.
                // View akan bereaksi dan menghitung ulang sisanya secara otomatis
                self?.currentTime = Date()
            }
    }
    
    // 3. LOGIKA PERHITUNGAN WAKTU
    // Menghitung selisih detik antara targetDate dan waktu sekarang
    func timeRemaining(for item: VaultItem) -> TimeInterval {
        let remaining = item.targetDate.timeIntervalSince(currentTime)
        return max(0, remaining) // Mencegah angka menjadi negatif (mentok di 0)
    }
    
    // Mengubah detik menjadi format HH:MM:SS
    func formatTime(_ totalSeconds: TimeInterval) -> (h: String, m: String, s: String) {
        let h = String(format: "%02d", Int(totalSeconds) / 3600)
        let m = String(format: "%02d", (Int(totalSeconds) % 3600) / 60)
        let s = String(format: "%02d", Int(totalSeconds) % 60)
        return (h, m, s)
    }
    
    // 4. LOGIKA ALERT "VALIDATE DECISION"
    // Mengecek apakah ada minimal satu item yang sudah menyentuh 00:00:00
    func checkAlertStatus(items: [VaultItem]) {
        // Cari item yang statusnya masih 'coolingDown' DAN waktunya sudah 0
        let isReady = items.contains { item in
            item.status == .coolingDown && timeRemaining(for: item) == 0
        }
        
        // Hanya animasi jika ada perubahan status
        if hasReadyItem != isReady {
            withAnimation(.easeInOut(duration: 0.3)) {
                hasReadyItem = isReady
            }
        }
    }
    
    // 5. GRAVITY SORTING LOGIC
    // Menerima array dari database, lalu menyusunnya untuk UI
    func processAndSortItems(_ items: [VaultItem]) -> [VaultItem?] {
        // A. Saring hanya yang aktif (Abaikan yang sudah di-Validate)
        let activeItems = items.filter { $0.status == .coolingDown || $0.status == .ready }
        
        // B. Urutkan berdasarkan aturan gravitasi 
        var sortedActiveItems = activeItems.sorted { item1, item2 in
            let rem1 = timeRemaining(for: item1)
            let rem2 = timeRemaining(for: item2)
            
            // Aturan 1: Yang sudah 0 (Finished) tenggelam ke bawah
            if rem1 > 0 && rem2 == 0 { return true }
            if rem1 == 0 && rem2 > 0 { return false }
            
            // Aturan 2: Kalau sama-sama berjalan, yang waktunya paling panjang di atas
            return rem1 > rem2
        }
        
        // C. Siapkan Array Kosong untuk UI (bisa berisi VaultItem nyata atau 'nil' untuk slot kosong)
        var uiSlots: [VaultItem?] = []
        
        // Masukkan item aktif ke dalam slot
        for item in sortedActiveItems {
            uiSlots.append(item)
        }
        
        // D. Jika total item kurang dari 3, isi sisanya dengan 'nil' (Slot Kosong / "Space for reflection")
        while uiSlots.count < 3 {
            // Karena Empty Slot harus melayang di atas (sesuai UX yang kita buat sebelumnya),
            // kita masukkan nil di urutan *pertama* (index 0)
            uiSlots.insert(nil, at: 0)
        }
        
        // Pastikan kita tidak pernah mengirim lebih dari 3 slot ke UI
        if uiSlots.count > 3 {
            return Array(uiSlots.suffix(3)) // Ambil 3 item terbawah
        }
        
        return uiSlots
    }
}



