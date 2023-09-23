//
//  ProfileCard.swift
//  Trail Companion
//
//  Created by Thomas Mary on 17/08/2023.
//

import SwiftUI

struct ProfileCard: View {
    var viewModel: GPXViewModel
    
    var body: some View {
        ProfileView(viewModel: viewModel)
    }
}

#Preview {
    ProfileCard(viewModel: GPXViewModel(gpx: gpxData))
}
