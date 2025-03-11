//
//  EventCell.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//

import UIKit

final class TextParametrCell: UITableViewCell, UITextViewDelegate {
    //MARK: - Constants
    private enum Constants {
        enum TextView {
            static let backgroundColor: UIColor = .clear
            static let fontSize: CGFloat = 20
            static let fontWeight: UIFont.Weight = .medium
            static let horizontalConstraint: CGFloat = 10
            static let bottomConstraint: CGFloat = 10
        }
        enum Label {
            static let backgroundColor: UIColor = .clear
            static let height: CGFloat = 80
            static let fontSize: CGFloat = 40
            static let fontWeight: UIFont.Weight = .bold
            static let horizontalConstraint: CGFloat = 10
            static let topConstraint: CGFloat = 10
        }
        enum ContentView {
            static let backgroundColor: UIColor = .clear
        }
    }
    //MARK: - Variables
    static let reuseIdentifier: String = "TextParametrCell"
    private let textField: UITextField = UITextField()
    private let label: UILabel = UILabel()
    private let textView = UITextView()
    
    var addEvent: ((String) -> Void)?
    
    //MARK: Properties
    var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }
    
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
        textView.text = text
    }
    
    func textViewDidChange(_ textView: UITextView) {
        addEvent?(textView.text)
    }
    
    //MARK: - Configures
    func configure (with parametr: String, text: UIColor) {
        label.text = parametr
        textColor = text
    }
    func configureUI() {
        backgroundColor = Constants.ContentView.backgroundColor
        configureLabel()
        configureTextView()
    }
    func configureTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Constants.TextView.backgroundColor
        textView.font = .systemFont(ofSize: Constants.TextView.fontSize, weight: Constants.TextView.fontWeight)
        textView.delegate = self
        contentView.addSubview(textView)
        textView.pinTop(to: label.bottomAnchor)
        textView.pinBottom(to: contentView.safeAreaLayoutGuide.bottomAnchor, Constants.TextView.bottomConstraint)
        textView.pinHorizontal(to: contentView, Constants.TextView.horizontalConstraint)
    }
    
    func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Constants.Label.backgroundColor
        label.setHeight(Constants.Label.height)
        label.font = .systemFont(ofSize: Constants.Label.fontSize, weight: Constants.Label.fontWeight)
        label.layer.masksToBounds = true
        contentView.addSubview(label)
        label.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor, Constants.Label.topConstraint)
        label.pinHorizontal(to: contentView, Constants.Label.horizontalConstraint)
        
    }
}
