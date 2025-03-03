//
//  AddWishEventViewController.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//

import UIKit

final class AddWishEventViewController: UIViewController {
    //MARK: - Constants
    
    //MARK: - Variables
    private let tableView: UITableView = UITableView()
    private let addEventButton: UIButton = UIButton(type: .system)
    private var titleText: String = ""
    private var descriptionText: String = ""
    private var startDate: Date = Date()
    private var endDate: Date = Date()
    var onAddWish: ((WishEventModel) -> Void)?
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: Configures
    func configureUI() {
        configureTableView()
        configureAddEventButton()
    }
    
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.pin(to: view, 10)
        tableView.register(TextParametrCell.self, forCellReuseIdentifier: TextParametrCell.reuseIdentifier)
        tableView.register(DateParametrCell.self, forCellReuseIdentifier: DateParametrCell.reuseIdentifier)
    }
    
    func configureAddEventButton() {
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        addEventButton.setTitle("Добавить", for: .normal)
        addEventButton.layer.cornerRadius = 10
        addEventButton.setHeight(50)
        addEventButton.setWidth(150)
        addEventButton.backgroundColor = .black
        tableView.addSubview(addEventButton)
        addEventButton.pinBottom(to: tableView.safeAreaLayoutGuide.bottomAnchor, 20)
        addEventButton.pinRight(to: tableView.safeAreaLayoutGuide.trailingAnchor, 20)
        addEventButton.addTarget(self, action: #selector(addEvent), for: .touchUpInside)
        
    }
    
    //MARK: - Actions
    @objc func addEvent() {
        var new = WishEventModel(title: titleText, description: descriptionText, startDate: startDate, endDate: endDate)
        
        let calendarManager = CalendarManager()
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextParametrCell.reuseIdentifier, for: indexPath)
            if let cell = cell as? TextParametrCell {
                cell.configure(with: "Title")
                cell.addEvent = { [weak self] newEvent in guard let self = self else { return }
                    titleText = newEvent}
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextParametrCell.reuseIdentifier, for: indexPath)
            if let cell = cell as? TextParametrCell {
                cell.configure(with: "D")
                cell.addEvent = { [weak self] newEvent in guard let self = self else { return }
                    descriptionText = newEvent}
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateParametrCell.reuseIdentifier, for: indexPath)
            if let cell = cell as? DateParametrCell {
                cell.configure()
                cell.addeventHandler = { [weak self] newEvent in guard let self = self else { return }
                    startDate = newEvent
                }
                
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateParametrCell.reuseIdentifier, for: indexPath)
            if let cell = cell as? DateParametrCell {
                cell.configure()
                cell.addeventHandler = { [weak self] newEvent in guard let self = self else { return }
                    endDate = newEvent
                }
                
            }
            return cell
        default: return UITableViewCell()
        }
        
    }
}
