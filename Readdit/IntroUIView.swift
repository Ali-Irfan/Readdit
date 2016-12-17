//
//  IntroUIView.swift
//  Readdit
//
//  Created by Ali Irfan on 2016-12-09.
//  Copyright © 2016 Ali Irfan. All rights reserved.
//

import UIKit
import SideMenu

class IntroUIView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        
    var image = General.resizeImage(image: UIImage(named: "menu-2")!, targetSize: CGSize(width: 15, height: 15))
    
    image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        
        self.navigationItem.leftBarButtonItem?.action = #selector(openSidebar)
    }
    
    func openSidebar(){
        print("Clicked")
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
}
