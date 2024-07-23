//  Created by Axel Ancona Esselmann on 7/23/24.
//

import Foundation
import Combine

class PublishedDebouncedWrapperModel<Value>: ObservableObject
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

    var notDebouncedPublisher: AnyPublisher<Value, Never> {
        $notDebounced.eraseToAnyPublisher()
    }
    var debouncedPublisher: AnyPublisher<Value, Never> {
        $debounced.eraseToAnyPublisher()
    }
    var isDebouncingPublisher: AnyPublisher<Bool, Never> {
        notDebouncedPublisher
            .combineLatest(debouncedPublisher)
            .map { $0 != $1 }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    var statesPublisher: AnyPublisher<DebounceState<Value>, Never> {
        notDebouncedPublisher
            .combineLatest(debouncedPublisher)
            .map {
                if $0 != $1 {
                    return DebounceState<Value>.debouncing($0, debounced: $1)
                } else {
                    return DebounceState<Value>.idle($0)
                }
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
