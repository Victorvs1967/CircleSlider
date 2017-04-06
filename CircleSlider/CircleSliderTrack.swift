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
  
  var _center: CGPoint?
  var _trackWidth: CGFloat?
    
  override func draw(in ctx: CGContext) {
    
    let center = CGPoint(x: self.frame.midX, y: self.frame.midY)
    _center = center
    _trackWidth = self.slider?.trackWidth
    let arcWidth: CGFloat = _trackWidth!
    let arcRadius = (self.frame.width - arcWidth) / 2
    
    let path = UIBezierPath(arcCenter: center, radius: arcRadius, startAngle: self.slider!.startAngle!, endAngle: self.slider!.endAngle!, clockwise: self.slider!.clockWise)
    
    ctx.setStrokeColor(self.slider!.trackTintColor!.cgColor)
    ctx.setLineWidth(arcWidth)
    
    if slider!.isCapRound! {
      ctx.setLineCap(.round)
    }
    
    ctx.addPath(path.cgPath)
    ctx.strokePath()
    
    if self.slider!.isTrackHighlightedGradient! {
      
      ctx.saveGState()
      ctx.beginPath()
      
      let rad = self.slider?.radian
      let sA = self.slider?.startAngle
      
      let hPath = UIBezierPath(arcCenter: center, radius: arcRadius + arcWidth / 2, startAngle: rad!, endAngle: sA!, clockwise: !self.slider!.clockWise)
      
      hPath.addArc(withCenter: self.mapRadianToPoint(radian: self.slider!.startAngle!), radius: arcWidth / 2, startAngle: self.slider!.startAngle!, endAngle: CGFloat(M_PI) + self.slider!.startAngle!, clockwise: !self.slider!.clockWise)
      hPath.addArc(withCenter: center, radius: arcRadius - arcWidth / 2, startAngle: sA!, endAngle: rad!, clockwise: self.slider!.clockWise)
      hPath.addArc(withCenter: self.mapRadianToPoint(radian: self.slider!.radian), radius: arcWidth / 2, startAngle: self.slider!.radian, endAngle: CGFloat(M_PI) - self.slider!.radian, clockwise: self.slider!.clockWise)
      hPath.close()
      
      ctx.addPath(hPath.cgPath)
      ctx.clip()
      
      let color = [self.slider?.trackHighlightedGradientFirstColor?.cgColor, self.slider?.trackHighlightedGradientSecondColor?.cgColor]
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      let colorLocations = [self.slider!.trackHighlightedGradientColorsLocation!.x, self.slider!.trackHighlightedGradientColorsLocation!.y]
      let gradient = CGGradient(colorsSpace: colorSpace, colors: color as CFArray, locations: colorLocations)
      
      ctx.drawLinearGradient(gradient!, start: self.slider!.gradientStartPoint!, end: self.slider!.gradientEndPoint!, options: CGGradientDrawingOptions(rawValue: 0))
      ctx.restoreGState()
      
    } else {
      
      let hPath = UIBezierPath(arcCenter: center, radius: arcRadius, startAngle: self.slider!.startAngle!, endAngle: self.slider!.radian, clockwise: self.slider!.clockWise)
      
      ctx.setStrokeColor(self.slider!.trackHighlightedTintColor!.cgColor)
      ctx.setLineWidth(arcWidth)
      ctx.addPath(hPath.cgPath)
      ctx.strokePath()
      
    }
  }
  
  func mapRadianToPoint(radian: CGFloat) -> CGPoint {
    
    return CGPoint(x: (_center!.x - _trackWidth! / 2) * cos(radian) + _center!.x, y: (_center!.y - _trackWidth! / 2) * sin(radian) + _center!.y)
    
  }

}
