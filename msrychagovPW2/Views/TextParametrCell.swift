//
//  EventCell.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//

import UIKit

final class EventCell: UITableViewCell {
    //MARK: - Constants
    
    //MARK: - Variables
    private let titleTextField: UITextField = UITextField()
    private let descriptionTextField: UITextField = UITextField()
    private let startDateTextField: UITextField = UITextField()
    private let endDateTextField: UITextField = UITextField()
    //MARK: - Methods
    
    //MARK: - Configures
    func configureUI() {
        configureTableView()
        configureTitleTextField()
        configureDescriptionTextField()
        configureStartDateTextField()
        configureEndDateTextField()
    }
    
    func configureTitleTextField() {
        
    }
    
    func configureDescriptionTextField() {
        
    }
    
    func configureStartDateTextField() {
        
    
    }
    
    func configureEndDateTextField() {
        
    }
}
