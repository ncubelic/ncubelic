//
//  SegmentedTableViewCell.swift
//  Icarus SMS
//
//  Created by Nikola Cubelic on 04/08/2022.
//

import UIKit

class SegmentedTableViewCell: UITableViewCell {
    
    private lazy var leftLabel = configure(UILabel()) {
        $0.font = .jostRegular(ofSize: 16)
        $0.textColor = .title
        $0.numberOfLines = 0
    }
    
    lazy var segmentedControl: NSegmentedControl = {
        let segmentedControl = NSegmentedControl(items: items)
        segmentedControl.tintColor = .primary1
        segmentedControl.selectedSegmentTintColor = .primary1
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.title], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentedChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    var items: [String] = []
    var title: String = ""
    
    weak var delegate: SectionableSegmentedControlDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        segmentedControl.selectedSegmentIndex = -1
    }
    
    func set(_ configuration: SegmentedConfiguration, row: Row) {
        segmentedControl.removeAllSegments()
        configuration.data.indices.forEach { index in
            segmentedControl.insertSegment(with: nil, at: index, animated: false)
            segmentedControl.setTitle(configuration.data[index].title ?? "", forSegmentAt: index)
            
            if configuration.data[index].isSelected {
                segmentedControl.selectedSegmentIndex = index
            }
        }
        leftLabel.text = row.title
    }
    
    @objc private func segmentedChanged(_ sender: NSegmentedControl) {
//        let segmentTag = segmentedControl.tag
        let selectedIndex = segmentedControl.selectedSegmentIndex
        let selectedText = segmentedControl.titleForSegment(at: selectedIndex)
        delegate?.segmentedControl(sender, didSelectText: selectedText, index: selectedIndex, indexPath: sender.indexPath)
    }
    
    private func setupViews() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(segmentedControl)
        
        leftLabel.layout(using: [
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftLabel.trailingAnchor.constraint(lessThanOrEqualTo: segmentedControl.leadingAnchor, constant: -5)
        ])
        
        segmentedControl.layout(using: [
            segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        segmentedControl.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
