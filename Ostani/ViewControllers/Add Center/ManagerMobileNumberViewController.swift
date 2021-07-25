//
//  ManagerMobileNumberViewController.swift
//  Ostani
//
//  Created by ali on 7/16/21.
//

import UIKit
import RxKeyboard
import RxSwift

class ManagerMobileNumberViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        if ValidationHelper.isPhoneNumberValid(phoneNumber: phoneNumberTextField.text) {
            model.manager.phoneNumber = phoneNumberTextField.text!
            let vc = ManagerInfoViewController.instantiateFromStoryboardName(storyboardName: .Main)
            vc.model = model
            Coordinator.pushViewController(sourceViewController: self, destinationViewController: vc)
        } else {
            BannerManager.showMessage(errorMessageStr: "فرمت شماره تلفن وارد شده اشتباه است")
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        Coordinator.popViewController(viewController: self)
    }
    
    var disposebag = DisposeBag()
    var model = AddCenterBody(name: "", telephone: "", address: "", centerTypeId: -1, score: -1, latitude: -1, longitude: -1, manager: ManagerData(phoneNumber: "", firstName: "", lastName: "", nationalCode: "", birthDate: ""), image: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleKeyboardIssues()
    }
    
    func handleKeyboardIssues() {
        let textfields = [phoneNumberTextField]
        phoneNumberTextField.addInputAccessory(textFields: textfields, dismissable: true, previousNextable: false)
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak scrollView] keyboardVisibleHeight in
                scrollView?.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposebag)
    }
    
    func setupUI() {
        nextButton.roundUp(14)
        phoneNumberTextField.roundUp(20)
    }
    
}
