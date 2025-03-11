
import UIKit

final class AddWishCell: UITableViewCell {
    //MARK: - Constatnts
    static let reuseId: String = "AddWishCell"
    private enum Constants {
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        enum TextField {
            static let backgroundColor: UIColor = .yellow
            static let placeholder: String = "Input ypur Wish"
            static let height: CGFloat = 50
            static let width: CGFloat = 100
            static let verticalConstraint: CGFloat = 3
            static let leftConstraint: CGFloat = 3
            static let rightConstraint: CGFloat = 30
        }
        enum AddButton {
            static let backgroundColor: UIColor = .blue
            static let height: CGFloat = 20
            static let width: CGFloat = 20
            static let leftConstraint: CGFloat = 5
            static let imageSystemName: String = "checkmark"
        }
        enum Wrap {
            static let backgroundColor: UIColor = .red
            static let height: CGFloat = 50
            static let width: CGFloat = 100
            static let pinContraint: CGFloat = 10
            static let cornerRadius: CGFloat = 10
        }
        enum PlaceHolder {
            static let string: String = "Введите желание"
        }
    }
    
    // MARK: - Variables
    private let wrap: UIView = UIView()
    private let addButton: UIButton = UIButton(type: .custom)
    private let textField: UITextField = UITextField()
    
    var addWish: ((String) -> Void)?
    
    //MARK: Properties
    private var textFieldColor: UIColor = .black {
        didSet {
            textField.textColor = textFieldColor
            addButton.tintColor = textFieldColor
            textField.attributedPlaceholder = NSAttributedString(
                string: Constants.PlaceHolder.string, // Текст плейсхолдера
                attributes: [
                    .foregroundColor: textFieldColor
                ]
            )
        }
    }
    
    private var wrapBackgroundColor: UIColor = Constants.Wrap.backgroundColor {
        didSet {
            wrap.backgroundColor = wrapBackgroundColor
        }
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    func setText(_ text: String) {
        textField.text = text
    }
    
    //MARK: - Configures
    
    func configure (textColor: UIColor, backgroundColor: UIColor) {
        textFieldColor = textColor
        wrapBackgroundColor = backgroundColor
    }
    
    func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        configureTextField()
        configureWrapLabel()
        configureAddButton()
        
    }
    
    func configureWrapLabel() {
        wrap.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        wrap.layer.cornerRadius = 10
        contentView.addSubview(wrap)
        wrap.pin(to: contentView, Constants.Wrap.pinContraint)
    }
    
    func configureTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        textField.backgroundColor = .clear
        textField.placeholder = Constants.TextField.placeholder
        textField.layer.cornerRadius = Constants.Wrap.cornerRadius
        wrap.addSubview(textField)
        
        textField.pinVertical(to: wrap, Constants.TextField.verticalConstraint)
        textField.pinLeft(to: wrap, Constants.TextField.leftConstraint)
        textField.pinRight(to: wrap, Constants.TextField.rightConstraint)
    }
    
    func configureAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        addButton.setHeight(Constants.AddButton.height)
        addButton.setWidth(Constants.AddButton.width)
        addButton.setImage(UIImage(systemName: Constants.AddButton.imageSystemName), for: .normal)
        contentView.addSubview(addButton)
        addButton.pinCenterY(to: textField)
        addButton.pinLeft(to: textField.trailingAnchor, 5)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
          

    }
    
    //MARK: - Actions
    @objc private func addButtonTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        addWish?(text) // Вызываем замыкатель, передавая текст
        textField.text = "" // Очищаем текстовое поле
        }
}
