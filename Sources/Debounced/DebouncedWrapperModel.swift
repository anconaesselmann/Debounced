//  Created by Axel Ancona Esselmann on 7/23/24.
//

import SwiftUI

@MainActor
class DebouncedWrapperModel<Value>: ObservableObject
    where Value: Equatable
{
    @Published
    var notDebounced: Value

    @Published
    private(set) var debounced: Value

    var isDebouncing: Bool {
        debounced != notDebounced
    }

    init(notDebounced: Value, for delay: Double) {
        self.notDebounced = notDebounced
        self.debounced = notDebounced
        $notDebounced.debounce(
            for: .seconds(delay),
            scheduler: DispatchQueue.main
        ).assign(to: &$debounced)
    }
}
