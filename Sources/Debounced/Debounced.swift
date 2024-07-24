//  Created by Axel Ancona Esselmann on 7/10/24.
//

import SwiftUI

@propertyWrapper
public struct Debounced<Value>: DynamicProperty
    where Value: Equatable
{
    @StateObject
    private var vm: DebouncedWrapperModel<Value>

    public var wrappedValue: Value {
        get { vm.debounced }

        nonmutating
        set { vm.notDebounced = newValue }
    }

    public var projectedValue: Binding<Value> {
        Binding { vm.notDebounced } set: { vm.notDebounced = $0 }
    }

    public init(
        wrappedValue: Value,
        for dueTime: DispatchQueue.SchedulerTimeType.Stride
    ) {
        _vm = StateObject(
            wrappedValue: DebouncedWrapperModel(
                notDebounced: wrappedValue,
                for: dueTime
            )
        )
    }
}

public extension Debounced {
    var value: Value { vm.notDebounced }
    var debounced: Value { vm.debounced }
    var isDebouncing: Bool { vm.isDebouncing }

    public init(
        wrappedValue: Value,
        for delay: Double
    ) {
        self = .init(wrappedValue: wrappedValue, for: .seconds(delay))
    }
}
