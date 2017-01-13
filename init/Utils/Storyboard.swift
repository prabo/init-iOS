import UIKit

public enum Storyboard: String {
    case MissionAddController
    case MissionCategoryAddController
    case MissionCategoryTableViewController
    case MissionDetailController
    case MissionEditController
    case MissionListTableViewController
    case RegisterViewController

    public func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        let viewControlelr = UIStoryboard(name: self.rawValue, bundle: nil).instantiateInitialViewController()
        guard let vc = viewControlelr as? VC else {
            fatalError("Couldn't instantiate \(self.rawValue)")
        }

        return vc
    }
}
