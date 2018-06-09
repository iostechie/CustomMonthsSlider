//
//  ViewController.swift
//  CustomSlideBar
//
//  Created by Swamy Kottu on 10/5/17.
//  Copyright © 2017 Swamy Kottu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var customSlider: CustomSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        customSlider.customSliderDelegate = self
        customSlider.customSliderDataSource = self
        customSlider.value = 30
        customSlider.height = 5.0
        customSlider.sliderStepLablesY = 12
        let sliderImage = self.imageWith(name: "slider-bg").stretchableImage(withLeftCapWidth: 14, topCapHeight: 0)
        customSlider.setMinimumTrackImage(sliderImage, for: .normal)
        customSlider.setMaximumTrackImage(sliderImage, for: .normal)
        customSlider.minimumTrackTintColor =  UIColor(red: 35.0/255.0, green: 122.0/255.0, blue: 186.0/255.0, alpha: 1.0)
        customSlider.maximumTrackTintColor = UIColor(red: 201.0/255.0, green: 201.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        
        customSlider.setThumbImage(#imageLiteral(resourceName: "slider-thumb"),
                                  for: UIControlState.normal)
        customSlider.setThumbImage(self.imageWith(name: "slider_button_disabled"), for: UIControlState.disabled)
        
    }
    
    func imageWith(name:String) -> UIImage {
        let image = UIImage(named: name, in: Bundle(for: type(of:self)), compatibleWith: nil)
        return image!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func someMthod(selected: Int)  {
        
    }


}

extension ViewController: CustomSliderDelegate, CustomSliderDataSource {
    
    func sliderStepsActual() -> [Int] {
        return [12, 18, 24, 36, 48, 54 , 60]
    }
    
    //Pass equal spacing steps... dummy values ex: [1, 2, 3, 4, 5, 6], [5, 10, 15, 20, 25] .....
    //Count should equal to actual steps count...
    func sliderSteps() -> [Int] {
        return [10, 20, 30, 40, 50, 60 , 70]
    }
    
    
    func customsliderStopped(at: Int) {
        print("Stopped value \(at)")
    }
}



