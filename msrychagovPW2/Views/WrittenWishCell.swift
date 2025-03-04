//
//  WrittenWishCell.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 02.12.2024.
//
import UIKit


final class WrittenWishCell: UITableViewCell, UIContextMenuInteractionDelegate {
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
    weak var delegate: WrittenWishCellDelegate?
    var index: Int?
    var onDelete: (() -> Void)?
    var onEdit: (() -> Void)?
    var onShare: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            configureUI()

            let interaction = UIContextMenuInteraction(delegate: self)
            addInteraction(interaction) // ✅ Добавляем контекстное меню в ячейку
        }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let editAction = UIAction(title: "✏️ Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.onEdit?()
            }
            
            let shareAction = UIAction(title: "📤 Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.onShare?()
            }

            let deleteAction = UIAction(title: "🗑️ Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.onDelete?()
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
    
    private var wrapBgColor: UIColor = .white {
        didSet {
            wrap.backgroundColor = wrapBgColor
        }
    }
    
    private var wishLabelTextColor: UIColor = .black {
        didSet {
            wishLabel.textColor = wishLabelTextColor
        }
    }
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview?
    {
        // Создаём объект параметров предпросмотра
        let previewParams = UIPreviewParameters()
        // Делаем «прозрачным» фон вокруг wrap, сохраняя при этом сам wrap цветным:
        previewParams.visiblePath = UIBezierPath(
            roundedRect: wrap.bounds,
            cornerRadius: wrap.layer.cornerRadius
        )

        // Возвращаем UITargetedPreview, «привязанный» к wrap
        return UITargetedPreview(view: wrap, parameters: previewParams)
    }
    
    
    func configure(with wish: String, at index: Int, withBgColor bgColor: UIColor, withTextColor textColor: UIColor, delegate: WrittenWishCellDelegate?) {
        self.wishLabel.text = wish
        self.index = index
        self.delegate = delegate
        wrapBgColor = bgColor
        wishLabelTextColor = textColor
        
    }
    
    func configureWrap () {
        wrap.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrap)
        wrap.layer.cornerRadius = Constants.Wrap.cornerRadius
        wrap.pinVertical(to: self, Constants.Wrap.offsetV)
        wrap.pinHorizontal(to: self, Constants.Wrap.offsetH)
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        configureWrap()
        wishLabel.textColor = .white
        wrap.addSubview(wishLabel)
        wishLabel.pinVertical(to: wrap, Constants.Wrap.wishLabelOffset)
        wishLabel.pinLeft(to: wrap, Constants.Wrap.wishLabelOffset)
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
        delegate?.shareWish("Желание:\n" + text) // Вызываем делегат и передаём текст желания
    }
}

protocol WrittenWishCellDelegate: AnyObject {
    func editWish(_ text: String, at index: Int)
    func shareWish(_ text: String)
}

