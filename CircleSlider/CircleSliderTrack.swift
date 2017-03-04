//
//  CircleSliderTrack.swift
//  CircleSlider
//
//  Created by Victor Smirnov on 03/03/2017.
//  Copyright © 2017 Victor Smirnov. All rights reserved.
//

import UIKit

class CircleSliderTrack: CALayer {
  
  var slider: CircleSlider?
  
  var center: CGPoint?
  var trackWidth: CGFloat?
  
  func drawInContext(ctx: CGContext) {
    
    let center = CGPoint(x: self.frame.midX, y: self.frame.midY)
    self.center = center
    self.trackWidth = self.slider?.trackWidth
    var arcWidth: CGFloat = self.trackWidth!
    var arcRadius: CGFloat = CGFloat(Float(self.frame.width) - Float(arcWidth) / 2)
    
    var path = UIBezierPath(arcCenter: center, radius: arcRadius, startAngle: (self.slider?.startAngle)!, endAngle: (self.slider?.endAngle)!, clockwise: (self.slider?.clockWise)!)
    
    
  }

}
