//
//  CustomSlider.swift
//  CustomSlideBar
//
//  Created by Swamy Kottu on 10/17/17.
//  Copyright © 2017 Swamy Kottu. All rights reserved.
//

import UIKit

public protocol CustomSliderDelegate: class {
    func customsliderStopped(at: Int)
}
public protocol CustomSliderDataSource: class {
    //Actual Values
    func sliderStepsActual() -> [Int]
    //Pass equal spacing steps... dummy values ex: [1, 2, 3, 4, 5, 6], [5, 10, 15, 20, 25] .....
    //Count should equal to actual steps...
    func sliderSteps() -> [Int]
}

public class CustomSlider: UISlider {
    
    public var currentvalue = 0
    private var nowcursorisat = 0
    
    //****Hacked****
    //Reason: Slider should be equally separated, even values don't have a common difference b/w them.
    //Provide a equally separated values in to this even if we don't have in actual values. Then send actual values in "stepValuesActual"
    //Difference between two any numbers should be the same -> It shows slider with equally separated steps
    //Ex: Actual - 10 18 30 38 40 50 58
    // Regular one - 10 20 30 40 50 60 70 (To appear slider with equally spaced)
    private var stepValues: [Int] = [] {
        willSet {
            maximumValue = Float(newValue[newValue.count-1])
            minimumValue = Float(newValue[0])
            
        }
    }
    //Actual steps in a slider - Selction o/p value will always from this
    private var stepValuesActual: [Int] = []
    public var height: CGFloat = 5.0 //default
    private var stackView: UIStackView?
    //StackView Height - Slider Labels
    public var sliderStepLablesHeight: CGFloat = 20.0 {
        didSet {
            updateSliderBottomLabels()
        }
    }
    
    public var sliderStepLablesY: CGFloat = 10.0 {
        didSet {
            addBottomLables()
        }
    }
    
    //Slider Labels Font and Color
    public var sliderStepLabelsFont: UIFont = UIFont.systemFont(ofSize: 15.0, weight: .regular) {
        didSet {
            updateSliderBottomLabels()
        }
    }
    public var sliderStepLabelsColor: UIColor = UIColor.black {
        didSet {
            updateSliderBottomLabels()
        }
    }
    //Delegate and DataSource
    weak public var customSliderDelegate: CustomSliderDelegate?
    weak public var customSliderDataSource: CustomSliderDataSource? {
        didSet {
            self.stepValues = (self.customSliderDataSource?.sliderSteps())!
            self.stepValuesActual = (self.customSliderDataSource?.sliderStepsActual())!
            addBottomLables()
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureSlider()
    }
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        configureSlider()
    }
    
    public override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = self.height
        return newBounds
    }
    
    func configureSlider() {
       self.isContinuous = false
       self.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
    }
    
    @objc private func sliderValueDidChange(_ slider: UISlider) {
        let sliderMonth = Int(slider.value)
        if sliderMonth > currentvalue {
            for index in nowcursorisat..<stepValues.count {
                if (currentvalue...stepValues[index]).contains(sliderMonth) {
                    nowcursorisat = index
                    currentvalue = stepValues[index]
                    break
                }
            }
        }
        else {
            for index in stride(from: nowcursorisat, to: 0, by: -1) {
                if (stepValues[index-1]..<stepValues[index]).contains(sliderMonth) {
                    nowcursorisat = index - 1
                    currentvalue = stepValues[index - 1]
                    break
                }
            }
        }
        if stepValues.count > 0 && self.stepValuesActual.count == self.stepValues.count {
            self.setValue(Float(self.stepValues[nowcursorisat]), animated: false)
            if let delegate = self.customSliderDelegate {
                delegate.customsliderStopped(at: self.stepValuesActual[nowcursorisat])
            }
        }
    }
    
    func addBottomLables()  {
        if let _ = self.stackView {
            self.stackView?.removeFromSuperview()
        }
        self.stackView = UIStackView()
        self.stackView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.stackView!)
        let stackViewLocal = self.stackView
        let heightlocal = self.sliderStepLablesHeight
        let yPosition = self.sliderStepLablesY + self.sliderStepLablesHeight
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-3-[labelView]-3-|", options: [], metrics: [:] , views: ["labelView": stackViewLocal ?? UIStackView()]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topSpace-[labelView(height)]", options: [], metrics: ["height":heightlocal, "topSpace": yPosition] , views: ["labelView": stackViewLocal ?? UIStackView()]))
        self.stackView?.alignment = .fill
        self.stackView?.axis = .horizontal
        self.stackView?.distribution = .equalCentering
        var index = 0
        for _ in self.stepValuesActual {
            let label = UILabel()
            label.font = sliderStepLabelsFont
            label.text = "\(self.stepValuesActual[index])"
            self.stackView?.addArrangedSubview(label)
            index += 1
        }
    }
    
    func updateSliderBottomLabels() {
        if let stackView = self.stackView {
            for view in stackView.subviews {
                if let label = view as? UILabel {
                    label.font = self.sliderStepLabelsFont
                    label.textColor = self.sliderStepLabelsColor
                }
            }
            stackView.frame .size = CGSize(width: stackView.bounds.width, height: self.sliderStepLablesHeight)
        }
    }

}
