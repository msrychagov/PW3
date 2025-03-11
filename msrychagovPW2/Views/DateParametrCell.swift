//
//  DateParametrCell.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 13.12.2024.
//

import UIKit

final class DateParametrCell: UITableViewCell {
    //MARK: - Constants
    private enum Constants {
        enum Label {
            static let height: CGFloat = 80
            static let fontSize: CGFloat = 40
            static let fontWeight: UIFont.Weight = .bold
            static let topConstraint: CGFloat = 10
            static let horizontalConstraint: CGFloat = 10
            static let backGotundColor: UIColor = .clear
        }
        enum DatePicker {
            static let topConstraint: CGFloat = 10
            static let bottomConsraint: CGFloat = 5
        }
    }
    //MARK: - Variables
    static let reuseIdentifier: String = "DateParametrCell"
    private let datePicker = UIDatePicker()
    private let label: UILabel = UILabel()
    var addeventHandler: ((Date) -> Void)?
    var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }
    
    //MARK: Methods
    func setDate(_ date: Date) {
        datePicker.date = date
    }
    
    //MARK: - Configures
    func configure(with parametr: String, text: UIColor) {
        textColor = text
        label.text = parametr
        configureUI()
    }
    
    func configureUI() {
        backgroundColor = .clear
        configureLabel()
        configureDatePicker()
    }
    func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Constants.Label.backGotundColor
        label.setHeight(Constants.Label.height)
        label.font = .systemFont(ofSize: Constants.Label.fontSize, weight: Constants.Label.fontWeight)
        label.layer.masksToBounds = true
        contentView.addSubview(label)
        label.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor, Constants.Label.topConstraint)
        label.pinHorizontal(to: contentView, Constants.Label.horizontalConstraint)
    }
    
    func configureDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(datePicker)
        datePicker.pinTop(to: label.bottomAnchor, 10)
        datePicker.pinBottom(to: contentView.safeAreaLayoutGuide.bottomAnchor, 5)
        datePicker.pinCenterX(to: contentView.safeAreaLayoutGuide.centerXAnchor)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged() {
        let date = datePicker.date
        addeventHandler?(date)
    }
    
    
}
