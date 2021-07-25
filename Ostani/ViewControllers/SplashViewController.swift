//
//  SplashViewController.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit
import Alamofire

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Coordinator.appNavigationController = self.navigationController
        if StoringData.token.isEmpty {
            let mobileVC = MobileViewController.instantiateFromStoryboardName(storyboardName: .Main)
            Coordinator.appNavigationController.setViewControllers([mobileVC], animated: true)
        } else {
            getUserData()
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
                    DispatchQueue.main.async {
                        let homeVC = HomeViewController.instantiateFromStoryboardName(storyboardName: .Main)
                        Coordinator.appNavigationController.setViewControllers([homeVC], animated: true)
                    }
                case .failure(let error):
                    BannerManager.showMessage(errorMessageStr: error.localizedDescription)
                    DispatchQueue.main.async {
                        let mobileVC = MobileViewController.instantiateFromStoryboardName(storyboardName: .Main)
                        Coordinator.appNavigationController.setViewControllers([mobileVC], animated: true)
                    }
                }
            }
    }

}
