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
                
                if let wpts = viewModel.wayPoints {
                    ForEach(wpts) { wpt in
                        Marker(wpt.displayedNamed, coordinate: wpt.locationCoordinate)
                    }
                }
                
                // Marker("Test", coordinate: viewModel.center)
            }
            
//            Map(coordinateRegion: $region, annotationItems: viewModel.wayPoints!) { item in
//                MapMarker(coordinate: item.locationCoordinate)
//            }
        }
    }
}

#Preview {
    MapCard(viewModel: GPXViewModel(gpx: gpxData))
}

struct MapAnnotation: Identifiable {
    var id = UUID()
    var name: String
    var coordinates: CLLocationCoordinate2D
}
