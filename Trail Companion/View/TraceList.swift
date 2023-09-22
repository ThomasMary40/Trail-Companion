//
//  TraceList.swift
//  Trail Companion
//
//  Created by Thomas Mary on 14/08/2023.
//

import SwiftUI

struct TraceList: View {
    @State var gpxList = allGpx
    @State private var importing = false
    
    var body: some View {
        VStack {
            NavigationView {
                List(gpxList) { gpx in
                    let viewModel = GPXViewModel(gpx: gpx)
                    NavigationLink {
                        TraceDetail(viewModel: viewModel)
                    } label: {
                        TraceRow(viewModel: viewModel)
                    }
                }
                .navigationTitle("Traces")
                .toolbar {
                    Button("+") {
                        importing = true
                    }
                    .fileImporter(
                        isPresented: $importing,
                        allowedContentTypes: [.item]
                    ) { result in
                        switch result {
                        case .success(let file):
                            print(file.absoluteString)
                            guard let url = URL(string: file.absoluteString) else {
                                print("error")
                                return
                            }
                            
                            guard let importedGpx = addGpx(url) else {
                                print("error")
                                return
                            }
                            
                            gpxList.append(importedGpx)
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        // delete the objects here
    }
}

#Preview {
    TraceList()
}
