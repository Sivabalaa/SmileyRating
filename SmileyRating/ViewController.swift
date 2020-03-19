//
//  ViewController.swift
//  SmileyRating
//
//  Created by apple on 25/02/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupRatingView()
    }
    
    //Design
    func setupRatingView() {
        let sliderStep: SliderStep = SliderStep()
        sliderStep.stepImages =   [UIImage(named:"terrible")!, UIImage(named:"bad")!, UIImage(named:"okay")!, UIImage(named:"good")!,UIImage(named:"great")!, ]
        
        sliderStep.tickTitles = ["Terrible", "Bad", "Okay", "Good", "Great"]
        sliderStep.tickImages = [UIImage(named:"unTerrible")!, UIImage(named:"unBad")!, UIImage(named:"unOkay")!, UIImage(named:"unGood")!,UIImage(named:"unGreat")!, ]
        sliderStep.minimumValue = 1
        sliderStep.maximumValue = Float(sliderStep.stepImages!.count) + sliderStep.minimumValue - 1.0
        sliderStep.stepTickColor = UIColor.clear
        sliderStep.stepTickWidth = 40
        sliderStep.stepTickHeight = 40
        sliderStep.trackHeight = 2
        sliderStep.value = 5
        sliderStep.trackColor = #colorLiteral(red: 0.9371728301, green: 0.9373074174, blue: 0.9371433258, alpha: 1)
        sliderStep.enableTap = true
        sliderStep.sliderStepDelegate = self
        sliderStep.isContinuous = true
        sliderStep.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sliderStep)
        NSLayoutConstraint.activate([
            //sliderStep
            sliderStep.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            sliderStep.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sliderStep.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sliderStep.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}

//MARK:- Delegate
extension ViewController: SliderStepDelegate {
    func didSelectedValue(sliderStep: SliderStep, value: Float) {
        print(Int(value))
    }
}

