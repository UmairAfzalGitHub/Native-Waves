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

class BaseViewController: UIViewController {

    // MARK: - Varaibales

    open var  baseViewModel = BaseViewModel()
    var coordinator: MainCoordinator?

    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupCustomPropertiesOnView() {}
    func populateViewWithData() {}

    /// Add a toolbar above the keyboard, contaning done button.
    /// Used to dismiss the keyboard
    func addDoneButtonOnKeyboard(textField: UITextField){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        textField.inputAccessoryView = doneToolbar
    }

    func setScreenOrientation(orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

    // MARK: - Selectors
    
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
}

extension BaseViewController: BaseViewModelDelegate {

    func showProgress() {
        self.showLoader()
    }

    func hideProgress() {
        self.hideLoader()
    }

    func showErrorAlert(message: String?) {
        AlertBuilder.failureAlertWithMessage(message: message)
    }

    func showSuccessAlert(message: String?) {
        AlertBuilder.successAlertWithMessage(message: message)
    }
}
