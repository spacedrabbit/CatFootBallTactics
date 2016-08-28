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
    
    let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GridSquare.adjustLabelValue(_:)))
    longPressGesture.minimumPressDuration = 0.45
    longPressGesture.delegate = self
    self.addGestureRecognizer(longPressGesture)
    
    self.layer.borderColor = UIColor.blackColor().CGColor
    self.layer.borderWidth = 2.0
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
    case .Player:
      self.team = .AI
    case .AI:
      self.team = .None
    }
  }
  
  internal func adjustLabelValue(sender: AnyObject) {
    print("long pressing")
  }
  
  // MARK: - Gesture Delegate
  override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    if self.team == .None && gestureRecognizer is UITapGestureRecognizer {
      return true
    }
    
    if self.team != .None && gestureRecognizer is UILongPressGestureRecognizer {
      // I only want to update the label if the team square is assigned
      return true
    }
    return false
  }
  
  internal lazy var skillLevelLabel: UILabel = {
    let label: UILabel = UILabel()
    label.font = UIFont.systemFontOfSize(14.0, weight: UIFontWeightBold)
    label.textColor = UIColor.whiteColor()
    return label
  }()
}
