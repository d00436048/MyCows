//
//  ContentView.swift
//  MyCows!
//
//  Created by Bridger Hall on 10/23/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        VStack {
            // Show the current view based on the activeView state
            switch viewRouter.activeView {
            case .main:
                MainMenu()
            case .settings:
                Settings()
            case .host:
                GameHost()
            case .join:
                GameJoin()
            case .lobby:
                GameLobby()
            case .game:
                Game()
            case .end:
                GameOver()
            }

//            Spacer()

//            // Navigation buttons to change the active view
//            HStack {
//                Button("Main") { viewRouter.activeView = .main }
//                Button("Settings") { viewRouter.activeView = .settings }
//                Button("gameHost") {viewRouter.activeView = .host}
//                Button("gamejoin") {viewRouter.activeView = .join}
//                Button("GameLobby") { viewRouter.activeView = .lobby }
//                Button("end") { viewRouter.activeView = .end }
//            }
//            .padding()
//            .background(Color.gray.opacity(0.2))
        }
    }
}


#Preview {
    ContentView()
}
