//
//  ProfileView.swift
//  Trail Companion
//
//  Created by Thomas Mary on 05/09/2023.
//

import SwiftUI
import Charts

struct ProfileView: View {
    var viewModel: GPXViewModel
    
    var body: some View {
        getChart(points: viewModel.viablePoints)
    }
    
    func getChart(points: [TrackPoint]) -> some View {
        Chart(points) {
            let wpt = $0.waypoint
            let distance = $0.fromStart/1000.0
            let elevation = $0.elevation ?? 0
            
            LineMark(
                x: .value("Distance", distance),
                y: .value("Elevation", elevation)
            )
            .foregroundStyle(
                .linearGradient(
                    colors: [.green, .red],
                    startPoint: .bottom,
                    endPoint: .top)
            )
            
            if wpt != nil {
                PointMark(
                    x: .value("Distance", distance),
                    y: .value("Elevation", elevation)
                )
//                .foregroundStyle(by: .value("Elevation", $0.elevation ?? 0.0))
                .opacity(1.0)
                .annotation(position: .overlay,
                            alignment: .bottom,
                            spacing: 10) {
//                    Text(wpt?.name ?? "")
//                        .font(.footnote)
                    
                }
                
            }
        }
        // .foregroundStyle(.orange)
        // .clipped(antialiased: true)
        .chartXAxisLabel("Distance", alignment: .center)
        .chartYAxisLabel("Elevation")
        .chartYAxis {
            AxisMarks(position: .leading, values: stride(
                from: viewModel.eleMin.toNearestLow(),
                to: viewModel.eleMax.toNearestUp(),
                by: viewModel.profilDenivAmpl).map { $0 })
        }
        .chartXAxis {
            AxisMarks(position: .bottom,
                      values: stride(
                        from: 0,
                        to: viewModel.distanceInKilometers,
                        by: 10).map { $0 })
        }
        .chartYScale(domain: .automatic(includesZero: false))
        .chartXScale(domain: .automatic())
    }
}

#Preview {
    ProfileView(viewModel: GPXViewModel(gpx: gpxData))
}
