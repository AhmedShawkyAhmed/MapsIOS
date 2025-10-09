//
//  AppDelegateAdapter.swift
//  MapsIOS
//
//  Created by Ahmed Shawky on 09/10/2025.
//


import SwiftUI
import GoogleMaps

class AppDelegateAdapter: NSObject, UIApplicationDelegate {
    
    private let googleMapsAPIKey = "AIzaSyAtHSDd-jAFuhWwxDA1NDHeL2RL3XCLKZY" 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        GMSServices.provideAPIKey(googleMapsAPIKey)
        
        return true
    }
    
}
