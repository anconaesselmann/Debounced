//  Created by Axel Ancona Esselmann on 7/11/24.
//

import SwiftUI
import Debounced

@main
struct DebouncedExample_01App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {

    @Debounced(for: 1.0)
    var text: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            TextField("This text gets debounced", text: $text)
            Text("Debounced: \"\(text)\"")
            if _text.isDebouncing {
                Text("Typing \"\(_text.value)\"...")
                ProgressView()
            }
            Spacer()
        }
        .padding()
        .onChange(of: text) {
            print("New debounced value: \"\(text)\"")
        }
        .onChange(of: text) { oldValue, newValue in
            print("Old debounced value: \"\(oldValue)\", new debounced value: \"\(newValue)\"")
        }
        .onChange(of: _text.isDebouncing) {
            print(_text.isDebouncing ? "Typing" : "Debounced")
        }
    }
}
