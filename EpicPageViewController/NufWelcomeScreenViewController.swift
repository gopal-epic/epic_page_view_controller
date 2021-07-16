//
//  NufWelcomeScreenViewController.swift
//  EpicPageViewController
//
//  Created by Gopal Rao Gurram on 6/29/21.
//

import UIKit

struct ExperimentConstants {

    enum ExperimentLabel: String {

        case experimentExampleLabel = "experiment-example-label"
        case experimentExampleLabelMultiVariant = "experiment-example-label-multi-variant"
        case welcomeExperiencePhase4Label = "welcome_experience_phase4"
        case noFirstBookOfTheDayBlocker = "first_book_of_the_day"

        public func getVariantLabel() -> String {
            switch self {
            case .experimentExampleLabel:
                return "experiment-example-variant-label"
            case .welcomeExperiencePhase4Label:
                return "experiment-example-variant-label"
            case .noFirstBookOfTheDayBlocker:
                return "first_book_of_the_day_no_show"
            default:
                return ""
            }
        }
    }

    enum WelcomeExperienceVariants: String, CaseIterable {
        case control = "welcome_experience_phase4_control"
        case variant1 = "welcome_experience_phase4_variant1"
        case variant2 = "welcome_experience_phase4_variant2"
        case variant3 = "welcome_experience_phase4_variant3"
        case variant4 = "welcome_experience_phase4_variant4"

        static func getVariantType() -> WelcomeExperienceVariants {
            return .variant1
        }
    }
}

enum NufWelcomePage: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo

    static func getPages(for variant: ExperimentConstants.WelcomeExperienceVariants) -> [NufWelcomePage] {
        switch variant {
        case .variant2:
            return [.pageZero]
        default:
            return [.pageZero, .pageOne, .pageTwo]
        }
    }

    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        }
    }

    func backgroundImage(for variant: ExperimentConstants.WelcomeExperienceVariants) -> UIImage? {
        switch variant {
        case .variant1:
            switch self {
            case .pageZero:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "variant1_iPhone_1" : "variant1_iPad_1")
            case .pageOne:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "variant1_iPhone_2" : "variant1_iPad_2")
            case .pageTwo:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "variant1_iPhone_3" : "variant1_iPad_3")
            }
        case .variant2:
            return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "variant2_iPhone" : "variant2_iPad")
        case .variant3:
            switch self {
            case .pageZero:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "variant3_iPhone_1" : "variant3_iPad_1")
            case .pageOne:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "variant3_iPhone_2" : "variant3_iPad_2")
            case .pageTwo:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "variant3_iPhone_3" : "variant3_iPad_3")
            }
        case .variant4:
            switch self {
            case .pageZero:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "variant4_iPhone_1" : "variant4_iPad_1")
            case .pageOne:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "variant4_iPhone_2" : "variant4_iPad_2")
            case .pageTwo:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "variant4_iPhone_3" : "variant4_iPad_3")
            }
        default:
            switch self {
            case .pageZero:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "control_iPhone_1" : "control_iPad_1")
            case .pageOne:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "control_iPhone_2" : "control_iPad_2")
            case .pageTwo:
                return UIImage(named: UIDevice.current.userInterfaceIdiom == .phone ? "control_iPhone_3" : "control_iPad_3")
            }
        }
    }
}

class NufWelcomeScreenViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var variant = ExperimentConstants.WelcomeExperienceVariants.control
    private var pageViewController: UIPageViewController?
    private var pages: [NufWelcomePage] = NufWelcomePage.getPages(for: .control)
    private var currentIndex: Int = 0
    var isAnimatingRotateCarousel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        variant = ExperimentConstants.WelcomeExperienceVariants.getVariantType()
        if variant != .control {
            pages = NufWelcomePage.getPages(for: variant)
        }

        setupPageViewController()
        
        view.bringSubviewToFront(pageControl)
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        pageViewController?.view.backgroundColor = .clear
        pageViewController?.view.frame = view.frame
        view.addSubview(pageViewController!.view)

        let initialVC = NufWelcomePageViewController(with: variant, page: pages[0])

        pageViewController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)

        pageViewController?.didMove(toParent: self)
    }

    private func updatePageControl() {
        guard variant != .variant2
        else {
            pageControl.isHidden = true
            return
        }

        if variant != .control {
            pageControl.currentPageIndicatorTintColor = UIColor.white
        }
    }

    func viewControllerAtIndex(_ index: Int) -> NufWelcomePageViewController? {
        return NufWelcomePageViewController(with: variant, page: pages[index])
    }
}

//MARK: - Page setup

extension NufWelcomeScreenViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed,
           let viewController = pageViewController.viewControllers?.first as? NufWelcomePageViewController {
            pageControl.currentPage = viewController.page.index
        }
    }
}

extension NufWelcomeScreenViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewController = viewController as? NufWelcomePageViewController
        else { return nil }

        var newIndex = viewController.page.index - 1
        if newIndex < 0 {
            newIndex = pages.count - 1
        }

        return viewControllerAtIndex(newIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewController = viewController as? NufWelcomePageViewController
        else { return nil }

        var newIndex = viewController.page.index + 1
        if newIndex >= pages.count {
            newIndex = 0
        }

        return viewControllerAtIndex(newIndex)
    }
}

extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

}
