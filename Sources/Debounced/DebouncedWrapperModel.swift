//  Created by Axel Ancona Esselmann on 7/23/24.
//

import SwiftUI

@MainActor
final internal class DebouncedWrapperModel<Value>: ObservableObject
    where Value: Equatable
{
    @Published
    internal var notDebounced: Value

    @Published
    internal private(set) var debounced: Value

    internal init(
        notDebounced: Value,
        for dueTime: DispatchQueue.SchedulerTimeType.Stride
    ) {
        self.notDebounced = notDebounced
        self.debounced = notDebounced
        $notDebounced.debounce(
            for: dueTime,
            scheduler: DispatchQueue.main
        ).assign(to: &$debounced)
    }
}

internal extension DebouncedWrapperModel {
    var isDebouncing: Bool {
        debounced != notDebounced
    }
}
