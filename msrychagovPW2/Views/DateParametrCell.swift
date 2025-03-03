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
    //MARK: - Configures
    func configure() {
        configureLabel()
        configureDatePicker()
    }
    
    func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.setWidth(100)
        label.setHeight(40)
        contentView.addSubview(label)
        label.pinLeft(to: contentView.leadingAnchor, 8)
    }
    
    func configureDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(datePicker)
        datePicker.pinLeft(to: label.trailingAnchor, 8)
        datePicker.pinRight(to: contentView.trailingAnchor, 10)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged() {
        let date = datePicker.date
        addeventHandler?(date)
    }
    
    
}
