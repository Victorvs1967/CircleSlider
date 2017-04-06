//
//  ViewController.swift
//  CircleSlider
//
//  Created by Victor Smirnov on 03/03/2017.
//  Copyright © 2017 Victor Smirnov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var slider: CircleSlider!
  var lable: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let slider = CircleSlider(frame: CGRect.zero)
    self.view.addSubview(slider)
    
    slider.trackHighlightedTintColor = UIColor(colorLiteralRed: 0.0, green: 122.0 / 255.0, blue: 1.0, alpha: 1.0)
    slider.thumbTintColor = UIColor.white
    slider.trackTintColor = UIColor.lightGray
    slider.thumbHighlightedTintColor = UIColor.white
    slider.trackWidth = 25.0
    slider.thumbWidth = 25.0
    
    slider.minimumValue = 0.0
    slider.startAngle = CGFloat(M_PI / 2)
    slider.endAngle = CGFloat(3 * M_PI / 4)
    slider.clockWise = true
    
    let start = CGPoint(x: 200, y: 100)
    let end = CGPoint(x: 0, y: 100)
    
    slider.setGradientColorForHighlightedTrackWithFirstColor(firstColor: .orange, secondColor: .blue, colorLocations: CGPoint(x: 0.3, y: 0.9), startPoint: start, endPoing: end)
    
    let lable = UILabel()
    lable.frame(forAlignmentRect: CGRect(x: 100, y: 175, width: 200, height: 50))
    lable.textAlignment = .center
    lable.backgroundColor = UIColor.clear
    lable.textColor = UIColor.black
    lable.font = UIFont.systemFont(ofSize: 26.0)
    self.view.addSubview(lable)
    
    self.lable = lable
    self.lable!.text = String(format: "%.2f", slider.value!)

    slider.addTarget(self, action: #selector(handleValue), for: UIControlEvents.valueChanged)
    
    self.slider = slider
    
  }
  
  @IBAction func trackW(sender: UISlider) {
    slider!.setTrackWidth(trackWidth: CGFloat(sender.value))
  }
  
  @IBAction func switch1(sender: UISwitch) {
    self.slider!.setClockWise(clockWise: sender.isOn)
  }
  
  @IBAction func thumbWidth(sender: UISlider) {
    self.slider!.setThumbWidth(tumbWidth: CGFloat(sender.value))
  }
  
  @IBAction func topChanged(sender: UISlider) {
    self.slider!.setEndAngle(endAngle: CGFloat(sender.value))
  }
  
  @IBAction func botChanged(sender: UISlider) {
    self.slider!.setStartAngle(startAngle: CGFloat(sender.value))
  }
  
  func handleValue(slider: CircleSlider) {
    self.lable!.text = String(format: "%.2f", slider.value!)
  }
  
  override func viewDidLayoutSubviews() {
    self.slider.setFrame(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
    self.lable.frame = CGRect(x: self.slider.frame.midX - 50, y: self.slider.frame.midY - 50, width: 100, height: 100)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

