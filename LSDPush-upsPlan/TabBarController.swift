//
//  TabBarController.swift
//  LSDPush-upsPlan
//
//  Created by LSD on 2017/1/14.
//  Copyright © 2017年 LSD. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController! == viewController && viewController.isKind(of: CalendarViewController.self) {
            (viewController as! CalendarViewController).reloadData()
        }
        return true
    }
    
}
