//
//  WishStoringViewController.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 02.12.2024.
//
import UIKit

final class WishStoringViewController: UIViewController, WrittenWishCellDelegate {
    // MARK: - Constants
    private enum Constants {
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
        
        enum DeleteAction {
            static let title: String = "Delete"
            static let imageSystemName: String = "trash"
        }
        
        enum WishArray  {
            static let defaultsKey: String = "Wishes"
        }
        
        enum TapGesture {
            static let cancelsTouchesInView: Bool = false
        }
        
        enum ActivityViewController {
            static let animated: Bool = true
        }
        
        enum Other {
            static let translatesAutoresizingMaskIntoConstraints: Bool = false
        }
    }
    
    
    // MARK: - Variables
    private let addWishButton: UIButton = UIButton(type: .system)
    private let tableView: UITableView = UITableView(frame: .zero)
    private let textField: UITextField = UITextField()
    private var wishArray: [String] = []
    private let defaults = UserDefaults.standard
    private let editText: String = ""
    var cellBackgroundColor: UIColor = .white
    var wishLabelTextColor: UIColor = .black
    private var editingIndex: Int?
    private var addWishCell: AddWishCell?
    var textColor: UIColor = .black
    
    var onWishSelected: ((String) -> Void)?
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        wishArray = defaults.array(forKey: Constants.WishArray.defaultsKey) as? [String] ?? []
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = Constants.TapGesture.cancelsTouchesInView  // Позволяет обрабатывать другие нажатия
        view.addGestureRecognizer(tapGesture)
        
        
        configureUI()
        
    }
    
    func editWish(_ text: String, at index: Int) {
        addWishCell?.setText(text)
        editingIndex = index
    }
    
    func shareWish(_ text: String) {
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityViewController, animated: Constants.ActivityViewController.animated)
    }
    
    func didSelectWish(_ wish: String) {
        onWishSelected?(wish)
    }
    
    // MARK: - Configures
    private func configureUI() {
        configureTable()
    }
    
    private func configureTable() {
        view.addSubview(tableView)
        tableView.backgroundColor = Constants.TableView.backgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = Constants.TableView.cornerRadius
        tableView.pin(to: view, Constants.TableView.pinConstraint)
        tableView.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        tableView.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
        
    }
    
    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
            addWishCell.configure(textColor: wishLabelTextColor, backgroundColor: cellBackgroundColor)
            self.addWishCell = addWishCell
            
            addWishCell.addWish = { [weak self] newWish in
                guard let self = self else { return }
                
                if let index = self.editingIndex {
                    self.wishArray[index] = newWish
                    self.editingIndex = nil
                } else {
                    self.wishArray.append(newWish)
                }
                
                self.defaults.set(self.wishArray, forKey: Constants.WishArray.defaultsKey)
                self.addWishCell?.setText("")
                self.tableView.reloadData()
            }
            
            return addWishCell
            
        case Constants.TableView.firstSection:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WrittenWishCell.reuseId,
                for: indexPath
            )
            guard let wishCell = cell as? WrittenWishCell else { return cell }
            wishCell.configure(with: wishArray[indexPath.row], at: indexPath.row, withBgColor: cellBackgroundColor,
                               withTextColor: wishLabelTextColor, delegate: self)
            
            wishCell.onEdit = { [weak self] in
                guard let self = self else { return }
                self.editWish(self.wishArray[indexPath.row], at: indexPath.row)
            }
            
            wishCell.onShare = { [weak self] in
                guard let self = self else { return }
                self.shareWish(self.wishArray[indexPath.row])
            }
            
            wishCell.onDelete = { [weak self] in
                guard let self = self else { return }
                self.wishArray.remove(at: indexPath.row)
                self.defaults.set(self.wishArray, forKey: Constants.WishArray.defaultsKey)
                self.tableView.reloadData()
            }
            return wishCell
        default:
            return UITableViewCell()
        }
    }
}

//MARK: UITableViewDelegate
extension WishStoringViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: Constants.DeleteAction.title) { [weak self] _, _, completionHandler in guard let self = self else { return }
            
            self.wishArray.remove(at: indexPath.row)
            
            defaults.set(self.wishArray, forKey: Constants.WishArray.defaultsKey)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        // Настройка действия
        deleteAction.backgroundColor = UIColor.red
        deleteAction.image = UIImage(systemName: Constants.DeleteAction.imageSystemName) // Иконка действия
        
        // Возвращаем конфигурацию действий
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWish = wishArray[indexPath.row]
        
        // Если клавиатура активна — просто скрываем её
        if view.isFirstResponder || textField.isFirstResponder {
            view.endEditing(true)
            return
        }
        
        // Если клавиатура не была активна, выполняем стандартное действие
        onWishSelected?(selectedWish)
    }
    
}


