
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
        }
        enum AddButton {
            static let backgroundColor: UIColor = .blue
            static let height: CGFloat = 20
            static let width: CGFloat = 20
            static let rightConstraint: CGFloat = 10
        }
        enum Wrap {
            static let backgroundColor: UIColor = .red
            static let height: CGFloat = 50
            static let width: CGFloat = 100
            static let pinContraint: CGFloat = 10
        }
    }
    
    // MARK: - Variables
    private let wrap: UIView = UIView()
    private let addButton: UIButton = UIButton(type: .custom)
    private let textField: UITextField = UITextField()
    var addWish: ((String) -> Void)?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configures
    
    func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        configureTextField()
        configureWrapLabel()
        configureAddButton()
        
    }
    
    func configureWrapLabel() {
        wrap.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        wrap.backgroundColor = .white
        wrap.layer.cornerRadius = 10
        contentView.addSubview(wrap)
        wrap.pin(to: contentView, Constants.Wrap.pinContraint)
    }
    
    func configureTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        textField.backgroundColor = .clear
        textField.placeholder = Constants.TextField.placeholder
        textField.layer.cornerRadius = 10
        wrap.addSubview(textField)
        
        textField.pinVertical(to: wrap, 3)
        textField.pinLeft(to: wrap, 3)
        textField.pinRight(to: wrap, 30)
    }
    
    func configureAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        addButton.tintColor = Constants.AddButton.backgroundColor
        addButton.setHeight(Constants.AddButton.height)
        addButton.setWidth(Constants.AddButton.width)
        addButton.setImage(UIImage(systemName: "plus.circle.fill"),for: .normal)
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
