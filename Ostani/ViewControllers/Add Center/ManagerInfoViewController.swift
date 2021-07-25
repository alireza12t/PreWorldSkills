//
//  ManagerInfoViewController.swift
//  Ostani
//
//  Created by ali on 7/16/21.
//

import UIKit
import RxKeyboard
import RxSwift
import Alamofire

class ManagerInfoViewController: UIViewController {
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nationalCodeTexxtField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        if let firstName = firstNameTextField.text, !firstName.isEmpty,
           let lastName = lastNameTextField.text, !lastName.isEmpty,
           let nationalCode = nationalCodeTexxtField.text,
           let birthDate = birthDateTextField.text {
            if ValidationHelper.isNationalCodeValid(nationalCode: nationalCode) {
                model?.manager.firstName = firstName
                model?.manager.lastName = lastName
                model?.manager.nationalCode = nationalCode
                model?.manager.birthDate = birthDate.toENDate()
                
                let vc = CenterInfoViewController.instantiateFromStoryboardName(storyboardName: .Main)
                vc.model = model
                Coordinator.pushViewController(sourceViewController: self, destinationViewController: vc)
            } else {
                BannerManager.showMessage(errorMessageStr: "فرمت کد ملی واردشده اشتباه است")
            }
        } else {
            BannerManager.showMessage(errorMessageStr: "پر کردن فیلدها نام و نام خانوادگی الزامی است")
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        Coordinator.popViewController(viewController: self)
    }
    
    var disposebag = DisposeBag()
    var model: AddCenterBody? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleKeyboardIssues()
        getManagerData()
        self.birthDateTextField.setInputViewDatePicker(target: self, selector: #selector(birthDateTextFieldDidTap))
    }
    
    @objc func birthDateTextFieldDidTap() {
        if let datePicker = self.birthDateTextField.inputView as? UIDatePicker {
            self.birthDateTextField.text = datePicker.date.getString()
        }
        self.birthDateTextField.resignFirstResponder()
    }
    
    func handleKeyboardIssues() {
        let textfields = [firstNameTextField, lastNameTextField, nationalCodeTexxtField, birthDateTextField]
        firstNameTextField.addInputAccessory(textFields: textfields, dismissable: true, previousNextable: false)
        lastNameTextField.addInputAccessory(textFields: textfields, dismissable: true, previousNextable: false)
        nationalCodeTexxtField.addInputAccessory(textFields: textfields, dismissable: true, previousNextable: false)
        birthDateTextField.addInputAccessory(textFields: textfields, dismissable: true, previousNextable: false)
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak scrollView] keyboardVisibleHeight in
                scrollView?.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposebag)
    }
    
    func setupUI() {
        backButton.roundUp(14)
        nextButton.roundUp(14)
        lastNameTextField.roundUp(20)
        firstNameTextField.roundUp(20)
        nationalCodeTexxtField.roundUp(20)
        birthDateTextField.roundUp(20)
    }
    
    func getManagerData() {
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
        let url = "http://api.alihejazi.me/AddCenter/CheckManagerPhone/"
        let parameters = [
            "phone" : model?.manager.phoneNumber.toEnglishNumber()
        ]
        let headders = HTTPHeaders([HTTPHeader(name: "Authorization", value: StoringData.token)])
        
        AF.request(url, method: .get, parameters: parameters, headers: headders)
            .responseDecodable(of: CheckManagerPhone.self) { (response) in
                switch response.result {
                case .success(let model):
                    DispatchQueue.main.async { [self] in
                        loadingActivityIndicator.isHidden = true
                        loadingActivityIndicator.stopAnimating()
                        if let manager = model.manager, model.status == "registered"  {
                            lastNameTextField.isEnabled = false
                            firstNameTextField.isEnabled = false
                            nationalCodeTexxtField.isEnabled = false
                            birthDateTextField.isEnabled = false
                            
                            lastNameTextField.text = manager.lastName
                            firstNameTextField.text = manager.firstName
                            nationalCodeTexxtField.text = manager.nationalCode
                            let birthDate = manager.birthDate.getDate()
                            birthDateTextField.text = birthDate.getString()
                        } else {
                            lastNameTextField.isEnabled = true
                            firstNameTextField.isEnabled = true
                            nationalCodeTexxtField.isEnabled = true
                            birthDateTextField.isEnabled = true
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    BannerManager.showMessage(errorMessageStr: "خطا در دریافت اطلاعات مدیر مرکز")
                    DispatchQueue.main.async { [self] in
                        loadingActivityIndicator.isHidden = true
                        loadingActivityIndicator.stopAnimating()
                        lastNameTextField.isEnabled = true
                        firstNameTextField.isEnabled = true
                        nationalCodeTexxtField.isEnabled = true
                        birthDateTextField.isEnabled = true
                    }
                }
            }
    }
}
