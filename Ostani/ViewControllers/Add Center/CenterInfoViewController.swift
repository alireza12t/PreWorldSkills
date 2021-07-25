//
//  CenterInfoViewController.swift
//  Ostani
//
//  Created by ali on 7/16/21.
//

import UIKit
import RxKeyboard
import RxSwift
import Alamofire

class CenterInfoViewController: UIViewController {
    
    @IBOutlet weak var centerTypeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        if let centerName = nameTextField.text, !centerName.isEmpty,
           let centerType = selectedCenterType,
           let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty {
                model?.telephone = phoneNumber
                model?.centerTypeId = selectedCenterType?.id ?? -1
                model?.name = centerName
                
                let vc = CenterAddressViewController.instantiateFromStoryboardName(storyboardName: .Main)
                vc.model = model
                Coordinator.pushViewController(sourceViewController: self, destinationViewController: vc)
        } else {
            BannerManager.showMessage(errorMessageStr: "پر کردن تمامی فیلدها الزامی است")
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        Coordinator.popViewController(viewController: self)
    }
    
    var disposebag = DisposeBag()
    var model: AddCenterBody? = nil
    var centerTypes: [CenterType] = []
    var selectedCenterType: CenterType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPickerView()
        handleKeyboardIssues()
        getCenterTypes()
    }
    
    func setupPickerView() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        self.centerTypeTextField.setInputViewPicker(pickerView: picker, target: self)
    }
    
    func handleKeyboardIssues() {
        let textfields = [phoneNumberTextField, nameTextField, centerTypeTextField]
        phoneNumberTextField.addInputAccessory(textFields: textfields, dismissable: true, previousNextable: false)
        nameTextField.addInputAccessory(textFields: textfields, dismissable: true, previousNextable: false)
        centerTypeTextField.addInputAccessory(textFields: textfields, dismissable: true, previousNextable: false)
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak scrollView] keyboardVisibleHeight in
                scrollView?.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposebag)
    }
    
    func setupUI() {
        backButton.roundUp(14)
        nextButton.roundUp(14)
        phoneNumberTextField.roundUp(20)
        nameTextField.roundUp(20)
        centerTypeTextField.roundUp(20)
    }
    
    func getCenterTypes() {
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
        let url = "http://api.alihejazi.me/Center/GetCenterTypes/"
        let headders = HTTPHeaders([HTTPHeader(name: "Authorization", value: StoringData.token)])
        
        AF.request(url, method: .get, headers: headders)
            .responseDecodable(of: [CenterType].self) { (response) in
                switch response.result {
                case .success(let model):
                    DispatchQueue.main.async { [self] in
                        self.centerTypes = model
                        loadingActivityIndicator.isHidden = true
                        loadingActivityIndicator.stopAnimating()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    BannerManager.showMessage(errorMessageStr: "خطا در دریافت اطلاعات مدیر مرکز")
                    DispatchQueue.main.async { [self] in
                        loadingActivityIndicator.isHidden = true
                        loadingActivityIndicator.stopAnimating()
                        
                    }
                }
            }
    }
    
}

extension CenterInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return centerTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        centerTypes[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        centerTypeTextField.text = centerTypes[row].title
        selectedCenterType = centerTypes[row]
    }
}
