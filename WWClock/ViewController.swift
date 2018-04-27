//
//  ViewController.swift
//  WWClock
//
//  Created by Vince Edgar Noel on 26/04/2018.
//  Copyright © 2018 binsnoel. All rights reserved.
//

import UIKit

@objc public final class WWCalendarTimeSelectorStyle: NSObject {
  fileprivate(set) public var showDateMonth: Bool = true
  fileprivate(set) public var showMonth: Bool = false
  fileprivate(set) public var showYear: Bool = true
  fileprivate(set) public var showTime: Bool = true
  fileprivate var isSingular = false
  
  public func showDateMonth(_ show: Bool) {
    showDateMonth = show
    showMonth = show ? false : showMonth
    if show && isSingular {
      showMonth = false
      showYear = false
      showTime = false
    }
  }
  
  public func showMonth(_ show: Bool) {
    showMonth = show
    showDateMonth = show ? false : showDateMonth
    if show && isSingular {
      showDateMonth = false
      showYear = false
      showTime = false
    }
  }
  
  public func showYear(_ show: Bool) {
    showYear = show
    if show && isSingular {
      showDateMonth = false
      showMonth = false
      showTime = false
    }
  }
  
  public func showTime(_ show: Bool) {
    showTime = show
    if show && isSingular {
      showDateMonth = false
      showMonth = false
      showYear = false
    }
  }
  
  fileprivate func countComponents() -> Int {
    return (showDateMonth ? 1 : 0) +
      (showMonth ? 1 : 0) +
      (showYear ? 1 : 0) +
      (showTime ? 1 : 0)
  }
  
  fileprivate convenience init(isSingular: Bool) {
    self.init()
    self.isSingular = isSingular
    showDateMonth = false
    showMonth = false
    showYear = false
    showTime = true
  }
}

class ViewController: UIViewController, WWClockProtocol {
  @IBOutlet weak var selTimeView: UIView!
  @IBOutlet weak var clockView: WWClock!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var amButton: UIButton!
  @IBOutlet weak var pmButton: UIButton!
  
  fileprivate var selTimeStateHour = true
  fileprivate let selAnimationDuration: TimeInterval = 0.4
  fileprivate var selCurrrent: WWCalendarTimeSelectorStyle = WWCalendarTimeSelectorStyle(isSingular: true)
  fileprivate var isFirstLoad = false
  
  open var optionSelectorPanelScaleTime: CGFloat = 2.75
  open var optionClockFontAMPM = UIFont.systemFont(ofSize: 18)
  open var optionClockFontAMPMHighlight = UIFont.systemFont(ofSize: 20)
  open var optionClockFontColorAMPM = UIColor.darkGray
  open var optionClockFontColorAMPMHighlight = UIColor.darkGray
  open var optionClockBackgroundColorAMPMHighlight = UIColor.groupTableViewBackground
  open var optionClockFontHour = UIFont.systemFont(ofSize: 16)
  open var optionClockFontHourHighlight = UIFont.systemFont(ofSize: 18)
  open var optionClockFontColorHour = UIColor.black
  open var optionClockFontColorHourHighlight = UIColor.white
  open var optionClockBackgroundColorHourHighlight = UIColor.lightGray
  open var optionClockBackgroundColorHourHighlightNeedle = UIColor.lightGray
  open var optionClockFontMinute = UIFont.systemFont(ofSize: 12)
  open var optionClockFontMinuteHighlight = UIFont.systemFont(ofSize: 14)
  open var optionClockFontColorMinute = UIColor.black
  open var optionClockFontColorMinuteHighlight = UIColor.white
  open var optionClockBackgroundColorMinuteHighlight = UIColor.lightGray
  open var optionClockBackgroundColorMinuteHighlightNeedle = UIColor.lightGray
  open var optionClockBackgroundColorFace = UIColor(white: 0.9, alpha: 1)
  open var optionClockBackgroundColorCenter = UIColor.darkGray
  open var optionTimeStep: WWCalendarTimeSelectorTimeStep = .oneMinute
  open var optionCurrentDate = Date().minute < 30 ? Date().beginningOfHour : Date().beginningOfHour + 1.hour
  open var optionSelectorPanelFontMonth = UIFont.systemFont(ofSize: 16)
  open var optionSelectorPanelFontDate = UIFont.systemFont(ofSize: 16)
  open var optionSelectorPanelFontYear = UIFont.systemFont(ofSize: 16)
  open var optionSelectorPanelFontTime = UIFont.boldSystemFont(ofSize: 35)
  open var optionSelectorPanelFontMultipleSelection = UIFont.systemFont(ofSize: 16)
  open var optionSelectorPanelFontMultipleSelectionHighlight = UIFont.systemFont(ofSize: 17)
  open var optionSelectorPanelFontColorMonth = UIColor(white: 1, alpha: 0.5)
  open var optionSelectorPanelFontColorMonthHighlight = UIColor.white
  open var optionSelectorPanelFontColorDate = UIColor(white: 1, alpha: 0.5)
  open var optionSelectorPanelFontColorDateHighlight = UIColor.white
  open var optionSelectorPanelFontColorYear = UIColor(white: 1, alpha: 0.5)
  open var optionSelectorPanelFontColorYearHighlight = UIColor.white
  open var optionSelectorPanelFontColorTime = UIColor.darkGray
  open var optionSelectorPanelFontColorTimeHighlight = UIColor.darkGray
  open var optionSelectorPanelFontColorMultipleSelection = UIColor.white
  open var optionSelectorPanelFontColorMultipleSelectionHighlight = UIColor.white
  open var optionSelectorPanelBackgroundColor = UIColor.brown.withAlphaComponent(0.9)
  

  open override func viewDidLoad() {
    super.viewDidLoad()
    
    view.layoutIfNeeded()
    
    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    //NotificationCenter.default.addObserver(self, selector: #selector(WWCalendarTimeSelector.didRotateOrNot), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    
    clockView.delegate = self
    clockView.minuteStep = optionTimeStep
    clockView.backgroundColorClockFace = optionClockBackgroundColorFace
    clockView.backgroundColorClockFaceCenter = optionClockBackgroundColorCenter
    clockView.fontAMPM = optionClockFontAMPM
    clockView.fontAMPMHighlight = optionClockFontAMPMHighlight
    clockView.fontColorAMPM = optionClockFontColorAMPM
    clockView.fontColorAMPMHighlight = optionClockFontColorAMPMHighlight
    clockView.backgroundColorAMPMHighlight = optionClockBackgroundColorAMPMHighlight
    clockView.fontHour = optionClockFontHour
    clockView.fontHourHighlight = optionClockFontHourHighlight
    clockView.fontColorHour = optionClockFontColorHour
    clockView.fontColorHourHighlight = optionClockFontColorHourHighlight
    clockView.backgroundColorHourHighlight = optionClockBackgroundColorHourHighlight
    clockView.backgroundColorHourHighlightNeedle = optionClockBackgroundColorHourHighlightNeedle
    clockView.fontMinute = optionClockFontMinute
    clockView.fontMinuteHighlight = optionClockFontMinuteHighlight
    clockView.fontColorMinute = optionClockFontColorMinute
    clockView.fontColorMinuteHighlight = optionClockFontColorMinuteHighlight
    clockView.backgroundColorMinuteHighlight = optionClockBackgroundColorMinuteHighlight
    clockView.backgroundColorMinuteHighlightNeedle = optionClockBackgroundColorMinuteHighlightNeedle
    
    updateDate()
    
    isFirstLoad = true
  }
  
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if isFirstLoad {
      isFirstLoad = false // Temp fix for i6s+ bug?
      clockView.setNeedsDisplay()
      //self.didRotateOrNot(animated: false)
      showTime(true, animated: false)
      WWClockSwitchAMPM(isAM: true, isPM: false)
    }
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    isFirstLoad = false
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBAction func amClicked(_ sender: Any) {
    WWClockSwitchAMPM(isAM: true, isPM: false)
  }
  @IBAction func pmClicked(_ sender: Any) {
    WWClockSwitchAMPM(isAM: false, isPM: true)
  }
  @IBAction func showTimeClicked(_ sender: Any) {
    showTime(true)
  }
  
  func showTime(_ userTap: Bool, animated: Bool = true) {
    if userTap {
      if selCurrrent.showTime {
        selTimeStateHour = !selTimeStateHour
      }
      else {
        selTimeStateHour = true
      }
    }
    
    if optionTimeStep == .sixtyMinutes {
      selTimeStateHour = true
    }
    
    changeSelTime(animated: animated)
    
    if userTap {
      clockView.showingHour = selTimeStateHour
    }
    clockView.setNeedsDisplay()
    
    if animated {
      UIView.transition(
        with: clockView,
        duration: selAnimationDuration / 2,
        options: [UIViewAnimationOptions.transitionCrossDissolve],
        animations: {
          self.clockView.layer.displayIfNeeded()
      },
        completion: nil
      )
    } else {
      self.clockView.layer.displayIfNeeded()
    }
    
    let animations = {
      self.clockView.alpha = 1
    }
    if animated {
      UIView.animate(
        withDuration: selAnimationDuration,
        delay: 0,
        options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.curveEaseOut],
        animations: animations,
        completion: nil
      )
    } else {
      animations()
    }
  }
  
  fileprivate func changeSelTime(animated: Bool = true) {
    
    
    //timeLabel.contentScaleFactor = UIScreen.main.scale * optionSelectorPanelScaleTime
    let animations = {
      //self.timeLabel.transform = CGAffineTransform.identity.scaledBy(x: self.optionSelectorPanelScaleTime, y: self.optionSelectorPanelScaleTime)
      self.view.layoutIfNeeded()
    }
    let completion = { (_: Bool) in
      if self.selCurrrent.showTime {
      }
    }
    if animated {
      UIView.animate(
        withDuration: selAnimationDuration,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.allowUserInteraction],
        animations: animations,
        completion: completion
      )
    } else {
      animations()
      completion(true)
    }
    selCurrrent.showTime(true)
    updateDate()
  }
  internal func WWClockGetTime() -> Date {
    return optionCurrentDate
  }
  
  internal func WWClockSwitchAMPM(isAM: Bool, isPM: Bool) {
    var newHour = optionCurrentDate.hour
    if isAM && newHour >= 12 {
      newHour = newHour - 12
    }
    if isPM && newHour < 12 {
      newHour = newHour + 12
    }
    
    optionCurrentDate = optionCurrentDate.change(hour: newHour)
    updateDate()
    //
    if isAM {
      amButton.backgroundColor = optionClockBackgroundColorAMPMHighlight
      pmButton.backgroundColor = UIColor.clear
    } else {
      amButton.backgroundColor = UIColor.clear
      pmButton.backgroundColor = optionClockBackgroundColorAMPMHighlight
    }
    //
    clockView.setNeedsDisplay()
    UIView.transition(
      with: clockView,
      duration: selAnimationDuration / 2,
      options: [UIViewAnimationOptions.transitionCrossDissolve, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState],
      animations: {
        self.clockView.layer.displayIfNeeded()
    },
      completion: nil
    )
  }
  
  //WWClock delegates
  internal func WWClockSetHourMilitary(_ hour: Int) {
    optionCurrentDate = optionCurrentDate.change(hour: hour)
    updateDate()
    clockView.setNeedsDisplay()
  }
  
  internal func WWClockSetMinute(_ minute: Int) {
    optionCurrentDate = optionCurrentDate.change(minute: minute)
    updateDate()
    clockView.setNeedsDisplay()
  }
  
  fileprivate func updateDate() {
    
    let timeText = optionCurrentDate.stringFromFormat("h':'mm").lowercased()
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = NSTextAlignment.center
    let attrText = NSMutableAttributedString(string: timeText, attributes: [NSFontAttributeName: optionSelectorPanelFontTime, NSForegroundColorAttributeName: optionSelectorPanelFontColorTime, NSParagraphStyleAttributeName: paragraph])
    
    if selCurrrent.showTime {
      
      let colonIndex = timeText.characters.distance(from: timeText.startIndex, to: timeText.range(of: ":")!.lowerBound)
      let hourRange = NSRange(location: 0, length: colonIndex)
      let minuteRange = NSRange(location: colonIndex + 1, length: 2)
      
      if selTimeStateHour {
        attrText.addAttributes([NSForegroundColorAttributeName: optionSelectorPanelFontColorTimeHighlight], range: hourRange)
      }
      else {
        attrText.addAttributes([NSForegroundColorAttributeName: optionSelectorPanelFontColorTimeHighlight], range: minuteRange)
      }
    }
    timeLabel.attributedText = attrText
    print(timeLabel)
  }
}

