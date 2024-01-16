//
//  ShopMateApp.swift
//  ShopMate
//
//  Created by שיראל זכריה on 14/01/2024.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import BackgroundTasks
import GoogleSignIn
import UIKit
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Initializetion code for firebase
        FirebaseApp.configure()
        
        // Initialize the Mobile Ads SDK
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
    
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    
}
@main
struct ShopMateApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var authState = AuthState()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authState)
                .onAppear {
                    // Ensure Firebase is configured only once
                    if FirebaseApp.app() == nil {
                        FirebaseApp.configure()
                    }
                    
                    authState.isAuthenticated = Auth.auth().currentUser != nil
                }
        }
    }
}
