//
//  CountdownClock.swift
//  QuizMobile
//
//  Created by Giovane Silva de Menezes Cavalcante on 08/02/20.
//  Copyright © 2020 GSMenezes. All rights reserved.
//

import Foundation

enum ClockState {
    case counting(seconds: Int)
    case finished
    
    var label: String {
        switch self {
        case .counting(let seconds):
            return String.timeFormatted(seconds)
        case .finished:
            return String.timeFormatted(0)
        }
    }
}

class CountdownClock {
    
    var timer: Timer?
    var timeLimit: Int
    var remainTime: Int = 0
    var onTimeUpdate: ((ClockState) -> Void)?
    
    init(seconds: Int, onTimeUpdate: ((ClockState) -> Void)?) {
        self.onTimeUpdate = onTimeUpdate
        self.timeLimit = seconds
    }
    
    func start() {
        remainTime = timeLimit
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(updateTimer),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateTimer() {
        
        if remainTime == 0 {
            onTimeUpdate?(.finished)
            stop()
        } else {
            remainTime -= 1
            onTimeUpdate?(.counting(seconds: remainTime))
        }
    }
}
