//
//  SectionRow.swift
//  Trail Companion
//
//  Created by Thomas Mary on 23/09/2023.
//

import SwiftUI

struct SectionRow: View {
    var section: Section
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionResume(section: section)
            SectionCumul(section: section)
            SectionStep(section: section)
        }
    }
}

struct SectionResume: View {
    var section: Section
    
    var body: some View {
        HStack {
            Text(section.name ?? "Name")
                .font(.headline)
        }
    }
}

struct SectionCumul: View {
    var section: Section
    
    var body: some View {
        HStack {
            if let lastPoint = section.points.last {
                Text(getDisplayedDistance(lastPoint.fromStart))
                Text("Alt : \(elevationFormat(lastPoint.elevation))")
            } else {
                Text("distance not found")
            }
            Text("D+ : \(elevationFormat(section.totalDenivPos))")
            Text("D- : \(elevationFormat(section.totalDenivNeg))")
        }
    }
}

struct SectionStep: View {
    var section: Section
    
    var body: some View {
        HStack {
            Text(getDisplayedDistance(section.sectionDistance))
            Text("D+ : \(elevationFormat(section.sectionDenivPos))")
            Text("D- : \(elevationFormat(section.sectionDenivNeg))")
        }
    }
}

#Preview {
    SectionRow(section: GPXViewModel(gpx: gpxData).sections.first!)
}
