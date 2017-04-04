//
//  ViewController.swift
//  MonkeyPinch
//
//  Created by ESS Mac Pro on 4/3/17.
//  Copyright © 2017 NGA Group Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        if sender.state == .ended {
            //1
            let velocity = sender.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude/200
            print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            //2
            let slideFactor = 0.1*slideMultiplier    //Increase for more of a slide
            
            //3
            var finalPoint = CGPoint(x: (sender.view?.center.x)! + (velocity.x * slideFactor), y: (sender.view?.center.y)! + (velocity.y * slideFactor))
            
            //4
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
            
            //5
            UIView.animate(withDuration: Double(slideFactor*2), delay: 0, options: .curveEaseOut, animations: { 
                sender.view?.center = finalPoint
            }, completion: nil)
        }
        
    }
    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
        
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
        
    }
    
    @IBAction func handleRotate(_ sender: UIRotationGestureRecognizer) {
        
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
        
    }

}

