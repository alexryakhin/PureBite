//
//  ShoppingListCellView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/29/24.
//

import SwiftUI
import CachedAsyncImage

struct ShoppingListCellView: View {
    
    private let item: ShoppingListItem
    private let onTapAction: () -> Void
    private let onEdit: (() -> Void)?
    private let onDelete: (() -> Void)?
    
    @State private var isPressed = false
    
    init(
        item: ShoppingListItem,
        onTapAction: @escaping () -> Void,
        onEdit: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.item = item
        self.onTapAction = onTapAction
        self.onEdit = onEdit
        self.onDelete = onDelete
    }

    var body: some View {
        HStack(spacing: 12) {
            // Item Image
            itemImageView
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.ingredient.name.capitalized)
                        .font(.headline)
                        .foregroundStyle(item.isChecked ? .secondary : .primary)
                        .strikethrough(item.isChecked)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Priority indicator
                    if item.priority != .normal {
                        Image(systemName: item.priority.icon)
                            .font(.caption)
                            .foregroundStyle(item.priority.color)
                    }
                }
                
                HStack {
                    Text(item.displayAmount)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    if let notes = item.notes, !notes.isEmpty {
                        Text("• \(notes)")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // Category badge
                    categoryBadge
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Checkbox
            Button(action: onTapAction) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isChecked ? .green : .secondary)
                    .animation(.easeInOut(duration: 0.2), value: item.isChecked)
            }
            .buttonStyle(.plain)
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if let onDelete = onDelete {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
            
            if let onEdit = onEdit {
                Button {
                    onEdit()
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .tint(.blue)
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                onTapAction()
            } label: {
                Label(
                    item.isChecked ? "Uncheck" : "Check",
                    systemImage: item.isChecked ? "circle" : "checkmark.circle.fill"
                )
            }
            .tint(item.isChecked ? .orange : .green)
        }
    }
    
    private var itemImageView: some View {
        Group {
            if let imageURL = item.imageURL {
                CachedAsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ShimmerView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                    }
                }
                .frame(width: 40, height: 40)
                .padding(5)
                .background(.white)
                .cornerRadius(12)
                .shadow(radius: 1)
            } else {
                Image(systemName: item.category.icon)
                    .font(.title2)
                    .foregroundStyle(item.category.color)
                    .frame(width: 50, height: 50)
                    .background(item.category.color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
    
    private var categoryBadge: some View {
        Text(item.category.rawValue)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(item.category.color.opacity(0.1))
            .foregroundStyle(item.category.color)
            .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 16) {
        ShoppingListCellView(
            item: ShoppingListItem(
                id: "1",
                amount: 2,
                unit: "lbs",
                ingredient: IngredientSearchInfo(
                    aisle: "Produce",
                    id: 1,
                    imageUrlPath: nil,
                    name: "Bananas",
                    possibleUnits: []
                ),
                category: .produce,
                priority: .high
            ),
            onTapAction: {},
            onEdit: {},
            onDelete: {}
        )
        
        ShoppingListCellView(
            item: ShoppingListItem(
                id: "2",
                isChecked: true,
                amount: 1,
                unit: "gallon",
                ingredient: IngredientSearchInfo(
                    aisle: "Dairy",
                    id: 2,
                    imageUrlPath: nil,
                    name: "Milk",
                    possibleUnits: []
                ),
                category: .dairy,
                notes: "Organic whole milk"
            ),
            onTapAction: {},
            onEdit: {},
            onDelete: {}
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
