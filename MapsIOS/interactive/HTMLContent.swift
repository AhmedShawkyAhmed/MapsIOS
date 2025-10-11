//
//  HTMLContent.swift
//  MapsIOS
//
//  Created by Ahmed Shawky on 11/10/2025.
//

import Foundation

private func escapeForJS(_ string: String) -> String {
    return string
        .replacingOccurrences(of: "\\", with: "\\\\")
        .replacingOccurrences(of: "`", with: "\\`")
        .replacingOccurrences(of: "$", with: "\\$")
}

// Create HTML with embedded SVG and interaction
func createHTMLContent(with svgContent: String) -> String {
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                -webkit-user-select: none;
                user-select: none;
                -webkit-tap-highlight-color: transparent;
                touch-action: auto;
            }
            
            body {
                background: #f5f5f5;
                overflow: hidden;
                font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            }
            
            #map-container {
                width: 100%;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
                background: #ffffff;
            }
            
            svg {
                width: 100%;
                height: auto;
                max-width: 2000px;
            }
            
            /* Default country styles */
            path {
                fill: #e0e0e0;
                stroke: #ffffff;
                stroke-width: 0.5;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            
            /* Selected state - dark blue */
            path.selected {
                fill: #1e3a8a !important;
                stroke: #1e40af;
                stroke-width: 1.5;
            }
            
    
            /* Active/pressed state */
            /*
            path:active {
                fill: #1e4000 !important;
            }
            */
            
            circle {
                display: none;
            }
        </style>
    </head>
    <body>
        <div id="map-container">
            <!-- SVG will be loaded here -->
        </div>
        
        <script>
            // Load and parse the SVG
            const svgContent = `\(escapeForJS(svgContent))`;
            document.getElementById('map-container').innerHTML = svgContent;
            
            let selectedElement = null;
            
            // Get all path elements
            const paths = document.querySelectorAll('svg path');
            
            paths.forEach((path, index) => {
                // Get country name from various attributes
                let countryName = path.getAttribute('name') || 
                                 path.getAttribute('id') || 
                                 path.getAttribute('class') || 
                                 '';
                
                // Clean up the name
                countryName = countryName.trim();
                
                // Make all paths interactive
                if (countryName && countryName.length > 0) {
                    path.setAttribute('data-country', countryName);
                } else {
                    countryName = `Region ${index + 1}`;
                    path.setAttribute('data-country', countryName);
                }
                
                // Add click event
                path.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    // Remove previous selection
                    if (selectedElement) {
                        selectedElement.classList.remove('selected');
                    }
                    
                    // Add new selection
                    this.classList.add('selected');
                    selectedElement = this;
                    
                    // Get the country name
                    const country = this.getAttribute('data-country') || 
                                  this.getAttribute('name') || 
                                  this.getAttribute('id') || 
                                  this.getAttribute('class') || 
                                  'Unknown Country';
                    
                    // Send to Swift
                    try {
                        if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.countryTapped) {
                            window.webkit.messageHandlers.countryTapped.postMessage(country);
                        }
                    } catch(err) {
                        console.error('Error sending message:', err);
                    }
                });
            });
        </script>
    </body>
    </html>
    """
}
