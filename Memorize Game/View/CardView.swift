//
//  CardView.swift
//  Memorize Game
//
//  Created by Matthew Braniff on 3/15/24.
//

import SwiftUI

protocol CardSelectionDelegate {
    func didSelectCard(with value: Int, flipCard: Binding<Bool>)
}

struct CardView: View {
    var text: String
    var flippable: Bool
    var delegate: CardSelectionDelegate?
    var value: Int
    var indexPath: IndexPath
    
    @State var turnFaceUp = false
    @State private var isAnimating: Bool = false
    
    private let cardDelay: TimeInterval = 0.1
    
    var delay: TimeInterval {
        TimeInterval(Double(indexPath.section) * cardDelay * 5.0 + Double(indexPath.row) * cardDelay)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(turnFaceUp ? .white : .orange)
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.orange)
            Text(text)
                .font(.largeTitle)
                .opacity(turnFaceUp ? 1 : 0)
        }
        .onTapGesture {
            guard flippable, !turnFaceUp else { return }
            
            turnFaceUp.toggle()
            delegate?.didSelectCard(with: value, flipCard: $turnFaceUp)
        }
        .frame(width: 60, height: 85)
        .onAppear {
            withAnimation(.spring.delay(self.delay).speed(2.5)) {
                self.isAnimating = true
            }
        }
        .offset(x: isAnimating ? 0 : -500)
    }
}

#Preview {
    CardView(text: "Howdy!", flippable: true, value: 1, indexPath: IndexPath(row: 0, section: 0))
}
