//
//  CountDownTimer.swift
//  Kroya_UI_Project
//
//  Created by Ounbonaliheng on 2/10/24.
//
import SwiftUI

class CountdownTimer: ObservableObject {
    @Published var countdown: Int = 180 {
        didSet {
            // Ensure countdown doesn't go below zero
            if countdown < 0 {
                countdown = 0
            }
        }
    }
    @Published var isResendDisabled: Bool = false
    
    private var timer: Timer?
    
    func start() {
        isResendDisabled = true
        countdown = 180
        timer?.invalidate()  // Stop any previous timers
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.countdown > 0 {
                self.countdown -= 1
            } else {
                timer.invalidate()
                self.isResendDisabled = false
            }
        }
    }
    
    func reset() {
        start()  // Reset the countdown
    }
    
    var formattedCountdown: String {
        let minutes = countdown / 60
        let seconds = countdown % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    deinit {
        timer?.invalidate()  // Clean up the timer when the instance is deallocated
    }
}
