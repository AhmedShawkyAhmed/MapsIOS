//
//  Coordinator.swift
//  MapsIOS
//
//  Created by Ahmed Shawky on 11/10/2025.
//

import WebKit

class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
    var parent: SVGMapWebView
    
    init(_ parent: SVGMapWebView) {
        self.parent = parent
    }
    

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView finished loading")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("❌ WebView navigation failed: \(error)")
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            print("Message received: \(message.name)")
//            print("Message body: \(message.body)")
        
        if message.name == "countryTapped" {
            if let countryName = message.body as? String {
                print("Country selected: \(countryName)")
                DispatchQueue.main.async {
                    self.parent.selectedCountry = countryName
                }
            } else {
                print("Failed to cast message body to String")
            }
        }
    }
}
