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
    @Binding var locationInfo: LocationInfo?
    @State private var position: MapCameraPosition = .automatic
    @State private var mapResults = Set<LocationSearchResult>()
    
    @State private var selectedResult: LocationSearchResult?
    @State private var selectedMarker: MKMapItem?
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var showSearchSheet: Bool = true
    
    @State private var selectedDetent: PresentationDetent = .height(200)
    @State private var openSelectedResult: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $position, selection: $selectedMarker) {
                    ForEach(Array(mapResults)) { result in
                        Marker(coordinate: result.item.placemark.coordinate) {
                            Image(systemName: "mappin")
                        }
                        .tag(result.item)
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
                .onChange(of: selectedMarker) { _, newValue in
                    if let newValue {
                        withAnimation {
                            selectedResult = LocationSearchResult(item: newValue)
                            position = .region(MKCoordinateRegion(center: newValue.placemark.coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                        }
                        openSelectedResult = true
                    }
                }
                .ignoresSafeArea()
                .sheet(isPresented: $showSearchSheet) {
                    LocationSearchSheetView(locationInfo: $locationInfo, selectedResult: $selectedResult, visibleRegion: $visibleRegion, position: $position, mapResults: $mapResults, selectedMarker: $selectedMarker, selectedDetent: $selectedDetent, openSelectedResult: $openSelectedResult, parentDismiss: dismiss)
                        .interactiveDismissDisabled()
                        .presentationDetents([.height(200), .large], selection: $selectedDetent)
                        .presentationBackground {
                            Rectangle()
                                .fill(.regularMaterial)
                                .padding(.bottom, -1000)
                        }
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
            }
        }
    }
}

struct LocationSearchSheetView: View {
    @Binding var locationInfo: LocationInfo?
    @Binding var selectedResult: LocationSearchResult?
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var position: MapCameraPosition
    @Binding var mapResults: Set<LocationSearchResult>
    @Binding var selectedMarker: MKMapItem?
    @Binding var selectedDetent: PresentationDetent
    
    @State private var searchResults: [LocationSearchResult] = []
    @State private var searchText = ""
    
    @Binding var openSelectedResult: Bool
    @FocusState private var isSearchFocused: Bool
    
    var parentDismiss: DismissAction
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search for a location", text: $searchText)
                    .autocorrectionDisabled()
                    .padding(.vertical, 8)
                    .focused($isSearchFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        searchLocation(query: searchText, addToMap: true)
                    }
                    .onChange(of: searchText) { _, newValue in
                        searchLocation(query: newValue)
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
                        selectedDetent = .height(200)
                        withAnimation {
                            isSearchFocused = false
                            selectedResult = result
                            mapResults = Set(searchResults)
                            position = .region(MKCoordinateRegion(center: result.item.placemark.coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                            selectedMarker = result.item
                        }
                        openSelectedResult = true
                    } label: {
                        VStack(alignment: .leading) {
                            Text(result.item.name ?? "")
                                .font(.headline)
                            Text(result.item.placemark.title ?? "")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .contentMargins(.top, 0)
                .scrollContentBackground(.hidden)
            }
        }
        .sheet(isPresented: $openSelectedResult) {
            SelectedLocationView(locationInfo: $locationInfo, selectedResult: $selectedResult, selectedMarker: $selectedMarker, searchResults: $searchResults, mapResults: $mapResults, position: $position, isOpen: $openSelectedResult, parentDismiss: parentDismiss)
                .interactiveDismissDisabled()
                .presentationDetents([.height(220), .medium])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        }
    }
    
    private func searchLocation(query: String, addToMap: Bool = false) {
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
            
            if addToMap {
                withAnimation {
                    self.mapResults = Set(response.mapItems.compactMap { item in
                        guard item.placemark.location?.coordinate != nil else { return nil }
                        
                        return LocationSearchResult(item: item)
                    })
                    self.position = .automatic
                }
            }
            self.searchResults = response.mapItems.compactMap { item in
                guard item.placemark.location?.coordinate != nil else { return nil }
                
                return LocationSearchResult(item: item)
            }
        }
    }
}

struct SelectedLocationView: View {
    @Binding var locationInfo: LocationInfo?
    @Binding var selectedResult: LocationSearchResult?
    @Binding var selectedMarker: MKMapItem?
    @Binding var searchResults: [LocationSearchResult]
    @Binding var mapResults: Set<LocationSearchResult>
    @Binding var position: MapCameraPosition
    @Binding var isOpen: Bool
    
    var parentDismiss: DismissAction
    
    var body: some View {
        if let selectedResult {
            NavigationStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text(selectedResult.item.name ?? "")
                        .font(.title2.weight(.medium))
                        .fontDesign(.rounded)
                    if let address = selectedResult.item.placemark.title {
                        DetailSection(header: "Details") {
                            Text(address)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close", systemImage: "xmark.circle.fill") {
                            Task {
                                isOpen = false
                                withAnimation {
                                    mapResults = Set(searchResults)
                                    self.selectedResult = nil
                                    self.selectedMarker = nil
                                    position = .automatic
                                }
                            }
                        }
                        .buttonStyle(.close)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            withAnimation {
                                self.locationInfo = LocationInfo(name: selectedResult.item.name, latitude: selectedResult.item.placemark.coordinate.latitude, longitude: selectedResult.item.placemark.coordinate.longitude)
                            }
                            parentDismiss()
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .buttonBorderShape(.capsule)
                        .tint(.accent)
                    }
                }
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
    @Previewable @State var locationInfo: LocationInfo?
        VStack {}
            .sheet(isPresented: .constant(true)) {
                LocationSelectorView(locationInfo: $locationInfo)
            }
}
