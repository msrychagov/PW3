//
//  EventCell.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//

import UIKit

final class TextParametrCell: UITableViewCell, UITextViewDelegate {
    //MARK: - Constants
    
    //MARK: - Variables
    static let reuseIdentifier: String = "TextParametrCell"
    private let textField: UITextField = UITextField()
    private let label: UILabel = UILabel()
    private let textView = UITextView()
    var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }

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
    func setText(_ text: String) {
        textView.text = text // ✅ Устанавливаем текст в поле ввода
    }
    //MARK: - Configures
    func configure (with parametr: String, text: UIColor) {
        label.text = parametr
        textColor = text
    }
    func configureUI() {
        backgroundColor = .clear
        configureLabel()
        configureTextView()
    }
    func configureTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 20, weight: .medium)
        textView.delegate = self
        contentView.addSubview(textView)
        textView.pinTop(to: label.bottomAnchor)
        textView.pinBottom(to: contentView.safeAreaLayoutGuide.bottomAnchor, 10)
        textView.pinHorizontal(to: contentView, 10)
    }
    
    func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.setHeight(80)
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.layer.masksToBounds = true
        contentView.addSubview(label)
        label.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor, 10)
        label.pinHorizontal(to: contentView, 10)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
            addEvent?(textView.text) // Передаём введённый текст
        }
}
