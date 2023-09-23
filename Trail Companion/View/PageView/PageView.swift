//
//  PageView.swift
//  Trail Companion
//
//  Created by Thomas Mary on 17/08/2023.
//

import SwiftUI

enum TracePage: String, CaseIterable {
    case profil
    case carte
    case segments
    
    var pageName: String {
        switch self {
        case .profil:
            "Profil"
        case .carte:
            "Carte"
        case .segments:
            "Segments"
        }
    }
}

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0
    @State private var currentlyPicked = TracePage.profil
    
    var body: some View {
        VStack {
            
            Picker("Current page", selection: $currentlyPicked) {
                ForEach(TracePage.allCases, id: \.self) {
                    Text($0.pageName)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: currentlyPicked) { _, newValue in
                switch newValue {
                case .profil:
                    currentPage = 0
                case .carte:
                    currentPage = 1
                case .segments:
                    currentPage = 2
                }
            }
            
            PageViewController(pages: pages, currentPage: $currentPage)
                .onChange(of: currentPage) { _, newValue in
                    switch newValue {
                    case 0:
                        currentlyPicked = .profil
                    case 1:
                        currentlyPicked = .carte
                    case 2:
                        currentlyPicked = .segments
                    default:
                        break
                    }
                }
        }
    }
    
    fileprivate func getTitle(_ atIndex: Int) -> Text {
        switch atIndex {
        case 0:
            return Text("Profil")
            
        case 1:
            return Text("Carte")
            
        case 2:
            return Text("Sections")
            
        default:
            return Text("Inconnu")
        }
    }
}

#Preview {
    PageView(
        pages: [
            AnyView(ProfileCard(viewModel: GPXViewModel(gpx: gpxData))),
            AnyView(MapCard(viewModel: GPXViewModel(gpx: gpxData))),
            AnyView(SectionsCard(viewModel: GPXViewModel(gpx: gpxData)))
        ]
    )
    // .aspectRatio(3 / 2, contentMode: .fit)
}
