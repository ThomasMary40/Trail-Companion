//
//  TraceDetail.swift
//  Trail Companion
//
//  Created by Thomas Mary on 14/08/2023.
//

import SwiftUI

struct TraceDetail: View {
    var viewModel: GPXViewModel
    
    var body: some View {
        PageView(pages: [
            AnyView(ProfileCard(viewModel: viewModel)),
            AnyView(MapCard(viewModel: viewModel)),
            AnyView(SectionsCard(viewModel: viewModel))
        ])
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.gpx.trk?.name ?? "Détails")
    }
}

#Preview {
    TraceDetail(viewModel: GPXViewModel(gpx: gpxData))
}
