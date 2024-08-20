//
//  CompactSessionCardView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 8/19/24.
//

import SwiftUI
import SwiftData

struct CompactSessionCardView: View {
    @Environment(\.modelContext) var modelContext
    var session: Session?
    @State private var isDeleting = false
    
    var body: some View {
        if let session {
            VStack {
                if let imagesData = session.imagesData, !imagesData.isEmpty,
                   let uiImage = UIImage(data: imagesData[0]) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 110)
                        .clipShape(.rect(cornerRadius: 6))
                }
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Text(session.title)
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .bold()
                        if let notes = session.notes, !notes.isEmpty {
                            Image(systemName: "note.text")
                                .foregroundStyle(.secondary)
                        }
                    }
                    Divider()
                    HStack {
                        Text(session.date, style: .date)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Menu {
                            Button(role: .destructive) {
                                isDeleting = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 20))
                                .tint(.secondary)
                                .padding(.vertical, 4)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .padding(.horizontal, 4)
            }
            .padding(8)
            .background(.thickMaterial)
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.bar, lineWidth: 1)
                    .allowsHitTesting(false)
            )
            .alert("Are you sure you want to delete \(session.title)?", isPresented: $isDeleting) {
                Button("Yes", role: .destructive) {
                    delete(session)
                }
            }
        }
    }
    
    private func delete(_ session: Session) {
        updateItemEffectsAndFlavors()
        withAnimation {
            modelContext.delete(session)
        }
    }
    
    private func updateItemEffectsAndFlavors() {
        guard let session, let item = session.item else { return }
        
        for effect in session.effects {
            if let existingEffect = item.effects.first(where: { $0.effect.name == effect.effect.name }) {
                existingEffect.count -= 1
                existingEffect.totalIntensity -= effect.intensity
                if existingEffect.count == 0 {
                    modelContext.delete(existingEffect)
                }
            }
        }
        
        for flavor in session.flavors {
            if let existingFlavor = item.flavors.first(where: { $0.flavor.name == flavor.flavor.name }) {
                existingFlavor.count -= 1
                existingFlavor.totalIntensity -= (flavor.intensity ?? 0)
                if existingFlavor.count == 0 {
                    modelContext.delete(existingFlavor)
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Schema([Item.self, Strain.self, Session.self]), configurations: config)
    
    let imageData = UIImage(named: "edibles-jar")?.pngData()
    let imageData2 = UIImage(named: "pre-roll")?.pngData()
    
    let item = Item(name: "Dream Gummies", type: .edible)
    container.mainContext.insert(item)
    let strain = Strain(name: "Blue Dream", type: .hybrid)
    container.mainContext.insert(strain)
    
    if let imageData {
        item.imagesData = [imageData]
    }
    item.strain = strain
    
    let session = Session(item: item)
    if let imageData2 {
        session.imagesData = [imageData2]
    }
    session.title = "Nighttime sesh"
    session.notes = "Test"
    container.mainContext.insert(session)
    
    return NavigationStack {
        VStack {
            CompactSessionCardView(session: session)
        }
    }
    .background(
        BackgroundView()
    )
}
