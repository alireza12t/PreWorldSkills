//
//  Coordinator.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit

enum StoryboardName: String {
    case Main
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    func viewController<T : UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return self.instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

class Coordinator: NSObject {
    static var appNavigationController: UINavigationController!
    /**
     This function pushes a view controller on another view controller using the existing navigation controller in our hierchy
     - parameter sourceViewController: a view controller that we want to push the new view controller on.
     - parameter destinationViewController: a view controller that we want to show the user.
     */
    class func pushViewController(sourceViewController: UIViewController, destinationViewController: UIViewController, animated: Bool = true) {
        sourceViewController.navigationController?.pushViewController(destinationViewController, animated: animated)
    }
    /**
     This function pops a view controller inside navigation controller from a source view controller.
     - parameter viewController: a view controller that we want to display to user.
     */
    class func popViewController(viewController: UIViewController, animated: Bool = true) {
        if viewController.isModal{
            viewController.dismiss(animated: true)
        } else {
            viewController.navigationController?.popViewController(animated: true)
        }
    }
}
