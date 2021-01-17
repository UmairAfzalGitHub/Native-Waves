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
import UIKit

extension UITableView {

    func dequeReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Unable to deque reusable cell with identifier "+String(describing: T.self))
        }
        return cell
    }

    func cellForRow<T: UITableViewCell>(atRow row: Int, inSection section: Int = 0) -> T? {
        return cellForRow(at: IndexPath(row: row, section: section)) as? T
    }

    func registerCell<T: UITableViewCell>(class: T.Type) {
        self.register(UINib(nibName: String(describing: T.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: T.self))
    }
}

