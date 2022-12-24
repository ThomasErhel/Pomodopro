//
//  ContentView.swift
//  Pomodopro Watch App
//
//  Created by Thomas Erhel on 23/12/2022.
//

import SwiftUI
import Foundation
import WatchKit
import UserNotifications

struct ContentView: View {
    @State private var timeRemaining: TimeInterval = 0.10 * 60
    @State private var isWorkTime = true
    @State private var timer: Timer?
    @State private var extendedRuntimeSession: WKExtendedRuntimeSession?
    
    var body: some View {
        VStack {
            Text("\(isWorkTime ? "Work 👨‍💻" : "Relax 🚶‍♂️")")
                .font(.title)
                .padding(.vertical)
            
            Text("\(String(format: "%02d:%02d", Int(timeRemaining) / 60, Int(timeRemaining) % 60))")
                .font(.title)
                .padding(.vertical)
        }
        .onAppear {
            self.startTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeRemaining -= 1
            
            if self.timeRemaining == 0 {
                self.timer?.invalidate()
                WKInterfaceDevice.current().play(.success)
                
                if self.isWorkTime {
                    self.showNotification(title: "Gratz! 🙌👏", body: "Let's chill 😁")
                    self.timeRemaining = 5 * 60
                    self.isWorkTime = false
                } else {
                    self.showNotification(title: "Back to work", body: "🤓")
                    self.timeRemaining = 0.10 * 60
                    self.isWorkTime = true
                }
                
                self.startTimer()
            }
        }
        
        extendedRuntimeSession = WKExtendedRuntimeSession()
        extendedRuntimeSession?.start()
    }
    
    private func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let request = UNNotificationRequest(identifier: "pomodoro_timer", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

