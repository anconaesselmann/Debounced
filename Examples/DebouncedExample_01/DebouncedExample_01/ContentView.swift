//  Created by Axel Ancona Esselmann on 7/11/24.
//

import SwiftUI
import Debounced

struct ContentView: View {

    @Debounced(for: 1.0)
    var text: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            TextField("This text gets debounced", text: $text)
            Text("Debounced: \"\(text)\"")
            if _text.isDebouncing {
                Text("Debouncing \"\(_text.value)\"...")
                ProgressView()
            }
            Spacer()
        }
        .padding()
        .onChange(of: text) {
            print("New debouced value: \"\(text)\"")
        }
        .onChange(of: text) { oldValue, newValue in
            print("Old debounced value: \"\(oldValue)\", new debounced value: \"\(newValue)\"")
        }
    }
}
