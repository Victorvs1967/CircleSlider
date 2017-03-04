//
//  CircleSlider.swift
//  CircleSlider
//
//  Created by Victor Smirnov on 04/03/2017.
//  Copyright © 2017 Victor Smirnov. All rights reserved.
//

import UIKit

@IBDesignable class CircleSlider: UIControl {
  
  @IBInspectable var value: CGFloat?
  @IBInspectable var minimumValue: CGFloat?
  @IBInspectable var maximumValue: CGFloat?
  
  var radian: CGFloat?
  
  @IBInspectable var startAngle: CGFloat?
  @IBInspectable var endAngle: CGFloat?
  @IBInspectable var clockWise: Bool?
  @IBInspectable var isCapRound: Bool?
  
  @IBInspectable var thumbTintColor: UIColor?
  @IBInspectable var thumbHighlightedTintColor: UIColor?
  @IBInspectable var trackTintColor: UIColor?
  @IBInspectable var trackHighlightedTintColor: UIColor?
  
  @IBInspectable var trackWidth: CGFloat?
  @IBInspectable var thumbWidth: CGFloat?
  
  var trackHighlightedGradientFirstColor: UIColor?
  var trackHighlightedGradientSecondColor: UIColor?
  var trackHighlightedGradientColorsLocation: CGPoint?
  var isTrackHighlightedGradient: Bool?
  var gradientStartPoint: CGPoint?
  var gradientEndPoint: CGPoint?
  
  var track: CircleSliderTrack?
  var thumb: CircleCliderThumb?
  
  
  
  

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
