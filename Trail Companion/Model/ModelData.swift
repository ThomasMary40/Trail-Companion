//
//  ModelData.swift
//  Trail Companion
//
//  Created by Thomas Mary on 04/08/2023.
//
import SwiftUI
import XMLParsing
import UniformTypeIdentifiers
import OSLog

var gpxData: GPX = load("GRP120_T1.gpx")
var allGpx: [GPX] = loadAll()
let emptyGpx: [GPX] = [GPX]()
let gpxUTType = UTType("com.trailcompanion.gpx")

final class ModelData: ObservableObject {
    @Published var allGpx: [GPX] = loadAll()
    @Published var gpxData: GPX = load("GRP120_T1.gpx")
}

// Load from "Data" folder
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = XMLDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func getGpxDocumentDir() -> URL {
    let filemgr = FileManager.default
    
    let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
    let docsDir = dirPaths[0]
    
    Logger.files.info("Path : \(docsDir)")
    
    return docsDir
}

func addGpx(_ from: URL) -> GPX? {
    let filemgr = FileManager.default
    let toGoUrl = getGpxDocumentDir().appending(path: from.lastPathComponent)
    
    if from.startAccessingSecurityScopedResource() {
        do {
            try filemgr.copyItem(at: from, to: toGoUrl)
            Logger.files.info("file copied sucessfully to \(toGoUrl)")
            
            return loadFromApplicationDocument(toGoUrl)
        } catch {
            Logger.files.error("error moving file to \(toGoUrl) : \(error.localizedDescription)")
            return nil
        }
    } else {
        return nil
    }
}

// Load from "Document" app folder
func loadFromApplicationDocument<T: Decodable>(_ url: URL) -> T {
    Logger.files.info("Loading file at \(url.absoluteString)")
    
    let filemgr = FileManager.default
    let data: Data

    guard filemgr.fileExists(atPath: url.relativePath)
    else {
        Logger.files.error("Couldn't find \(url.relativePath) in main bundle.")
        fatalError()
    }

    do {
        data = try Data(contentsOf: url)
    } catch {
        Logger.files.error("Couldn't load \(url.relativePath) from main bundle:\n\(error)")
        fatalError()
    }

    do {
        let decoder = XMLDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        Logger.files.error("Couldn't parse \(url.relativePath) as \(T.self):\n\(error)")
        fatalError()
    }
}

func loadAll() -> [GPX] {
    var gpxs = [GPX]()
    let filemgr = FileManager.default
    do {
        let filelist = try filemgr.contentsOfDirectory(atPath: getGpxDocumentDir().relativePath)
        Logger.files.info("Number of files to load : \(filelist.endIndex)")
        for filename in filelist {
            Logger.files.info("Loading \(filename) ...")
            if filename.lowercased().hasSuffix(".gpx") {
                let url = getGpxDocumentDir().appending(component: filename)
                let gpx = loadFromApplicationDocument(url) as GPX
                gpx.id = UUID().uuidString
                gpxs.append(gpx)
                Logger.files.info("GPX \(gpx.metadata?.name ?? "Unknow") Added")
            }
        }
    } catch let error {
        Logger.files.error("Error loading all files : \(error.localizedDescription)")
    }

    return gpxs
}
