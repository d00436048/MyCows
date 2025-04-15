//
//  GameLobby.swift
//  MyCows!
//
//  Created by Bridger Hall on 10/25/24.
//

import SwiftUI
import Firebase

struct GameLobby: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        
        ZStack{
            
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    if horizontalSizeClass == .compact {
                        Button("<-") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewRouter.activeView = .main // Triggers the transition
                            }
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .font(Font.custom("a Art Paper", size: 18))
                        .cornerRadius(8)
                        .padding(.leading, 100) // Set distance from the left
                        .padding(.top, -10)      // Set distance from the top
                        Spacer() // Pushes button to top-left corner
                    } else {
                        Button("<-") {withAnimation(.easeInOut(duration: 0.5)) {
                            viewRouter.activeView = .main // Triggers the transition
                        }
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .font(Font.custom("a Art Paper", size: 18))
                        .cornerRadius(8)
                        .padding(.leading, 25) // Set distance from the left
                        .padding(.top, 25)      // Set distance from the top
                        Spacer() // Pushes button to top-left corner
                    }
                }
                Spacer() // Keeps content aligned below the button
            }
            
            Text("GameLobby")
            
            VStack {
                
                Button("host", action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewRouter.activeView = .host // Triggers the transition
                    }
                })
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .font(Font.custom("a Art Paper", size: 18))
                .cornerRadius(8)
                Button("join", action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewRouter.activeView = .join // Triggers the transition
                    }
                })
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .font(Font.custom("a Art Paper", size: 18))
                .cornerRadius(8)
            }
        }
    }
}

#Preview {
    GameLobby()
}
