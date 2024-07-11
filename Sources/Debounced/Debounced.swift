//  Created by Axel Ancona Esselmann on 7/10/24.
//

import SwiftUI

@propertyWrapper
public struct Debounced<Value>: DynamicProperty
    where Value: Equatable
{
    public var wrappedValue: Value {
        get { debounced }

        nonmutating
        set { set(newValue) }
    }

    public var projectedValue: Binding<Value> {
        Binding { value } set: { wrappedValue = $0 }
    }

    private let delay: Double
    private let timer = OptionalContainer<Timer>()

    @State
    private var state: DebouceState<Value>

    public init(
        wrappedValue initialValue: Value,
        for delay: TimeInterval
    ) {
        self.state = .idle(initialValue)
        self.delay = delay
    }

    private func set(_ newValue: Value) {
        guard newValue != value else {
            return
        }
        state.update(newValue)
        timer.set(delay: delay) { state.debounce() }
    }
}

public extension Debounced {
    var value: Value { state.value }
    var debounced: Value { state.debouncedValue }
    var isDebouncing: Bool { state.isDebouncing }
}
