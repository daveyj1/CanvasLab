//
//  CanvasViewController.swift
//  CanvasLab
//
//  Created by Joseph Davey on 2/19/18.
//  Copyright © 2018 Joseph Davey. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var arrowView: UIImageView!
    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    var orgPosition: CGPoint!
    
    @IBOutlet weak var excitedFace: UIImageView!
    @IBOutlet weak var happyFace: UIImageView!
    @IBOutlet weak var sadFace: UIImageView!
    @IBOutlet weak var tongueFace: UIImageView!
    @IBOutlet weak var winkFace: UIImageView!
    @IBOutlet weak var deadFace: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 182
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
        arrowView.image = #imageLiteral(resourceName: "down_arrow")
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            if trayView.center.y < trayUp.y {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y/10)
            } else {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            }
        } else if sender.state == .ended {
            let velocity = sender.velocity(in: view)
            if velocity.y > 0 {
                arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            } else {
                //arrowView.image = #imageLiteral(resourceName: "down_arrow")
                arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
            }
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        //print("Being placed")
        let translation = sender.translation(in: view)
        if sender.state == .began {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)))
            let rotateGestureRecongnizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(sender:)))
            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(sender:)))
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
                
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecongnizer)
            newlyCreatedFace.addGestureRecognizer(doubleTapGestureRecognizer)
        } else if sender.state == .ended {
            newlyCreatedFace.transform = CGAffineTransform.identity
            
            if newlyCreatedFace.center.y >= trayView.center.y - 111 {
                print("cant place there")
                newlyCreatedFace.removeFromSuperview()
                return
            }

            print("just placed")
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
    }
    
    @objc func didPan(sender: UIPanGestureRecognizer) {
        //print("Being moved")
        let translation = sender.translation(in: view)
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            orgPosition = newlyCreatedFace.center
            print(orgPosition.x)
            print(orgPosition.y)
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            if newlyCreatedFace.center.y >= trayView.center.y - 111 {
                print("On tray")
                //newlyCreatedFace.center = CGPoint(x: orgPosition.x, y: orgPosition.y)
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.newlyCreatedFace.center = CGPoint(x: self.orgPosition.x, y: self.orgPosition.y)
                }, completion: nil)
            }
            print("just moved")
        }
    }
    
    @objc func didPinch(sender: UIPinchGestureRecognizer) {
        //print("Being pinched")
        let scale = sender.scale
        if sender.state == .began || sender.state == .changed {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFace.transform = newlyCreatedFace.transform.scaledBy(x: scale, y: scale)
            sender.scale = 1
        } else if sender.state == .ended {
            print("just pinched")
        }
    }
    
    @objc func didRotate(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        if sender.state == .began || sender.state == .changed {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFace.transform = newlyCreatedFace.transform.rotated(by: rotation/15)
            sender.rotation = 1
        } else if sender.state == .ended {
            print("just rotated")
        }
    }
    
    @objc func didDoubleTap(sender: UITapGestureRecognizer) {
        newlyCreatedFace = sender.view as! UIImageView
        newlyCreatedFace.removeFromSuperview()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
