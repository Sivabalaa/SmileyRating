//
//  SliderStepRating.swift
//
//  Created by apple on 14/10/19.
//  Copyright © 2019 Ndot. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

protocol SliderStepDelegate {
    func didSelectedValue(sliderStep: SliderStep , value:Float)
}


class SliderStep: UISlider {
    
    @IBInspectable var enableTap: Bool = true
    @IBInspectable var trackHeight: Float = 4
    @IBInspectable var trackColor: UIColor = UIColor.lightGray
    @IBInspectable var drawTicks: Bool = true
    @IBInspectable var stepTickWidth: Float = 15
    @IBInspectable var stepTickHeight: Float = 15
    @IBInspectable var stepTickColor: UIColor = UIColor.lightGray
    @IBInspectable var stepTickRounded: Bool = true
    @IBInspectable var unselectedFont: UIFont = UIFont.systemFont(ofSize: 13)
    @IBInspectable var selectedFont: UIFont = UIFont.systemFont(ofSize: 13)
    @IBInspectable var stepTitlesOffset: CGFloat = 1
    @IBInspectable var highlightedImageSize: CGFloat = 55
    @IBInspectable var selectedColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    @IBInspectable var unselectedColor: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    
    @objc var customTrack: Bool = true
    
    ///Requireds
    @objc var stepImages: [UIImage]?
    
    //Optionals
    @objc var tickTitles: [String]?
    @objc var tickImages: [UIImage]?
    
    fileprivate var _stepTickLabels: [UILabel]?
    fileprivate var _stepTickImages: [UIImageView]?
    
    //Delegate
    var sliderStepDelegate:SliderStepDelegate!
    
    @objc var stepWidth: Double {
        return Double(trackWidth) / Double(steps)
    }
    @objc var trackWidth: CGFloat {
        return self.bounds.size.width
    }
    @objc var trackLeftOffset: CGFloat {
        let rect = rectForValue(minimumValue)
        return rect.width / 2
    }
    @objc var trackRightOffset: CGFloat {
        let rect = rectForValue(maximumValue)
        return rect.width / 2
    }
    @objc var steps: Int {
        return Int(maximumValue - minimumValue)
    }
    
    override var value: Float {
        didSet {
            movingSliderStepValue()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentMode = .redraw //enable redraw on rotation (calls setNeedsDisplay)
        
        if enableTap {
            let tap = UITapGestureRecognizer(target: self, action: #selector(SliderStep.sliderTapped(_:)))
            self.addGestureRecognizer(tap)
        }
        
        self.addTarget(self, action: #selector(SliderStep.movingSliderStepValue), for: .valueChanged)
        self.addTarget(self, action: #selector(SliderStep.didMoveSliderStepValue), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc internal func sliderTapped(_ gestureRecognizer: UIGestureRecognizer) {
        if self.isHighlighted {
            return
        }
        
        let pointTapped: CGPoint = gestureRecognizer.location(in: self)
        let percentage = Float(pointTapped.x / trackWidth)
        let delta = percentage * (maximumValue - minimumValue)
        let newValue = minimumValue + delta
        
        self.setValue(newValue, animated: false)
        didMoveSliderStepValue(true)
    }
    
    @objc internal func movingSliderStepValue() {
        let intValue = Int(round(self.value))
        let floatValue = Float(intValue)
        
        setThumbForSliderValue(floatValue)
    }
    
    @objc internal func didMoveSliderStepValue(_ sendValueChangedEvent: Bool = false) {
        let intValue = Int(round(self.value))
        let floatValue = Float(intValue)
        
        UIView.animate(withDuration: 0.15, animations: {
            self.setValue(floatValue, animated: true)
        }, completion: { (fin) in
            self.setThumbForSliderValue(floatValue)
            self.sliderStepDelegate.didSelectedValue( sliderStep: self, value: floatValue)
            if sendValueChangedEvent {
                self.sendActions(for: .valueChanged)
            }
        })
    }
    
    @objc internal func setThumbForSliderValue(_ value: Float) {
        //Image
        if let selectionImage = thumbForSliderValue(value) {
            let image = selectionImage.resizeImage(targetSize: CGSize(width: highlightedImageSize, height: highlightedImageSize))
            self.setThumbImage(image, for: UIControl.State())
            self.setThumbImage(image, for: UIControl.State.selected)
            self.setThumbImage(image, for: UIControl.State.highlighted)
        }
        
        //Label
        thumbForSliderValueLbl(value)
    }
    
    @objc internal func thumbForSliderValue(_ value: Float) -> UIImage? {
        let intValue = Int(round(value))
        let imageIndex = intValue - Int(minimumValue)
        
        if imageIndex >= 0 && stepImages?.count > imageIndex {
            return stepImages?[imageIndex]
        }
        
        return nil
    }
    
    @objc internal func thumbForSliderValueLbl(_ value: Float) {
        guard _stepTickLabels?.count > 0 else {
            return
        }
        let intValue = Int(round(value))
        let lblIndex = intValue - Int(minimumValue)
        
        
        for i in 0 ..<  _stepTickLabels!.count {
            if i == lblIndex {
                _stepTickLabels?[i].textColor = selectedColor
            } else {
                _stepTickLabels?[i].textColor = unselectedColor
            }
        }
    }
    
    @objc internal func rectForValue(_ value: Float) -> CGRect {
        let trackRect = self.trackRect(forBounds: bounds)
        let rect = thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
        return rect
    }
    
    override func draw(_ rect: CGRect) {
        guard minimumValue >= 0 && maximumValue > minimumValue else {
            print("SliderStep ERROR: minimumValue AND maximumValue need to be UInt: maximumValue < minimumValue OR minimumValue < 0 OR maximumValue < 0. EXIT.")
            return
        }
        
        guard Float(Int(self.value)) == self.value else {
            print("SliderStep ERROR: current/start value needs to be UInt (not Float). EXIT.")
            return
        }
        
        guard Float(Int(minimumValue)) == minimumValue && Float(Int(maximumValue)) == maximumValue else {
            print("SliderStep ERROR: minimumValue AND maximumValue need to be UInt (not Float). EXIT.")
            return
        }
        
        guard let images = stepImages, images.count == Int((maximumValue - minimumValue + 1)) else {
            print("SliderStep ERROR: images is nil OR images.count != (maximumValue - minimumValue + 1). EXIT.")
            return
        }
        
        guard tickTitles == nil || images.count == tickTitles?.count else {
            print("SliderStep ERROR: tickTitles is not nil OR tickTitles.count != stepImages.count. EXIT.")
            return
        }
        
        guard tickImages == nil || tickImages?.count == images.count else {
            print("SliderStep ERROR: tickImages is not nil OR tickImages.count != stepImages.count. EXIT.")
            return
        }
        
        guard images.count == (Int(maximumValue) - Int(minimumValue) + 1) else {
            print("SliderStep ERROR: Int(maximumValue) - Int(minimumValue) + 1 != images.count. EXIT.")
            return
        }
        
        
        drawLabels()
        drawTrack()
        drawImages()
        //Selected Item
        setThumbForSliderValue(self.value)
    }
    
    @objc internal func drawLabels() {
        
        guard let ti = tickTitles else {
            return
        }
        
        if _stepTickLabels == nil {
            _stepTickLabels = []
        }
        
        if let sl = _stepTickLabels {
            for l in sl {
                l.removeFromSuperview()
            }
            _stepTickLabels?.removeAll()
            
            for index in 0..<ti.count {
                let title = ti[index]
                let lbl = UILabel()
                lbl.font = unselectedFont
                lbl.text = title
                lbl.textColor = unselectedColor
                lbl.textAlignment = .center
                lbl.sizeToFit()
                
                var offset: CGFloat = 0
                if index+1 < (steps%2 == 0 ? steps/2+1 : steps/2) {
                    offset = trackLeftOffset/2
                }
                else if index+1 > (steps%2 == 0 ? steps/2+1 : steps/2) {
                    offset = -(trackRightOffset/2)
                }
                if index == 0 {
                    offset = trackLeftOffset
                }
                
                if index == steps {
                    offset = -trackRightOffset
                }
                
                let x = offset + CGFloat(Double(index) * stepWidth) - (lbl.frame.size.width / 2)
                var rect = lbl.frame
                rect.origin.x = x
                rect.origin.y = bounds.midY - (bounds.size.height / 2) - rect.size.height + highlightedImageSize + 10
                lbl.frame = rect
                self.addSubview(lbl)
                _stepTickLabels?.append(lbl)
            }
        }
    }
    
    @objc internal func drawImages() {
        guard let ti = tickImages else {
            return
        }
        
        if _stepTickImages == nil {
            _stepTickImages = []
        }
        
        if let sl = _stepTickImages {
            for l in sl {
                l.removeFromSuperview()
            }
            _stepTickImages?.removeAll()
            
            for index in 0..<ti.count {
                let img = ti[index]
                let imv = UIImageView(image: img)
                imv.contentMode = .scaleAspectFit
                imv.sizeToFit()
                
                var offset: CGFloat = 0
                
                if index+1 < (steps%2 == 0 ? steps/2+1 : steps/2) {
                    offset = trackLeftOffset/2
                }
                else if index+1 > (steps%2 == 0 ? steps/2+1 : steps/2) {
                    offset = -(trackLeftOffset/2)
                }
                
                if index == 0 {
                    offset = trackLeftOffset
                }
                
                if index == steps {
                    offset = -trackRightOffset
                }
                
                let x = offset + CGFloat(Double(index) * stepWidth) - (imv.frame.size.width / 2)
                var rect = imv.frame
                rect.origin.x = x
                rect.origin.y = bounds.midY - (rect.size.height / 2)
                imv.frame = rect
                self.insertSubview(imv, at: 2) //index 2 => draw images below the thumb/above the line
                _stepTickImages?.append(imv)
            }
        }
    }
    
    @objc internal func drawTrack() {
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        
        // Remove the original track if custom
        if customTrack {
            // Clear original track using a transparent pixel
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
            let transparentImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            setMaximumTrackImage(transparentImage, for: UIControl.State())
            setMinimumTrackImage(transparentImage, for: UIControl.State())
            
            // Draw custom track
            ctx?.setFillColor(trackColor.cgColor)
            let x = trackLeftOffset
            let y = bounds.midY - CGFloat(trackHeight / 2)
            let rect = CGRect(x: x, y: y, width: bounds.width - trackLeftOffset - trackRightOffset, height: CGFloat(trackHeight))
            let trackPath = UIBezierPath(rect: rect)
            
            ctx?.addPath(trackPath.cgPath)
            ctx?.fillPath()
        }
        
        
        if drawTicks {
            // Draw ticks
            ctx?.setFillColor(stepTickColor.cgColor)
            
            for index in 0...steps {
                
                var offset: CGFloat = 0
                
                if index == 0 {
                    offset = trackLeftOffset
                }
                
                if index == steps {
                    offset = -trackRightOffset
                }
                
                let x = offset + CGFloat(Double(index) * stepWidth) - CGFloat(stepTickWidth / 2)
                let y = bounds.midY - CGFloat(stepTickHeight / 2)
                
                // Create rounded/squared tick bezier
                let stepPath: UIBezierPath
                let rect = CGRect(x: x, y: y, width: CGFloat(stepTickWidth), height: CGFloat(stepTickHeight))
                
                if customTrack && stepTickRounded {
                    let radius = CGFloat(stepTickHeight/2)
                    stepPath = UIBezierPath(roundedRect: rect, cornerRadius: radius)
                } else {
                    stepPath = UIBezierPath(rect: rect)
                }
                
                ctx?.addPath(stepPath.cgPath)
                ctx?.fillPath()
            }
        }
        
        ctx?.restoreGState()
    }
    
    //Avoid exc bad access on viewcontroller view did load
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        drawTrack()
        self.value = self.minimumValue
    }
    
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
