//
//  File.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit

extension UIViewController{
    /**
     This function returns a view controller from a storyboard.
     - parameters storyboardName: it's a struct that holds all storyboard names that are included in the project.
     - Returns: UIViewController
     */
    static func instantiateFromStoryboardName(storyboardName: StoryboardName) -> Self {
        return storyboardName.viewController(viewControllerClass: self)
    }
    
    /**
     This variable returns the name of a storyboard that contains a specific view controller.
     */
    class var storyboardID: String {
        return "\(self)"
    }
    
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
