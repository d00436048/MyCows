//
//  GameLobby.swift
//  MyCows!
//
//  Created by Bridger Hall on 10/25/24.
//

import SwiftUI
import Firebase

struct GameHost: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var firebaseManager = FirebaseManager.shared
    @State private var gameCode: String? = nil
    @State private var hostName: String = ""
    @State private var gameCodeGenerated: Bool = false
    
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
                        .font(Font.custom("a Art Paper", size: 18))
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
                        .font(Font.custom("a Art Paper", size: 18))
                        .cornerRadius(8)
                        .padding(.leading, 25) // Set distance from the left
                        .padding(.top, 25)      // Set distance from the top
                        Spacer() // Pushes button to top-left corner
                    }
                    
                }
                Spacer() // Keeps content aligned below the button
            }
            
            TextField("Enter UserName", text: $hostName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(Font.custom("a Art Paper", size: 18))
                .padding(.horizontal, 150)
                .padding(.top, 25)
                .onChange(of: hostName) { newValue in
                    hostName = newValue.filter { $0.isLetter || $0.isNumber || $0.isWhitespace}
                }
            
            Text("GameHost")
            VStack {
                
                Button("Host A Game") {
                    print("host pressed")
                    if hostName .isEmpty {
                        print("cannot be empty")
                    } else{
                        if gameCodeGenerated == false{
                            firebaseManager.createGame(hostName: hostName) {
                                code in gameCode = code
                                gameCodeGenerated = true
                            }
                        } else {
                            print("already genereqted")
                        }
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                if let code = gameCode {
                    Text("Game Code: \(code)")
                        .font(.title)
                        .padding()
                }
                
                Button("Start Game") {
                    if gameCodeGenerated == true {
                        viewRouter.activeView = .game
                        self.gameCodeManager.name = hostName
                    } else {
                        print("need game code")
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }
}

#Preview {
    GameHost()
}
