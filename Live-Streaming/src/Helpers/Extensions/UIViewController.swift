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

public extension UIViewController {

    private var overlayContainerView: UIView {

        if let navigationView: UIView = navigationController?.view {
            return navigationView
        }
        return view
    }

    /// Displays an activity indicator on the screen.
    /// Ensure the UI is updated from the main thread
    /// in case this method is called from a closure

    func showLoader() {
        let location = self.view.center

        DispatchQueue.main.async { [weak self] in

            guard let self = self else { return }

            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .red
            //Add the tag so we can find the view in order to remove it later
            activityIndicator.tag = 9000
            //Set the location
            activityIndicator.center = location
            activityIndicator.hidesWhenStopped = true
            //Start animating and add the view
            activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            self.view.addSubview(activityIndicator)
        }
    }

    /// Hides the activity indicator.
    func hideLoader() {
        
        DispatchQueue.main.async { [weak self] in

            guard let self = self else { return }

            if let activityIndicator = self.view.subviews.filter({ $0.tag == 9000}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
}
