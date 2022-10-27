import UIKit

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(ofType type: T.Type) {
        let identifier = String(describing: type.self)
        self.register(T.self, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: type.self), for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier: \(identifier)")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type.self)
        
        guard let supplementaryView = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue supplementary view with identifier: \(identifier)")
        }
        return supplementaryView
    }
    
    func dequeueReusableSupplementaryFooterView<T: UICollectionReusableView>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type.self)
        
        guard let supplementaryView = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue supplementary view with identifier: \(identifier)")
        }
        return supplementaryView
    }
    
    func registerSupplementaryHeaderView<T: UICollectionReusableView>(ofType type: T.Type) {
        let identifier = String(describing: type.self)
        self.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    func registerSupplementaryFooterView<T: UICollectionReusableView>(ofType type: T.Type) {
        let identifier = String(describing: type.self)
        self.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
    }
}
