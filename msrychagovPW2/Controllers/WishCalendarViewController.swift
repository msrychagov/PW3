//
//  WishCalendarViewController.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//


import UIKit

class WishCalendarViewController: UIViewController{
    
    
    
    //MARK: - Constants
    private enum Constants {
        enum CollectionView {
            static let boundsWidthDiff: CGFloat = 10
            static let height: CGFloat = 200
            static let layoutMinimumLineSpacing: CGFloat = 0
            static let layoutMinimumInteritemSpacing: CGFloat = 0
            static let contentInset: CGFloat = 10
            static let cornerRadius: CGFloat = 10
            static let horizontalConstraint: CGFloat = 20
            static let bottomConstraint: CGFloat = 30
            static let topConstraint: CGFloat = 10
        }
        enum Cell {
            static let forCellReuseIdentifier: String = "Cell"
        }
        enum AlerController {
            static let title: String = "Добавить желание"
            static let message: String = "Выберите способ добавления"
            enum Actions {
                static let cancel: String = "Отмена"
                static let createNew: String = "Создать новое"
                static let chooseExisting: String = "Выбрать из списка"
            }
        }
        enum Defaults {
            static let dataKey: String = "Events"
        }
        enum AddButton {
            static let title: String = "Add"
            static let titleLabelFontSize: CGFloat = 32
            static let titleLabelFontWeight: UIFont.Weight = .bold
            static let cornerRadius: CGFloat = 20
            static let bottomConstraint: CGFloat = 3
            static let width: CGFloat = 250
            static let height: CGFloat = 80
        }
    }
    
    //MARK: - Variables
    private var wishEvents: [WishEventModel] = []
    private let addButton: UIButton = UIButton(type: .system)
    private let defaults = UserDefaults.standard
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    //MARK: - Properties
    var cellTextColor: UIColor? {
        didSet {
            addButton.setTitleColor(cellTextColor, for: .normal)
        }
    }
    
    var cellColor: UIColor? {
        didSet {
            addButton.backgroundColor = cellColor
        }
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEvents()
        configureUI()
        if let layout = collectionView.collectionViewLayout as?
            UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = Constants.CollectionView.layoutMinimumInteritemSpacing
            layout.minimumLineSpacing = Constants.CollectionView.layoutMinimumLineSpacing
            layout.invalidateLayout()
        }
        /* Temporary line */
        collectionView.register(
            WishEventCell.self,
            forCellWithReuseIdentifier: WishEventCell.reuseIdentifier
        )
    }
    
    private func openCreateWishScreen() {
        let vc = AddWishEventViewController() // Создаём новый экран
        vc.view.backgroundColor = view.backgroundColor
        vc.textColor = cellTextColor
        vc.tableColor = cellColor
        vc.onAddWish = { [weak self] newWish in
            guard let self = self else { return }
            
            self.wishEvents.append(newWish)
            
            self.saveEvents()
            
            self.collectionView.reloadData()
        }
        
        present(vc, animated: true)
    }
    
    private func openWishListScreen() {
        let wishListVC = WishStoringViewController()
        
        wishListVC.view.backgroundColor = self.view.backgroundColor
        wishListVC.cellBackgroundColor = cellColor!
        wishListVC.wishLabelTextColor = cellTextColor!
        wishListVC.onWishSelected = { [weak self] selectedWish in
            self?.navigationController?.popViewController(animated: true)
            self?.addWishFromList(selectedWish)
        }
        
        navigationController?.pushViewController(wishListVC, animated: true)
    }
    
    private func addWishFromList(_ wish: String) {
        let vc = AddWishEventViewController()
        vc.view.backgroundColor = view.backgroundColor
        vc.textColor = cellTextColor
        vc.tableColor = cellColor
        vc.setWishTitle(wish)
        
        vc.onAddWish = { [weak self] newWish in
            guard let self = self else { return }
            self.wishEvents.append(newWish)
            self.saveEvents()
            self.collectionView.reloadData()
        }
        
        present(vc, animated: true)
    }
    
    private func editWish(_ wish: WishEventModel, at indexPath: Int) {
        let vc = AddWishEventViewController()
        vc.view.backgroundColor = view.backgroundColor
        vc.textColor = cellTextColor
        vc.tableColor = cellColor
        vc.setWishTitle(wish.title)
        vc.setWishDescription(wish.description)
        vc.setWishStartDate(wish.startDate)
        vc.setWishEndDate(wish.endDate)
        vc.onAddWish = { [weak self] newWish in
            guard let self = self else { return }
            self.wishEvents[indexPath] = newWish
            self.saveEvents()
            self.collectionView.reloadData()
        }
        present(vc, animated: true)
    }
    
    private func shareWish(_ wish: WishEventModel) {
        let activityViewController = UIActivityViewController(activityItems: [wish.title], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    private func saveEvents() {
        if let encodedData = try? JSONEncoder().encode(wishEvents) {
            defaults.set(encodedData, forKey: Constants.Defaults.dataKey)
        }
    }
    
    private func loadEvents() {
        if let savedData = defaults.data(forKey: Constants.Defaults.dataKey),
           let decodedEvents = try? JSONDecoder().decode([WishEventModel].self, from: savedData) {
            wishEvents = decodedEvents
        }
    }
    
    //MARK: - Configures
    private func configureUI() {
        view.addSubview(collectionView)
        view.addSubview(addButton)
        configureCollection()
        configureAddButton()
    }
    private func configureAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle(Constants.AddButton.title, for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: Constants.AddButton.titleLabelFontSize, weight: Constants.AddButton.titleLabelFontWeight)
        addButton.layer.cornerRadius = Constants.AddButton.cornerRadius
        addButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.AddButton.bottomConstraint)
        addButton.pinCenterX(to: view.centerXAnchor)
        addButton.setWidth(Constants.AddButton.width)
        addButton.setHeight(Constants.AddButton.height)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
    }
    private func configureCollection() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: Constants.CollectionView.contentInset, left: Constants.CollectionView.contentInset, bottom: Constants.CollectionView.contentInset, right: Constants.CollectionView.contentInset)
        collectionView.layer.cornerRadius = Constants.CollectionView.cornerRadius
        /* Temporary line */
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.Cell.forCellReuseIdentifier)
        collectionView.pinHorizontal(to: view, Constants.CollectionView.horizontalConstraint)
        collectionView.pinBottom(to: addButton.topAnchor, Constants.CollectionView.bottomConstraint)
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.CollectionView.topConstraint)
    }
    
    //MARK: - Actions
    @objc func addButtonTapped() {
        let alertController = UIAlertController(
            title: Constants.AlerController.title,
            message: Constants.AlerController.message,
            preferredStyle: .actionSheet
        )
        
        let createNewAction = UIAlertAction(title: Constants.AlerController.Actions.createNew, style: .default) { _ in
            self.openCreateWishScreen()
        }
        
        let chooseExistingAction = UIAlertAction(title: Constants.AlerController.Actions.chooseExisting, style: .default) { _ in
            self.openWishListScreen()
        }
        
        let cancelAction = UIAlertAction(title: Constants.AlerController.Actions.cancel, style: .cancel, handler: nil)
        
        alertController.addAction(createNewAction)
        alertController.addAction(chooseExistingAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(
        _
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return wishEvents.count
    }
    func collectionView(
        _
        collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WishEventCell.reuseIdentifier,
            for: indexPath
        )
        guard let wishEventCell = cell as? WishEventCell else {
            return cell
        }
        
        // Получаем модель для текущего элемента
        let model = wishEvents[indexPath.item]
        
        // Конфигурируем ячейку
        wishEventCell.configure(with: model, wrapColor: cellColor, text: cellTextColor)
        
        wishEventCell.onDelete = { [weak self] in
            guard let self = self else { return }
            let model = self.wishEvents[indexPath.item]
            
            if let eventIdentifier = model.eventIdentifier, !eventIdentifier.isEmpty {
                print("Удаление события с идентификатором: \(eventIdentifier)")
                let calendarManager = CalendarManager.shared
                calendarManager.delete(eventIdentifier: eventIdentifier) { success in
                    if success {
                        print("Событие успешно удалено из календаря.")
                    } else {
                        print("Не удалось удалить событие из календаря.")
                    }
                }
            } else {
                print("Идентификатор события отсутствует или пуст.")
            }
            
            self.wishEvents.remove(at: indexPath.item)
            self.collectionView.reloadData()
            self.saveEvents()
        }
        
        wishEventCell.onEdit = { [weak self] in
            guard let self = self else { return }
            self.editWish(self.wishEvents[indexPath.row], at: indexPath.row)
        }
        
        wishEventCell.onShare = { [weak self] in
            guard let self = self else { return }
            let model = self.wishEvents[indexPath.item]
            let activityViewController = UIActivityViewController(
                activityItems: [model.title],
                applicationActivities: nil
            )
            self.present(activityViewController, animated: true)
        }
        
        return wishEventCell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // Adjust cell size as needed
        return CGSize(width: collectionView.bounds.width - Constants.CollectionView.boundsWidthDiff, height: Constants.CollectionView.height)
    }
    func collectionView(
        _
        collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("Cell tapped at index \(indexPath.item)")
    }
}
