//
//  MultiPlayer.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/31.
//

import Foundation
import GameKit

protocol MultiPlayer {
    var minPlayer: Int { get set }
    var maxPlayer: Int { get set }
    
}

protocol MultiPlayerViewModel {
    var match: MultiPlayerMatch { get }
}

class MultiPlayerMatch: NSObject, GKMatchDelegate {
    let match: GKMatch?
    let strDataPrefix = "strData:"
    let encodingMethod: String.Encoding = .utf8
    let decodingMethod = UTF8.self
    
    init(_ match: GKMatch, receivedStrDataHandler: @escaping (_ str: String) -> Void) {
        self.match = match
        self.receivedStrDataHandler = receivedStrDataHandler
    }
    
    func sendStrData(_ msg: String) {
        if let encodedString = "\(strDataPrefix)\(msg)".data(using: encodingMethod) {
            sendData(encodedString, mode: .reliable)
        } else {
            print("Sending msg: \(msg) failed")
        }
    }
   
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        do {
            try match?.sendData(toAllPlayers: data, with: mode)
        } catch {
            print(error)
        }
    }
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let content = String(decoding: data, as: decodingMethod)
        
        if content.starts(with: strDataPrefix) {
            receivedStrDataHandler(content.replacing(strDataPrefix, with: ""))
        }
    }
    
    var receivedStrDataHandler: (_ str: String) -> Void
}

//protocol DataHandler {
//    func receivedStrDataHandler (_ str: String) -> Void
//}

protocol SetGameModeViewModel: ObservableObject {
    var isMultiPlayer: Bool { get }
    var playerNumber: (Int, Int) { get }
}


