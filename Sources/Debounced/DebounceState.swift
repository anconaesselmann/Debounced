//  Created by Axel Ancona Esselmann on 7/10/24.
//

import Foundation

public enum DebounceState<Value>: Equatable where Value: Equatable {
    case debouncing(Value, debounced: Value)
    case idle(Value)

    public mutating func update(_ value: Value) {
        self = updated(value)
    }

    public mutating func debounce() {
        self = debounced()
    }
}

public extension DebounceState {
    var isDebouncing: Bool {
        switch self {
        case .debouncing: return true
        case .idle: return false
        }
    }

    var value: Value {
        switch self {
        case .debouncing(let value, debounced: _), .idle(let value):
            return value
        }
    }

    var debouncedValue: Value {
        switch self {
        case .debouncing(_, debounced: let debounced), .idle(let debounced):
            return debounced
        }
    }

    func updated(_ value: Value) -> Self {
        .debouncing(value, debounced: debouncedValue)
    }

    func debounced() -> Self {
        .idle(value)
    }
}
