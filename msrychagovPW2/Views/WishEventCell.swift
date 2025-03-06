//
//  WishEventCell.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//

import UIKit

final class WishEventCell: UICollectionViewCell {
    //MARK: - Constants
    
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
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
    //MARK: - Methods
    
    // MARK: - Cell Configuration
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
    
    // MARK: - UI Configuration
    private func configureWrap() {
        addSubview(wrapView)
        wrapView.pin(to: self, 10)
        wrapView.layer.cornerRadius = 10
        wrapView.backgroundColor = wrapBackgroundColor
    }
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.pinTop(to: wrapView.topAnchor, 2)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.pinLeft(to: wrapView.leadingAnchor, 10)
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 5
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        wrapView.addSubview(descriptionLabel)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, 2)
        descriptionLabel.pinLeft(to: wrapView.leadingAnchor, 10)
        descriptionLabel.pinRight(to: wrapView.trailingAnchor, 10)
    }
    private func configureStartTextField() {
        startTextField.translatesAutoresizingMaskIntoConstraints = false
        startTextField.isUserInteractionEnabled = false
        wrapView.addSubview(startTextField)
        startTextField.text = "Начало:"
        startTextField.font = UIFont.boldSystemFont(ofSize: 15)
        startTextField.pinTop(to: descriptionLabel.bottomAnchor, 4)
        startTextField.pinLeft(to: wrapView.leadingAnchor, 10)
    }
    
    private func configureEndTextField() {
        endTextField.translatesAutoresizingMaskIntoConstraints = false
        endTextField.isUserInteractionEnabled = false
        wrapView.addSubview(endTextField)
        endTextField.text = "Окончание:"
        endTextField.font = UIFont.boldSystemFont(ofSize: 15)
        endTextField.pinTop(to: startTextField.bottomAnchor, 4)
        endTextField.pinLeft(to: wrapView.leadingAnchor, 10)
    }
    
    func configureStartDateLabel() {
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.font = UIFont.systemFont(ofSize: 12)
        wrapView.addSubview(startDateLabel)
        startDateLabel.pinCenterY(to: startTextField.centerYAnchor)
        startDateLabel.pinLeft(to: startTextField.trailingAnchor, 10)
    }
    
    func configureEndDateLabel() {
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.font = UIFont.systemFont(ofSize: 12)
        wrapView.addSubview(endDateLabel)
        endDateLabel.pinCenterY(to: endTextField.centerYAnchor)
        endDateLabel.pinLeft(to: endTextField.trailingAnchor, 10)
    }
    
    func configureActionMenuButton() {
        actionMenuButton.translatesAutoresizingMaskIntoConstraints = false
        actionMenuButton.setHeight(20)
        actionMenuButton.setWidth(20)
        actionMenuButton.setImage(UIImage(systemName: "line.3.horizontal.circle.fill"), for: .normal)
        
        // Создаём меню один раз и привязываем сразу
        let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
            self.onEdit?()
        }
        let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            self.onShare?()
        }
        let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.onDelete?()
        }

        let menu = UIMenu(title: "Действия", children: [editAction, shareAction, deleteAction])

        actionMenuButton.menu = menu // Привязываем меню сразу
        actionMenuButton.showsMenuAsPrimaryAction = true // Делаем кнопку триггером для меню

        wrapView.addSubview(actionMenuButton)
        actionMenuButton.pinTop(to: wrapView.topAnchor, 5)
        actionMenuButton.pinRight(to: wrapView.trailingAnchor, 5)
    }
}

protocol WishEventCellDelegate: WishCalendarViewController {
    func editWish(_ wish: WishEventModel, at index: Int)
    func shareWish(_ wish: WishEventModel)
}


