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
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
        
    }
    //MARK: - Variables
    private let wishLabel: UILabel = UILabel()
    private let wrap: UIView = UIView()
    private let deleteButton: UIButton = UIButton(type: .custom)
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

    func configure(with wish: String) {
        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        wishLabel.text = wish
        wishLabel.backgroundColor = .clear
        
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
        wrap.addSubview(wishLabel)
        wishLabel.pinVertical(to: wrap, Constants.Wrap.wishLabelOffset)
        wishLabel.pinLeft(to: wrap, Constants.Wrap.wishLabelOffset)
        wishLabel.pinRight(to: deleteButton, Constants.Wrap.wishLabelOffset)
    }
    
    // MARK: - Actions
    @objc private func deleteButtonPressed() {
        onDelete?()
    }
}
