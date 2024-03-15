//
//  CardGridView.swift
//  Memorize Game
//
//  Created by Matthew Braniff on 3/15/24.
//

import SwiftUI

struct CardGridView: View {
    var amount: Int
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var gameController: GameController
    
    @State var cardsCanFlip: Bool = true
    
    private let maxColumns = 5
    
    private var rowCount: Int {
        Int(ceil(Float(amount)/Float(maxColumns)))
    }
    
    var body: some View {
        ScrollView {
            Grid(verticalSpacing: 10) {
                ForEach(0..<rowCount, id: \.self) { rowIndex in
                    GridRow {
                        ForEach(0..<rowCount(for: rowIndex), id: \.self) { column in
                            let index = rowIndex * maxColumns + column
                            CardView(text: theme.currentTheme[gameController.gameBoard[index]], flippable: cardsCanFlip, delegate: gameController, value: gameController.gameBoard[index], indexPath: IndexPath(row: column, section: rowIndex))
                        }
                    }
                    .frame(idealWidth: 75, idealHeight: 90)
                }
                .frame(maxWidth: .infinity)
            }
            .id(gameController.gameId)
        }
        .scrollIndicators(.hidden)
        .padding()
        .onAppear {
            gameController.flipEnabled = $cardsCanFlip
        }
    }
    
    func rowCount(for index: Int) -> Int {
        return index == rowCount - 1 ? amount % maxColumns == 0 ? maxColumns : amount % maxColumns : maxColumns
    }
}

#Preview {
    CardGridView(amount: 2)
        .environmentObject(Theme())
        .environmentObject(GameController())
}
