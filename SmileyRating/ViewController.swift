//
//  ViewController.swift
//  SmileyRating
//
//  Created by apple on 25/02/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Rating
    @IBOutlet weak var sliderStepRating: SliderStep!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupRatingView()
    }
    
    //Design
    func setupRatingView() {
        sliderStepRating.stepImages =   [UIImage(named:"terrible")!, UIImage(named:"bad")!, UIImage(named:"okay")!, UIImage(named:"good")!,UIImage(named:"great")!, ]
        
        sliderStepRating.tickTitles = ["Terrible", "Bad", "Okay", "Good", "Great"]
        sliderStepRating.tickImages = [UIImage(named:"unTerrible")!, UIImage(named:"unBad")!, UIImage(named:"unOkay")!, UIImage(named:"unGood")!,UIImage(named:"unGreat")!, ]
        
        sliderStepRating.minimumValue = 1
        sliderStepRating.maximumValue = Float(sliderStepRating.stepImages!.count) + sliderStepRating.minimumValue - 1.0
        sliderStepRating.stepTickColor = UIColor.clear
        sliderStepRating.stepTickWidth = 40
        sliderStepRating.stepTickHeight = 40
        sliderStepRating.trackHeight = 2
        sliderStepRating.value = 5
        sliderStepRating.trackColor = #colorLiteral(red: 0.9371728301, green: 0.9373074174, blue: 0.9371433258, alpha: 1)
        sliderStepRating.enableTap = true
        sliderStepRating.sliderStepDelegate = self
        sliderStepRating.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sliderStepRating)
        NSLayoutConstraint.activate([
            //sliderStepRating
            sliderStepRating.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            sliderStepRating.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sliderStepRating.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sliderStepRating.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}

//MARK:- Delegate
extension ViewController: SliderStepDelegate {
    func didSelectedValue(sliderStep: SliderStep, value: Float) {
        print(Int(value))
    }
}

