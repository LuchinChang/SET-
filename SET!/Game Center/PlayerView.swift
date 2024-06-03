//
//  PlayerView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/29.
//

import SwiftUI
import GameKit

struct PlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if self.viewModel.imageLoaded,
               let uiImage = self.viewModel.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128, height: 128)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            } else {
                Image(systemName: "person.fill")
                    .font(Font.custom("System", size: 64))
                    .frame(width: 128, height: 128)
                    .background(Color("TextColor"))
                    .foregroundColor(Color("BackgroundColor"))
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            Text(self.viewModel.player.displayName)
            VStack(alignment: .center, spacing: 4) {
                Text("Alias: \(self.viewModel.player.alias)")
                    .font(.footnote)
                Text(self.viewModel.player.gamePlayerID)
                    .font(.footnote)
                Text(self.viewModel.player.teamPlayerID)
                    .font(.footnote)
            }
        }
        .onAppear() {
            self.viewModel.load()
        }
    }
}

class PlayerViewModel: ObservableObject {

    let player: GKPlayer

    @Published var displayName: String
    @Published var imageLoaded = false
    @Published var uiImage: UIImage?

    public init(_ player: GKPlayer) {
        self.player = player
        self.displayName = self.player.displayName
    }

    public func load() {
        DispatchQueue.global().async { [self] in
            self.player.loadPhoto(for: GKPlayer.PhotoSize.normal, withCompletionHandler: { (image, error) in
                guard let image = image else {
                    return
                }
                DispatchQueue.main.async {
                    self.uiImage = image
                    self.imageLoaded = true
                }
            })
        }
    }
}
