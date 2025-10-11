//
//  LoadErrorPage.swift
//  MapsIOS
//
//  Created by Ahmed Shawky on 11/10/2025.
//

import WebKit

func loadErrorPage(_ webView: WKWebView) {
    webView.loadHTMLString("""
        <html>
        <body style="font-family: -apple-system; padding: 20px; text-align: center;">
            <h2>Error: SVG file not found</h2>
            <p>Please add 'map.text' to your Xcode project.</p>
            <ol style="text-align: left;">
                <li>Drag and drop 'map.text' into Xcode</li>
                <li>Make sure "Add to targets" is checked</li>
                <li>Rebuild the app</li>
            </ol>
        </body>
        </html>
    """, baseURL: nil)
}
