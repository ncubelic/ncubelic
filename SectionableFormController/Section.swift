//
//  Section.swift
//  Icarus SMS
//
//  Created by Nikola Čubelić on 19.10.2021..
//  Copyright © 2021 Inxelo Technologies. All rights reserved.
//

import UIKit

struct Section {
    var title: String?
    var description: String?
    var rows: [Row]
}

struct Row {
    var title: String
    var subtitle: String?
    var placeholder: String?
    var type: CellType
    var isSelected: Bool = false
    var isMandatory: Bool = false
    
    mutating func setSelected(_ selected: Bool) {
        self.isSelected = selected
    }
}

enum CellType {
    case textField(TextFieldConfiguration)
    case disclosure
    case checkbox
    case switcher
    case segmented(SegmentedConfiguration)
    case date(DateConfiguration)
    case textView
    case dropdown
    case subtitle
    case tags([Tag])
    
    mutating func update(dateConfiguration: DateConfiguration) {
        switch self {
        case .date:
            self = .date(dateConfiguration)
        default:
            break
        }
    }
}

struct TextFieldConfiguration {
    let keyboardType: UIKeyboardType
    let isSecured: Bool
    let returnKeyType: UIReturnKeyType
    var maxCharacters: Int?
    var textContentType: UITextContentType?
    var autocapitalizationType: UITextAutocapitalizationType?
}

extension TextFieldConfiguration {
    
    static var name: TextFieldConfiguration {
        TextFieldConfiguration(keyboardType: .asciiCapable, isSecured: false, returnKeyType: .next)
    }
    
    static var number: TextFieldConfiguration {
        TextFieldConfiguration(keyboardType: .numberPad, isSecured: false, returnKeyType: .next)
    }
    
    static var decimal: TextFieldConfiguration {
        TextFieldConfiguration(keyboardType: .decimalPad, isSecured: false, returnKeyType: .next)
    }
}

struct SegmentedConfiguration {
    
    let distribution: Distribution
    var data: [SegmentedModel]
    
    enum Distribution {
        case fill
        case trailing
    }
    
    struct SegmentedModel {
        let title: String?
        let image: UIImage?
        let value: Int?
        var isSelected = false
    }
    
    static var `default`: SegmentedConfiguration {
        .init(distribution: .trailing, data: [])
    }
}

struct DateConfiguration {
    var minDate: Date?
    var maxDate: Date?
    var selectedDate: Date?
    var timeComponent: Bool = false
}

extension DateConfiguration {
        
    init(minDate: Date?, maxDate: Date?) {
        self.minDate = minDate
        self.maxDate = maxDate
        self.selectedDate = nil
    }
}

extension Array where Element == Row {
    
    mutating func deselectAll() {
        for index in self.indices {
            self[index].isSelected = false
        }
    }
}

extension Array where Element == Section {
    
    func selectedIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for (index, section) in self.enumerated() {
            for (rowIndex, row) in section.rows.enumerated() where row.isSelected {
                indexPaths.append(IndexPath(row: rowIndex, section: index))
            }
        }
        return indexPaths
    }
}
