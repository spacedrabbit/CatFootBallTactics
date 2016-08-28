//
//  FieldGrid.swift
//  CatFootBallTactics
//
//  Created by Louis Tur on 8/28/16.
//  Copyright © 2016 catthoughts. All rights reserved.
//

import UIKit
import SnapKit

class FieldGrid: UIView {
  internal var gridSquares: [GridSquare] = []
  internal var sideLength: CGFloat = 0
  internal var gridSize: CGVector = CGVector(dx: 0, dy: 0)
  internal var gridPositions: [CGVector] = []
  
  
  // MARK: - Initialization
  convenience init(gridsWithSize size: CGVector, gridLength: CGFloat) {
    self.init(frame: CGRectZero)
    self.sideLength = gridLength
    self.gridSize = size
    self.backgroundColor = UIColor.greenColor()
    
    for h in 0..<Int(self.gridSize.dx) {
      for v in 0..<Int(self.gridSize.dy) {
        gridSquares.append(GridSquare(withGridPosition: CGVector(dx: h, dy: v)))
      }
    }
    
    self.setupViewHierarchy()
    self.configureConstraints()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  
  // MARK: - Setup
  private func configureConstraints() {
    var getTopLeftMostSquareToken: dispatch_once_t = 0
    var topLeftMostSquare: GridSquare?
    
    // first arrange the grid
    let arrangedRows: [[GridSquare]] = self.configureRows()
    for (idxRow, row): (Int, [GridSquare]) in arrangedRows.enumerate() {
      
      var previousSquare: GridSquare?
      for square: GridSquare in row {
        
        if let existingPriorSquare: GridSquare = previousSquare {
          square.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(existingPriorSquare.snp_right)
            make.top.equalTo(existingPriorSquare)
            make.size.equalTo(existingPriorSquare.snp_size)
          })
        }
        else { // if starting a new row. this essentially "anchors" view to a set position to allow the other views in the same row to arrange themselves properly
          dispatch_once(&getTopLeftMostSquareToken, {
            topLeftMostSquare = square
          })
          
          square.snp_makeConstraints(closure: { (make) in
            // set the top constraint to the current row * the row length
            // set leftmost constraints to the leading edge of view
            make.top.equalTo(self).offset(CGFloat(idxRow - 1) * self.sideLength) // idx starts at 1, not zero apparently
            make.left.equalTo(self)
          })

          // then, make the square the right dimensions
          square.snp_makeConstraints(closure: { (make) in
            make.size.equalTo(CGSize(width: self.sideLength, height: self.sideLength))
          })
        }
        // finally set it as the previous square
        previousSquare = square
        
      }
    }
    
    // then update container view size
    self.snp_makeConstraints { (make) in
      make.size.equalTo(CGSizeMake(self.sideLength * self.gridSize.dx, self.sideLength * self.gridSize.dy))
      make.top.left.equalTo(topLeftMostSquare!)
    }
  }
  
  private func configureRows() -> [[GridSquare]] {
    var fullContainer: [[GridSquare]] = [[]]
    
        for row in 0..<Int(self.gridSize.dy) {
          let rowContainer: [GridSquare] = self.gridSquares.filter { (square: GridSquare) -> Bool in
            if Int(square.gridPosition.dy) == row {
              return true
            }
            return false
          }
          
          fullContainer.append(rowContainer)
        }
    
    return fullContainer
  }
  
  private func setupViewHierarchy() {
    self.gridSquares.forEach { (square) in
      self.addSubview(square)
    }
  }
  
}