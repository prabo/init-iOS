import UIKit

public enum Storyboard: String {
    case MissionList
    case MissionDetail
    case MissionAdd
    case MissionEdit
    case CategoryList
    case CategoryAdd
    case Register

    public func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        let viewControlelr = UIStoryboard(name: self.rawValue, bundle: nil).instantiateInitialViewController()
        guard let vc = viewControlelr as? VC else {
            fatalError("Couldn't instantiate \(self.rawValue)")
        }

        return vc
    }
}
