//
//  GridSquare.swift
//  CatFootBallTactics
//
//  Created by Louis Tur on 8/28/16.
//  Copyright © 2016 catthoughts. All rights reserved.
//

import UIKit

internal enum Team {
  case Player, AI, None
}

class GridSquare: UIView, UIGestureRecognizerDelegate {
  static internal let PlayerTeamColor: UIColor = UIColor.blueColor()
  static internal let AITeamColor: UIColor = UIColor.redColor()
  static internal let NoTeamColor: UIColor = UIColor.clearColor()
  
  internal var currentlyLongPressing: Bool = false
  internal var gridSkillValue: Int = 0
  internal var gridPosition: CGVector!
  internal var team: Team = .None {
    willSet {
      switch newValue {
      case .Player:
        self.backgroundColor = GridSquare.PlayerTeamColor
      case .AI:
        self.backgroundColor = GridSquare.AITeamColor
      case .None:
        self.backgroundColor = GridSquare.NoTeamColor
      }
    }
  }
  
  convenience init(withGridPosition pos: CGVector) {
    self.init(frame: CGRectZero)
    self.gridPosition = pos
    
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GridSquare.changeTeam(_:)))
    tapGesture.numberOfTapsRequired = 1
    self.addGestureRecognizer(tapGesture)
    
    let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GridSquare.toggleLongPress(_:)))
    longPressGesture.minimumPressDuration = 0.25
    longPressGesture.delegate = self
    self.addGestureRecognizer(longPressGesture)
    
    let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GridSquare.adjustLabelValue(_:)))
    self.addGestureRecognizer(panGesture)
    
    self.layer.borderColor = UIColor.blackColor().CGColor
    self.layer.borderWidth = 2.0
    self.skillLevelLabel.text = "\(self.gridSkillValue)"
    self.addSubview(self.skillLevelLabel)
    self.skillLevelLabel.snp_makeConstraints { (make) in
      make.center.equalTo(self)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  internal func changeTeam(sender: AnyObject?) {
    switch self.team {
    case .None:
      self.team = .Player
      self.skillLevelLabel.hidden = false
    case .Player:
      self.team = .AI
      self.skillLevelLabel.hidden = false
    case .AI:
      self.team = .None
      self.skillLevelLabel.hidden = true
    }
  }
  
  internal func adjustLabelValue(sender: AnyObject?) {
    if self.currentlyLongPressing {
      if let panSender: UIPanGestureRecognizer = sender as? UIPanGestureRecognizer {
        let translation = panSender.translationInView(self)
        let currentVelocity = panSender.velocityInView(self)
        
        var movingLeft: Bool = false
        if currentVelocity.x <= 0 {
          movingLeft = true
        } else {
          movingLeft = false
        }
        
        let logVelocity = log(abs(currentVelocity.x))
        print("current velocity: \(currentVelocity)")
        print("current logarithmic velocity: \(logVelocity)")
        
        
        if movingLeft && self.gridSkillValue > 0 {
          self.gridSkillValue -= Int(floor(logVelocity))
        }
        else {
          self.gridSkillValue += Int(floor(logVelocity))
        }
        
        self.skillLevelLabel.text = "\(self.gridSkillValue)"
      }
    }
  }
  
  internal func toggleLongPress(sender: AnyObject?) {
    self.currentlyLongPressing = !self.currentlyLongPressing
  }
  
  // MARK: - Gesture Delegate
  override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer is UITapGestureRecognizer {
      return true
    }
    
    if self.team != .None && (gestureRecognizer is UILongPressGestureRecognizer || gestureRecognizer is UIPanGestureRecognizer){
      // I only want to update the label if the team square is assigned
      return true
    }
    return false
  }
  
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer is UILongPressGestureRecognizer && otherGestureRecognizer is UIPanGestureRecognizer {
      return true
    }
    return false
  }
  
  // MARK: - Lazy Inits
  internal lazy var skillLevelLabel: UILabel = {
    let label: UILabel = UILabel()
    label.font = UIFont.systemFontOfSize(14.0, weight: UIFontWeightBold)
    label.textColor = UIColor.whiteColor()
    label.hidden = true
    return label
  }()
}
