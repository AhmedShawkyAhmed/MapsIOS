//
//  InteractiveWorldMap.swift
//  MapsIOS
//
//  Created by Ahmed Shawky on 10/10/2025.
//

import SwiftUI
import WebKit


struct InteractiveWorldMap: View {
    @State private var selectedCountry: String?
    
    var body: some View {
            // SVG Map Container
            SVGMapWebView(selectedCountry: $selectedCountry)
                .ignoresSafeArea()
    }
}

#Preview {
    InteractiveWorldMap()
}
