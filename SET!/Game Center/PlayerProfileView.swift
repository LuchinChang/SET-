//
//  PlayerView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/29.
//

import SwiftUI
import GameKit

struct PlayerProfileView: View {
    @ObservedObject var player: PlayerViewModel
    
    var name = "TestingName"
    let size: CGFloat
    var displayName: Bool
    
    var body: some View {
        VStack {
            if (player.imageLoaded),
               let uiImage = player.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .circleClip(size)
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .circleClip(size)
            }
            if displayName { Text(name) }
        }
    }
    
    init(_ player: GKPlayer, displayName: Bool = true, size: CGFloat = 150) {
        self.player = PlayerViewModel(player)
        self.name = player.displayName
        self.size = size
        self.displayName = displayName
        self.player.loadImage()
    }
    
    static let localPlayer = PlayerProfileView(GKLocalPlayer.local, size: 200)
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
//                .padding()
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 10)
        }
    }
    
    init(_ size: CGFloat) {
        self.size = size
    }
}

class PlayerViewModel: ObservableObject, Identifiable {
    let id = UUID()
    let player: GKPlayer
    
    @Published var displayName: String
    @Published var imageLoaded = false
    @Published var uiImage: UIImage?
    
    init(_ player: GKPlayer) {
        self.player = player
        self.displayName = self.player.displayName
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

//
//
//#Preview {
//    VStack {
//        PlayerProfileView(size: 150)
//        PlayerProfileView.test
//    }
//}
