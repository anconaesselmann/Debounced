//  Created by Axel Ancona Esselmann on 7/11/24.
//

import SwiftUI
import Combine
import Debounced

@MainActor
class ContentViewModel: ObservableObject {

    @PublishedDebounced(for: 1)
    var text: String = ""

    var debounced: String = ""
    var isDebouncing: Bool = false
    var value: String = ""

    var bag = Set<AnyCancellable>()

    init() {
        _text.states
            .dropFirst()
            .sink { [weak self] in
                switch $0 {
                case .debouncing(let value, debounced: _):
                    self?.value = value
                    self?.isDebouncing = true
                case .idle(let debounced):
                    self?.debounced = debounced
                    self?.isDebouncing = false
                }
                self?.objectWillChange.send()
            }.store(in: &bag)
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
