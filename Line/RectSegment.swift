//
//  Line.swift
//  Line
//
//  Created by Pedro Cacique on 18/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import Foundation
import SpriteKit

class RectSegment {
    
    var p0: CGPoint
    var p1: CGPoint
    var angular: CGFloat
    var linear: CGFloat
    var currentPoint: CGPoint
    var color: UIColor
    var lineWidth: CGFloat
    
    init(p0:CGPoint, p1:CGPoint, color:UIColor = .white, lineWidth: CGFloat = 1){
        self.p0 = p0
        self.p1 = p1
        self.angular = (p1.y - p0.y) / (p1.x - p0.x)
        self.linear = p0.y - angular * p0.x
        self.currentPoint = p0
        self.color = color
        self.lineWidth = lineWidth
    }
    
    func getPoint(x:CGFloat) -> CGPoint {
        if getType() == .VERTICAL {
            return p0
        } else if getType() == .HORIZONTAL {
            return CGPoint(x: x, y:p0.y)
        }
        
        let y = angular * x + linear
        return CGPoint(x: x, y: y)
    }
    
    func getPoint(y:CGFloat) -> CGPoint {
        if getType() == .VERTICAL {
            return CGPoint(x: p0.x, y:y)
        } else if getType() == .HORIZONTAL {
            return p0
        }
        
        let x = (y - linear)/angular
        return CGPoint(x: x, y: y)
    }
    
    func getType() -> RectSegmentType{
        if p0.x == p1.x {
            return .VERTICAL
        } else if p0.y == p1.y {
            return .HORIZONTAL
        } else {
            return .INCLINED
        }
    }
}

enum RectSegmentType{
    case VERTICAL, HORIZONTAL, INCLINED
}
