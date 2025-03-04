import UIKit


final class CustomSlider: UIView {
    // MARK: - Constants
    private enum Constants {
        static let topTitleConstraint: CGFloat = 10
        static let leftTitleConstraint: CGFloat = 20
        static let bottomSliderContraint: CGFloat = 10
        static let leftSliderConstraint: CGFloat = 20
    }
    
    // MARK: - Variables
    var valueChanged: ((Double) -> Void)?
    var slider = UISlider()
    var titleView = UILabel()

    // MARK: - Constructors
    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        titleView.text = title
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Methods
    func setTitleColor(_ color: UIColor) {
            titleView.textColor = color
        }
    
    func setSliderColors(minimumTrack: UIColor, maximumTrack: UIColor, thumb: UIColor) {
        slider.minimumTrackTintColor = minimumTrack
        slider.maximumTrackTintColor = maximumTrack
        slider.thumbTintColor = thumb
    }
    
    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false

        for view in [slider, titleView] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleView.pinCenterX(to: centerXAnchor)
        titleView.pinTop(to: topAnchor, Constants.topTitleConstraint)
        titleView.pinLeft(to: leadingAnchor, Constants.leftTitleConstraint)
        
        slider.pinTop(to: titleView.bottomAnchor)
        slider.pinCenterX(to: centerXAnchor)
        slider.pinBottom(to: bottomAnchor, Constants.bottomSliderContraint)
        slider.pinLeft(to: leadingAnchor, Constants.leftSliderConstraint)
    }

    //MARK: - Actions
    @objc
    private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}
