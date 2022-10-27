import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(ofType type: T.Type) {
        let identifier = String(describing: type.self)
        self.register(T.self, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(ofType type: T.Type) {
        let identifier = String(describing: type.self)
        self.register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: type.self), for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
    
    func dequeueHeaderFooter<T>(_ type: T.Type) -> T {
        let identifier = String(describing: type.self)
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("Unable to dequeue header/footer view with identifier: \(identifier)")
        }
        return view
    }
}
