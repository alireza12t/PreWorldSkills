//
//  HomeViewController.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var allCenterCountContainerView: UIView!
    @IBOutlet weak var myCenterCountContainerView: UIView!
    @IBOutlet weak var allCenterCountLabel: UILabel!
    @IBOutlet weak var myCenterCountLabel: UILabel!
    @IBOutlet weak var addCenterButton: UIButton!
    @IBOutlet weak var seeCentersButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func profileButtonDidTap(_ sender: Any) {
        Coordinator.pushViewController(sourceViewController: self, destinationViewController: ProfileViewController.instantiateFromStoryboardName(storyboardName: .Main))
    }
    
    @IBAction func showAllCentersButtonDidTap(_ sender: Any) {
        Coordinator.pushViewController(sourceViewController: self, destinationViewController: CenterListViewController.instantiateFromStoryboardName(storyboardName: .Main))
    }
    
    @IBAction func addCenterButtonDidTap(_ sender: Any) {
        Coordinator.pushViewController(sourceViewController: self, destinationViewController: ManagerMobileNumberViewController.instantiateFromStoryboardName(storyboardName: .Main))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        setupUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
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
    
    func setupUi() {
        profileContainerView.roundUp(20)
        allCenterCountContainerView.roundUp(20)
        myCenterCountContainerView.roundUp(20)
        addCenterButton.roundUp(14)
        seeCentersButton.roundUp(14)
        profileImageView.addBorder(cornerRadius: 20, color: .brandGreen, borderWidth: 3)
        
        allCenterCountLabel.text = String(StoringData.allCentersCount)
        myCenterCountLabel.text = String(StoringData.myCentersCount)
        nameLabel.text = "\(StoringData.firstName) \(StoringData.lastName)"
        
        if StoringData.image.isEmpty {
            profileImageView.image = UIImage(named: "ui-user")!
        } else {
            profileImageView.image = StoringData.image.base64ToImage
        }
    }
    
    
}

