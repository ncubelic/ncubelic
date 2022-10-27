import UIKit

class NTextField: UITextField {

    var indexPath: IndexPath?
    var maxCharacters: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("unimplemented init(coder:)")
    }
    
    func configure(with configuration: TextFieldConfiguration) {
        self.isSecureTextEntry = configuration.isSecured
        self.returnKeyType = configuration.returnKeyType
        self.keyboardType = configuration.keyboardType
        self.maxCharacters = configuration.maxCharacters
        self.textContentType = configuration.textContentType
        self.autocapitalizationType = configuration.autocapitalizationType ?? UITextAutocapitalizationType.sentences
    }
    
    private func setupViews() {
        borderStyle = .none
        font = .jostRegular(ofSize: 16)
    }
}
