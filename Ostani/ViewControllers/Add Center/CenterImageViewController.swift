//
//  CenterImageViewController.swift
//  Ostani
//
//  Created by ali on 7/16/21.
//

import UIKit
import Cosmos
import TOCropViewController
import Alamofire

class CenterImageViewController: UIViewController, TOCropViewControllerDelegate {
    
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var uploadImageContainerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func uploadImageViewDidTap(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func doneButtonDidTap(_ sender: Any) {
        loadingActivityIndicator.startAnimating()
        loadingActivityIndicator.isHidden = false
        let url = try! "http://api.alihejazi.me/AddCenter/Save/".asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        model.score = Int(rateView.rating)
        model.image = selectedImage?.imageToBase64
        
        let json: [String: Any] = [
            "name": model.name,
            "centerTypeId": model.centerTypeId,
            "telephone": model.telephone,
            "address": model.address,
            "latitude": model.latitude,
            "longitude": model.longitude,
            "image": model.image ?? "",
            "score": model.score,
            "manager":
                [
                    "phoneNumber": model.manager.phoneNumber,
                    "firstName": model.manager.firstName,
                    "lastName": model.manager.lastName,
                    "nationalCode": model.manager.nationalCode,
                    "birthDate": model.manager.birthDate,
                ]
        ]
        
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: json)
        
        AF.request(urlRequest)
            .response { (response) in
                switch response.result {
                case .success(_ ):
                    DispatchQueue.main.async { [self] in
                        loadingActivityIndicator.isHidden = true
                        loadingActivityIndicator.stopAnimating()
                        BannerManager.showMessage(errorMessageStr: "مرکز با موفقیت ثبت شد", .success)
                        let homeVC = HomeViewController.instantiateFromStoryboardName(storyboardName: .Main)
                        Coordinator.appNavigationController.setViewControllers([homeVC], animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    BannerManager.showMessage(errorMessageStr: "خطا در ثبت مرکز")
                    DispatchQueue.main.async { [self] in
                        loadingActivityIndicator.isHidden = true
                        loadingActivityIndicator.stopAnimating()
                        
                    }
                }
            }
        
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        Coordinator.popViewController(viewController: self)
    }
    
    var model: AddCenterBody!
    var selectedImage: UIImage? = nil
    var imagePicker = UIImagePickerController()
    var imageCroper: TOCropViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadingActivityIndicator.stopAnimating()
        loadingActivityIndicator.isHidden = true
        rateView.rating = 5
    }
    
    func setupUI() {
        backButton.roundUp(14)
        doneButton.roundUp(14)
        uploadImageContainerView.roundUp(20)
    }
}

extension CenterImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        self.selectedImage = newImage
        dismiss(animated: true)
        presentCropViewController(image: newImage)
    }
    
    func presentCropViewController(image: UIImage) {
        self.imageCroper = TOCropViewController(image: image)
        imageCroper.delegate = self
        self.present(imageCroper, animated: true)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        restaurantImageView.image = image
        uploadLabel.isHidden = true
        self.selectedImage = image
        dismiss(animated: true)
    }
}

