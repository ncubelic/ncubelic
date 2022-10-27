import UIKit

class TextViewTableViewCell: UITableViewCell {
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.font = .jostRegular(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let textview = configure(NTextView()) {
        $0.adjustsFontForContentSizeCategory = true
        $0.isScrollEnabled = false
        $0.keyboardDismissMode = .interactive
        $0.layer.borderColor = UIColor.gray.cgColor
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with row: Row) {
        topLabel.text = row.title
        
        var attributedText = NSAttributedString()
        if let subtitle = row.subtitle {
            attributedText = NSAttributedString(string: subtitle, attributes: [NSAttributedString.Key.foregroundColor: UIColor.title])
        } else {
            attributedText = NSAttributedString(string: row.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        }
        textview.attributedText = attributedText
        
        // If field name has *, set it in different color
        let attributedTitle = NSMutableAttributedString(string: row.title)
        if row.isMandatory {
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.primary1,
                NSAttributedString.Key.font: UIFont.jostBold(ofSize: 16)
            ]
            let sign = NSAttributedString(string: " *", attributes: attributes)
            attributedTitle.append(sign)
        }
        topLabel.attributedText = attributedTitle
//        // If field name has *, set it in different color
//        if row.title.last == "*" {
//            guard let index = row.title.lastIndex(of: "*") else {
//                topLabel.text = row.title
//                return
//            }
//            let distance: Int = row.title.distance(from: row.title.startIndex, to: index)
//            let attributedText = NSMutableAttributedString(string: row.title)
//            attributedText.addAttribute(.foregroundColor, value: UIColor.primary1, range: .init(location: distance, length: 1))
//            attributedText.addAttribute(.font, value: UIFont.jostBold(ofSize: 16), range: .init(location: distance, length: 1))
//            topLabel.attributedText = attributedText
//        } else {
//            topLabel.text = row.title
//        }
    }
    
    private func setupViews() {
        contentView.addSubview(topLabel)
        contentView.addSubview(textview)
        
        topLabel.layout(using: [
            topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            topLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        textview.layout(using: [
            textview.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 5),
            textview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            textview.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
}
