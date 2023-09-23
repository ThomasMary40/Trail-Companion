//
//  SectionsCard.swift
//  Trail Companion
//
//  Created by Thomas Mary on 22/08/2023.
//

import SwiftUI

struct SectionsCard: View {
    var viewModel: GPXViewModel
    
    var body: some View {
        List(viewModel.sections) { section in
            SectionRow(section: section)
        }
    }
}

#Preview {
    SectionsCard(viewModel: GPXViewModel(gpx: gpxData))
}
