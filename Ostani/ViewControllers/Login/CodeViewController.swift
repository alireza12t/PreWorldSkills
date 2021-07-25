//
//  CodeViewController.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit
import Alamofire
import RxKeyboard
import RxSwift

class CodeViewController: UIViewController {
    
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var buttonsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginBotton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        Coordinator.popViewController(viewController: self)
    }
    
    @IBAction func loginButtonDidTap(_ sender: Any) {
        if !(codeTextField.text ?? "").isEmpty {
            login(code: codeTextField.text!)
        } else {
            BannerManager.showMessage(errorMessageStr: "وارد کردن کد الزامی است")
        }
    }
    
    @IBAction func sendCodeAgainButtonDidTap(_ sender: Any) {
        sendGetCodeRequest(phoneNumber: phoneNumber)
    }
    
    var timer: Timer!
    var disposebag = DisposeBag()
    var phoneNumber: String = ""
    var timeLeft = 120

    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer()
        startTimer()
        setupKeyboardHandler()
        setupUi()
    }
    
    func setupKeyboardHandler() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                if keyboardVisibleHeight == 0 {
                    self?.buttonsBottomConstraint.constant = 150
                } else {
                    self?.buttonsBottomConstraint.constant = keyboardVisibleHeight + 15
                }
            })
            .disposed(by: disposebag)
    }
    
    func setupUi() {
        codeTextField.roundUp(20)
        loginBotton.roundUp(14)
        timerButton.roundUp(14)
    }
    
    
    
    func startTimer() {
        self.timeLeft = 120
        self.timerButton.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            
            timeLeft -= 1
            
            var timerText = "\(timeLeft/60):\(timeLeft%60)"
            if timeLeft % 60 >= 10{
                timerText = "\(timeLeft/60):\(timeLeft%60)"
            } else {
                timerText = "\(timeLeft/60):0\(timeLeft%60)"
            }
            self.timerButton.titleLabel?.text = timerText
            self.timerButton.setTitle(timerText, for: .normal)
            
            if(timeLeft==0){
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        self.timeLeft = 0
        self.timerButton.titleLabel?.text = "ارسال مجدد"
        self.timerButton.setTitle("ارسال مجدد", for: .normal)
        self.timerButton.isEnabled = true
        timer?.invalidate()
    }
    
    func login(code: String) {
        let url = "http://api.alihejazi.me/User/Login/"
        let parameters: [String: String] = [
            "phone": phoneNumber.toEnglishNumber(),
            "code": code.toEnglishNumber()
        ]
        
        AF.request(url, method: .get, parameters: parameters)
            .responseDecodable(of: Login.self) { (response) in
                switch response.result {
                case .success(let model):
                    StoringData.image = model.image ?? ""
                    StoringData.firstName = model.firstName
                    StoringData.lastName = model.lastName
                    StoringData.token = "Bearer \(model.token)"
                    StoringData.phoneNumber = self.phoneNumber
                    StoringData.myCentersCount = model.userCenters
                    StoringData.allCentersCount = model.allCenters
                    DispatchQueue.main.async {
                        Coordinator.pushViewController(sourceViewController: self, destinationViewController: HomeViewController.instantiateFromStoryboardName(storyboardName: .Main))
                    }
                case .failure(let error):
                    BannerManager.showMessage(errorMessageStr: error.localizedDescription)
                }
            }
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
}
