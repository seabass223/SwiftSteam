//
//  DetailsUIView.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/11/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import UIKit

class DetailsUIView : UIView
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.backgroundColor = UIColor.whiteColor()
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

//        var center = self.center
//        var frame = self.frame
//        let bottomOffset = CGFloat(5)
//        let topOffset = CGFloat(2)
//        let bottomLineWidth = CGFloat(40)
//        let topLineWidth = CGFloat(3)
//        let topLineY = frame.height - 100
        
//        var ctx = UIGraphicsGetCurrentContext()
        
//        var colors [] = {
//            1.0, 1.0, 1.0, 1.0,
//            1.0, 0.0, 0.0, 1.0
//        };
        
//        var baseSpace = CGColorSpaceCreateDeviceRGB();
//        CGGradientCreateWithColors(baseSpace, colors:, <#locations: UnsafePointer<CGFloat>#>)
//        var gradient = CGGradientCreateWithColorComponents(baseSpace, colors, , 2);
        
        
//        CGContextSaveGState(ctx);
//        CGContextAddEllipseInRect(context, rect);
//        CGContextClip(context);
        
//        var startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
//        var endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
//        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
//        CGGradientRelease(gradient), gradient = NULL;
        
//        CGContextRestoreGState(context);
        
//        CGContextAddEllipseInRect(context, rect);
//        CGContextDrawPath(context, kCGPathStroke);
        
        
        //        CGContextAddQuadCurveToPoint(ctx, center.x-offset-topLineWidth+5, topLineY-5, center.x-offset-topLineWidth - 7, topLineY-5)
        //        CGContextAddLineToPoint(ctx, 0, topLineY-5)
        //        CGContextAddLineToPoint(ctx, 0, topLineY-7)
        //        CGContextAddLineToPoint(ctx, center.x-offset-topLineWidth, topLineY - 7)
        //        CGContextAddQuadCurveToPoint(ctx, center.x-offset, topLineY-7, center.x-offset, topLineY)
        
//        CGContextMoveToPoint(ctx, center.x-bottomOffset, frame.size.height)
//        CGContextAddLineToPoint(ctx, center.x-bottomOffset-bottomLineWidth,frame.size.height)
//        CGContextAddLineToPoint(ctx, center.x-topOffset-topLineWidth,topLineY)
//        CGContextAddLineToPoint(ctx, center.x-topOffset,topLineY)
//        CGContextAddLineToPoint(ctx, center.x-bottomOffset, frame.size.height)
//        
//        CGContextMoveToPoint(ctx, center.x+bottomOffset, frame.size.height)
//        CGContextAddLineToPoint(ctx, center.x+bottomOffset+bottomLineWidth,frame.size.height)
//        CGContextAddLineToPoint(ctx, center.x+topOffset+topLineWidth,topLineY)
//        CGContextAddLineToPoint(ctx, center.x+topOffset,topLineY)
//        CGContextAddLineToPoint(ctx, center.x+bottomOffset, frame.size.height)
//        
//        CGContextClosePath(ctx)
//        CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor!)
//        CGContextFillPath(ctx)
    }
    
}
