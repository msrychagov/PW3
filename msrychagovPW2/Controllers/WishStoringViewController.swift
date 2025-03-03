//
//  WishStoringViewController.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 02.12.2024.
//
import UIKit

final class WishStoringViewController: UIViewController, WrittenWishCellDelegate {
    func editWish(_ text: String, at index: Int) {
        addWishCell?.setText(text) // ✅ Устанавливаем текст в AddWishCell
        editingIndex = index // ✅ Запоминаем, какое желание редактируем
    }
    
    func shareWish(_ text: String) {
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    func didSelectWish(_ wish: String) {
        onWishSelected?(wish) // ✅ Передаём желание
        navigationController?.popViewController(animated: true) // ✅ Закрываем экран
    }
    
    
    // MARK: - Constants
    
    private enum Constants {
        enum View {
            enum Names {
                
            }
            
            enum Constraints {
                
            }
            
            enum Colors {
                static let background: UIColor = .systemGray6
            }
        }
        enum CloseButton {
            static let systemName: String = "xmark.app.fill"
            static let topConstraint: CGFloat = 10
            static let trailingConstraint: CGFloat = 10
            static let tintColor: UIColor = .black
        }
        
        enum TableView {
            static let backgroundColor: UIColor = .clear
            static let cornerRadius: CGFloat = 10
            static let pinConstraint: CGFloat = 40
            static let numberOfSections: Int = 2
            static let zeroNumberOfRows: Int = 1
            static let defaultNumberOfRows: Int = 0
            static let zeroSection: Int = 0
            static let firstSection: Int = 1
        }
        
        enum WishArray {
            static let toSetName: String = "Wishes"
        }
        
        enum Defaults {
            enum Names {
                
            }
            
            enum Constraints {
                
            }
            
            enum Colors {
                
            }
        }
        
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    
    
    // MARK: - Variables
    private let closeButton: UIButton = UIButton(type: .custom)
    private let addWishButton: UIButton = UIButton(type: .system)
    private let tableView: UITableView = UITableView(frame: .zero)
    private let textField: UITextField = UITextField()
    private var wishArray: [String] = []
    private let defaults = UserDefaults.standard
    private let editText: String = ""
    private var editingIndex: Int? // Индекс редактируемого желания
    private var addWishCell: AddWishCell?
    var onWishSelected: ((String) -> Void)?
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        wishArray = defaults.array(forKey: Constants.WishArray.toSetName) as? [String] ?? []
        view.backgroundColor = .gray
        configureUI()
        
    }
    
    // MARK: - Configures
    private func configureUI() {
        configureCloseButton()
        configureTable()
    }
    
    
    private func configureCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        closeButton.tintColor = Constants.CloseButton.tintColor
        closeButton.setImage(UIImage(systemName: Constants.CloseButton.systemName),for: .normal)
        view.addSubview(closeButton)
        closeButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.CloseButton.topConstraint)
        closeButton.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, Constants.CloseButton.trailingConstraint)
        closeButton.addTarget(self, action: #selector(closeViewButtonPressed), for: .touchUpInside)
    }
    
    private func configureTable() {
        closeButton.translatesAutoresizingMaskIntoConstraints = Constants.Other.translatesAutoresizingMaskIntoConstraints
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = Constants.TableView.cornerRadius
        tableView.pin(to: view, Constants.TableView.pinConstraint)
        tableView.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        tableView.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
        
    }
    
    // MARK: - Actions
    @objc private func closeViewButtonPressed() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.TableView.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Constants.TableView.zeroSection:
            return Constants.TableView.zeroNumberOfRows
        case Constants.TableView.firstSection:
            return wishArray.count
        default:
            return Constants.TableView.defaultNumberOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Constants.TableView.zeroSection:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AddWishCell.reuseId,
                for: indexPath
            )
            guard let addWishCell = cell as? AddWishCell else { return cell }
            
            self.addWishCell = addWishCell // ✅ Сохраняем ссылку на AddWishCell
            
            addWishCell.addWish = { [weak self] newWish in
                guard let self = self else { return }
                
                if let index = self.editingIndex {
                    self.wishArray[index] = newWish
                    self.editingIndex = nil
                } else {
                    self.wishArray.append(newWish)
                }
                
                self.defaults.set(self.wishArray, forKey: Constants.WishArray.toSetName)
                self.addWishCell?.setText("") // ✅ Очищаем поле после редактирования
                self.tableView.reloadData()
            }
            
            return addWishCell
        case Constants.TableView.firstSection:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WrittenWishCell.reuseId,
                for: indexPath
            )
            guard let wishCell = cell as? WrittenWishCell else { return cell }
            wishCell.configure(with: wishArray[indexPath.row], at: indexPath.row, delegate: self)
            wishCell.onDelete = { [weak self] in
                        guard let self = self else { return }
                        self.wishArray.remove(at: indexPath.row)
                        defaults.set(self.wishArray, forKey: Constants.WishArray.toSetName)
                        self.tableView.reloadData()
                    }
            return wishCell
        default:
            return UITableViewCell()
        }
    }
}

extension WishStoringViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in guard let self = self else { return }
            
            self.wishArray.remove(at: indexPath.row)
            
            defaults.set(self.wishArray, forKey: "Wishes")
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        // Настройка действия
        deleteAction.backgroundColor = UIColor.red // Цвет фона
        deleteAction.image = UIImage(systemName: "trash") // Иконка действия
        
        // Возвращаем конфигурацию действий
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWish = wishArray[indexPath.row]
        dismiss(animated: true) { [weak self] in
            self?.didSelectWish(selectedWish) // ✅ Теперь передаётся после закрытия экрана
        }
    }
}


