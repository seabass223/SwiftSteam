//
//  Fragment.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/12/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import UIKit
class Fragment:UIView
{
    override init(frame:CGRect)
    {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    var image:UIImage?
    var x:Int = 0
    var y:Int = 0
    var percent:CGFloat = 0.0
    var offsetX:CGFloat = 0.0
    var offsetY:CGFloat = 0.0
    var lastOneOut:Bool = false
    
    func setImage(image:UIImage, x:Int, y:Int, maxX:Int, maxY:Int, lastOneOut:Bool)
    {
        self.lastOneOut = lastOneOut
        self.layer.anchorPoint = CGPointMake(0.5, 0.5)
        self.image = image
        self.x = x
        self.y = y
        self.percent = 1.0 - CGFloat(y) / CGFloat(maxY)
        self.percent += CGFloat(CGFloat(arc4random_uniform(3)) / CGFloat(10.0))
        
        self.offsetY = -CGFloat(arc4random_uniform(25) + 85)
        
        let halfMaxX = CGFloat(maxX)/2.0
        self.offsetX = ((CGFloat(x) - halfMaxX) * 50.0) + (CGFloat(arc4random_uniform(80))-40.0)
        
        self.setNeedsDisplay()
    }
    
    func doAnimation()
    {
        self.transform = CGAffineTransformMakeTranslation(self.offsetX, self.offsetY)
        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.0)
        self.transform = CGAffineTransformRotate(self.transform, CGFloat(M_PI) * CGFloat(CGFloat(arc4random_uniform(10)) / CGFloat(10.0)))
        
        UIView.animateWithDuration(NSTimeInterval(3.0), delay: NSTimeInterval(0.8*self.percent), options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.transform = CGAffineTransformIdentity
            }) { (finished) -> Void in
                
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        var ctx = UIGraphicsGetCurrentContext()
        var r = CGRectIntersection(self.frame, CGRectMake(0, 0, image!.size.width, image!.size.height))
        var cImg = CGImageCreateWithImageInRect(image!.CGImage, r)
        CGContextTranslateCTM(ctx, 0, self.frame.size.height);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        CGContextDrawImage(ctx, rect, cImg)
    }
}
