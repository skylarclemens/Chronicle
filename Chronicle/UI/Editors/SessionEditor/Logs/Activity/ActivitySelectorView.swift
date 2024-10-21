//
//  ActivitySelectorView.swift
//  Chronicle
//
//  Created by Skylar Clemens on 10/17/24.
//

import SwiftUI
import SwiftData

struct ActivitySelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var sessionViewModel: SessionEditorViewModel
    
    @State private var viewModel = ActivitiesViewModel()
    
    @Query(sort: [SortDescriptor(\Activity.isCustom, order: .reverse), SortDescriptor(\Activity.name)]) var activityList: [Activity]
    
    @State private var searchText: String = ""
    @State private var openAddNewActivity: Bool = false
    
    var filteredActivityList: [Activity] {
        if !searchText.isEmpty {
            return activityList.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        return activityList
    }
    
    var activitiesByCategory: [ActivityCategory?: [Activity]] {
        Dictionary(grouping: filteredActivityList, by: \.category)
    }
    
    var body: some View {
        NavigationStack {
            List {
                if searchText.isEmpty {
                    Button {
                        openAddNewActivity = true
                    } label: {
                        HStack {
                            Text("Add New Activity")
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
                ForEach(ActivityCategory.allCases, id: \.id) { category in
                    if let categoryActivities = activitiesByCategory[category],
                       !categoryActivities.isEmpty {
                        Section(category.label) {
                            ForEach(categoryActivities) { activity in
                                let selected = viewModel.activities.contains { $0.name == activity.name }
                                Button {
                                    withAnimation {
                                        if selected {
                                            viewModel.activities.removeAll { $0.name == activity.name }
                                        } else {
                                            viewModel.activities.append(activity)
                                        }
                                    }
                                } label: {
                                    HStack {
                                        if let symbol = activity.symbol {
                                            HStack {
                                                Image(systemName: symbol)
                                            }
                                            .frame(width: 28)
                                        }
                                        Text(activity.name)
                                        Spacer()
                                        Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(selected ? .accent : .secondary)
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .contentMargins(.top, 0)
            .safeAreaInset(edge: .top) {
                if !viewModel.activities.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.activities) { activity in
                                    Button {
                                        withAnimation {
                                            if viewModel.activities.contains(where: { $0.name == activity.name }) {
                                                viewModel.activities.removeAll { $0.name == activity.name }
                                            }
                                        }
                                    } label: {
                                        HStack(spacing: 4) {
                                            if let symbol = activity.symbol {
                                                Image(systemName: symbol)
                                                    .font(.footnote)
                                            }
                                            Text(activity.name)
                                                .font(.footnote)
                                            Image(systemName: "xmark")
                                                .font(.caption2.bold())
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .buttonStyle(.editorInput)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .contentMargins(.horizontal, 16)
                        .contentMargins(.vertical, 8)
                        .scrollIndicators(.hidden)
                        .frame(maxHeight: 60, alignment: .top)
                        .background(
                            Color(.systemGroupedBackground)
                                .mask(LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .clear]), startPoint: .top, endPoint: .bottom))
                        )
                    
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search activities")
            .navigationTitle("Select Activities")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .buttonStyle(.close)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        save()
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(.accent)
                }
            }
            .onAppear {
                if !sessionViewModel.activities.isEmpty {
                    viewModel.activities = sessionViewModel.activities
                }
            }
            .sheet(isPresented: $openAddNewActivity) {
                AddNewActivityView(viewModel: $viewModel, activities: activityList)
                    .presentationDetents([.height(250)])
            }
        }
    }
    
    private func save() {
        sessionViewModel.activities = viewModel.activities
    }
}

@Observable
class ActivitiesViewModel {
    var activities: [Activity] = []
}

#Preview {
    @Previewable @State var viewModel = SessionEditorViewModel()
    NavigationStack {
        VStack {}
        .sheet(isPresented: .constant(true)) {
            ActivitySelectorView(sessionViewModel: $viewModel)
        }
    }
    .modelContainer(SampleData.shared.container)
}
