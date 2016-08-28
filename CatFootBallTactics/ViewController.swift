//
//  ViewController.swift
//  CatFootBallTactics
//
//  Created by Louis Tur on 8/28/16.
//  Copyright © 2016 catthoughts. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  static internal let HorizontalSpaces: Int = 7
  static internal let VerticalSpaces: Int = 10
  
  internal var fieldGrid: FieldGrid!
  internal var gridSideLength: CGFloat = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.whiteColor()
    
    self.gridSideLength = floor(min(self.view.frame.size.width / CGFloat(ViewController.HorizontalSpaces),
      self.view.frame.size.height / CGFloat(ViewController.VerticalSpaces)))
    
    self.fieldGrid = FieldGrid(gridsWithSize: CGVector(dx: ViewController.HorizontalSpaces, dy: ViewController.VerticalSpaces), gridLength: self.gridSideLength)
    self.view.addSubview(self.fieldGrid)
    
    self.fieldGrid.snp_makeConstraints { (make) in
      make.centerY.equalTo(self.view)
      make.left.equalTo(self.view)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}