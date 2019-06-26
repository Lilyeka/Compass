//
//  ViewController.swift
//  Compass
//
//  Created by Лилия Левина on 26/06/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let compass = CompassView()
        compass.frame = CGRect(x: 50, y: 100, width: 300, height: 300)
        
        view.addSubview(compass)
    }


}

