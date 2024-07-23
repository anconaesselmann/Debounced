//  Created by Axel Ancona Esselmann on 7/11/24.
//

import SwiftUI
import Debounced

@MainActor
class ContentViewModel: ObservableObject {
    @PublishedDebounced(for: 1)
    var text: String = ""

    @Published
    var debounced: String = ""

    @Published
    var isDebouncing: Bool = false

    @Published
    var value: String = ""

    init() {
        _text.debounced.assign(to: &$debounced)
        _text.isDebouncing.assign(to: &$isDebouncing)
        // Note: changes made to "text" by the TextField do not
        // not update the view. To have access to each change before
        // debouncing (likely not a common use case) bind `value`
        // to a publisher:
        _text.value.assign(to: &$value)
    }
}

struct ContentView: View {

    @StateObject
    var vm = ContentViewModel()

    var body: some View {
        VStack {
            TextField("This text gets debounced", text: $vm.text)
            Text("Debounced: \"\(vm.debounced)\"")
            if vm.isDebouncing {
                Text("Debouncing \"\(vm.text)\"...")
                ProgressView()
            }
            Spacer()
        }
        .padding()
    }
}
