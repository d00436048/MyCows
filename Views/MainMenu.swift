//
//  MainMenu.swift
//  MyCows!
//
//  Created by Bridger Hall on 10/25/24.
//

import SwiftUI

struct MainMenu: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var cloudOffset: CGFloat = -250  // Start off-screen to the left
    @State private var signX: CGFloat = 200
    @State private var signY: CGFloat = 200
    @StateObject private var viewModel = RewardedViewModel()
    
    
    var body: some View {
        ZStack{
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            Image("clud")
                .offset(x: cloudOffset, y: -250)
                .onAppear {
                      // Animate cloud movement across the screen
                      withAnimation(
                          Animation.linear(duration: 12).repeatForever(autoreverses: false)
                      ) {
                          cloudOffset = UIScreen.main.bounds.width + 200 // Off-screen to the right
                      }
                  }
            
            
            Image("sign")
                .resizable()
                .frame(width: 550, height: 300)
                .rotationEffect(.degrees(12))
                .offset(x: 20, y: -50)
            
            VStack {
                ZStack{
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            viewRouter.activeView = .lobby // Triggers the transition
                        }
                    }) {
                        Image("play")
                            .resizable()
                            .padding(.vertical, -5.01)
                            .scaledToFit()
                            .frame(width: signX, height: signY)
                            .rotationEffect(.degrees(signX-200))
                            .onAppear{
                                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: true)) {
                                    signX = signX + 20
                                    signY = signY + 20
                                }
                            }
                        
                    }
                    .padding()
                    .background(Color.clear)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
//                Button("got tosettings") {
//                    viewRouter.activeView = .settings
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
                
                Spacer()
            }
            .offset(x: 0, y:425)
            
            Button("Show Rewarded Ad") {
                viewModel.showAd()
            }
            .padding()
            .onAppear {
                Task {
                    await viewModel.loadAd()
                }
            }
            
            Button("settings", action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    viewRouter.activeView = .settings // Triggers the transition
                }
            })
            .padding()
            .background(Color.red)
            .font(Font.custom("CustomFont", size: 18))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    MainMenu()
}
