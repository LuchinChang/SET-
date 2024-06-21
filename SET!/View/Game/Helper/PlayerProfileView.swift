//
//  PlayerView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/29.
//

import SwiftUI
import GameKit

struct PlayerProfileView: View, Identifiable {
    @StateObject private var player: PlayerViewModel
    
    let id = UUID()
    let size: CGFloat
    let hideName: Bool
    
    var body: some View {
        VStack {
            if (player.imageLoaded), let uiImage = player.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .circleClip(size)
                
            } else {
                PlayerProfileView.defaultImage
                    .resizable()
                    .circleClip(size)
            }
            
            if !hideName {
                Text(player.displayName)
//                                   Text("LCCCCC")
                    .font(.title)
                    .bold()
                    .italic()
                    .foregroundStyle(ViewStyle.textColor)
            }
        }
        
    }
    
    init(_ player: GKPlayer, hideName: Bool = true, size: CGFloat = 200) {
        _player = StateObject(wrappedValue: PlayerViewModel(player))
        self.size = size
        self.hideName = hideName
    }
    
    static let defaultImage = Image(systemName: "person.fill")
    static let placeHolder = PlayerProfileView(GKLocalPlayer.local, size: 200)
}

class PlayerViewModel: ObservableObject {
    let player: GKPlayer
    
    let displayName: String
    @Published var imageLoaded = false
    @Published var uiImage: UIImage?
    
    init(_ player: GKPlayer) {
        self.player = player
        self.displayName = self.player.displayName
        loadImage()
    }
    
    func loadImage() {
        DispatchQueue.global().async {
            self.player.loadPhoto(for: GKPlayer.PhotoSize.normal) { image, error in
                guard let image = image else { return }
                
                DispatchQueue.main.async {
                    self.uiImage = image
                    self.imageLoaded = true
                }
            }
        }
    }
    
    static let localPlayer = PlayerViewModel(GKLocalPlayer.local)
}


extension View {
    func circleClip(_ size: CGFloat) -> some View {
        modifier(CircleClip(size))
    }
}

struct CircleClip: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        VStack {
            content
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 10)
        }
    }
    
    init(_ size: CGFloat) {
        self.size = size
    }
}

