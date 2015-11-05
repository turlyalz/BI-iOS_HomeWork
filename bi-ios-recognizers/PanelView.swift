//
//  PanelView.swift
//  bi-ios-recognizers
//
//  Created by Dominik Vesely on 03/11/15.
//  Copyright © 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import UIKit


class PanelView : UIView {
    
    var delegate : PanelViewDelegate?
    var onSliderChange : ((CGFloat) -> ())!
    var onSegmentedChange: ((Int) -> ())!
    
    var isPaused = false
    var time: Float = 5.0
    
    weak var slider: UISlider!
    weak var stepper: UIStepper!
    weak var _switch: UISwitch!
    weak var label: UILabel!
    weak var timer: NSTimer!
    weak var segmented: UISegmentedControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGrayColor()
        
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 15
        slider.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        addSubview(slider)
        self.slider = slider
        
        let stepper = UIStepper()
        stepper.minimumValue = 0;
        stepper.maximumValue = 15;
        stepper.stepValue = 0.5;
        stepper.addTarget(self, action: "stepperChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        addSubview(stepper)
        self.stepper = stepper
        
        let _switch = UISwitch()
        _switch.setOn(true, animated: false)
        _switch.addTarget(self, action: "switchToggled", forControlEvents: UIControlEvents.ValueChanged)
        
        addSubview(_switch)
        self._switch = _switch
        
        let label = UILabel()
        label.text = "Amplitude: "
        label.font = UIFont(name: "Palatino", size: 24)
        addSubview(label)
        self.label = label
        
        let segmented = UISegmentedControl()
        segmented.insertSegmentWithTitle("Red", atIndex: 0, animated: false)
        segmented.insertSegmentWithTitle("Blue", atIndex: 1, animated: false)
        segmented.insertSegmentWithTitle("Green", atIndex: 2, animated: false)
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: "segmentedSwitched:", forControlEvents: UIControlEvents.ValueChanged)
        addSubview(segmented)
        self.segmented = segmented
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1/30, target: self, selector: "fireTimer:", userInfo: nil, repeats: true)
        self.performSelector("invalidateTimer:", withObject: timer, afterDelay: NSTimeInterval(time))

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.slider.frame = CGRectMake(8, 8, CGRectGetWidth(self.bounds) - 16, 44);
        self.stepper.frame = CGRectMake(8, 8 + 44+8, CGRectGetWidth(self.bounds) - 16, 44);
        self.segmented.frame = CGRectMake(180, 8 + 104+8, 200, 30);
        self.label.frame = CGRectMake(180, 8 + 40+8, CGRectGetWidth(self.bounds) - 16, 44);
        self._switch.frame = CGRectMake(8, 8 + 104+8, CGRectGetWidth(self.bounds) - 16, 44);
    }
    
    
    func invalidateTimer(timer: NSTimer) {
        timer.invalidate()
    }
    
    
    //MARK: Action
    func fireTimer(timer:NSTimer) {
        var value = self.slider.value
        value += 0.01
        self.slider.value = value
        self.stepper.value = Double(value)
        sliderChanged(self.slider)
        time -= 0.03
    }
    
    func segmentedSwitched(segmented: UISegmentedControl) {
        onSegmentedChange(segmented.selectedSegmentIndex)
    }
    
    func switchToggled() {
        if self.stepper.enabled {
            self.stepper.enabled = false
            self.stepper.alpha = 0.5
            self.slider.enabled = false
        }
        else {
            self.stepper.enabled = true
            self.stepper.alpha = 1
            self.slider.enabled = true
        }
        
        print("Time: \(time)")
        if time < 0.031 {
            isPaused = true
            return
        }
        
        if !isPaused {
            isPaused = true
            self.timer?.invalidate()
        }
        else {
            isPaused = false
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1/30, target: self, selector: "fireTimer:", userInfo: nil, repeats: true)
            self.performSelector("invalidateTimer:", withObject: timer, afterDelay: NSTimeInterval(time))
        }
 
    }
    
    func sliderChanged(slider : UISlider) {
        onSliderChange(CGFloat(slider.value))
        stepper.value = Double(slider.value)
        delegate?.stepperDidChange(stepper, panel: self)
        //delegate?.sliderDidChange(slider, panel: self)
        //self.slider.value = Float(stepper.value)
        
    }
    
    func stepperChanged(stepper: UIStepper) {
        delegate?.stepperDidChange(stepper, panel: self)
        slider.value = Float(stepper.value)
        onSliderChange(CGFloat(slider.value))
       //stepper.value = Double(slider.value)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol PanelViewDelegate {
    
    func sliderDidChange(slider : UISlider, panel:PanelView)
    func stepperDidChange(stepper : UIStepper, panel:PanelView)
    
}
