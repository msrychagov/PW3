//
//  WrittenWishCell.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 02.12.2024.
//
import UIKit


final class WrittenWishCell: UITableViewCell {
    //MARK: - Constants
    static let reuseId: String = "WrittenWishCell"
    private enum Constants {
        enum Wrap {
            static let backgroundColor: UIColor = .green
            static let cornerRadius: CGFloat = 16
            static let offsetV: CGFloat = 5
            static let offsetH: CGFloat = 10
            static let wishLabelOffset: CGFloat = 8
        }
        
        enum View {
            static let backgroundColor: UIColor = .blue
        }
        
        enum WishLabel {
            
        }
        
        enum deleteButton {
            static let systemName: String = "xmark.app.fill"
            static let topConstraint: CGFloat = 10
            static let trailingConstraint: CGFloat = 10
            static let tintColor: UIColor = .black
        }
        enum editButton {
            static let systemName: String = "pencil"
            static let topConstraint: CGFloat = 10
            static let trailingConstraint: CGFloat = 40
            static let tintColor: UIColor = .black
        }
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        
    }
    //MARK: - Variables
    private let wishLabel: UILabel = UILabel()
    private let wrap: UIView = UIView()
    private let deleteButton: UIButton = UIButton(type: .custom)
    private let editButton: UIButton = UIButton(type: .custom)
    private let shareButton: UIButton = UIButton(type: .system)
    weak var delegate: WrittenWishCellDelegate?
    var index: Int?
    var onDelete: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with wish: String, at index: Int, delegate: WrittenWishCellDelegate?) {
        self.wishLabel.text = wish
        self.index = index
        self.delegate = delegate
    }
    
    func configureDeleteButton() {
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.tintColor = .black
        deleteButton.setImage(UIImage(systemName: Constants.deleteButton.systemName), for: .normal)
        wrap.addSubview(deleteButton)
        deleteButton.pinTop(to: wrap.topAnchor, 5)
        deleteButton.pinRight(to: wrap.trailingAnchor, 5)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
    }
    
    private func configureShareButton() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.tintColor = .black
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal) // Иконка "Поделиться"
        
        wrap.addSubview(shareButton)
        shareButton.pinTop(to: wrap.topAnchor, 5)
        shareButton.pinRight(to: editButton.leadingAnchor, 5) // Располагаем слева от кнопки "Редактировать"

        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    func configureEditButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.tintColor = .black
        editButton.setImage(UIImage(systemName: Constants.editButton.systemName), for: .normal)
        wrap.addSubview(editButton)
        editButton.pinTop(to: wrap.topAnchor, 5)
        editButton.pinRight(to: deleteButton.leadingAnchor, 5)
        editButton.addTarget(self, action: #selector (editButtonPressed), for: .touchUpInside)
    }
    
    func configureWrap () {
        wrap.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrap)
        wrap.backgroundColor = .white
        wrap.layer.cornerRadius = Constants.Wrap.cornerRadius
        wrap.pinVertical(to: self, Constants.Wrap.offsetV)
        wrap.pinHorizontal(to: self, Constants.Wrap.offsetH)
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        configureWrap()
        configureDeleteButton()
        configureEditButton()
        configureShareButton()
        wrap.addSubview(wishLabel)
        wishLabel.pinVertical(to: wrap, Constants.Wrap.wishLabelOffset)
        wishLabel.pinLeft(to: wrap, Constants.Wrap.wishLabelOffset)
        wishLabel.pinRight(to: deleteButton, Constants.Wrap.wishLabelOffset)
    }
    
    // MARK: - Actions
    @objc private func deleteButtonPressed() {
        onDelete?()
    }
    
    @objc private func editButtonPressed() {
        guard let text = wishLabel.text, let index = index else { return }
        delegate?.editWish(text, at: index)
    }
    
    @objc private func shareButtonTapped() {
        guard let text = wishLabel.text else { return }
        delegate?.shareWish(text) // Вызываем делегат и передаём текст желания
    }
}

protocol WrittenWishCellDelegate: AnyObject {
    func editWish(_ text: String, at index: Int)
    func shareWish(_ text: String)
}
