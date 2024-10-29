//
//  RaceCategoryTagList.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 28/10/2024.
//

import SwiftUI

struct RaceCategoryTagList: View {

    let categories: [RaceSummary.Category]

    @Binding var selectedCategories: Set<RaceSummary.Category>

    var body: some View {
        ViewThatFits {
            HStack {
                content
            }
            VStack {
                content
            }
        }
    }

    var content: some View {
        ForEach(categories) { category in
            Button {
                if selectedCategories.contains(category) {
                    selectedCategories.remove(category)
                } else {
                    selectedCategories.insert(category)
                }
            } label: {
                Image(category.imageName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(category.title)
                    .font(.caption)
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(selectedCategories.contains(category) ? .white : .gray)
            .controlSize(.regular)
            .tint(selectedCategories.contains(category) ? .nedsOrange : .gray5)
        }
    }

}

#Preview {
    RaceCategoryTagList(
        categories: [.greyhound, .harness, .horse], selectedCategories: .constant([.greyhound])
    )
}
