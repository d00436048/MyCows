//
//  My_CowsREALApp.swift
//  My CowsREAL
//
//  Created by Bridger Hall on 10/31/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct My_CowsREALApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var viewRouter = ViewRouter()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewRouter)
                    }
    }
}
