//
//  MobileViewController.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit
import Alamofire
import RxKeyboard
import RxSwift

class MobileViewController: UIViewController {
    
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginBotton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBAction func loginButtonDidTap(_ sender: Any) {
        if ValidationHelper.isPhoneNumberValid(phoneNumber: phoneNumberTextField.text) {
            sendGetCodeRequest(phoneNumber: phoneNumberTextField.text!.toEnglishNumber())
        } else {
            BannerManager.showMessage(errorMessageStr: "فرمت شماره تلفن وارد شده اشتباه است")
        }
    }
    
    var disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        setupKeyboardHandler()
        setupUi()
    }
    
    func setupKeyboardHandler() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                if keyboardVisibleHeight == 0 {
                    self?.loginButtonBottomConstraint.constant = 150
                } else {
                    self?.loginButtonBottomConstraint.constant = keyboardVisibleHeight + 15
                }
            })
            .disposed(by: disposebag)
    }
    
    func setupUi() {
        phoneNumberTextField.roundUp(20)
        loginBotton.roundUp(14)
    }
    
    func sendGetCodeRequest(phoneNumber: String) {
        let url = "http://api.alihejazi.me/User/SendCode/"
        let parameters: [String: String] = ["phone": phoneNumber]
        
        AF.request(url, method: .get, parameters: parameters)
            .responseString { response in
                switch response.result {
                case .success(let result):
                    DispatchQueue.main.async {
                        if result == "Code Sent" {
                            let vc = CodeViewController.instantiateFromStoryboardName(storyboardName: .Main)
                            vc.phoneNumber = phoneNumber
                            Coordinator.pushViewController(sourceViewController: self, destinationViewController: vc)
                        } else {
                            BannerManager.showMessage(errorMessageStr: result)
                        }
                    }
                case .failure(let error):
                    BannerManager.showMessage(errorMessageStr: error.localizedDescription)
                }
            }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        loginBotton.isEnabled = ValidationHelper.isPhoneNumberValid(phoneNumber: textField.text)
    }
}
