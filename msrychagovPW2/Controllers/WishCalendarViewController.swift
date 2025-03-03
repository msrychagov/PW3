//
//  WishCalendarViewController.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 09.12.2024.
//


import UIKit

class WishCalendarViewController: UIViewController{
    
    
    
    //MARK: - Constants
    private enum Contants {
        
    }
    
    //MARK: - Variables
    private var wishEvents: [WishEventModel] = []
    private let addButton: UIButton = UIButton(type: .custom)
    private let defaults = UserDefaults.standard
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        loadEvents()
        configureUI()
        if let layout = collectionView.collectionViewLayout as?
            UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.invalidateLayout()
        }
        /* Temporary line */
        collectionView.register(
            WishEventCell.self,
            forCellWithReuseIdentifier: WishEventCell.reuseIdentifier
        )
    }
    
    //MARK: - Configures
    private func configureUI() {
        configureCollection()
        configureAddButton()
    }
    private func configureAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.tintColor = .black
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.setHeight(20)
        addButton.setWidth(20)
        view.addSubview(addButton)
        addButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 3)
        addButton.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 3)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
    }
    private func configureCollection() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        /* Temporary line */
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        collectionView.pinHorizontal(to: view, 20)
        collectionView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 30)
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
    }
    
    private func saveEvents() {
        if let encodedData = try? JSONEncoder().encode(wishEvents) {
            defaults.set(encodedData, forKey: "Events")
        }
    }
    
    private func loadEvents() {
        if let savedData = defaults.data(forKey: "Events"),
           let decodedEvents = try? JSONDecoder().decode([WishEventModel].self, from: savedData) {
            wishEvents = decodedEvents
        }
    }
    
    //MARK: - Actions
    @objc func addButtonTapped() {
        let vc = AddWishEventViewController()
        vc.view.backgroundColor = view.backgroundColor
        vc.onAddWish = { [weak self] newWish in
            guard let self = self else { return }
            
            // Добавляем новое событие в массив
            self.wishEvents.append(newWish)
            
            self.saveEvents()
            // Обновляем коллекцию
            self.collectionView.reloadData()
        }
        
        present(vc, animated: true)
        
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
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                            WishEventCell.reuseIdentifier, for: indexPath)
            guard let wishEventCell = cell as? WishEventCell else {
                return cell
            }
            
            wishEventCell.configure(
                with: WishEventModel(
                    title: "Test Title",
                    description: "Test Description",
                    startDate: Date(),
                    endDate: Date()
                )
            )
            return wishEventCell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                            WishEventCell.reuseIdentifier, for: indexPath)
            guard let wishEventCell = cell as? WishEventCell else {
                return cell
            }
            
            wishEventCell.configure(
                with: WishEventModel(
                    title: "hhhhh",
                    description: "Test Description",
                    startDate: Date(),
                    endDate: Date()
                )
            )
            return wishEventCell
        default :
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WishEventCell.reuseIdentifier,
                for: indexPath
            )
            guard let wishEventCell = cell as? WishEventCell else {
                return cell
            }
            wishEventCell.onDelete = { [weak self] in
                guard let self = self else { return }
                let model = self.wishEvents[indexPath.item]
                
                if let eventIdentifier = model.eventIdentifier, !eventIdentifier.isEmpty {
                    print("Удаление события с идентификатором: \(eventIdentifier)")
                    let calendarManager = CalendarManager()
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
            // Получаем модель для текущего элемента
            let model = wishEvents[indexPath.item]
            
            // Конфигурируем ячейку
            wishEventCell.configure(with: model)
            
            return wishEventCell
        }
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
        return CGSize(width: collectionView.bounds.width - 10, height: 100)
    }
    func collectionView(
        _
        collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("Cell tapped at index \(indexPath.item)")
    }
}
