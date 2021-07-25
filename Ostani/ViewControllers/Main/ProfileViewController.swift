//
//  ProfileViewController.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit
import Alamofire
import RxKeyboard
import RxSwift

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var cancellButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var prrofileImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var ffirstNameTextFiled: UITextField!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var lastNameTextFieldd: UITextField!
    
    @IBAction func removeImageButtonDiddTap(_ sender: Any) {
        if StoringData.image.isEmpty {
            prrofileImageView.image = UIImage(named: "ui-user")!
        } else {
            prrofileImageView.image = StoringData.image.base64ToImage
        }
        image = nil
    }
    
    @IBAction func editImageButtonDiddTapp(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        Coordinator.popViewController(viewController: self)
    }
    
    @IBAction func exitButtonDidTap(_ sender: Any) {
        StoringData.image = ""
        StoringData.firstName = ""
        StoringData.lastName = ""
        StoringData.token = ""
        StoringData.phoneNumber = ""
        StoringData.myCentersCount = 0
        StoringData.allCentersCount = 0
        DispatchQueue.main.async {
            let mobileVC = MobileViewController.instantiateFromStoryboardName(storyboardName: .Main)
            Coordinator.appNavigationController.setViewControllers([mobileVC], animated: true)
        }
    }
    
    @IBAction func saveButtonDDidTap(_ sender: Any) {
        updateProfile(completion: { progress in
            print("progress" + progress)
        })
    }
    
    @IBAction func cancellButtonDDidTap(_ sender: Any) {
        ffirstNameTextFiled.text = StoringData.firstName
        lastNameTextFieldd.text = StoringData.lastName
        
        if StoringData.image.isEmpty {
            prrofileImageView.image = UIImage(named: "ui-user")!
        } else {
            prrofileImageView.image = StoringData.image.base64ToImage
        }
        
        image = nil
        firstName = ""
        lastName = ""
    }
    
    var image: UIImage? = nil
    var firstName = ""
    var lastName = ""
    var imagePicker = UIImagePickerController()
    var disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak scrollView] keyboardVisibleHeight in
                scrollView?.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposebag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
    }
    
    func setupUi() {
        mobileTextField.roundUp(20)
        ffirstNameTextFiled.roundUp(20)
        lastNameTextFieldd.roundUp(20)
        saveButton.roundUp(14)
        cancellButton.roundUp(14)
        prrofileImageView.addBorder(cornerRadius: 20, color: .brandGreen, borderWidth: 3)
        
        exitButton.addBorder(cornerRadius: 14, color: .systemRed, borderWidth: 2)
        
        ffirstNameTextFiled.text = StoringData.firstName
        lastNameTextFieldd.text = StoringData.lastName
        mobileTextField.text = StoringData.phoneNumber
        
        if StoringData.image.isEmpty {
            prrofileImageView.image = UIImage(named: "ui-user")!
        } else {
            prrofileImageView.image = StoringData.image.base64ToImage
        }
    }
    
    func getUserData() {
        let url = "http://api.alihejazi.me/User/GetUserData/"
        let headders = HTTPHeaders([HTTPHeader(name: "Authorization", value: StoringData.token)])
        
        AF.request(url, method: .get, headers: headders)
            .responseDecodable(of: UserData.self) { (response) in
                switch response.result {
                case .success(let model):
                    StoringData.image = model.image ?? ""
                    StoringData.firstName = model.firstName
                    StoringData.lastName = model.lastName
                    StoringData.myCentersCount = model.userCenters
                    StoringData.allCentersCount = model.allCenters
                case .failure(let error):
                    BannerManager.showMessage(errorMessageStr: error.localizedDescription)
                }
            }
    }
    
    func updateProfile(completion: @escaping (String) -> ()) {
        
        let url = "http://api.alihejazi.me/User/updateProfile/"
        
        let parameters: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "image" : image?.imageToBase64 ?? ""
        ]

        let header = HTTPHeaders(["Authorization": StoringData.token])
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).response { (response) in
                print(response.result)
                switch response.result {
                case .success(_):
                    
                    BannerManager.showMessage(errorMessageStr: "تغییرات با موفقیت انجام شد", .success)
                case .failure(_):
                    break
                }
            }
        
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        print(newImage.size)
        prrofileImageView.image = newImage
        self.image = newImage
        dismiss(animated: true)
    }
}
