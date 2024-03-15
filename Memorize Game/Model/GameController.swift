//
//  GameController.swift
//  Memorize Game
//
//  Created by Matthew Braniff on 3/15/24.
//

import Foundation
import SwiftUI

class GameController: ObservableObject {
    private let maxOptions = 5
    @Published private(set) var gameBoard: [Int] = []
    var flipEnabled: Binding<Bool>?
    @Published var gameId: Int = 0
    @Published var gameWin: Bool = false
    @Published var score: Int = 0
    
    typealias Selection = (value: Int, flipCard: Binding<Bool>)
    
    private var firstSelection: Selection?
    private var matches = 0
    
    func startGame(with amount: Int) {
        gameId += 1
        matches = 0
        score = 0
        gameWin = false
        
        let amount = amount % 2 == 0 ? amount : amount - 1
        
        var lookup: [Int:Int] = Dictionary(uniqueKeysWithValues: zip(0..<maxOptions, Array(repeating:0, count: maxOptions)))
        var gameBoard: [Int] = []
        for _ in 0..<amount {
            let random = Int.random(in: 0..<maxOptions)
            if let value = lookup[random] {
                lookup[random] = value + 1
            }
            gameBoard.append(random)
        }
        
        for i in 0..<gameBoard.count {
            let value1 = gameBoard[i]
            if let count1 = lookup[value1], count1 % 2 != 0 {
                for j in i..<gameBoard.count {
                    let value2 = gameBoard[j]
                    if let count2 = lookup[value2], count2 % 2 != 0 {
                        gameBoard[j] = value1
                        lookup[value2] = count2 - 1
                        lookup[value1] = count1 + 1
                    }
                }
            }
        }
        
        self.gameBoard = gameBoard
    }
}

extension GameController: CardSelectionDelegate {
    @MainActor
    func didSelectCard(with value: Int, flipCard: Binding<Bool>) {
        let selection = Selection(value: value, flipCard: flipCard)
        if let firstSelection {
            if firstSelection.value != selection.value {
                if matches > 0 {
                    score -= 1
                }
                self.flipEnabled?.wrappedValue = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.flipEnabled?.wrappedValue = true
                    selection.flipCard.wrappedValue = false
                    firstSelection.flipCard.wrappedValue = false
                    self.firstSelection = nil
                }
            } else {
                score += 2
                self.firstSelection = nil
                matches += 1
                if matches == self.gameBoard.count/2 {
                    gameWin = true
                }
            }
        } else {
            self.firstSelection = selection
        }
    }
}
