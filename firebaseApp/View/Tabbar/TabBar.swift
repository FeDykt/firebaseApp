//
//  TabBar.swift
//  firebaseApp
//
//  Created by fedot on 02.12.2021.
//

import UIKit
import Firebase

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
           UITabBar.appearance().barTintColor = .systemBackground
           tabBar.tintColor = .label
        
           setupVCs()
        
    }

    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.image = image
            createNavBarButton(rootViewController: rootViewController)
            return navController
        }
    
    func createNavBarButton(rootViewController: UIViewController) {
        let logo = UIBarButtonItem(title: "InstaClon", style: .plain, target: self, action: nil)
        let textAttributes = [NSAttributedString.Key.font: UIFont(name: "SignPainter", size: 36)!]
        logo.tintColor = .black
        logo.setTitleTextAttributes(textAttributes, for: .normal)
        logo.setTitleTextAttributes(textAttributes, for: .highlighted)
        rootViewController.navigationItem.leftBarButtonItem = logo
    }

    
    func setupVCs() {
            viewControllers = [
                createNavController(for: TableViewController(),
                                       title: NSLocalizedString("Home", comment: ""),
                                       image: UIImage(systemName: "house")!),
                createNavController(for: AuthVC(),
                                       title: NSLocalizedString("Search", comment: ""),
                                       image: UIImage(systemName: "magnifyingglass")!),
                createNavController(for: ViewController(),
                                       title: NSLocalizedString("Reals", comment: ""),
                                       image: UIImage(systemName: "play.rectangle")!),
                createNavController(for: ViewController(),
                                       title: NSLocalizedString("Profile", comment: ""),
                                       image: UIImage(systemName: "heart")!),
                createNavController(for: ViewController(),
                                       title: NSLocalizedString("Profile", comment: ""),
                                       image: UIImage(systemName: "person")!)
            ]
        }
    
}




