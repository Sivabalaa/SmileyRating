# SliderStepRating

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)

# About
#### A custom range `UISlider` in Swift - Draggable, Tappable, `@IBInspectable`

## Overview
* Easy customization(Font, Colors, Images, Ticks, Height, Width, Rounded)
* `@IBInspectable`
* Tappable
* Draggable
* Swift 5.0 above
* Xcode 11 above
* Orientation support
* Manual drag & drop the class

## Demo

![Sample](https://raw.githubusercontent.com/Sivabalaa/SmileyRating/master/Images/Sample.gif)
![Sample0](https://raw.githubusercontent.com/Sivabalaa/SmileyRating/master/Images/SampleImage.png)

## Manual
* Import `SliderStepRating.swift` into you project
* Add `UISlider` in you Storyboard file
* Set the `UISlider` class to `SliderStep`
* Cheers :)

## StoryBoard Demo

![Sample](https://raw.githubusercontent.com/Sivabalaa/SmileyRating/master/Images/UISliderView_StoryBoard.png)

### By StoryBoard

![StoryBoard](https://raw.githubusercontent.com/Sivabalaa/SmileyRating/master/Images/StoryBoard.png)

## By Code

```swift
//Rating
@IBOutlet weak var sliderStepRating: SliderStep!

override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setupRatingView()
}

//MARK:- Design
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
```

## Delegate methods 

Whenever a user selects a ratings(Draggable, Tappable), the following method will be called:

```swift
//MARK:- SliderStepDelegate
extension ViewController: SliderStepDelegate {
    func didSelectedValue(sliderStep: SliderStep, value: Float) {
        print(Int(value))
    }
}
```

License
=================
SliderStepRating is distributed under the MIT
license (see https://mit-license.org).




