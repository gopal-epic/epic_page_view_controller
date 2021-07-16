//
//  ViewController.swift
//  EpicPageViewController
//
//  Created by Gopal Rao Gurram on 6/29/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .lightGray
        
        showNufWelcomeScreen()
    }
    
    func showNufWelcomeScreen() {
        let nufWelcomeView = NufWelcomeScreenViewController()
        navigationController?.pushViewController(nufWelcomeView, animated: true)
    }

}

