//
//  LoadingView.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/10/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import UIKit

protocol LoadingViewDelegate
{
    func LoadingViewFinishedLoading(gameLogoView:GameLogoView, gameDetailsView:GameDetailsSpinner)
}

class LoadingView : UIView, GameDetailsSpinnerDelegate
{
    var gameLogoView:GameLogoView?
    var emitterLayer = CAEmitterLayer()
    var delegate:LoadingViewDelegate?
    var label:UILabel = UILabel(frame: CGRectMake(0, 0, 350, 60))
    var textColorTimer:NSTimer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.font  = UIFont(name: "Arcade Interlaced", size: 32)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.text = "LOADING"
        label.alpha = 0
        var pt = self.center
        pt.y = 100
        label.center = pt
        
        self.addSubview(label)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGameLogoView(logoView:GameLogoView)
    {
        gameLogoView = logoView
        gameLogoView!.superview!.addSubview(self)
        
        
        //PARTICLES
        emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height+100)
        emitterLayer.emitterZPosition = 10
        emitterLayer.emitterSize = CGSizeMake(self.bounds.size.width, 100)
        emitterLayer.emitterShape = kCAEmitterLayerRectangle
        
        
        var emitterCell = CAEmitterCell()
        emitterCell.scale = CGFloat(0.1)
        emitterCell.scaleRange = CGFloat(0.4)
        emitterCell.lifetime = Float(2.0)
        emitterCell.birthRate = 27
        emitterCell.velocity = 0
        emitterCell.yAcceleration = -1000
        
        emitterCell.contents = UIImage(named: "line")?.CGImage
        emitterLayer.emitterCells = [emitterCell]
        self.layer.addSublayer(emitterLayer)
        
        
        
        //SHAKE
        var shake = CABasicAnimation(keyPath: "position")
        shake.duration = CFTimeInterval(0.05)
        shake.repeatCount = 1000
        shake.autoreverses = true
        shake.fromValue = NSValue(CGPoint:CGPointMake(gameLogoView!.center.x, gameLogoView!.center.y-CGFloat(2)))
        shake.toValue = NSValue(CGPoint:CGPointMake(gameLogoView!.center.x, gameLogoView!.center.y+CGFloat(2)))
        gameLogoView!.layer.addAnimation(shake, forKey: "position")
        
        
        
        //LIST (as in: list back and forth)
        var list = CABasicAnimation(keyPath: "transform.rotation.x")
        list.duration = CFTimeInterval(1.5)
        list.repeatCount = 1000
        list.autoreverses = true

        list.fromValue = -M_PI_4/2
        list.toValue = -M_PI_4
        
        list.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.gameLogoView!.layer.addAnimation(list, forKey: "rotation")
        
        var transform:CATransform3D = CATransform3DIdentity
        transform.m34 = perspective
        transform = CATransform3DRotate(transform, 0, 0, 0, 0)
        self.gameLogoView!.layer.transform = transform

        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.label.alpha = 1
        })
    
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
            //prewarm the gamedetailspinnerview
            var detailsSpinner = GameDetailsSpinner(frame:CGRectMake(20, 20, self.frame.size.width - 40, self.frame.size.height - 170))
            detailsSpinner.delegate = self
            detailsSpinner.transform = CGAffineTransformMakeTranslation(self.frame.size.width, 0)//set offscreen
            self.addSubview(detailsSpinner)
            detailsSpinner.setGame(logoView.game!)
        })
    }
    
    //MARK: GameDetailsSpinnerDelegate
    func gameDetailsIsRendered(inst: GameDetailsSpinner) {
        self.gameLogoView!.layer.removeAllAnimations()
        inst.transform = CGAffineTransformMakeTranslation(0, 0)//set back
        self.gameLogoView!.tiltTo(CGFloat(0), time: NSTimeInterval(0.3))
        inst.removeFromSuperview()//remove it from screen
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.gameLogoView!.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height/2)
            }, completion: { finished in
                self.emitterLayer.birthRate = 0
                self.delegate?.LoadingViewFinishedLoading(self.gameLogoView!, gameDetailsView: inst)
        })
    }
}