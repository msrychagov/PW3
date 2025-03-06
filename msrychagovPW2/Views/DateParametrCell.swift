//
//  DateParametrCell.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 13.12.2024.
//

import UIKit

final class DateParametrCell: UITableViewCell {
    //MARK: - Constants
    
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
        label.backgroundColor = .clear
        label.setHeight(80)
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.layer.masksToBounds = true
        contentView.addSubview(label)
        label.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor, 10)
        label.pinHorizontal(to: contentView, 10)
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
