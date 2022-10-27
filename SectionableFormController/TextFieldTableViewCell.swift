import UIKit

class TextFieldTableViewCell: UITableViewCell {

    let leftLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .jostRegular(ofSize: 16)
        return label
    }()
    
    let valueTextField = NTextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("unimplemented init(coder:)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(row: Row) {
        leftLabel.text = row.title
        valueTextField.isEnabled = false
        valueTextField.placeholder = row.placeholder
        valueTextField.text = row.subtitle
        valueTextField.textAlignment = .right
        
        valueTextField.attributedPlaceholder = NSAttributedString(
            string: valueTextField.placeholder ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ]
        )
        
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
        
//        if row.isMandatory || row.title.last == "*" {
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
    
    private func createSubviews() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(valueTextField)
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        valueTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            leftLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22),
            valueTextField.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor),
            valueTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueTextField.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
    }
}
