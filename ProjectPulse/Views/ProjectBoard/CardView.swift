//
//  CardView.swift
//  Trello
//
//  Created by aj sai on 25/07/25.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var board: Board
    @ObservedObject var boardList: BoardList
    @ObservedObject var card: Card
    
    @State private var isChecked: Bool = false
    @State private var showClipTextField: Bool = false
    @State private var clipLinkText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(card.priority)
                    .font(.caption)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red.opacity(0.9))
                    )
                Text(card.taskType)
                    .font(.caption)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.9))
                    )
                Spacer()
                Menu {
                    Button("Edit") { handleEditCard() }
                    Button("Delete", role: .destructive) {
                        boardList.removeCard(card)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color.gray.opacity(0.7))
                        .imageScale(.small)
                }
            }
            
            HStack {
                Text(card.taskName)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Spacer()
                Toggle("", isOn: $isChecked)
                    .toggleStyle(CircleCheckboxToggleStyle())
                    .labelsHidden()
            }
            
            ForEach(card.clipLinks, id: \.self) { link in
                if let url = URL(string: link) {
                    Link(destination: url) {
                        Text(link)
                            .font(.caption)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
            
            if showClipTextField {
                TextField("Insert clip link...", text: $clipLinkText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 2)
                    .onChange(of: clipLinkText) { _, newValue in
                        if newValue != newValue.lowercased() {
                            clipLinkText = newValue.lowercased()
                        }
                    }
                    .onSubmit {
                        saveLink()
                    }
            }
            
            HStack {
                Button {
                    withAnimation {
                        showClipTextField.toggle()
                    }
                } label: {
                    Image(systemName: "paperclip")
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.gray.opacity(0.6))
                }
                Spacer()
                Button {
                    // TODO: implement doc upload action
                } label: {
                    Image(systemName: "doc")
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.gray.opacity(0.7))
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1, y: 1)
    }
    
    private func handleEditCard() {
        presentAlertTextField(title: "Edit Card", defaultTextFieldText: card.content) { text in
            guard let text = text, !text.isEmpty else {
                return
            }
            card.content = text
        }
    }
    
    private func saveLink() {
        guard let url = URL(string: clipLinkText), !clipLinkText.isEmpty else { return }
        if !card.clipLinks.contains(clipLinkText) {
            card.clipLinks.append(clipLinkText)
        }
        clipLinkText = ""
        showClipTextField = false
    }
}

#Preview {
    @Previewable @StateObject var boardList = Board.stub.lists[0]
    let sampleCard = Card(
        boardListId: boardList.id,
        content: "Fix bug causing app crash on launch",
        priority: "High",
        taskType: "Bug",
        taskName: "Crash Fix"
    )

    CardView(board: Board.stub, boardList: boardList, card: sampleCard)
        .frame(width: 300)
}
