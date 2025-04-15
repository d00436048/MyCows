//
//  Settings.swift
//  MyCows!
//
//  Created by Bridger Hall on 10/25/24.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        
        ZStack{
            
            VStack {
                HStack {
                    if horizontalSizeClass == .compact {
                        Button("<-") {
                            viewRouter.activeView = .main
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
                            viewRouter.activeView = .lobby
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.leading, 25) // Set distance from the left
                        .padding(.top, 25)      // Set distance from the top
                        Spacer() // Pushes button to top-left corner
                    }
                }
                Spacer() // Keeps content aligned below the button
            }
            
            
            Text("Settings")
        }
    }
}

#Preview {
    Settings()
}
