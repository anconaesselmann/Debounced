//  Created by Axel Ancona Esselmann on 7/10/24.
//

import SwiftUI
import Combine

@propertyWrapper
public struct PublishedDebounced<Value>
    where Value: Equatable
{
    private var vm: PublishedDebouncedWrapperModel<Value>

    public var wrappedValue: Value {
        get { vm.notDebounced }

        nonmutating
        set { vm.notDebounced = newValue }
    }

    public var projectedValue: Binding<Value> {
        Binding { vm.notDebounced } set: { vm.notDebounced = $0 }
    }

    public init(wrappedValue: Value, for delay: Double) {
        self.vm = PublishedDebouncedWrapperModel(
            notDebounced: wrappedValue,
            for: delay
        )
    }
}

public extension PublishedDebounced {
    var debounced: AnyPublisher<Value, Never> { vm.debouncedPublisher }
    var value: AnyPublisher<Value, Never> { vm.notDebouncedPublisher }
    var isDebouncing: AnyPublisher<Bool, Never> { vm.isDebouncingPublisher }
    var debouncedWrappedValue: Value { vm.debounced }
    var states: AnyPublisher<DebounceState<Value>, Never> { vm.statesPublisher }
}
