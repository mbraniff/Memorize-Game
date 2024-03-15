//
//  WinView.swift
//  Memorize Game
//
//  Created by Matthew Braniff on 3/15/24.
//

import SwiftUI

protocol WinScreenDelegate {
    func doDismissScreen()
}

struct WinView: View {
    @State private var isAnimating = false
    @State private var animateGradient = false
    
    @State var gradient: [Color] = [.yellow, .orange, .red]
    @State var textGradient: [Color] = [.blue, .teal, .green]
    
    var score: Int
    
    var delegate: WinScreenDelegate?
    
    var body: some View {
        ZStack {
            LinearGradient(colors: gradient, startPoint: .top, endPoint: .bottom)
            
            VStack {
                Text("YOU WIN!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(LinearGradient(colors:textGradient, startPoint: .leading, endPoint: .trailing))
                    .shadow(radius: 5)
                
                Text("Score: \(score)")
                    .font(.title3)
                    .bold()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.20, repeats: true) { _ in
                withAnimation(.easeInOut) {
                    cycleGradient()
                }
            }
            
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
                delegate?.doDismissScreen()
            }
        }
        .onTapGesture {
            delegate?.doDismissScreen()
        }
    }
    
    func cycleGradient() {
        gradient = [gradient[2]] + gradient[0...1]
        textGradient = [textGradient[2]] + textGradient[0...1]
    }
}

#Preview {
    WinView(score: 10)
}
