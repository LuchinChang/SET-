//
//  MultiPlayer.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/31.
//

import Foundation
import GameKit

struct MatchCommunicationHelper {
    let match: GKMatch
    
    func sendStrData(_ msg: String) {
        if let encodedString = encodeMsg(msg, msgType: .str) {
            sendData(encodedString, mode: .reliable)
        } else {
            print("Sending msg: \(msg) failed")
        }
    }
   
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        do {
            try match.sendData(toAllPlayers: data, with: mode)
        } catch {
            print(error)
        }
    }
    
    func encodeMsg(_ msg: String, msgType: MsgType) -> Data? {
        switch msgType {
        case .str:
            "\(msgType.rawValue)\(msg)".data(using: Constants.encodingMethod)
        default:
            "\(msgType.rawValue)".data(using: Constants.encodingMethod)
        }
    }
    
    func decodeMsg(_ msg: Data) -> (msgType: MsgType, content: String) {
        var content = String(decoding: msg, as: Constants.decodingMethod)
        var msgType: MsgType = .default
        
        if content.starts(with: MsgType.str.rawValue) {
            content = content.replacing(MsgType.str.rawValue, with: "")
            msgType = .str
        }
        
        return (msgType, content)
    }
    
    enum MsgType: String {
        case str = "strData:"
        case `default` = "default:"
    }
    
    struct Constants {
        static let encodingMethod: String.Encoding = .utf8
        static let decodingMethod = UTF8.self
    }
}

protocol MultiPlayerViewModel {
    var matchDelegator: GKMatchDelegate { get set }
}

protocol TimedGame {
    var remainingTime: Int { get set }
}

protocol SetGameViewModel: ObservableObject {
    var isMultiPlayer: Bool { get }
    var playerNumber: (Int, Int) { get }

}

final class TimerHandler {
    var timer: Timer?
    var countingDown: () -> Void

    init(countingDown: @escaping () -> Void) {
        self.countingDown = countingDown
    }

    func initializeHost() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.countingDown()
        }
    }

    deinit {
        timer?.invalidate()
    }
}


