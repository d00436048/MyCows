//
//  GameCodeManger.swift
//  My CowsREAL
//
//  Created by Bridger Hall on 10/31/24.
//

//
//  GameManager.swift
//  MyCows!
//
//  Created by Bridger Hall on 10/25/24.
//

import SwiftUI
import Combine

class GameCodeManager: ObservableObject {
    static let shared = GameCodeManager()
    
    @Published var code: String = ""
    @Published var name: String = ""
    
    private init() {}
}

