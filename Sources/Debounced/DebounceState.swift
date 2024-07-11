//  Created by Axel Ancona Esselmann on 7/10/24.
//

import Foundation

public enum DebouceState<Value>: Equatable where Value: Equatable {
    case debouncing(value: Value, debounced: Value)
    case idle(Value)

    public func updated(_ value: Value) -> Self {
        .debouncing(value: value, debounced: debouncedValue)
    }

    public func debounced() -> Self {
        .idle(value)
    }

    public mutating func update(_ value: Value) {
        self = updated(value)
    }

    public mutating func debounce() {
        self = debounced()
    }
}

public extension DebouceState {
    var isDebouncing: Bool {
        switch self {
        case .debouncing: return true
        case .idle: return false
        }
    }

    var value: Value {
        switch self {
        case .debouncing(value: let value, debounced: _), .idle(let value):
            return value
        }
    }

    var debouncedValue: Value {
        switch self {
        case .debouncing(value: _, debounced: let debounced), .idle(let debounced):
            return debounced
        }
    }
}
