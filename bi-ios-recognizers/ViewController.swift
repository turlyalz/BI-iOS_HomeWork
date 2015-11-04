//
//  ViewController.swift
//  bi-ios-recognizers
//
//  Created by Dominik Vesely on 03/11/15.
//  Copyright © 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PanelViewDelegate {
    
    weak var graphView : GraphView!
    weak var panelView : PanelView!
    
    override func loadView() {
        self.view = UIView()
        view.backgroundColor = .whiteColor()
        
        let gv = GraphView(frame: CGRectZero)
        gv.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        
        self.view.addSubview(gv)
        self.graphView = gv
        
        let pv = PanelView(frame: CGRectZero)
        pv.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        pv.delegate = self
        
        pv.onSliderChange = {
            self.graphView.amplitude = $0
        }
        
       /* pv.onSliderChange = { [weak self] (value : CGFloat) in
            self?.graphView.amplitude = value
        } */
        
        
        gv.onAmplitudeChanged = { (value) in
            pv.label.text = "Amplitude: " + String(format: "%.2f", value)
        }
        
        pv.onSegmentedChange = { (value) in
            var color: UIColor
            switch (value) {
            case 0:
                color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
                
            case 1:
                color = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
            case 2:
                color = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
            default:
                return
            }
            gv.color = color
            gv.setNeedsDisplay()
        }
        
        view.addSubview(pv)
        self.panelView = pv
        
    }
    
    
    
    
    //MARK: PanelViewDelegate
    func sliderDidChange(slider: UISlider, panel: PanelView) {
        self.graphView.amplitude = CGFloat(slider.value);
        
    }
    
    func stepperDidChange(stepper: UIStepper, panel: PanelView) {
        self.graphView.amplitude = CGFloat(stepper.value);
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.graphView.frame = CGRectMake(8, 20 + 8, CGRectGetWidth(self.view.bounds) - 16, 200);
        self.panelView.frame = CGRectMake(8, 20 + 16 + 200, CGRectGetWidth(self.view.bounds) - 16, 168);
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = UIView(frame: CGRectMake(10, 10, 100, 100))
        v.backgroundColor = .redColor()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "oneTap:")
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTapGesture.numberOfTapsRequired = 2
        

        view.addSubview(v)
        v.addGestureRecognizer(tapGesture)
        v.addGestureRecognizer(doubleTapGesture)
        tapGesture.requireGestureRecognizerToFail(doubleTapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "pan:")
        v.addGestureRecognizer(panGesture)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func pan(reco: UIPanGestureRecognizer) {
        let translation = reco.translationInView(self.view)
        if let view = reco.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        reco.setTranslation(CGPointZero, inView: self.view)
    }

    
    
    //MARK: Recognizers
    func oneTap(reco : UIGestureRecognizer) {
        print("single")
    }
    
    func doubleTap(reco : UIGestureRecognizer) {
        print("double")
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

