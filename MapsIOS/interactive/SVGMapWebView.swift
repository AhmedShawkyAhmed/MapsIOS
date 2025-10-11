//
//  SVGMapWebView.swift
//  MapsIOS
//
//  Created by Ahmed Shawky on 11/10/2025.
//

import SwiftUI
import WebKit


struct SVGMapWebView: UIViewRepresentable {
    @Binding var selectedCountry: String?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        
        // Add the message handler BEFORE creating the webView
        config.userContentController.add(context.coordinator, name: "countryTapped")
        print("🔧 Message handler 'countryTapped' added")
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.maximumZoomScale = 5.0
        webView.scrollView.minimumZoomScale = 1.0
        webView.isOpaque = false
        webView.backgroundColor = .white
        webView.scrollView.backgroundColor = .white
        
        // Add navigation delegate to track page loading
        webView.navigationDelegate = context.coordinator
        
        // Load SVG from file
        if let svgPath = Bundle.main.path(forResource: "map", ofType: "text"),
           let svgContent = try? String(contentsOfFile: svgPath, encoding: .utf8) {
            print("SVG loaded successfully, length: \(svgContent.count)")
            webView.loadHTMLString(createHTMLContent(with: svgContent), baseURL: nil)
        } else {
            print("Failed to load SVG file. Make sure 'map.text' is in your project.")
            loadErrorPage(webView)
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
    
}
