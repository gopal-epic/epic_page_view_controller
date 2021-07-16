//
//  NufWelcomePageView.swift
//  EpicPageViewController
//
//  Created by Gopal Rao Gurram on 6/29/21.
//

import UIKit

class NufWelcomePageView: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var page: NufWelcomePage
    
    init(with page: NufWelcomePage) {
        self.page = page
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel?.text = "titleLabel Text"
    }
}
