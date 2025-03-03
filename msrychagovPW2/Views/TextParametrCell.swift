//
//  EventCell.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//

import UIKit

final class TextParametrCell: UITableViewCell {
    //MARK: - Constants
    
    //MARK: - Variables
    static let reuseIdentifier: String = "TextParametrCell"
    private let textField: UITextField = UITextField()
    private let label: UILabel = UILabel()
    var addEvent: ((String) -> Void)?
    //MARK: - Lyfecycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods
    
    //MARK: - Configures
    func configure (with parametr: String) {
        label.text = parametr
    }
    func configureUI() {
        backgroundColor = .blue
        configureTextField()
        configureLabel()
    }
    
    func configureTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .green
        contentView.addSubview(textField)
        textField.pinRight(to: contentView.trailingAnchor, 8)
        textField.setWidth(100)
        textField.addTarget(self, action: #selector(changeTextField), for: .editingChanged)
    }
    
    func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        contentView.addSubview(label)
        label.pinLeft(to: contentView.leadingAnchor, 8)
        label.pinRight(to: textField.leadingAnchor, 8)
        
    }
    
    @objc private func changeTextField() {
        guard let text = textField.text, !text.isEmpty else { return }
        addEvent?(text) // Вызываем замыкатель, передавая текст
        }
}
