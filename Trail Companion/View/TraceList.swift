//
//  TraceList.swift
//  Trail Companion
//
//  Created by Thomas Mary on 14/08/2023.
//

import SwiftUI
import OSLog

struct TraceList: View {
    @State var gpxList = allGpx
    @State private var importing = false
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(gpxList) { gpx in
                        let viewModel = GPXViewModel(gpx: gpx)
                        NavigationLink {
                            TraceDetail(viewModel: viewModel)
                        } label: {
                            TraceRow(viewModel: viewModel)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        delete(at: indexSet)
                    })
                    .onMove(perform: { indices, newOffset in
                        gpxList.move(fromOffsets: indices, toOffset: newOffset)
                    })
                }
                .navigationTitle("Traces")
                .toolbar {
                    ToolbarItemGroup {
                        EditButton()
                        Spacer()
                        Button("+") {
                            importing = true
                        }
                        .fileImporter(
                            isPresented: $importing,
                            allowedContentTypes: [.item]
                        ) { result in
                            switch result {
                            case .success(let file):
                                Logger.files.info("\(file.absoluteString)")
                                guard let url = URL(string: file.absoluteString) else {
                                    Logger.files.error("Error : no file at \(file.absoluteString)")
                                    return
                                }
                                
                                guard let importedGpx = addGpx(url) else {
                                    Logger.files.error("Error adding gpx at \(file.absoluteString)")
                                    return
                                }
                                
                                gpxList.append(importedGpx)
                                
                            case .failure(let error):
                                Logger.files.error("\(error.localizedDescription)")
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        gpxList.remove(atOffsets: offsets)
    }
}

#Preview {
    TraceList()
}
