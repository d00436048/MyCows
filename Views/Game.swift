//
//  Game.swift
//  MyCows!
//
//  Created by Bridger Hall on 10/25/24.
//

import SwiftUI

struct Game: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var firebaseManager = FirebaseManager.shared
    
    var gameCodeManager = GameCodeManager.shared

    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            
            
            Text("Gameplay")
            VStack {
                Text("Welcome to the gameplay")
                    .font(Font.custom("a Art Paper", size: 18))

                
                Text("gamecode: \(self.gameCodeManager.code)")
                    .font(Font.custom("a Art Paper", size: 18))
                    .padding()
                Text("your name: \(self.gameCodeManager.name)")
                    .font(Font.custom("a Art Paper", size: 18))

                    .padding()
                
                
                Text(firebaseManager.localPlayerScore)
                    .font(.title2)
                    .onAppear {
                        firebaseManager.observeLocalPlayerScore(
                            gameCode: gameCodeManager.code,
                            playerName: gameCodeManager.name
                        )
                    }
                    .padding()
                
                Text("____Players____")
                    .font(.title3)
                
                List(firebaseManager.players, id: \.self) { playerInfo in Text(playerInfo)
                        .padding(.vertical, 4)
                }
                .onAppear{ firebaseManager.loadPlayersWithScores(gameCode: self.gameCodeManager.code)}
                
                HStack{
                    
                    if horizontalSizeClass == .compact {
                        Button("ICCOWS"){
                            FirebaseManager.shared.addToPlayerScore(gameCode: self.gameCodeManager.code, playerName: self.gameCodeManager.name, additionalBurgers: 0, additionalCows: 2)
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(Font.custom("a Art Paper", size: 18))
                        .cornerRadius(8)
                        .padding(.horizontal, 30)
                        .padding(.trailing, 5)
                    } else {
                        Button("ICCOWS"){
                            FirebaseManager.shared.addToPlayerScore(gameCode: self.gameCodeManager.code, playerName: self.gameCodeManager.name, additionalBurgers: 0, additionalCows: 2)
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(Font.custom("a Art Paper", size: 18))
                        .cornerRadius(8)
                        .padding(.leading, 30)
                        .padding(.trailing, 5)
                    }

                    
                    Button("Mcdlds"){
                        FirebaseManager.shared.addCowsToScoreAsBurgersAndCows(gameCode: self.gameCodeManager.code, playerName: self.gameCodeManager.name)
                    }
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(Font.custom("a Art Paper", size: 18))
                    .cornerRadius(8)
                    .padding(.horizontal, 5)
                    
                    Button("DedCws"){
                        FirebaseManager.shared.subtractAllCowsToScoreForAllExceptLocal(gameCode: gameCodeManager.code, localPlayerName: gameCodeManager.name)
                    }
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(Font.custom("a Art Paper", size: 18))
                    .cornerRadius(8)
                    .padding(.horizontal, 5)
                    
                    Button("MadCws"){
                        FirebaseManager.shared.subtractHalfCowsToScoreForAllExceptLocal(gameCode: gameCodeManager.code, localPlayerName: gameCodeManager.name)
                    }
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(Font.custom("a Art Paper", size: 18))
                    .cornerRadius(8)
                    .padding(.horizontal, 5)
                    
                    if horizontalSizeClass == .compact {
                        Button("CowMoo"){
                            FirebaseManager.shared.addCowsToScoreDouble(gameCode: self.gameCodeManager.code, playerName: self.gameCodeManager.name)
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(Font.custom("a Art Paper", size: 18))
                        .cornerRadius(8)
                        .padding(.horizontal, 5)
                    } else {
                        Button("CowMoo"){
                            FirebaseManager.shared.addCowsToScoreDouble(gameCode: self.gameCodeManager.code, playerName: self.gameCodeManager.name)
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(Font.custom("a Art Paper", size: 18))
                        .cornerRadius(8)
                        .padding(.leading, 5)
                        .padding(.trailing, 30)
                    }
    
                }
                Button("Go to gameover screen", action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewRouter.activeView = .end // Triggers the transition
                        firebaseManager.removePlayer(gameCode: self.gameCodeManager.code, playerName:
                                                        self.gameCodeManager.name)
                    }
                })

                .background(Color.blue)
                .foregroundColor(.white)
                .font(Font.custom("a Art Paper", size: 18))
                .cornerRadius(8)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    Game()
}
