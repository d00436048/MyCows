//
//  viewrouter.swift
//  My CowsREAL
//
//  Created by Bridger Hall on 10/31/24.
//

//
//  viewrouter.swift
//  MyCows!
//
//  Created by Bridger Hall on 10/25/24.
//
import SwiftUI

// Enum for view cases
enum ActiveView {
    case main, settings, lobby, host, join, game, end
}

// ObservableObject to share active view state across the app
class ViewRouter: ObservableObject {
    @Published var activeView: ActiveView = .main
}

class Client_game_info: ObservableObject {
    @Published var code = 0000
}
