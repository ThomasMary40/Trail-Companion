//
//  TraceRow.swift
//  Trail Companion
//
//  Created by Thomas Mary on 14/08/2023.
//

import SwiftUI

struct TraceRow: View {
    
    var viewModel: GPXViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            FirstLine(viewModel: viewModel)
            SecondLine(viewModel: viewModel)
            ThirdLine(viewModel: viewModel)
        }
    }
}

struct FirstLine: View {
    var viewModel: GPXViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.gpx.metadata?.name ?? "")
                .font(.title)
        }
    }
}

struct SecondLine: View {
    var viewModel: GPXViewModel
    
    var body: some View {
        HStack {
            Text("Distance : \(getDisplayedDistance(viewModel.distanceInMeters))")
        }
    }
}

struct ThirdLine: View {
    var viewModel: GPXViewModel
    
    var body: some View {
        let positive = viewModel.positiveDeniv
        let negative = viewModel.negativeDeniv
        HStack {
            if positive > 0 || negative > 0 {
                Text("Elevation : \(elevationFormat(positive)) D+ | \(elevationFormat(negative)) D-")
            }
        }
    }
}

#Preview {
    TraceRow(viewModel: GPXViewModel(gpx: gpxData))
        .previewLayout(.fixed(width: 300, height: 70))
}

func elevationFormat(_ number: Double) -> String {
    let customFormatter = NumberFormatter()
    customFormatter.roundingMode = .down
    customFormatter.maximumFractionDigits = 0
    
    return customFormatter.string(from: NSNumber(value: number)) ?? ""
}

func getDisplayedDistance(_ from: Double) -> String {
    let measurement = Measurement(value: from, unit: UnitLength.meters)
    let formatter = MeasurementFormatter()
    
    formatter.locale = Locale(identifier: "fr_FR")
    
    return formatter.string(from: measurement)
}

func getDisplayedElevation(_ from: Double) -> String {
    let formatter = LengthFormatter()
    formatter.isForPersonHeightUse = true
    formatter.unitStyle = .medium
        
    return formatter.string(fromMeters: from)
}
