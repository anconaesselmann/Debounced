//  Created by Axel Ancona Esselmann on 7/10/24.
//

import Foundation

extension OptionalContainer where T == Timer {
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }

    func set(delay: TimeInterval, block: @escaping () -> Void) {
        invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: delay,
            repeats: false,
            block: { [weak self] _ in
                block()
                self?.invalidate()
            }
        )
    }
}
