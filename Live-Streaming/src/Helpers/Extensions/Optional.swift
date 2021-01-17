//
// Copyright (c) 2021, NativeWaves
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//


import Foundation

extension Optional where Wrapped == String {

    var orEmpty: String {
        return self ?? ""
    }

    var orDash: String {
        return self ?? "-"
    }

    var orZero: String {
        return self ?? "0"
    }

    func doubleValue() -> Double {
        return (self as NSString?)?.doubleValue ?? 0
    }
}

extension Optional where Wrapped == Double {

    var orZero: Double {
        return self ?? 0
    }
}

extension Optional where Wrapped == Int {

    var orZero: Int {
        return self ?? 0
    }
}

extension Optional where Wrapped == Float {

    var orZero: Float {
        return self ?? 0.0
    }
}

extension Optional where Wrapped == Bool {

    var orFalse: Bool {
        return self ?? false
    }

    var orTrue: Bool {
        return self ?? true
    }
}

extension Optional where Wrapped == Date {

    var orCurrent: Date {
        return self ?? Date()
    }
}
