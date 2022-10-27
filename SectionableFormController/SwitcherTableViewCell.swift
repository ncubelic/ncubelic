import UIKit

protocol SwitcherTableViewCellDelegate: AnyObject {
    func switcherTableViewCell(_ cell: SwitcherTableViewCell, isSwitcherOn isOn: Bool, indexPath: IndexPath?)
}

class SwitcherTableViewCell: UITableViewCell {
    
    lazy var switcher: NSwitch = {
        let switcher = NSwitch()
        return switcher
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    weak var delegate: SwitcherTableViewCellDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("unimplemented init(coder:)")
    }
    
    func configure(with row: Row) {
        textLabel?.text = row.title
        
        if let isOn = row.subtitle {
            switcher.isOn = isOn == Switcher.on.rawValue
        }
        switcher.addTarget(self, action: #selector(switcherChanged), for: .valueChanged)
        
        // If field name has *, set it in different color
        let attributedText = NSMutableAttributedString(string: row.title)
        if row.isMandatory {
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.primary1,
                NSAttributedString.Key.font: UIFont.jostBold(ofSize: 16)
            ]
            let sign = NSAttributedString(string: " *", attributes: attributes)
            attributedText.append(sign)
        }
        textLabel?.attributedText = attributedText
//        // If field name has *, set it in different color
//        if row.title.last == "*" {
//            guard let index = row.title.lastIndex(of: "*") else {
//                textLabel?.text = row.title
//                return
//            }
//            let distance: Int = row.title.distance(from: row.title.startIndex, to: index)
//            let attributedText = NSMutableAttributedString(string: row.title)
//            attributedText.addAttribute(.foregroundColor, value: UIColor.primary1, range: .init(location: distance, length: 1))
//            attributedText.addAttribute(.font, value: UIFont.jostBold(ofSize: 16), range: .init(location: distance, length: 1))
//            textLabel?.attributedText = attributedText
//        } else {
//            textLabel?.text = row.title
//        }
    }
    
    private func setupViews() {
        accessoryView = switcher
        textLabel?.font = .jostRegular(ofSize: 16)
        textLabel?.numberOfLines = 0
    }
    
    @objc func switcherChanged() {
        delegate?.switcherTableViewCell(self, isSwitcherOn: switcher.isOn, indexPath: switcher.indexPath)
    }
}

class NSwitch: UISwitch {
    
    var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        onTintColor = .primary1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Switcher: String {
    case on
    case off
}
