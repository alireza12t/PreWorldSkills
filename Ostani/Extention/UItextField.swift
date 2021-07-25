//
//  UItextField.swift
//  Ostani
//
//  Created by ali on 7/16/21.
//

import UIKit

extension UITextField {
    func addInputAccessory(textFields: [UITextField?], dismissable: Bool = true, previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "بستن", style: .plain, target: nil, action: nil)
            doneButton.target = textFields[index]
            doneButton.action = #selector(UITextField.resignFirstResponder)
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(title: "قبلی", style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                
                let nextButton = UIBarButtonItem(title: "بعدی", style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items = [previousButton, nextButton, spacer, doneButton]
            } else {
                items = [spacer, doneButton]
            }
            
            toolbar.setItems(items, animated: false)
            textField?.inputAccessoryView = toolbar
        }
    }
    
    func setInputViewDatePicker(target: Any, selector: Selector) {

        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar(identifier: .persian)
        datePicker.locale = Locale(identifier: "fa_IR")
        datePicker.date = Date()
        datePicker.maximumDate = Date()
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "لغو", style: .plain, target: nil, action: #selector(tapCancel))
        let barButton = UIBarButtonItem(title: "بستن", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    func setInputViewPicker(pickerView: UIPickerView, target: Any) {
        let screenWidth = UIScreen.main.bounds.width
        self.inputView = pickerView
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
