//
//  TimerView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/6/20.
//

import SwiftUI

struct TimerView: View {
    var timeInSeconds: Int
    
    var body: some View {
        Text(secToMinSecFormat(timeInSeconds))
            .timerStyle()
    }
    
    func secToMinSecFormat(_ seconds: Int) -> String {
        let min = seconds / 60
        let sec = seconds % 60
        
        return String(format: "%1d: %02d", min, sec)
    }
    
    init(_ timeInSeconds: Int) {
        self.timeInSeconds = timeInSeconds
    }
}

#Preview {
    TimerView(100)
}
