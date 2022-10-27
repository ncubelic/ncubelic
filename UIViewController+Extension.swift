import UIKit

extension UIViewController {
    
    func install(_ child: UIViewController) {
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(child.view)
        
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    func top() -> UIViewController {
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.top() ?? nav
        } else if let tab = self as? UITabBarController {
            return tab.selectedViewController ?? tab
        } else {
            return presentedViewController?.top() ?? self
        }
    }
}
