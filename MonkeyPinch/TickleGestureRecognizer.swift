//
//  TickleGestureRecognizer.swift
//  MonkeyPinch
//
//  Created by ESS Mac Pro on 4/4/17.
//  Copyright © 2017 NGA Group Inc. All rights reserved.
//

import Foundation
import UIKit

class TickleGestureRecognizer: UIGestureRecognizer {
    
    //1
    let requiredTickles = 2
    let distanceForTickleGesture:CGFloat = 25.0
    
    //2
    enum Direction:Int {
        case DirectionUnknown = 0
        case DirectionLeft
        case DirectionRight
    }
    
    //3
    var tickleCount:Int = 0
    var curTickleStart:CGPoint = CGPoint.zero
    var lastDirection:Direction = .DirectionUnknown
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first as UITouch! {
            self.curTickleStart = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        
        if let touch = touches.first as UITouch! {
            
            let ticklePoint = touch.location(in: self.view)
            
            let moveAmt = ticklePoint.x - curTickleStart.x
            var curDirection:Direction
            if moveAmt < 0 {
                curDirection = .DirectionLeft
            }else{
                curDirection = .DirectionRight
            }
            
            //moveAmt is a float, so self.distanceForTickleGesture needs to be a Float also
            if abs(moveAmt) < self.distanceForTickleGesture {
                return
            }
            
            if self.lastDirection == .DirectionUnknown || (self.lastDirection == .DirectionLeft && curDirection == .DirectionRight) || (self.lastDirection == .DirectionRight && curDirection == .DirectionLeft) {
                
                self.tickleCount += 1
                self.curTickleStart = ticklePoint
                self.lastDirection = curDirection
                
                if self.state == .possible && self.tickleCount > self.requiredTickles {
                    self.state = .ended
                }
            }
        }
        
    }
    
    override func reset() {
        
        self.tickleCount = 0
        self.curTickleStart = CGPoint.zero
        self.lastDirection = .DirectionUnknown
        if self.state == .possible {
            self.state = .failed
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        
        self.reset()
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        
        self.reset()
        
    }
    
}
