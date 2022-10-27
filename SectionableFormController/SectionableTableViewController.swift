import UIKit

protocol SectionableSwitcherDelegate: AnyObject {
    func switcher(_ switcher: NSwitch, isSwitcherOn: Bool, indexPath: IndexPath?)
}

protocol SectionableTextFieldDelegate: AnyObject {
    func textField(_ textField: NTextField, didEndEditingAt indexPath: IndexPath?)
}

protocol SectionableDatePickerDelegate: AnyObject {
    func datePicker(_ datePicker: NDatePicker, didChangeDate date: Date, at indexPath: IndexPath)
}

protocol SectionableTextViewDelegate: AnyObject {
    func textView(_ textView: NTextView, didEndEditingAt indexPath: IndexPath?)
}

protocol SectionableSegmentedControlDelegate: AnyObject {
    func segmentedControl(_ segmentedControl: NSegmentedControl, didSelectText text: String?, index: Int, indexPath: IndexPath?)
}

class SectionableTableViewController: UIViewController, KeyboardObserving {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var sections: [Section]
    var bottomConstraint: NSLayoutConstraint?
    var keyboardObserver: NSObjectProtocol?
    
    weak var sectionableTextFieldDelegate: SectionableTextFieldDelegate?
    weak var sectionableSwitcherDelegate: SectionableSwitcherDelegate?
    weak var sectionableDatePickerDelegate: SectionableDatePickerDelegate?
    weak var sectionableTextViewDelegate: SectionableTextViewDelegate?
    weak var sectionableSegmentedControlDelegate: SectionableSegmentedControlDelegate?
    
    deinit {
        removeKeyboardObservers(from: .default)
    }
    
    init(sections: [Section]) {
        self.sections = sections
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("unimplmeneted init(coder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerCell(ofType: TextFieldTableViewCell.self)
        tableView.registerCell(ofType: SwitcherTableViewCell.self)
        tableView.registerCell(ofType: DatePickerTableViewCell.self)
        tableView.registerCell(ofType: TextViewTableViewCell.self)
        tableView.registerCell(ofType: TwoLabelsTableViewCell.self)
        tableView.registerCell(ofType: SegmentedTableViewCell.self)
        setupViews()
        addKeyboardObservers(to: .default)
    }
    
    func keyboardWillShow(withSize size: CGSize) {
        tableView.contentInset.bottom = size.height
        tableView.verticalScrollIndicatorInsets.bottom = size.height
    }
    
    func keyboardWillHide() {
        tableView.contentInset.bottom = 0
        tableView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    func update(sections: [Section], shouldReload: Bool = true) {
        self.sections = sections
        if shouldReload {
            tableView.reloadData()
        }
    }
    
    @objc func dismissAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        bottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint?.isActive = true
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}

extension SectionableTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].rows[indexPath.row]
        switch item.type {
        case .textField(let config):
            let cell = tableView.dequeueReusableCell(TextFieldTableViewCell.self, for: indexPath)
            cell.valueTextField.indexPath = indexPath
            cell.valueTextField.configure(with: config)
            cell.valueTextField.inputAccessoryView = UIToolbar().makeDoneToolbar(selector: #selector(doneButtonAction))
            cell.valueTextField.delegate = self
            cell.setup(row: item)
            return cell
        case .switcher:
            let cell = tableView.dequeueReusableCell(SwitcherTableViewCell.self, for: indexPath)
            cell.switcher.indexPath = indexPath
            cell.delegate = self
            cell.configure(with: item)
            return cell
        case .date(let config):
            let cell = tableView.dequeueReusableCell(DatePickerTableViewCell.self, for: indexPath)
            cell.setup(with: item)
            cell.datePicker.minimumDate = config.minDate
            cell.datePicker.maximumDate = config.maxDate
            if let selectedDate = config.selectedDate {
                cell.datePicker.setDate(selectedDate, animated: false)
            }
            cell.datePicker.indexPath = indexPath
            cell.datePicker.datePickerMode = config.timeComponent ? .dateAndTime : .date
            cell.datePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
            return cell
        case .textView:
            let cell = tableView.dequeueReusableCell(TextViewTableViewCell.self, for: indexPath)
            cell.setup(with: item)
            cell.textview.delegate = self
            cell.textview.indexPath = indexPath
            cell.textview.inputAccessoryView = UIToolbar().makeDoneToolbar(selector: #selector(doneButtonAction))
            return cell
        case .disclosure:
            let cell = tableView.dequeueReusableCell(TwoLabelsTableViewCell.self, for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.setup(row: item)
            return cell
        case .segmented(let config):
            let cell = tableView.dequeueReusableCell(SegmentedTableViewCell.self, for: indexPath)
            cell.segmentedControl.indexPath = indexPath
            cell.set(config, row: item)
            cell.delegate = self
            return cell
        default:
            fatalError("unimplemented row type: \(item.type)")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections[section].description
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousState = sections[indexPath.section].rows[indexPath.row].isSelected
        let previouslySelectedIndexPaths = sections.selectedIndexPaths()
        
        sections[indexPath.section].rows.deselectAll()
        sections[indexPath.section].rows[indexPath.row].setSelected(!previousState)
        tableView.reloadRows(at: [indexPath] + previouslySelectedIndexPaths, with: .automatic)
        
        let item = sections[indexPath.section].rows[indexPath.row]
        
        switch item.type {
        case .textField:
            guard let textFieldCell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell else { return }
            textFieldCell.valueTextField.isEnabled = true
            textFieldCell.valueTextField.becomeFirstResponder()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections[section].rows.isEmpty {
            return .leastNonzeroMagnitude
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if sections[section].rows.isEmpty {
            return .leastNonzeroMagnitude
        } else {
            return UITableView.automaticDimension
        }
    }
    
    @objc func doneButtonAction() {
        view.endEditing(true)
    }
    
    @objc func dateValueChanged(_ sender: NDatePicker) {
        guard let indexPath = sender.indexPath else {
            print("Unknown indexPath")
            return
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? DatePickerTableViewCell else { return }
        if case CellType.date(let config) = sections[indexPath.section].rows[indexPath.row].type {
            sections[indexPath.section].rows[indexPath.row].subtitle = config.timeComponent == true ? DateFormatter.icarus.string(from: sender.date) : DateFormatter.onlyDate.string(from: sender.date)
        }
        cell.setup(with: sections[indexPath.section].rows[indexPath.row])
        sectionableDatePickerDelegate?.datePicker(sender, didChangeDate: sender.date, at: indexPath)
    }
}

extension SectionableTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = textField as? NTextField else { return }
        sectionableTextFieldDelegate?.textField(textField, didEndEditingAt: textField.indexPath)
        textField.isEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? NTextField else { return true }
        guard let maxCharacters = textField.maxCharacters else { return true }
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= maxCharacters
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textField = textField as? NTextField else { return false }
        guard let indexPath = textField.indexPath else { return false }
        guard let nextIndexPath = nextIndexPath(for: indexPath, in: tableView) else { return false }
        if let cell = tableView.cellForRow(at: nextIndexPath) as? TextFieldTableViewCell {
            cell.valueTextField.isEnabled = true
            cell.valueTextField.becomeFirstResponder()
        } else if let cell = tableView.cellForRow(at: nextIndexPath) as? TextViewTableViewCell {
            cell.textview.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func nextIndexPath(for currentIndexPath: IndexPath, in tableView: UITableView) -> IndexPath? {
        var nextRow = 0
        var nextSection = 0
        var iteration = 0
        var startRow = currentIndexPath.row
        for section in currentIndexPath.section ..< tableView.numberOfSections {
            nextSection = section
            for row in startRow ..< tableView.numberOfRows(inSection: section) {
                nextRow = row
                iteration += 1
                if iteration == 2 {
                    let nextIndexPath = IndexPath(row: nextRow, section: nextSection)
                    return nextIndexPath
                }
            }
            startRow = 0
        }
        
        return nil
    }
}

extension SectionableTableViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightText {
            textView.text = nil
            textView.textColor  = .title
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let textView = textView as? NTextView else { return }
        sectionableTextViewDelegate?.textView(textView, didEndEditingAt: textView.indexPath)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
}

extension SectionableTableViewController: SwitcherTableViewCellDelegate {
    
    func switcherTableViewCell(_ cell: SwitcherTableViewCell, isSwitcherOn isOn: Bool, indexPath: IndexPath?) {
        sectionableSwitcherDelegate?.switcher(cell.switcher, isSwitcherOn: isOn, indexPath: indexPath)
    }
}

extension SectionableTableViewController: SectionableSegmentedControlDelegate {
    
    func segmentedControl(_ segmentedControl: NSegmentedControl, didSelectText text: String?, index: Int, indexPath: IndexPath?) {
        sectionableSegmentedControlDelegate?.segmentedControl(segmentedControl, didSelectText: text, index: index, indexPath: indexPath)
    }
}

