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

    public init(
        wrappedValue: Value,
        for dueTime: DispatchQueue.SchedulerTimeType.Stride
    ) {
        self.vm = PublishedDebouncedWrapperModel(
            notDebounced: wrappedValue,
            for: dueTime
        )
    }
}

public extension PublishedDebounced {
    var value: AnyPublisher<Value, Never> { vm.notDebouncedPublisher }
    var debounced: AnyPublisher<Value, Never> { vm.debouncedPublisher }
    var isDebouncing: AnyPublisher<Bool, Never> { vm.isDebouncingPublisher }
    var states: AnyPublisher<DebounceState<Value>, Never> { vm.statesPublisher }
    
    var debouncedWrappedValue: Value { vm.debounced }

    public init(
        wrappedValue: Value,
        for delay: Double
    ) {
        self = .init(wrappedValue: wrappedValue, for: .seconds(delay))
    }
}
