//  Created by Axel Ancona Esselmann on 7/10/24.
//

import SwiftUI
import Combine

@propertyWrapper
public struct PublishedDebounced<Value>
    where Value: Equatable
{
    public var wrappedValue: Value {
        get { _state.value.value }

        nonmutating
        set { set(newValue) }
    }

    public var projectedValue: Binding<Value> {
        Binding { _state.value.value } set: { wrappedValue = $0 }
    }

    private let delay: Double
    private let timer = OptionalContainer<Timer>()
    
    private let _state: CurrentValueSubject<DebouceState<Value>, Never>

    public init(
        wrappedValue initialValue: Value,
        for delay: TimeInterval
    ) {
        self._state = CurrentValueSubject<DebouceState<Value>, Never>(.idle(initialValue))
        self.delay = delay
    }

    private func set(_ newValue: Value) {
        guard newValue != _state.value.value else {
            return
        }
        _state.send(_state.value.updated(newValue))
        timer.set(delay: delay) {
            _state.send(_state.value.debounced())
        }
    }
}

public extension PublishedDebounced {
    var states: AnyPublisher<DebouceState<Value>, Never> {
        _state.eraseToAnyPublisher()
    }
    var debounced: AnyPublisher<Value, Never> {
        _state.map { $0.debouncedValue }.eraseToAnyPublisher()
    }

    var value: AnyPublisher<Value, Never> {
        _state.map { $0.value }.eraseToAnyPublisher()
    }

    var isDebouncing: AnyPublisher<Bool, Never> {
        _state.map { $0.isDebouncing }.eraseToAnyPublisher()
    }

    var objectWillChange: AnyPublisher<Void, Never> {
        _state
            .filter { !$0.isDebouncing }
            .map { _ in return }
            .eraseToAnyPublisher()
    }

    var debouncedWrappedValue: Value {
        _state.value.debouncedValue
    }
}
