//
//  GPXViewModel.swift
//  Trail Companion
//
//  Created by Thomas Mary on 09/08/2023.
//

import Foundation
import CoreLocation
import MapKit

class GPXViewModel {
    let gpx: GPX
    var lastPoint: TrackPoint?
    var viablePoints = [TrackPoint]()
    
    // technical data
    var totalPoints = 0
    
    // Elevation datas
    var positiveDeniv = 0.0
    var negativeDeniv = 0.0
    
    // maps data
    var latMin = 0.0
    var latMax = 0.0
    var longMin = 0.0
    var longMax = 0.0
    var eleMin = 0.0
    var eleMax = 0.0
    
    var wayPoints = gpxData.wpt
    
    lazy var profilDenivAmpl: Double = {
        if elevationAmplitude < 50 {
            return 5
        }
        
        if elevationAmplitude < 200 {
            return 10
        }
        
        if elevationAmplitude < 1000 {
            return 50
        }
        
        return 100
    }()
    
    lazy var elevationAmplitude: Double = {
        eleMax - eleMin
    }()
    
    lazy var distanceInMeters: Double = {
        lastPoint?.fromStart ?? 0.0
    }()
    
    lazy var distanceInKilometers: Double = {
        distanceInMeters / 1000.0
    }()
    
    lazy var region: MKCoordinateRegion = {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 42.360256, longitude: -71.057279),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }()
    
    lazy var center: CLLocationCoordinate2D = {
        let lat = (latMax + latMin) / 2.0
        let lon = (longMax + longMin) / 2.0
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }()
    
    lazy var mapSpan: MKCoordinateSpan = {
        let latDelta = latMax - latMin + 0.05
        let longDelta = longMax - longMin + 0.05
        
        return MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
    }()
    
    lazy var routePointsCoordinates: [CLLocationCoordinate2D]? = {
        
        guard let trk = gpx.trk else {
            return nil
        }
        
        var points = [CLLocationCoordinate2D]()
        
        for segment in trk.trackSegments {
            for point in segment.trackPoints {
                let newPoint = CLLocationCoordinate2D.init(latitude: point.latitude, longitude: point.longitude)
                points.append(newPoint)
            }
        }
        
        return points
    }()
    
    init(gpx: GPX) {
        self.gpx = gpx
        // print("init view model")
        guard let trk = gpx.trk else {
            return
        }
        
        for segment in trk.trackSegments {
            lastPoint = segment.trackPoints.last
            
            var previousPoint: TrackPoint?
            var cpt = 0
            
            totalPoints += segment.trackPoints.count
            
            for point in segment.trackPoints {
                
                if previousPoint == nil {
                    latMin = point.latitude
                    latMax = point.latitude
                    longMin = point.longitude
                    longMax = point.longitude
                    eleMin = point.elevation ?? 0.0
                    eleMax = point.elevation ?? 0.0
                } else {
                    if latMin > point.latitude {
                        latMin = point.latitude
                    }
                    
                    if point.latitude > latMax {
                        latMax = point.latitude
                    }
                    
                    if longMin > point.longitude {
                        longMin = point.longitude
                    }
                    
                    if point.longitude > longMax {
                        longMax = point.longitude
                    }
                    
                    if let elevation = point.elevation {
                        if elevation > eleMax {
                            eleMax = elevation
                        }
                        
                        if eleMin > elevation {
                            eleMin = elevation
                        }
                    }
                }
                
                if point.elevation ?? 0.0 > 0.0 {
                    point.pos = cpt
                    viablePoints.append(point)
                    cpt += 1
                }
                
                if let previousPoint {
                    point.fromStart = previousPoint.fromStart + distanceBetween(previousPoint, point)
                }
                
                previousPoint = point
            }
            
            // On retire les 1 premiers et 1 derniers points de la liste pour ne pas avoir les waypoints 'start' et 'finish'
            var adjustedPoints = segment.trackPoints
            adjustedPoints.removeFirst(1)
            adjustedPoints.removeLast(1)
            
            if let waypoints = gpx.wpt {
                for waypoint in waypoints {
                    let point = adjustedPoints.filter {
                        $0.latitude == waypoint.lat &&
                        $0.longitude == waypoint.lon
                    }.first
                    
                    if point != nil {
                        point!.waypoint = waypoint
                    }
                }
            }
        }
        
        calculateDeniv()
        
        // print("Viable points : \(viablePoints.count) / \(totalPoints)")
    }
    
    func getFilteredPoints() -> [TrackPoint] {
        viablePoints
    }
    
    func calculateDeniv() {
        
        var previousPoint: TrackPoint?
        
        for point in viablePoints {
            if previousPoint != nil {
                let currentElevation = point.elevation ?? 0.0
                let previousElevation = previousPoint?.elevation ?? 0.0
                
                if currentElevation > previousElevation {
                    positiveDeniv += currentElevation - previousElevation
                } else if currentElevation < previousElevation {
                    negativeDeniv += previousElevation - currentElevation
                }
            }
            previousPoint = point
        }
    }
    
    func getTotalDistance() -> Double {

        guard let trk = gpx.trk else {
            return 0.0
        }
        
        guard let points = trk.trackSegments.first?.trackPoints else {
            return 0.0
        }
        
        var total = 0.0
        var previousPoint: TrackPoint?
        
        for point in points {
            if previousPoint != nil {
                let coordinate0 = CLLocation(latitude: previousPoint!.latitude, longitude: previousPoint!.longitude)
                let coordinate1 = CLLocation(latitude: point.latitude, longitude: point.longitude)
                
                total += coordinate0.distance(from: coordinate1)
            }
            
            previousPoint = point
        }
        
        return total
    }
    
    func distanceBetween(_ point1: TrackPoint, _ point2: TrackPoint) -> Double {
        let coordinate0 = CLLocation(latitude: point1.latitude, longitude: point1.longitude)
        let coordinate1 = CLLocation(latitude: point2.latitude, longitude: point2.longitude)
        
        return coordinate0.distance(from: coordinate1)
    }
}

extension Double {
    func toNearestLow() -> Double {
        var stringValue = "\(Int(self))"
        stringValue.removeLast()
        stringValue.append("0")
        
        return Double(stringValue) ?? 0.0
    }
    
    func toNearestUp() -> Double {
        
        guard self > 10.0 else {
            return 10.0
        }
        
        var stringValue = "\(Int(self))"
        let lastChar = stringValue.removeLast()
        let intLast = Int("\(lastChar)") ?? 0
        
        guard intLast > 0 else {
            return self
        }

        var intDizaine = Int("\(stringValue.removeLast())") ?? 0
        var intCentaine = Int("\(stringValue.removeLast())") ?? 0
        var intMil = Int("\(stringValue.removeLast())") ?? 0
        
        intDizaine += 1
        
        if intDizaine > 9 {
            intDizaine = 0
            intCentaine += 1
            
            if intCentaine > 9 {
                intCentaine = 0
                intMil += 1
            }
        }
        
        // Ont met 1 pour frocer l'affichage d'une ligne horizontale sur une chiffre rond
        // Par exemple, suir le GRR, on est à 2500, ilf aut mettre 2501 pour afficher la dernière barre
        stringValue.append("\(intMil)\(intCentaine)\(intDizaine)1")
        
        return Double(stringValue) ?? 0.0
    }
}
