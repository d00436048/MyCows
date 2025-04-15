//
//  GameJoin.swift
//  MyCows!
//
//  Created by Bridger Hall on 10/25/24.
//

import SwiftUI
import Firebase

struct GameJoin: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var firebaseManager = FirebaseManager.shared
    @State private var gameCode: String = ""
    @State private var playerName: String = ""
    @State private var gameExists: Bool = false
    
    var gameCodeManager = GameCodeManager.shared

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
                                viewRouter.activeView = .lobby // Triggers the transition
                            }
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.leading, 100) // Set distance from the left
                        .padding(.top, -10)      // Set distance from the top
                        Spacer() // Pushes button to top-left corner
                    } else {
                        Button("<-") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewRouter.activeView = .lobby // Triggers the transition
                            }
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.leading, 25) // Set distance from the left
                        .padding(.top, 25)      // Set distance from the top
                        Spacer() // Pushes button to top-left corner
                    }
                    // Pushes button to top-left corner
                }
                Spacer() // Keeps content aligned below the button
            }
            
            
            Text("GameHost")
            VStack {
                
                TextField("Enter Gamecode", text: $gameCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(Font.custom("a Art Paper", size: 18))
                    .padding()
                    .onChange(of: gameCode) { newValue in
                        gameCode = newValue.filter { $0.isLetter || $0.isNumber || $0.isWhitespace}}
                
                TextField("Enter UserName", text: $playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(Font.custom("a Art Paper", size: 18))
                    .padding()
                    .onChange(of: playerName) { newValue in
                        playerName = newValue.filter { $0.isLetter || $0.isNumber || $0.isWhitespace}}
                    
                
                Button("Join Game") {
                    if playerName .isEmpty {
                        print("cannot be empty")
                    } else{
                        if gameCode.isEmpty {
                            print("cannot be empty")
                        } else {
                            firebaseManager.checkGameExists(gameCode: gameCode) { exists in
                                DispatchQueue.main.async {
                                    gameExists = exists
                                }
                            }
                            if gameExists {
                                firebaseManager.joinGame(gameCode: gameCode, playerName: playerName)
                                viewRouter.activeView = .game
                                self.gameCodeManager.code = gameCode
                                self.gameCodeManager.name = playerName
                            }
                        }
                    }
                }
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
    GameJoin()
}
