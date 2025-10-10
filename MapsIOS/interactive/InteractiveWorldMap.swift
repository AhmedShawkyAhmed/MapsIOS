import SwiftUI
import WebKit

// MARK: - Main View
struct InteractiveWorldMap: View {
    @State private var selectedCountry: String?
    
    var body: some View {
        VStack(spacing: 0) {
            // SVG Map Container
            SVGMapWebView(selectedCountry: $selectedCountry)
                .ignoresSafeArea()
        }
        .animation(.spring(response: 0.3), value: selectedCountry)
    }
}

// MARK: - WebView for SVG
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
    
    private func loadErrorPage(_ webView: WKWebView) {
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
    
    class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        var parent: SVGMapWebView
        
        init(_ parent: SVGMapWebView) {
            self.parent = parent
        }
        
        // MARK: - WKNavigationDelegate
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("WebView finished loading")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ WebView navigation failed: \(error)")
        }
        
        // MARK: - WKScriptMessageHandler
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("Message received: \(message.name)")
            print("Message body: \(message.body)")
            
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
                }
                
                body {
                    background: #f5f5f5;
                    overflow: auto;
                    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                    touch-action: manipulation;
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
                
                /* Hover effect - light blue */
                path:hover {
                    fill: #87ceeb !important;
                    stroke: #4682b4;
                    stroke-width: 1;
                }
                
                /* Selected state - dark blue */
                path.selected {
                    fill: #1e3a8a !important;
                    stroke: #1e40af;
                    stroke-width: 1.5;
                }
                
                /* Active/pressed state */
                path:active {
                    fill: #1e40af !important;
                }
                
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
    
    private func escapeForJS(_ string: String) -> String {
        return string
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "`", with: "\\`")
            .replacingOccurrences(of: "$", with: "\\$")
    }
}

// MARK: - Preview
#Preview {
    InteractiveWorldMap()
}

/*
 INSTRUCTIONS FOR YOUR SVG:
 
 1. Copy your entire SVG content from the file
 2. Replace the svgContent variable in createHTMLContent() with your SVG
 3. The solution will automatically:
    - Detect all path elements
    - Extract country names from 'name', 'id', or 'class' attributes
    - Add click handlers
    - Apply styling
    - Send country name to Swift when tapped
 
 4. Your SVG already has:
    - id attributes (like "AF", "AO", "AR")
    - name attributes (like "Afghanistan", "Angola", "Argentina")
    - class attributes (like "Angola", "Argentina", "Australia")
 
 5. The code handles all three automatically!
 
 ALTERNATIVE: Load from file
 If you want to load from a file instead:
 1. Add your SVG file to Xcode project
 2. Use this code in makeUIView:
 
 if let svgPath = Bundle.main.path(forResource: "world-map", ofType: "svg"),
    let svgString = try? String(contentsOfFile: svgPath) {
    webView.loadHTMLString(createHTMLContent(with: svgString), baseURL: nil)
 }
*/
