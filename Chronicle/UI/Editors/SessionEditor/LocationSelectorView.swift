//
//  LocationSelectorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/3/24.
//

import SwiftUI
import MapKit

struct LocationSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var viewModel: SessionEditorViewModel
    @State private var position: MapCameraPosition = .automatic
    @State private var searchResults: [LocationSearchResult] = []
    
    @State private var selectedResult: MKMapItem?
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var showSearchSheet: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $position) {
                    if let selectedResult {
                        Marker(selectedResult.name ?? "Selected Location", coordinate: selectedResult.placemark.coordinate)
                    } else {
                        ForEach(searchResults) { result in
                            Marker(coordinate: result.item.placemark.coordinate) {
                                Image(systemName: "mappin")
                            }
                            .tag(result)
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .onMapCameraChange { context in
                    visibleRegion = context.region
                }
                .ignoresSafeArea()
                .sheet(isPresented: $showSearchSheet) {
                    LocationSearchSheetView(selectedResult: $selectedResult, visibleRegion: $visibleRegion, position: $position, searchResults: $searchResults)
                        .interactiveDismissDisabled()
                        .presentationDetents([.height(200), .large])
                        .presentationBackground(.regularMaterial)
                        .presentationBackgroundInteraction(.enabled(upThrough: .large))
                }
                
                
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .buttonStyle(.close)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        
    }
    
    
}

struct LocationSearchSheetView: View {
    @Binding var selectedResult: MKMapItem?
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var position: MapCameraPosition
    @Binding var searchResults: [LocationSearchResult]
    
    @State private var searchText = ""
    
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search for a location", text: $searchText)
                    .autocorrectionDisabled()
                    .padding(.vertical, 8)
                    .onSubmit {
                        searchLocation(query: searchText)
                    }
            }
            .padding(.horizontal, 8)
            .background(Color(.systemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 12))
            .padding()
            Spacer()
            if !searchResults.isEmpty {
                List(searchResults) { result in
                    Button {
                        withAnimation {
                            selectedResult = result.item
                            position = .region(MKCoordinateRegion(center: result.item.placemark.coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                        }
                    } label: {
                        VStack(alignment: .leading) {
                            Text(result.item.name ?? "")
                                .font(.headline)
                            Text(result.item.placemark.title ?? "")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .contentMargins(.top, 0)
                .scrollContentBackground(.hidden)
            }
        }
    }
    
    private func searchLocation(query: String) {
        guard !query.isEmpty else {
            self.searchResults = []
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = visibleRegion ?? MKCoordinateRegion(center: .init(), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.searchResults = response.mapItems.compactMap { item in
                guard item.placemark.location?.coordinate != nil else { return nil }
                
                return LocationSearchResult(item: item)
            }
        }
    }
}

struct LocationSearchResult: Identifiable, Hashable {
    let id = UUID()
    let item: MKMapItem
    
    static func == (lhs: LocationSearchResult, rhs: LocationSearchResult) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#Preview {
    @Previewable @State var sessionViewModel = SessionEditorViewModel()
        VStack {}
            .sheet(isPresented: .constant(true)) {
                LocationSelectorView(viewModel: $sessionViewModel)
            }
}
