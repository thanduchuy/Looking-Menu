//
//  HomeViewController.swift
//  Thực Đơn
//
//  Created by Huy Than Duc on 25/12/2020.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var buttonStated: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setStyle()
    }
    
    func setStyle() {
        icon.cornerCircle()
        buttonStated.layer.cornerRadius = buttonStated.frame.height/2
    }
    
}
