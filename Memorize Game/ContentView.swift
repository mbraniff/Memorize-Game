//
//  ContentView.swift
//  Memorize Game
//
//  Created by Matthew Braniff on 3/13/24.
//

import SwiftUI

struct ContentView: View, WinScreenDelegate {
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var gameController: GameController
    
    @State var cardAmount = 25
    
    var body: some View {
        VStack {
            
            // MARK: - HEADER
            ZStack {
                VStack {
                    Text("Memorize!")
                        .font(.largeTitle)
                    Text("Score: \(gameController.score)")
                        .font(.title2)
                }
                HStack {
                    Picker("Card Amount", selection: $cardAmount) {
                        ForEach(2..<51) { value in
                            if value % 2 == 0 {
                                Text("\(value)").tag(value)
                            }
                        }
                    }
                    Spacer()
                    Button {
                        gameController.startGame(with: cardAmount)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .padding(.trailing)
                }
            }
            
            // MARK: - Grid View
            CardGridView(amount: gameController.gameBoard.count)
            Spacer()
            
            // MARK: - FOOTER
            HStack {
                ForEach(ThemeEnum.allCases, id: \.self) { themeValue in
                    Button {
                        theme.currentTheme = themeValue.theme
                    } label: {
                        Text(themeValue.rawValue)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .onAppear {
            gameController.startGame(with: cardAmount)
        }
        .overlay {
            if gameController.gameWin {
                WinView(score: gameController.score, delegate: self)
            }
        }
    }
    
    func doDismissScreen() {
        gameController.startGame(with: cardAmount)
    }
}

#Preview {
    ContentView()
        .environmentObject(Theme())
        .environmentObject(GameController())
}
