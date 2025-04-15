//
//  FirebaseManager.swift
//  My CowsREAL
//
//  Created by Bridger Hall on 10/31/24.
//

//
//  FirebaseManager.swift
//  MyCows!
//
//  Created by Bridger Hall on 10/25/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()

//    private init() {
//        FirebaseApp.configure()
//    }

    private let database = Database.database().reference()
    
    var gameCodeManager = GameCodeManager.shared
    
    @Published var players: [String] = []
    @Published var localPlayerScore: String = "Burgers: 0, Cows: 0"

    func generateGameCode() -> String {
        return UUID().uuidString.prefix(4).uppercased()
    }

    func createGame(hostName: String, completion: @escaping (String) -> Void) {
        print("console")
        let gameCode = generateGameCode()

        let initialPlayerData: [String: Any] = [
            "burgers": 0,
            "cows": 0
        ]

        let gameData: [String: Any] = [
            "players": [
                hostName: initialPlayerData
            ],
            "gameCode": [
                gameCode: gameCode
            ]
        ]

        database.child("games").child(gameCode).setValue(gameData) { error, _ in
            if let error = error {
                print("Error creating game: \(error.localizedDescription)")
            } else {
                self.gameCodeManager.code = gameCode
                completion(gameCode)
            }
        }
    }
    
    
    func checkGameExists(gameCode: String, completion: @escaping (Bool) -> Void) {
        database.child("games").child(gameCode).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                // The game code exists
                completion(true)
            } else {
                // The game code does not exist
                completion(false)
            }
        } withCancel: { error in
            print("Error checking game existence: \(error.localizedDescription)")
            completion(false)
        }
    }

    func joinGame(gameCode: String, playerName: String) {
        let playerData: [String: Any] = ["burgers": 0, "cows": 0]

        database.child("games").child(gameCode).child("players").child(playerName).setValue(playerData) {error, _ in
            if let error = error {
                print("Error joining game: \(error.localizedDescription)")
            }
        }
    }
    
    func removePlayer(gameCode: String, playerName: String) {
        database.child("games").child(gameCode).child("players").child(playerName).removeValue { error, _ in
            if let error = error {
                print("Error removing player: \(error.localizedDescription)")
            } else {
                print("Player successfully removed.")
            }
        }
    }
    
    func loadPlayersWithScores(gameCode: String) {
        database.child("games").child(gameCode).child("players").observe(.value) { snapshot in
            var fetchedPlayers: [String] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let playerData = childSnapshot.value as? [String: Any],
                   let playerName = childSnapshot.key as String?,
                   playerName != self.gameCodeManager.name { // Exclude local player
                    let burgers = playerData["burgers"] as? Int ?? 0
                    let cows = playerData["cows"] as? Int ?? 0
                    let playerInfo = "\(playerName): Burgers: \(burgers), Cows: \(cows)"
                    fetchedPlayers.append(playerInfo)
                }
            }
            self.players = fetchedPlayers // Update the players array without the local player
        } withCancel: { error in
            print("Error loading players: \(error.localizedDescription)")
        }
    }
    
    func addToPlayerScore(gameCode: String, playerName: String, additionalBurgers: Int, additionalCows: Int) {
        let playerPath = database.child("games").child(gameCode).child("players").child(playerName)
        
        // Retrieve the current scores
        playerPath.observeSingleEvent(of: .value) { snapshot in
            if let playerData = snapshot.value as? [String: Any],
               var currentBurgers = playerData["burgers"] as? Int,
               var currentCows = playerData["cows"] as? Int {
                
                if currentBurgers + additionalBurgers > 1000000000000000 {
                    currentBurgers = 0
                }
                if currentCows + additionalCows > 1000000000000000 {
                    currentCows = 0
                }

                // Add the new scores to the current scores
                let updatedBurgers = currentBurgers + additionalBurgers
                let updatedCows = currentCows + additionalCows

                // Update the database with the new scores
                let updatedData: [String: Any] = [
                    "burgers": updatedBurgers,
                    "cows": updatedCows
                ]

                playerPath.updateChildValues(updatedData) { error, _ in
                    if let error = error {
                        print("Error updating player score: \(error.localizedDescription)")
                    } else {
                        print("Player score successfully updated.")
                    }
                }
            } else {
                print("Error retrieving current scores.")
            }
        }
    }
    
    func addCowsToScoreAsBurgersAndCows(gameCode: String, playerName: String) {
        let playerPath = database.child("games").child(gameCode).child("players").child(playerName)
        
        // Retrieve current cow count
        playerPath.observeSingleEvent(of: .value) { snapshot in
            if let playerData = snapshot.value as? [String: Any],
               let currentCows = playerData["cows"] as? Int {

                // Call the existing addToPlayerScore method, passing currentCows for both parameters
                self.addToPlayerScore(gameCode: gameCode, playerName: playerName, additionalBurgers: currentCows, additionalCows: -currentCows)
            } else {
                print("Error fetching current cow count.")
            }
        }
    }

    func observeLocalPlayerScore(gameCode: String, playerName: String) {
        let playerPath = database.child("games").child(gameCode).child("players").child(playerName)
        
        playerPath.observe(.value) { snapshot in
            if let playerData = snapshot.value as? [String: Any],
               let burgers = playerData["burgers"] as? Int,
               let cows = playerData["cows"] as? Int {
                self.localPlayerScore = "Burgers: \(burgers), Cows: \(cows)"
            } else {
                print("Error fetching local player score.")
            }
        }
    }
    
    func subtractAllCowsToScoreForAllExceptLocal(gameCode: String, localPlayerName: String) {
        let playersPath = database.child("games").child(gameCode).child("players")
        
        // Retrieve all players
        playersPath.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let playerName = childSnapshot.key as String?,
                   playerName != localPlayerName { // Exclude local player
                    
                    // Fetch the player's cow count
                    let playerData = childSnapshot.value as? [String: Any]
                    let currentCows = playerData?["cows"] as? Int ?? 0

                    // Update the player's cows and call addToPlayerScore
                    self.addToPlayerScore(gameCode: gameCode, playerName: playerName, additionalBurgers: 0, additionalCows: -currentCows)
                }
            }
        } withCancel: { error in
            print("Error subtracting all cows: \(error.localizedDescription)")
        }
    }

    func subtractHalfCowsToScoreForAllExceptLocal(gameCode: String, localPlayerName: String) {
        let playersPath = database.child("games").child(gameCode).child("players")
        
        // Retrieve all players
        playersPath.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let playerName = childSnapshot.key as String?,
                   playerName != localPlayerName { // Exclude local player
                    
                    // Fetch the player's cow count
                    let playerData = childSnapshot.value as? [String: Any]
                    let currentCows = playerData?["cows"] as? Int ?? 0
                    
                    // Subtract half the cows and call addToPlayerScore
                    self.addToPlayerScore(gameCode: gameCode, playerName: playerName, additionalBurgers: 0, additionalCows: -(currentCows / 2))
                }
            }
        } withCancel: { error in
            print("Error subtracting half cows: \(error.localizedDescription)")
        }
    }
    
    func addCowsToScoreDouble(gameCode: String, playerName: String) {
        let playerPath = database.child("games").child(gameCode).child("players").child(playerName)
        
        // Retrieve current cow count
        playerPath.observeSingleEvent(of: .value) { snapshot in
            if let playerData = snapshot.value as? [String: Any],
               let currentCows = playerData["cows"] as? Int {

                // Call the existing addToPlayerScore method, passing currentCows for both parameters
                self.addToPlayerScore(gameCode: gameCode, playerName: playerName, additionalBurgers: 0, additionalCows: currentCows)
            } else {
                print("Error fetching current cow count.")
            }
        }
    }
    
//    func loadPlayers(gameCode: String) {
//        database.child("games").child(gameCode).child("players").observe(.value) { snapshot in
//            var fetchedPlayers: [String] = []
//            for child in snapshot.children {
//                if let childSnapshot = child as? DataSnapshot,
//                   let playerData = childSnapshot.value as? [String: Any],
//                   let playerName = playerData["name"] as? String {
//                    fetchedPlayers.append(playerName)
//                }
//            }
//            self.players = fetchedPlayers // Update the players array
//        } withCancel: { error in
//            print("Error loading players: \(error.localizedDescription)")
//        }
//    }

}
