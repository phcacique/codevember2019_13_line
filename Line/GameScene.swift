//
//  GameScene.swift
//  Line
//
//  Created by Pedro Cacique on 18/11/19.
//  Copyright © 2019 Pedro Cacique. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var segments: [RectSegment] = []
    var colors: [UIColor] = [ UIColor(red: 209/255, green: 196/255, blue: 131/255, alpha: 1),
                              UIColor(red: 104/255, green: 175/255, blue: 200/255, alpha: 1),
                              UIColor(red: 239/255, green: 130/255, blue: 177/255, alpha: 1),
                              UIColor(red: 137/255, green: 191/255, blue: 179/255, alpha: 1)
    ]
    
    var step:CGFloat = 5
    var probability: Int = 98
    var alphaEnabled: Bool = true
    
    var renderTime: TimeInterval = 0
    let createTime: TimeInterval = 0.01
    let maxNodes: Int = 60000
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 41/255, green: 42/255, blue: 47/255, alpha: 1)
        setup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    @objc func doubleTapped() {
        setup()
    }
    
    func setup(){
        segments = []
        removeAllChildren()
        let x = CGFloat.random(in: self.frame.width/10 ... 9*self.frame.width/10)
        let segment: RectSegment = RectSegment(p0: CGPoint(x: x, y:0), p1: CGPoint(x: x, y:self.frame.height), color:getRandomColor())
        segments.append(segment)
    }
    
    func getRandomColor(withAlpha:Bool = false) -> UIColor{
        return colors[ Int.random(in: 0..<colors.count) ].withAlphaComponent( (alphaEnabled || withAlpha) ? CGFloat.random(in: 0.2 ... 1): 1 )
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if currentTime > renderTime {
            
            if checkDrawing() == false {
                setup()
                return
            }
            
            DispatchQueue.main.async {
                for segment in self.segments {
                    
                    if (segment.currentPoint.x >= 0 && segment.currentPoint.x <= self.frame.width) &&
                        (segment.currentPoint.y >= 0 && segment.currentPoint.y <= self.frame.height){
                        var newPoint = segment.p0
                        if segment.getType() == .VERTICAL {
                            newPoint = segment.getPoint(y: segment.currentPoint.y + ( (segment.p1.y > segment.p0.y) ? self.step : -self.step ))
                        } else {
                            newPoint = segment.getPoint(x: segment.currentPoint.x + ( (segment.p1.x > segment.p0.x) ? self.step : -self.step ))
                        }
                        
                        let path:CGMutablePath = CGMutablePath()
                        path.move(to: segment.currentPoint)
                        path.addLine(to: newPoint)
                        segment.currentPoint = newPoint
                        
                        let shape = SKShapeNode()
                        shape.path = path
                        shape.strokeColor = segment.color
                        shape.lineWidth = segment.lineWidth
                        
                        self.addChild(shape)
                        
                        //add new segment
                        if Int.random(in: 0...100) > self.probability {
                            if segment.getType() == .VERTICAL{
                                let newX = (Int.random(in: 0...10) > 5) ? self.size.width : -self.size.width
                                let s = RectSegment(p0: segment.currentPoint,
                                                    p1: CGPoint(x: newX, y: segment.currentPoint.y),
                                                    color: self.getRandomColor())
                                self.segments.append(s)
                            } else if segment.getType() == .HORIZONTAL{
                                let newY = (Int.random(in: 0...10) > 5) ? self.size.height : -self.size.height
                                let s2 = RectSegment(p0: segment.currentPoint,
                                                    p1: CGPoint(x: segment.currentPoint.x, y: newY),
                                                    color: self.getRandomColor())
                                self.segments.append(s2)
                            }
                        }
                    }
                }
            }

            renderTime = currentTime + createTime
        }
    }
    
    func checkDrawing() -> Bool {
        var count = 0
        for segment in segments{
            if (segment.currentPoint.x >= 0 && segment.currentPoint.x <= self.frame.width) &&
            (segment.currentPoint.y >= 0 && segment.currentPoint.y <= self.frame.height){
                count += 1
            }
        }
        return count != 0 && self.children.count < maxNodes
    }
}
