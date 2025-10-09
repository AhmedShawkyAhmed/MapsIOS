//
//  AppDelegateAdapter.swift
//  MapsIOS
//
//  Created by Ahmed Shawky on 09/10/2025.
//


import SwiftUI
import GoogleMaps

class AppDelegateAdapter: NSObject, UIApplicationDelegate {
    
    // Replace "YOUR_API_KEY" with your actual key
    private let googleMapsAPIKey = "AIzaSyAtHSDd-jAFuhWwxDA1NDHeL2RL3XCLKZY" 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Initialize the Google Maps SDK
        GMSServices.provideAPIKey(googleMapsAPIKey)
        
        return true
    }
    
    // You can implement other UIApplicationDelegate methods here if needed
}
