//
//  TimeoutViewModel.swift
//  MyVaultApp
//
//  Created by DIMAS DAFFA ERNANDA on 04/05/26.
//

import Foundation
import Combine

@MainActor
final class TimeoutViewModel: ObservableObject {
	@Published var isTimerFinished: Bool = false
	@Published var timeRemaining: TimeInterval = 0

	var item: VaultItem?

	private var timerCancellable: AnyCancellable?

	init() {}

	deinit {
		// Membersihkan timer saat view model dihancurkan untuk mencegah memory leak
		timerCancellable?.cancel()
	}

	var hours: String { String(format: "%02d", Int(timeRemaining) / 3600) }
	var minutes: String { String(format: "%02d", (Int(timeRemaining) % 3600) / 60) }
	var seconds: String { String(format: "%02d", Int(timeRemaining) % 60) }

	// Mengatur item dan memulai timer saat view muncul
	func setup(with vaultItem: VaultItem) {
		// Hindari setup ulang jika item sudah ada
		if self.item != nil { return }
		self.item = vaultItem
		updateTimer()
		startTimer()
	}

	func updateTimer() {
		guard let item = item else { return }
		if isTimerFinished { return }

		let remaining = item.targetDate.timeIntervalSince(Date())
		if remaining > 0 {
			timeRemaining = remaining
			isTimerFinished = false
		} else {
			timeRemaining = 0
			isTimerFinished = true
			timerCancellable?.cancel()
		}
	}

	private func startTimer() {
		timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
			.autoconnect()
			.sink { [weak self] _ in
				self?.updateTimer()
			}
	}
}
