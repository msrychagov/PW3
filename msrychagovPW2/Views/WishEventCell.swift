//
//  WishEventCell.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//

import UIKit

protocol WishEventCellDelegate: WishCalendarViewController {
    func editWish(_ wish: WishEventModel, at index: Int)
    func shareWish(_ wish: WishEventModel)
}

final class WishEventCell: UICollectionViewCell {
    //MARK: - Constants
    private enum Constants {
        enum Wrap {
            static let constraint: CGFloat = 10
            static let cornerRadius: CGFloat = 10
        }
        enum TitleLabel {
            static let topConstraint: CGFloat = 2
            static let fontSize: CGFloat = 32
            static let leftConstraint: CGFloat = 10
        }
        enum DescriptionLabel {
            static let topConstraint: CGFloat = 2
            static let fontSize: CGFloat = 14
            static let leftConstraint: CGFloat = 10
            static let rightConstraint: CGFloat = 10
            static let numberOfLines: Int = 5
        }
        enum StartTextField {
            static let topConstraint: CGFloat = 4
            static let fontSize: CGFloat = 15
            static let leftConstraint: CGFloat = 10
            static let text: String = "Начало: "
        }
        enum EndTextField {
            static let topConstraint: CGFloat = 4
            static let fontSize: CGFloat = 15
            static let leftConstraint: CGFloat = 10
            static let text: String = "Оконачание: "
        }
        enum StartDateLabel {
            static let fontSize: CGFloat = 12
            static let leftConstraint: CGFloat = 10
        }
        enum EndDateLabel {
            static let fontSize: CGFloat = 12
            static let leftConstraint: CGFloat = 10
        }
        enum ActionMenuButton {
            static let imageSystemName: String = "line.3.horizontal.circle.fill"
            enum Actions {
                static let editName: String = "Редактировать"
                static let editImageSystemName: String = "pencil"
                static let shareName: String = "Поделиться"
                static let shareImageSystemName: String = "square.and.arrow.up"
                static let deleteName: String = "Удалить"
                static let deleteImageSystemName: String = "trash"
            }
            static let menuTitle: String = "Действия"
            static let topConstraint: CGFloat = 5
            static let rightConstraint: CGFloat = 5
        }
    }
    //MARK: - Variables
    static let reuseIdentifier: String = "WishEventCell"
    private let wrapView: UIView = UIView()
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let startDateLabel: UILabel = UILabel()
    private let endDateLabel: UILabel = UILabel()
    private let actionMenuButton: UIButton = UIButton(type: .custom)
    private let startTextField: UITextField = UITextField()
    private let endTextField: UITextField = UITextField()
    private var wrapBackgroundColor: UIColor?
    
    var onDelete: (() -> Void)?
    var onEdit: (() -> Void)?
    var onShare: (() -> Void)?
    
    //MARK: - Properties
    private var textColor: UIColor? {
        didSet {
            
            for label in [titleLabel, descriptionLabel, startDateLabel, endDateLabel] {
                label.textColor = textColor
            }
            for textField in [startTextField, endTextField] {
                textField.textColor = textColor
            }
            actionMenuButton.tintColor = textColor
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure(with event: WishEventModel, wrapColor: UIColor?, text: UIColor?) {
        wrapBackgroundColor = wrapColor
        textColor = text
        configureWrap()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStartTextField()
        configureEndTextField()
        configureEndDateLabel()
        configureStartDateLabel()
        configureActionMenuButton()
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        startDateLabel.text = event.startDate.formatted(date: .abbreviated, time: .shortened)
        endDateLabel.text = event.endDate.formatted(date: .abbreviated, time: .shortened)
        
    }

    private func configureWrap() {
        addSubview(wrapView)
        wrapView.pin(to: self, Constants.Wrap.constraint)
        wrapView.layer.cornerRadius = Constants.Wrap.cornerRadius
        wrapView.backgroundColor = wrapBackgroundColor
    }
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.pinTop(to: wrapView.topAnchor, Constants.TitleLabel.topConstraint)
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.TitleLabel.fontSize)
        titleLabel.pinLeft(to: wrapView.leadingAnchor, Constants.TitleLabel.leftConstraint)
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = Constants.DescriptionLabel.numberOfLines
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.DescriptionLabel.fontSize)
        wrapView.addSubview(descriptionLabel)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.DescriptionLabel.topConstraint)
        descriptionLabel.pinLeft(to: wrapView.leadingAnchor, Constants.DescriptionLabel.leftConstraint)
        descriptionLabel.pinRight(to: wrapView.trailingAnchor, Constants.DescriptionLabel.rightConstraint)
    }
    private func configureStartTextField() {
        startTextField.translatesAutoresizingMaskIntoConstraints = false
        startTextField.isUserInteractionEnabled = false
        wrapView.addSubview(startTextField)
        startTextField.text = Constants.StartTextField.text
        startTextField.font = UIFont.boldSystemFont(ofSize: Constants.StartTextField.fontSize)
        startTextField.pinTop(to: descriptionLabel.bottomAnchor, Constants.StartTextField.topConstraint)
        startTextField.pinLeft(to: wrapView.leadingAnchor, Constants.StartTextField.leftConstraint)
    }
    
    private func configureEndTextField() {
        endTextField.translatesAutoresizingMaskIntoConstraints = false
        endTextField.isUserInteractionEnabled = false
        wrapView.addSubview(endTextField)
        endTextField.text = Constants.EndTextField.text
        endTextField.font = UIFont.boldSystemFont(ofSize: Constants.EndTextField.fontSize)
        endTextField.pinTop(to: startTextField.bottomAnchor, Constants.EndTextField.topConstraint)
        endTextField.pinLeft(to: wrapView.leadingAnchor, Constants.EndTextField.leftConstraint)
    }
    
    func configureStartDateLabel() {
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.font = UIFont.systemFont(ofSize: Constants.StartDateLabel.fontSize)
        wrapView.addSubview(startDateLabel)
        startDateLabel.pinCenterY(to: startTextField.centerYAnchor)
        startDateLabel.pinLeft(to: startTextField.trailingAnchor, Constants.StartDateLabel.leftConstraint)
    }
    
    func configureEndDateLabel() {
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.font = UIFont.systemFont(ofSize: Constants.EndDateLabel.fontSize)
        wrapView.addSubview(endDateLabel)
        endDateLabel.pinCenterY(to: endTextField.centerYAnchor)
        endDateLabel.pinLeft(to: endTextField.trailingAnchor, Constants.EndDateLabel.leftConstraint)
    }
    
    func configureActionMenuButton() {
        actionMenuButton.translatesAutoresizingMaskIntoConstraints = false
        actionMenuButton.setHeight(20)
        actionMenuButton.setWidth(20)
        actionMenuButton.setImage(UIImage(systemName: Constants.ActionMenuButton.imageSystemName), for: .normal)
        
        // Создаём меню один раз и привязываем сразу
        let editAction = UIAction(title: Constants.ActionMenuButton.Actions.editName, image: UIImage(systemName: Constants.ActionMenuButton.Actions.editImageSystemName)) { _ in
            self.onEdit?()
        }
        let shareAction = UIAction(title: Constants.ActionMenuButton.Actions.shareName, image: UIImage(systemName: Constants.ActionMenuButton.Actions.shareImageSystemName)) { _ in
            self.onShare?()
        }
        let deleteAction = UIAction(title: Constants.ActionMenuButton.Actions.deleteName, image: UIImage(systemName: Constants.ActionMenuButton.Actions.deleteImageSystemName), attributes: .destructive) { _ in
            self.onDelete?()
        }

        let menu = UIMenu(title: Constants.ActionMenuButton.menuTitle, children: [editAction, shareAction, deleteAction])

        actionMenuButton.menu = menu // Привязываем меню сразу
        actionMenuButton.showsMenuAsPrimaryAction = true // Делаем кнопку триггером для меню

        wrapView.addSubview(actionMenuButton)
        actionMenuButton.pinTop(to: wrapView.topAnchor, Constants.ActionMenuButton.topConstraint)
        actionMenuButton.pinRight(to: wrapView.trailingAnchor, Constants.ActionMenuButton.rightConstraint)
    }
}


