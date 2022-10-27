import UIKit

class TwoLabelsTableViewCell: UITableViewCell {
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .title
        label.numberOfLines = 0
        label.font = .jostRegular(ofSize: 16)
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .title
        label.textAlignment = .right
        label.font = .jostRegular(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var rightLabelTrailingConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("unimplemented init(coder:)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        leftLabel.textColor = .title
        rightLabel.textColor = .title
    }
    
    func setup(row: Row) {
        leftLabel.text = row.title
        rightLabel.text = row.subtitle
        
        rightLabelTrailingConstraint?.constant = accessoryType == .none ? -15 : -5
        
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
        leftLabel.attributedText = attributedText
        
//        // If field name has *, set it in different color
//        if row.title.last == "*" {
//            guard let index = row.title.lastIndex(of: "*") else {
//                leftLabel.text = row.title
//                return
//            }
//            let distance: Int = row.title.distance(from: row.title.startIndex, to: index)
//            let attributedText = NSMutableAttributedString(string: row.title)
//            attributedText.addAttribute(.foregroundColor, value: UIColor.primary1, range: .init(location: distance, length: 1))
//            attributedText.addAttribute(.font, value: UIFont.jostBold(ofSize: 16), range: .init(location: distance, length: 1))
//            leftLabel.attributedText = attributedText
//        } else {
//            leftLabel.text = row.title
//        }
    }
    
    func setup(left: String, right: String) {
        leftLabel.text = left
        rightLabel.text = right
        rightLabelTrailingConstraint?.constant = accessoryType == .none ? -15 : -5
    }
    
    func disabledCell(_ disabled: Bool) {
        if disabled {
            leftLabel.textColor = UIColor.title.withAlphaComponent(0.4)
            rightLabel.textColor = UIColor.title.withAlphaComponent(0.4)
        } else {
            leftLabel.textColor = .title
            rightLabel.textColor = .title
        }
    }
    
    private func createSubviews() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            rightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            rightLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            rightLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor, constant: 5)
        ])
        
        let constraint = rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        constraint.isActive = true
        rightLabelTrailingConstraint = constraint
    }
}
