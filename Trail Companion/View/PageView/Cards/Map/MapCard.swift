//
//  MapCard.swift
//  Trail Companion
//
//  Created by Thomas Mary on 18/08/2023.
//

import SwiftUI
import MapKit

struct MapCard: View {
    var viewModel: GPXViewModel
    
    var body: some View {
        @State var region = MKCoordinateRegion(center: viewModel.center, span: viewModel.mapSpan)
        
        VStack {
            Map(initialPosition: .region(MKCoordinateRegion(center: viewModel.center, span: viewModel.mapSpan))) {
                
                if let routePointsCoordinates = viewModel.routePointsCoordinates {
                    MapPolyline(coordinates: routePointsCoordinates)
                        .stroke(.red, lineWidth: 2)
                }
                
                ForEach(viewModel.wayPoints) { wpt in
                    Marker(wpt.displayedNamed, coordinate: wpt.locationCoordinate)
                }
                
                // Marker("Center", coordinate: viewModel.center)
            }
        }
    }
}

#Preview {
    MapCard(viewModel: GPXViewModel(gpx: gpxData))
}
