//
//  ContentView.swift
//  notesssss
//
//  Created by Fabrizio Ecuba on 10/11/25.
//

import SwiftUI
struct Note: Identifiable, Codable {
    let id: UUID
    var text: String
}
struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var newNoteText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    NavigationLink(destination: NoteDetailView(note: binding(for: note))) {
                        Text(note.text.isEmpty ? "Nuova nota" : note.text)
                            .lineLimit(1)
                    }
                }
            }
            .navigationTitle("My Notes")
            .toolbar {
                Button(action: addNote) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear(perform: loadNotes)
    }
    
    private func addNote() {
        let newNote = Note(id: UUID(), text: "")
        notes.append(newNote)
        saveNotes()
    }
    
    private func binding(for note: Note) -> Binding<Note> {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else {
            fatalError("Nota non trovata")
        }
        return $notes[index]
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
    
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes"),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
        }
    }
}
struct NoteDetailView: View {
    @Binding var note: Note
    
    var body: some View {
        TextEditor(text: $note.text)
            .padding()
            .navigationTitle("Modify note")
            .onDisappear {
                if let encoded = try? JSONEncoder().encode([note]) {
                    UserDefaults.standard.set(encoded, forKey: "notes")
                }
            }
    }
}
#Preview {
    ContentView()
}
