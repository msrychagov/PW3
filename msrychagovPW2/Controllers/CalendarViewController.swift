import UIKit

class CalendarViewController: UIViewController {

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime // Режим выбора даты и времени
        picker.preferredDatePickerStyle = .inline // Стиль (можно менять)
        picker.minimumDate = Date() // Ограничение на минимальную дату
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подтвердить дату", for: .normal)
        button.addTarget(CalendarViewController.self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(datePicker)
        view.addSubview(confirmButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Расположение UIDatePicker
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Расположение кнопки подтверждения
            confirmButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func confirmButtonTapped() {
        selectedDate = datePicker.date
        print("Выбрана дата: \(selectedDate!)")
        // Здесь можно обработать выбранную дату
    }
}
