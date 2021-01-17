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

extension UIView {

    @IBInspectable
    var isCirculer: Bool {

        get {
            return layer.cornerRadius == min(self.frame.width, self.frame.height) / CGFloat(2.0) ? true : false
        }

        set {

            if newValue {
                layer.cornerRadius = self.frame.height/2
                self.clipsToBounds = true

            } else {
                layer.cornerRadius = 0.0
                self.clipsToBounds = false
            }
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat {

        get {
            return layer.cornerRadius
        }

        set {
            layer.cornerRadius = newValue
        }
    }
    
    func hide() {
        self.isHidden = true
    }

    func show() {
        self.isHidden = false
    }
}

