//
//  ViewController.swift
//  MonkeyPinch
//
//  Created by ESS Mac Pro on 4/3/17.
//  Copyright © 2017 NGA Group Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var chompPlayer:AVAudioPlayer?
    
    func loadSound(fileName:String) -> AVAudioPlayer {
        
        let url = Bundle.main.url(forResource: fileName as String, withExtension: "caf")
//        var error:Error? = nil
        let player = try! AVAudioPlayer(contentsOf: url!)
        player.prepareToPlay()
        return player
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //1
        let filteredSubViews = self.view.subviews.filter({ $0.isKind(of: UIImageView.self)})
        //2
        for view in filteredSubViews {
           //3
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
            //4
            recognizer.delegate = self
            view.addGestureRecognizer(recognizer)
            
            //TODO: Add a custom gesture recognizer too
        }
        
        self.chompPlayer = self.loadSound(fileName: "chomp")
    }

    func handleTap(recognizer:UITapGestureRecognizer) {
        self.chompPlayer?.play()
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

extension ViewController : UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

