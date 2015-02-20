//
//  EarthBoundBattleBg.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/14/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import UIKit
class EarthBoundBattleBg:UIView
{
    var replicatorLayerX = CAReplicatorLayer()
    var replicatorLayerY = CAReplicatorLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(image:UIImage)
    {
        let size:CGFloat = image.size.width
        
//        let replicatorLayerX = CAReplicatorLayer()
        replicatorLayerX.frame = self.bounds
        replicatorLayerX.instanceCount =  Int(ceil(self.bounds.size.width / CGFloat(size)))
        replicatorLayerX.instanceDelay = CFTimeInterval(0.5)
        
        replicatorLayerX.instanceTransform = CATransform3DTranslate(replicatorLayerX.instanceTransform, size, 0, 0)
        
        var imgView = UIImageView(image: image)
        let instanceLayer = imgView.layer
        imgView.layer.opacity = 0.1
        
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0.3
        fadeAnimation.toValue = 0.6
        fadeAnimation.duration = 1
        fadeAnimation.autoreverses = true
        fadeAnimation.repeatCount = Float(Int.max)
        instanceLayer.addAnimation(fadeAnimation, forKey: "FadeAnimation")
        
        replicatorLayerX.addSublayer(instanceLayer)
        
        
//        let replicatorLayerY = CAReplicatorLayer()
        replicatorLayerY.instanceCount = Int(ceil(self.bounds.size.height / CGFloat(size)))
        replicatorLayerY.instanceDelay = -CFTimeInterval(1.0 / 4.0)
        replicatorLayerY.frame = self.bounds
        replicatorLayerY.instanceTransform = CATransform3DTranslate(replicatorLayerY.transform, 0, size, 0)
        
        replicatorLayerY.addSublayer(replicatorLayerX)
        
        self.layer.addSublayer(replicatorLayerY)
    }
    
    func cleanup()
    {
        replicatorLayerX.removeAllAnimations()
        replicatorLayerY.removeAllAnimations()
    }
}
