//
//  GameOver.swift
//  MyCows!
//
//  Created by Bridger Hall on 10/25/24.
//

import SwiftUI

struct GameOver: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            Text("Game over")
            VStack {
                Button("Go to lobby", action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewRouter.activeView = .main // Triggers the transition
                    }
                })
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }
}

#Preview {
    GameOver()
}
