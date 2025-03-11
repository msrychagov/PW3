//
//  ViewController.swift
//  msrychagovPW2
//
//  Created by Михаил Рычагов on 05.11.2024.
//

import UIKit

final class WishMakerViewController: UIViewController {
    //MARK: - Constants
    private enum Constants {
        static let title: String = "WishMaker"
        static let description: String = "Enter the color components of your wish"
        static let redSliderTitle: String = "Red"
        static let greenSliderTitle: String = "Green"
        static let blueSliderTitle: String = "Blue"
        static let titleFontSize: CGFloat = 32
        static let descriptionFontSize: CGFloat = 16
        static let descriptionLineHeight: Int = 24
        static let topConstraint: CGFloat = 10
        static let leftContraint: CGFloat = 20
        static let bottomConstraint: CGFloat = 40
        static let minSliderValue: Double = 0.0
        static let maxSliderValue: Double = 255.0
        static let stackCornerRadius: CGFloat = 20
        static let alphaValue: CGFloat = 1
        static let titleHeight: CGFloat = 110
        static let titleWidth: CGFloat = 350
        static let descriptionHeight: CGFloat = 50
        static let descriptionWidth: CGFloat = 350
        static let pinTopDescription: CGFloat = 80
        static let toggleButtonTitle: String = "Toggle Sliders"
        static let toggleButtonHeight: CGFloat = 50
        static let toggleButtonWidth: CGFloat = 350
        static let stackWidth: CGFloat = 350
        static let toggleButtonBottomConstraint: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let buttonBottom: CGFloat = 20
        static let buttonSide: CGFloat = 10
        static let buttonText: String = "Add Wish"
        static let buttonRadius: CGFloat = 10
        static let titleText: String = "Schedule wish granting"
        static let stackBottomConstraint: CGFloat = 10
        static let actionStackSpacing: CGFloat = 3
        static let actionStackBottomConstraint: CGFloat = 15
        static let actionStackHorizontalConstraint: CGFloat = 15
        
    }
    
    //MARK: - Variables
    private var titleView = UILabel()
    private var descriptionView = UILabel()
    private var toggleButton = UIButton(type: .system)
    private var stack = UIStackView()
    private let addWishButton: UIButton = UIButton(type: .system)
    private let actionStack: UIStackView = UIStackView()
    private let scheduleButton: UIButton = UIButton(type: .system)
    private var redComponent = 0.0
    private var greenComponent = 0.0
    private var blueComponent = 0.0
    
    //MARK: - Properties
    public var colors: UIColor = .black {
        didSet {
            // Устанавливаем цвет фона
            view.backgroundColor = colors
            let contrastColor = colors.inverted()
            for button in [addWishButton, scheduleButton, toggleButton] {
                button.setTitleColor(colors, for: .normal)
                button.backgroundColor = contrastColor
            }
            for label in [titleView, descriptionView] {
                label.backgroundColor = contrastColor
                label.textColor = colors
            }
            
            for subview in stack.arrangedSubviews {
                subview.backgroundColor = contrastColor
                
                if let customSlider = subview as? CustomSlider {
                    customSlider.setTitleColor(colors)
                    customSlider.setSliderColors(
                        minimumTrack: colors,
                        maximumTrack: colors,
                        thumb: colors
                    )
                }
            }
            
            
        }
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Configures
    private func configureUI() {
        configureTitle()
        configureActionStack()
        configureDescription()
        configureSlidersStack()
        configureToggleButton()
    }
    
    private func configureTitle() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = Constants.title
        titleView.font = UIFont.systemFont(ofSize: Constants.titleFontSize)
        titleView.textAlignment = .center
        titleView.backgroundColor = .white
        titleView.layer.cornerRadius = Constants.stackCornerRadius
        titleView.layer.masksToBounds = true
        
        view.addSubview(titleView)
        titleView.pinCenterX(to: view.safeAreaLayoutGuide.centerXAnchor)
        titleView.setHeight(Constants.titleHeight)
        titleView.setWidth(Constants.titleWidth)
        titleView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.topConstraint)
    }
    
    private func configureDescription() {
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.text = Constants.description
        descriptionView.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        descriptionView.textAlignment = .center
        descriptionView.backgroundColor = .white
        descriptionView.layer.cornerRadius = Constants.stackCornerRadius
        descriptionView.layer.masksToBounds = true
        
        view.addSubview(descriptionView)
        descriptionView.pinCenterX(to: titleView)
        descriptionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.pinTopDescription)
        descriptionView.setHeight(Constants.descriptionHeight)
        descriptionView.setWidth(Constants.descriptionWidth)
    }
    
    private func configureSlidersStack() {
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        
        stack.layer.cornerRadius = Constants.stackCornerRadius
        stack.clipsToBounds = true
        
        let sliderRed = CustomSlider(title: Constants.redSliderTitle, min: Constants.minSliderValue, max: Constants.maxSliderValue)
        let sliderGreen = CustomSlider(title: Constants.greenSliderTitle, min: Constants.minSliderValue, max: Constants.maxSliderValue)
        let sliderBlue = CustomSlider(title: Constants.blueSliderTitle, min: Constants.minSliderValue, max: Constants.maxSliderValue)
        
        stack.pinCenterX(to: view.centerXAnchor)
        stack.pinLeft(to: view.leadingAnchor, Constants.leftContraint)
        stack.pinBottom(to: actionStack.topAnchor, Constants.stackBottomConstraint)
        stack.setWidth(Constants.stackWidth)
        
        for slider in [sliderRed, sliderBlue, sliderGreen] {
            stack.addArrangedSubview(slider)
            slider.valueChanged = { [weak self] value in
                guard let self = self else { return }
                
                switch slider {
                case sliderRed:
                    self.redComponent = value
                case sliderGreen:
                    self.greenComponent = value
                case sliderBlue:
                    self.blueComponent = value
                default: break
                }
                self.colors = UIColor(
                    red: CGFloat(self.redComponent / Constants.maxSliderValue),
                    green: CGFloat(self.greenComponent / Constants.maxSliderValue),
                    blue: CGFloat(self.blueComponent / Constants.maxSliderValue),
                    alpha: Constants.alphaValue
                )
            }
        }
    }
    
    private func configureToggleButton() {
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.setTitle(Constants.toggleButtonTitle, for: .normal)
        toggleButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        toggleButton.backgroundColor = .white
        toggleButton.setTitleColor(colors, for: .normal)
        toggleButton.layer.cornerRadius = Constants.stackCornerRadius
        toggleButton.addTarget(self, action: #selector(toggleSlidersVisibility), for: .touchUpInside)
        
        
        view.addSubview(toggleButton)
        toggleButton.pinCenterX(to: view.centerXAnchor)
        toggleButton.setHeight(Constants.toggleButtonHeight)
        toggleButton.setWidth(Constants.toggleButtonWidth)
        toggleButton.pinBottom(to: stack.topAnchor, Constants.toggleButtonBottomConstraint)
    }
    
    private func configureAddWishButton() {
        addWishButton.translatesAutoresizingMaskIntoConstraints = false
        addWishButton.setTitle(Constants.buttonText, for: .normal)
        addWishButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        addWishButton.setTitleColor(colors, for: .normal)
        addWishButton.layer.cornerRadius = Constants.buttonRadius
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
        addWishButton.backgroundColor = .white
        
    }
    
    private func configureScheduleButton() {
        scheduleButton.translatesAutoresizingMaskIntoConstraints = false
        scheduleButton.setTitle(Constants.titleText, for: .normal)
        scheduleButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        scheduleButton.setTitleColor(colors, for: .normal)
        scheduleButton.layer.cornerRadius = Constants.buttonRadius
        scheduleButton.addTarget(self, action: #selector(scheduleWishButtonPressed), for: .touchUpInside)
        scheduleButton.backgroundColor = .white
    }
    
    private func configureActionStack() {
        actionStack.axis = .vertical
        view.addSubview(actionStack)
        actionStack.spacing = Constants.actionStackSpacing
        for button in [addWishButton, scheduleButton] {
            actionStack.addArrangedSubview(button)
        }
        configureAddWishButton()
        configureScheduleButton()
        actionStack.pinBottom(to: view, Constants.actionStackBottomConstraint)
        actionStack.pinHorizontal(to: view, Constants.actionStackHorizontalConstraint)
    }
    // MARK: - Actions
    @objc private func toggleSlidersVisibility() {
        stack.isHidden.toggle()
    }
    
    @objc private func addWishButtonPressed() {
        let vc = WishStoringViewController()
        vc.view.backgroundColor = colors
        vc.cellBackgroundColor = colors.inverted()
        vc.wishLabelTextColor = colors
        present(vc, animated: true)
        
    }
    
    @objc private func scheduleWishButtonPressed() {
        let vc = WishCalendarViewController()
        vc.view.backgroundColor = colors
        vc.cellColor = colors.inverted()
        vc.cellTextColor = colors
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: UIColor
extension UIColor {
    /// Инвертирует цвет (меняет белый на черный, синий на желтый и т. д.)
    func inverted() -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
    }
}

