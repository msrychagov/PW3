//
//  AddWishEventViewController.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//

import UIKit

final class AddWishEventViewController: UIViewController {
    //MARK: - Constants
    private enum Constants {
        enum TableView {
            static let cornerRadius: CGFloat = 10
            static let rowHeight: CGFloat = 180
            static let constraint: CGFloat = 20
            static let bottomConstraint: CGFloat = 20
            static let numberOfSections: Int = 4
            static let zeroSection: Int = 0
            static let firstSection: Int = 1
            static let secondSection: Int = 2
            static let thirdSection: Int = 3
            static let forNumberOfSectionReturnesValues: Int = 1
            static let defaultScetcionsReturnesValue: Int = 0
        }
        enum CellTitles {
            static let title: String = "Title"
            static let description: String = "Description"
            static let startDate: String = "Start Date"
            static let endDate: String = "End Date"
        }
        enum AddEventButton {
            static let title: String = "Save"
            static let cornerRadius: CGFloat = 10
            static let height: CGFloat = 50
            static let width: CGFloat = 150
            static let titleLabelFontSize: CGFloat = 30
            static let titleLabelFontWeight: UIFont.Weight = .bold
            static let bottomConstraint: CGFloat = 20
        }
    }
    //MARK: - Variables
    private let tableView: UITableView = UITableView()
    private let addEventButton: UIButton = UIButton(type: .system)
    private var titleText: String = ""
    private var descriptionText: String = ""
    private var startDate: Date = Date()
    private var endDate: Date = Date()
    
    //MARK: Properties
    var textColor: UIColor? {
        didSet {
            addEventButton.setTitleColor(textColor, for: .normal)
        }
    }
    var tableColor: UIColor? {
        didSet {
            tableView.backgroundColor = tableColor
            addEventButton.backgroundColor = tableColor
        }
    }
    var onAddWish: ((WishEventModel) -> Void)?
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func setWishTitle(_ title: String) {
        titleText = title
        tableView.reloadData()
    }
    
    func setWishDescription(_ description: String) {
        descriptionText = description
        tableView.reloadData() 
    }
    
    func setWishStartDate(_ date: Date) {
        startDate = date
        tableView.reloadData()
    }
    
    func setWishEndDate(_ date: Date) {
        endDate = date
        tableView.reloadData()
    }
    
    //MARK: Configures
    func configureUI() {
        configureAddEventButton()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = Constants.TableView.cornerRadius
        tableView.rowHeight = Constants.TableView.rowHeight
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.pin(to: view, Constants.TableView.constraint)
        tableView.pinBottom(to: addEventButton.topAnchor, Constants.TableView.bottomConstraint)
        tableView.register(TextParametrCell.self, forCellReuseIdentifier: TextParametrCell.reuseIdentifier)
        tableView.register(DateParametrCell.self, forCellReuseIdentifier: DateParametrCell.reuseIdentifier)
    }
    
    func configureAddEventButton() {
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        addEventButton.setTitle(Constants.AddEventButton.title, for: .normal)
        addEventButton.layer.cornerRadius = Constants.AddEventButton.cornerRadius
        addEventButton.setHeight(Constants.AddEventButton.height)
        addEventButton.setWidth(Constants.AddEventButton.width)
        addEventButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.AddEventButton.titleLabelFontSize, weight: Constants.AddEventButton.titleLabelFontWeight)
        view.addSubview(addEventButton)
        addEventButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.AddEventButton.bottomConstraint)
        addEventButton.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
        addEventButton.addTarget(self, action: #selector(addEvent), for: .touchUpInside)
        
    }
    
    //MARK: - Actions
    @objc func addEvent() {
        var new = WishEventModel(title: titleText, description: descriptionText, startDate: startDate, endDate: endDate)
        
        let calendarManager = CalendarManager.shared
        let event = CalendarEventModel(
            title: titleText,
            startDate: startDate,
            endDate: endDate,
            note: descriptionText
        )
        
        if let eventIdentifier = calendarManager.create(eventModel: event) {
            print("Событие успешно создано с идентификатором: \(eventIdentifier)")
            new.eventIdentifier = eventIdentifier // Сохраняем идентификатор в WishEventModel
        } else {
            print("Не удалось создать событие.")
        }
        
        onAddWish?(new) // Передаем обновленную модель обратно
        dismiss(animated: true)
    }
}

//MARK: - UITableViewDataSource
extension AddWishEventViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.TableView.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Constants.TableView.zeroSection: return Constants.TableView.forNumberOfSectionReturnesValues
        case Constants.TableView.firstSection: return Constants.TableView.forNumberOfSectionReturnesValues
        case Constants.TableView.secondSection: return Constants.TableView.forNumberOfSectionReturnesValues
        case Constants.TableView.thirdSection: return Constants.TableView.forNumberOfSectionReturnesValues
        default: return Constants.TableView.defaultScetcionsReturnesValue
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Constants.TableView.zeroSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextParametrCell.reuseIdentifier, for: indexPath)
            if let cell = cell as? TextParametrCell {
                cell.configure(with: Constants.CellTitles.title, text: textColor!)
                cell.setText(titleText)
                cell.addEvent = { [weak self] newEvent in
                    guard let self = self else { return }
                    self.titleText = newEvent
                }
            }
            cell.selectionStyle = .none
            return cell
        case Constants.TableView.firstSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextParametrCell.reuseIdentifier, for: indexPath)
            if let cell = cell as? TextParametrCell {
                cell.configure(with: Constants.CellTitles.description, text: textColor!)
                cell.setText(descriptionText)
                cell.addEvent = { [weak self] newEvent in guard let self = self else { return }
                    descriptionText = newEvent}
            }
            cell.selectionStyle = .none
            return cell
        case Constants.TableView.secondSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateParametrCell.reuseIdentifier, for: indexPath)
            if let cell = cell as? DateParametrCell {
                cell.configure(with: Constants.CellTitles.startDate, text: textColor!)
                cell.setDate(startDate)
                cell.addeventHandler = { [weak self] newEvent in guard let self = self else { return }
                    startDate = newEvent
                }
                
            }
            cell.selectionStyle = .none
            return cell
        case Constants.TableView.thirdSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateParametrCell.reuseIdentifier, for: indexPath)
            if let cell = cell as? DateParametrCell {
                cell.configure(with: Constants.CellTitles.endDate, text: textColor!)
                cell.setDate(endDate)
                cell.addeventHandler = { [weak self] newEvent in guard let self = self else { return }
                    endDate = newEvent
                }
                
            }
            cell.selectionStyle = .none
            return cell
        default: return UITableViewCell()
        }
        
    }
}
