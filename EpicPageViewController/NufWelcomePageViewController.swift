//
//  NufWelcomePageViewController.swift
//  Epic
//
//  Created by Gopal Rao Gurram on 6/29/21.
//  Copyright © 2021 Epic. All rights reserved.
//

import UIKit

class NufWelcomePageViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!

    var page: NufWelcomePage
    var variant: ExperimentConstants.WelcomeExperienceVariants

    init(with variant: ExperimentConstants.WelcomeExperienceVariants, page: NufWelcomePage) {
        self.variant = variant
        self.page = page

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.image = page.backgroundImage(for: variant)
    }
}
