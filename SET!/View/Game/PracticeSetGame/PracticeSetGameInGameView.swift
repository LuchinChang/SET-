//
//  inGameView.swift
//  SET!
//
//  Created by LuChin Chang on 2024/5/28.
//

import SwiftUI

struct PracticeSetGameInGameView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var practiceSetGame: SetPracticeVM
    
    @Namespace private var discardNamespace
    @Namespace private var dealingNamespace
    
    @State var showWhyNotMatchedHint = false
    private var isNotMatchedPair: Bool {
        practiceSetGame.cards.filter({
            $0.isMatched == false
        }).count == 3
    }
    
    var body: some View {
        VStack {
            PracticeSetBannerView()
            Spacer()
            cardBoard
            Spacer()
            bottom
        }
        .padding()
        .onAppear {
            practiceSetGame.newGame()
        }
        .sheet(isPresented: $showWhyNotMatchedHint) {
            notMatchedExplanation
                .presentationDetents([.fraction(0.3)])
        }
    }
    
    var notMatchedExplanation: some View {
        let matchResult = practiceSetGame.whyCardsNotMatched()
        
        return List {
            ForEach(matchResult.elements, id: \.key) { result in
                HStack {
                    Text(result.key)
                    Spacer()
                    Image(systemName: result.value ?  "checkmark.circle" : "xmark.circle")
                }
                .foregroundStyle(result.value ? .green : .red)
                .font(.title)
            }
        }
    }
    
    var cardBoard: some View {
        CardBoardVew(
            practiceSetGame.cardsOnTable,
            dealingNamespace: dealingNamespace,
            discardNamespace: discardNamespace,
            choose: practiceSetGame.choose
        )
    }
    
    // MARK: Bottom    
    
    var discardPile: some View {
        PileOfCardsView(practiceSetGame.cardsMatched, nameSpace: discardNamespace, size: Constants.cardWidth)
    }
    
    var deck: some View {
        PileOfCardsView(practiceSetGame.cardsInDeck, nameSpace: dealingNamespace, size: Constants.cardWidth)
            .foregroundStyle(ViewStyle.Card.backColor)
            .onTapGesture {
                practiceSetGame.dealWithAnimation(3)
            }
    }
    
    var hint: some View {
        VStack {
            Button("Hint") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    practiceSetGame.hint()
                }
            }
            .font(.largeTitle)
            .bold()
            .padding(.bottom, 3)
            
            Button(action: {
                showWhyNotMatchedHint = true
            }, label: {
                Image(systemName: "questionmark.circle")
                    .font(.title)
                    .foregroundStyle(isNotMatchedPair ? ViewStyle.textColor : .gray)
                    .animation(nil, value: isNotMatchedPair)
            })
            .disabled(!isNotMatchedPair)
        }
        
    }
    
    var bottom: some View {
        HStack {
            discardPile
            Spacer()
            hint
            Spacer()
            deck
        }
        .padding(3.5)
    }
    
    private struct Constants {
        static let cardWidth: CGFloat = 70
    }
}

#Preview {
    PracticeSetGameInGameView()
}
