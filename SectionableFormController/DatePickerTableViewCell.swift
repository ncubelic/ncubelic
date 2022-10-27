import UIKit

class DatePickerTableViewCell: UITableViewCell {
    
    private lazy var horizontalStack = configure(UIStackView()) {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    private lazy var verticalStack = configure(UIStackView()) {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let datePicker = configure(NDatePicker()) {
        $0.isHidden = true
    }
    
    let leftLabel = configure(UILabel()) {
        $0.textColor = .title
        $0.font = .jostRegular(ofSize: 16)
        $0.numberOfLines = 0
    }
    
    let rightLabel = configure(UILabel()) {
        $0.textColor = .title
        $0.textAlignment = .right
        $0.numberOfLines = 0
        $0.font = .jostRegular(ofSize: 16)
        $0.lineBreakMode = .byWordWrapping
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with row: Row) {
        leftLabel.text = row.title
        rightLabel.text = row.subtitle != nil ? row.subtitle : row.placeholder
        rightLabel.textColor = row.subtitle != nil ? .title : .lightGray
        datePicker.isHidden = !row.isSelected
        
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
    
    private func setupViews() {
        horizontalStack.addArrangedSubview(leftLabel)
        horizontalStack.addArrangedSubview(rightLabel)

        verticalStack.addArrangedSubview(horizontalStack)
        verticalStack.addArrangedSubview(datePicker)
        
        contentView.addSubview(verticalStack)
        
        verticalStack.layout(using: [
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
