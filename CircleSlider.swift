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

  var radian: CGFloat = 0.0

  @IBInspectable var startAngle: CGFloat?
  @IBInspectable var endAngle: CGFloat?
  @IBInspectable var clockWise: Bool = true
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

  var _track: CircleSliderTrack?
  var _thumb: CircleSliderThumb?

  var _center = CGPoint(x: 0.0, y: 0.0)
  var _lastTouch = UITouch()
  var _rad: CGFloat = 0.0
  var _isInitiallySet: Bool?

  override init(frame: CGRect) {
    
    super.init(frame: frame)

    if self.isEnabled {
      self.initializeComponent()
    }

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func updateLayer() {

    CATransaction.begin()
    CATransaction.disableActions()

    _track?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    _track?.setNeedsDisplay()

    var point = self.mapRadianToPoint(radian: self.radian)

    if !_isInitiallySet! {

      point = self.mapRadianToPoint(radian: self.radianForValue(value: self.value!))
      _isInitiallySet = true
      self.radian = self.radianForValue(value: self.value!)

    }

    _thumb?.frame = CGRect(x: point.x - self.thumbWidth! / 2, y: point.y - self.thumbWidth! / 2, width: self.thumbWidth!, height: self.thumbWidth!)
    _thumb?.setNeedsDisplay()

    CATransaction.commit()

  }

  func initializeComponent() {

    self.minimumValue = 50.0
    self.maximumValue = 100.0
    self.value = 75.0

    self.startAngle = 0
    self.endAngle = CGFloat(M_PI)
    self.clockWise = true

    self.thumbTintColor = UIColor.blue
    self.thumbHighlightedTintColor = UIColor.black
    self.trackTintColor = UIColor.lightGray
    self.trackHighlightedTintColor = UIColor.blue

    self.trackWidth = 10.0
    self.thumbWidth = 20.0
    self.isCapRound = true

    _track = CircleSliderTrack(layer: layer)
    _thumb = CircleSliderThumb(layer: layer)

    _track?.contentsScale = UIScreen.main.scale
    _thumb?.contentsScale = UIScreen.main.scale

    _track?.slider = self
    _thumb?.slider = self

    self.layer.addSublayer(_track!)
    self.layer.addSublayer(_thumb!)

    _isInitiallySet = false
    self.updateLayer()

  }

  func radianForValue(value: CGFloat) -> CGFloat {

    let val = ((value - self.minimumValue!) / (self.maximumValue! - self.minimumValue!)) * self.distance()

    return self.clockWise ? val + self.startAngle! : -val + self.startAngle!
  }

  func valueForRadian(radian: CGFloat) -> CGFloat {

    let a = radian - ((2.0 * CGFloat(M_PI) - self.distance()) / 2.0)
    let b = self.maximumValue! - self.minimumValue!

    return a * b / self.distance() + self.minimumValue!

  }

  func mapRadianToPoint(radian: CGFloat) -> CGPoint {

    return CGPoint(x: (_center.x - self.trackWidth! / 2) * cos(radian) + _center.x, y: (_center.y - self.trackWidth! / 2) * sin(radian) + _center.y)
  }

  func distance() -> CGFloat {

    if self.startAngle!.isLess(than: self.endAngle!) {
      if self.clockWise {
        return self.endAngle! - self.startAngle!
      } else {
        return 2.0 * CGFloat(M_PI) - (self.endAngle! - self.startAngle!)
      }
    } else {
      if self.clockWise {
        return 2.0 * CGFloat(M_PI) - (self.startAngle! - self.endAngle!)
      } else {
        return self.startAngle! - self.endAngle!
      }
    }
  }

  func radianForPoint(point: CGPoint) -> CGFloat {
    var val: CGFloat = 0
    let x1 = point.x, x0 = _center.x, y1 = point.y, y0 = _center.y

    if x0.isLess(than: x1) && y0.isLess(than: y1) {
      val = atan((y1 - y0) / (x1 / x0))
    } else if x1.isLess(than: x0) && y0.isLess(than: y1) {
      val = atan((x0 - x1) / (y1 - y0)) + CGFloat(M_PI) / 2
    } else if x1.isLess(than: x0) && y1.isLess(than: y0) {
      val = atan((y0 - y1) / (x0 - x1)) + CGFloat(M_PI)
    } else if x0.isLess(than: x1) && y1.isLess(than: y0) {
      val = atan((x1 - x0) / (y0 - y1)) + 3 * CGFloat(M_PI) / 2
    }

    if x1.isEqual(to: x0) {
      if y0.isLess(than: y1) {
        val = CGFloat(M_PI) / 2
      } else {
        val = 3 * CGFloat(M_PI) / 2
      }
    } else if y1.isEqual(to: y0) {
      if x1.isLess(than: x0) {
        val = CGFloat(M_PI)
      }
    }

    return val
  }

  func transformRadianForCurrentOptions(rad: CGFloat, forStartAngle startAngle: CGFloat) -> CGFloat {

    var val: CGFloat = 0.0

    if self.clockWise {
      if startAngle.isLess(than: rad) {
        val = rad - startAngle
      } else if rad.isLess(than: startAngle) {
        val = 2 * CGFloat(M_PI) - startAngle + rad
      }
    } else {
      if startAngle.isLess(than: rad) {
        val = 2 * CGFloat(M_PI) - rad + startAngle
      } else if rad.isLess(than: startAngle) {
        val = startAngle - rad
      }
    }

    return val

  }

  func reverseTransformForModifideStartAngleToDefault(rad: CGFloat) -> CGFloat {
    var val: CGFloat = 0.0
    let startAngle = self.transformedStartAngle()

    if self.clockWise {
      if startAngle.isLess(than: rad) {
        val = rad + startAngle
      } else if rad.isLess(than: startAngle) || rad.isEqual(to: startAngle) {
        val = -2 * CGFloat(M_PI) + startAngle + rad
      }
    } else {
      if startAngle.isLess(than: rad) {
        val = 2 * CGFloat(M_PI) - rad + startAngle
      } else if rad.isLess(than: startAngle) {
        val = startAngle - rad
      }
    }

    return val
  }

  func transformedStartAngle() -> CGFloat {
    let sA = self.startAngle!
    let offset = (2 * CGFloat(M_PI) - self.distance()) / 2

    if self.endAngle!.isLess(than: sA) {
      if self.clockWise {
        return sA - offset
      } else {
        var v = sA + offset
        if (2 * CGFloat(M_PI)).isLess(than: v) {
          v -= 2 * CGFloat(M_PI)
        }
        return v
      }
    } else {
        if self.clockWise {
          var v  = self.endAngle! + offset
          if (2 * CGFloat(M_PI)).isLess(than: v) {
            v -= 2 * CGFloat(M_PI)
        }
        return v
        } else {
          return sA + offset
        }
    }
  }

  func reverceTransformRadian(val: CGFloat) -> CGFloat {
    var rad: CGFloat = 0.0

    if self.clockWise {
      if self.startAngle!.isLess(than: val) {
        rad = val + self.startAngle!
      } else if val.isLess(than: self.startAngle!) {
        rad = val - 2 * CGFloat(M_PI) + self.startAngle!
      }
    } else {
      if self.startAngle!.isLess(than: val) {
        rad = 2 * CGFloat(M_PI) - val + self.startAngle!
      } else if val.isLess(than: self.startAngle!) {
        rad = self.startAngle! - val
      }
    }

    return rad

  }

  func boundValueForValue(value: CGFloat) -> CGFloat {
    return min(value, self.maximumValue!)
  }

  func boundRadianForRadian(radian: CGFloat) -> CGFloat {
    let d = self.distance()
    let tSa = (2 * CGFloat(M_PI) - d) / 2

    return max(min(tSa + d, radian), tSa)
  }

  func setGradientColorForHighlightedTrackWithFirstColor(firstColor: UIColor, secondColor: UIColor, colorLocations: CGPoint, startPoint: CGPoint,  endPoing: CGPoint) {

    trackHighlightedGradientFirstColor = firstColor
    trackHighlightedGradientSecondColor = secondColor
    trackHighlightedGradientColorsLocation = colorLocations
    isTrackHighlightedGradient = true
    gradientEndPoint = endPoing
    gradientStartPoint = startPoint
    _track?.needsDisplay()

  }

  func removeGradient() {
    isTrackHighlightedGradient = false
    _track?.setNeedsDisplay()
  }

  func setTumbImage(thumbImage: UIImage) {
    _thumb?.setImage(image: thumbImage)
  }

  //#pragma mark - Setters

  func setStartAngle(startAngle: CGFloat) {
    if (2 * CGFloat(M_PI)).isLess(than: startAngle) || startAngle.isLess(than: 0.0) {
      let exception = NSException(name: NSExceptionName(rawValue: "Invalid value of startAngle"), reason: "startAngle must be more then 0 and less then 2PI", userInfo: nil)
      exception.raise()
    }
    self.startAngle = startAngle
    self.calculateForTouch(touch: _lastTouch)
    self.updateLayer()
  }

  func setEndAngle(endAngle: CGFloat) {
    if (2 * CGFloat(M_PI)).isLess(than: endAngle) || endAngle.isLess(than: 0.0) {
      let exception = NSException(name: NSExceptionName(rawValue: "Invalid value of endAngle"), reason: "endAngle must be more then 0 and less 2PI", userInfo: nil)
      exception.raise()
    }
    self.endAngle = endAngle
    self.calculateForTouch(touch: _lastTouch)
    self.updateLayer()
  }

  func setValue(value: CGFloat) {
    var v = value
    if self.maximumValue!.isLess(than: v) || v.isLess(than: self.minimumValue!) {
      v = self.minimumValue!
    }
    self.value = v
    self.updateLayer()
  }

  func setClockWise(clockWise: Bool) {
    self.clockWise = clockWise
    self.updateLayer()
  }

  func setIsCapRound(isCapRound: Bool) {
    self.isCapRound = isCapRound
    self.updateLayer()
  }

  func setMinimumValue(minimumValue: CGFloat) {
    self.minimumValue = minimumValue
    self.updateLayer()
  }

  func setMaximumValue(maximumValue: CGFloat) {
    self.maximumValue = maximumValue
    self.updateLayer()
  }

  func setThumbWidth(tumbWidth: CGFloat) {
    self.thumbWidth! = tumbWidth
    self.updateLayer()
  }

  func setTrackWidth(trackWidth: CGFloat) {
    self.trackWidth! = trackWidth
    self.updateLayer()
  }

  func setTumbTintColor(tumbTintColor: UIColor) {
    self.thumbTintColor! = tumbTintColor
    self.updateLayer()
  }

  func setThumbHighlitingTintColor(thumbHighlightedTintColor: UIColor) {
    self.thumbHighlightedTintColor = thumbHighlightedTintColor
    self.updateLayer()
  }

  func setTrackTintColor(trackTintColor: UIColor) {
    self.trackTintColor = trackTintColor
    self.updateLayer()
  }

  func setTrackHighlightedTintColor(trackHighlightedTintColor: UIColor) {
    self.trackHighlightedTintColor! = trackHighlightedTintColor
    self.updateLayer()
  }

  func setFrame(frame: CGRect) {
    super.frame = frame
    _center = CGPoint(x: frame.width / 2, y: frame.height / 2)
    _isInitiallySet = false
    self.updateLayer()
  }

  //#pragma mark - Tracking

  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    if self._thumb!.frame.contains(touch.location(in: self)) {
      self._thumb!.isHighlighted = true
      return true
    }
    return false
  }

  override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    self.calculateForTouch(touch: touch)
    _lastTouch = touch
    self.updateLayer()

    self.sendActions(for: UIControlEvents.valueChanged)

    return true
  }

  func calculateForTouch(touch: UITouch) {
    let prePad = self.radianForPoint(point: touch.location(in: self))
    let transN = self.transformRadianForCurrentOptions(rad: prePad, forStartAngle: self.transformedStartAngle())
    let boundRadianTN = self.boundRadianForRadian(radian: transN)
    let reversedBoundValue = self.reverseTransformForModifideStartAngleToDefault(rad: boundRadianTN)

    self.radian = reversedBoundValue

    self.value = self.boundValueForValue(value: self.valueForRadian(radian: transN))
  }

  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    _thumb!.isHighlighted = false
    _thumb!.setNeedsDisplay()
  }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
