//
//  CircleCliderThumb.swift
//  CircleSlider
//
//  Created by Victor Smirnov on 04/03/2017.
//  Copyright © 2017 Victor Smirnov. All rights reserved.
//

import UIKit

class CircleSliderThumb: CALayer {

  var slider: CircleSlider?

  var removeOutline = true
  var removeShadow = true
  var isHighlighted = true

  var _hasImage = false
  var _image: UIImage?

  override func draw(in ctx: CGContext) {

    if !_hasImage {

      let thumbFrame =  self.bounds.insetBy(dx: 2.0, dy: 2.0)
      let path = UIBezierPath(roundedRect: thumbFrame, cornerRadius: thumbFrame.size.width / 2)

      let shadowColor = UIColor.gray
      if !self.removeShadow {
        ctx.setShadow(offset: CGSize.init(width: 0.0, height: 1.0), blur: 1.0, color: shadowColor.cgColor)
      }

      ctx.setStrokeColor(self.slider!.thumbTintColor!.cgColor)
      ctx.addPath(path.cgPath)
      ctx.fillPath()

      if !self.removeOutline {
        ctx.setStrokeColor(shadowColor.cgColor)
        ctx.setLineWidth(0.5)
        ctx.addPath(path.cgPath)
        ctx.strokePath()
      }

      if (self.isHighlighted) {
        ctx.setFillColor(self.slider!.thumbHighlightedTintColor!.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
      }

    } else {
      ctx.draw(_image!.cgImage!, in: self.bounds)
    }

  }

  func setImage(image: UIImage) {

    _hasImage = true
    _image = image
    self.setNeedsDisplay()

  }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
