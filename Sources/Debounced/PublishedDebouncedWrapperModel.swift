//  Created by Axel Ancona Esselmann on 7/23/24.
//

import Foundation
import Combine

final internal class PublishedDebouncedWrapperModel<Value>: ObservableObject
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

internal extension PublishedDebouncedWrapperModel {
    var isDebouncing: Bool {
        debounced != notDebounced
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
