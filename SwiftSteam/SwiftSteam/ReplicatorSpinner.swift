//
//  ReplicatorSpinner.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/14/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import UIKit
class ReplicatorSpinner:UIView{
    
    
    var instanceLayer = CALayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = self.bounds
        
        // 2
        replicatorLayer.instanceCount = 30
        replicatorLayer.instanceDelay = CFTimeInterval(1 / 30.0)
        replicatorLayer.preservesDepth = false
        replicatorLayer.instanceColor = UIColor.blackColor().CGColor
        
        // 3
//        replicatorLayer.instanceRedOffset = 0.0
//        replicatorLayer.instanceGreenOffset = -0.5
//        replicatorLayer.instanceBlueOffset = -0.5
        replicatorLayer.instanceAlphaOffset = 0.0
        
        // 4
        let angle = Float(M_PI * 2.0) / 30
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        self.layer.addSublayer(replicatorLayer)
        
//         5
//        let instanceLayer = CALayer()
        let layerWidth: CGFloat = 10.0
        let midX = CGRectGetMidX(self.bounds) - layerWidth / 2.0
        instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * 3.0)
        instanceLayer.backgroundColor = UIColor.whiteColor().CGColor
        replicatorLayer.addSublayer(instanceLayer)
        
        // 6
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 1
        fadeAnimation.repeatCount = Float(Int.max)
        
        // 7
        instanceLayer.opacity = 0.0
        instanceLayer.addAnimation(fadeAnimation, forKey: "FadeAnimation")
        
        var t = replicatorLayer.transform
        t.m34 = perspective
        t = CATransform3DRotate(t, CGFloat(-M_PI_2)*1.2, 1, 0, 0)
        t = CATransform3DScale(t, 0.40, 0.40, 1)
        t = CATransform3DTranslate(t, 0, 0, 135)
        replicatorLayer.transform = t
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cleanup()
    {
        instanceLayer.removeAllAnimations()
    }
}
