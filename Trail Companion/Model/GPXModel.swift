//
//  GPXModel.swift
//  Trail Companion
//
//  Created by Thomas Mary on 04/08/2023.
//

import Foundation
import SwiftUI
import XMLParsing
import CoreLocation

class GPX: Codable, Identifiable {
    var id: String?
    var version: String
    var creator: String
    var metadata: Metadata?
    var trk: Track?
    var wpt: [Waypoint]?
}

class Metadata: Codable {
    var name: String?
    var desc: String?
    var author: String?
    var copyright: String?
    var link: [Link]?
    
    init() {
        self.name = ""
        self.desc = ""
        self.author = ""
        self.copyright = ""
        self.link = []
    }
}

class Waypoint: Codable, Identifiable {
    var id: String?
    var lat: Double
    var lon: Double
    var time: Date?
    var name: String?
    var cmt: String?
    var desc: String?
    var type: String?
    var syml: String?
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: lat,
            longitude: lon)
    }
    
    var displayedNamed: String {
        guard let name else {
            return "Point"
        }
        
        return name
    }
}

class Link: Codable {
    var href: String
    var text: String
    
    init() {
        self.href = ""
        self.text = ""
    }
}

class Track: Codable {
    var name: String
    var trackSegments: [TrackSegment]
    
    init() {
        self.name = ""
        self.trackSegments = []
    }

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case trackSegments = "trkseg"
    }
}

class TrackSegment: Codable, Identifiable {
    var id = UUID().uuidString
    
    var trackPoints: [TrackPoint]

    enum CodingKeys: String, CodingKey {
        case trackPoints = "trkpt"
    }
}

class TrackPoint: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case elevation = "ele"
        case time
    }
    
    var id = UUID().uuidString
    
    var pos = 0
    var fromStart = 0.0
    
    var latitude: Double
    var longitude: Double
    var elevation: Double?
    var time: Date?
    
    var waypoint: Waypoint?
}
