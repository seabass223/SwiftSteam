//
//  GameDetailsSpinner.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/11/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import UIKit

protocol GameDetailsSpinnerDelegate
{
    func gameDetailsIsRendered(inst:GameDetailsSpinner)
}

class GameDetailsSpinner :UIView
{
    override init(frame:CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate:GameDetailsSpinnerDelegate?
    var game:SteamGame?
    var label:UILabel?
    var descriptionLabel:UILabel?
    var drawState = -1
    var spinTimer:NSTimer?
    var degrees:CGFloat = 0.0
    var speed:CGFloat = 0.0
    var prevDragX:CGFloat = 0.0
    var cachedImageRepresentation:UIImage?
    var fragments:Array<Fragment> = Array<Fragment>()
    let rows = 20
    let cols = 10
    
    func setGame(game:SteamGame)
    {
        self.game = game;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)!) { () -> Void in
            var json = self.game!.downloadAchieveMents()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.renderView()
            })
        }
    }
    
    func renderView()
    {
        let padding = CGFloat(30);
        label = UILabel(frame: CGRectMake(padding, padding, self.frame.width-padding*2, 40))
        self.addSubview(label!)
        label!.font = UIFont(name: "Arcade Normal", size: 20)
        label!.textColor = UIColor.whiteColor()
        label!.numberOfLines = 0
        label!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label!.textAlignment = NSTextAlignment.Center
        label!.text = self.game!.name
        
        var font = UIFont(name: "Arcade Normal", size: 12)
        let res = self.game!.achievements!
                    .filter(){$0.achieved == true}
                    .reduce("") { countElements($0) == 0 ? $1.name : $0 + "\n" + $1.name }
        
        
        var descText:String = "Achievements: \(self.game!.achievements!.filter(){$0.achieved == true}.count)/\(self.game!.achievements!.count)\nTotal Minutes Played: \(self.game!.totalsContainer!.totalMinutesPlayedInAllGames)\nLongest Game Played: \(self.game!.totalsContainer!.longestGamePlay!.minutesPlayed)\n\(self.game!.totalsContainer!.longestGamePlay!.name)\n\(self.game!.name): \(self.game!.minutesPlayed)"
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        var attribText:NSAttributedString = NSAttributedString(string:descText, attributes: [NSParagraphStyleAttributeName:paragraphStyle])
        
        descriptionLabel = UILabel(frame: CGRectMake(padding, padding+padding+label!.frame.size.height, self.frame.width-padding*2, 235))
        self.addSubview(descriptionLabel!)
        descriptionLabel!.numberOfLines = 0
        descriptionLabel!.textAlignment = NSTextAlignment.Center
        descriptionLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descriptionLabel!.font = font
        descriptionLabel!.textColor = UIColor.whiteColor()
        descriptionLabel!.attributedText = attribText
        
        drawState = 0
        self.setNeedsDisplay()
 
    }
    
    func CreateFragments()
    {
        var h:CGFloat = ceil(CGFloat(cachedImageRepresentation!.size.height / CGFloat(rows)))
        var w:CGFloat = ceil(CGFloat(cachedImageRepresentation!.size.width / CGFloat(cols)))
        
        var i = 0
        for y in (0...rows)
        {
            for x in (0...cols)
            {
                var xp = CGFloat(x) * w
                var yp = CGFloat(y) * h
                
                var f = Fragment(frame: CGRectMake(CGFloat(xp), CGFloat(yp), w, h))
                f.setImage(cachedImageRepresentation!, x:x, y:y, maxX:cols, maxY:rows, lastOneOut:(y==rows && x==cols))
                self.addSubview(f)
                i++
                fragments.append(f)
            }
        }
        
        delegate!.gameDetailsIsRendered(self)
    }
    
    func FragmentReveal()
    {

        for f in fragments
        {
           f.doAnimation()
        }
        
        var t = self.layer.transform
        self.layer.anchorPoint = CGPointMake(0.5, 0.5)
        t.m34 = perspective
        t = CATransform3DScale(t, 0.2, 0.2, 1)
        t = CATransform3DRotate(t, CGFloat(M_PI_2), 0, 1, 0)
        self.layer.zPosition = 1000
        self.layer.transform = t
        
        var toT = CATransform3DIdentity
        toT.m34 = manualSpinPerspective
        toT = CATransform3DScale(toT, 0.8, 0.8, 1)

        self.allowDrag()
        
        UIView.animateWithDuration(NSTimeInterval(3), delay: NSTimeInterval(0), options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.layer.transform = toT
            }) { (finished) -> Void in
        }
        
    }
    
    override func drawRect(rect: CGRect) {
        var ctx = UIGraphicsGetCurrentContext()
        if(drawState == 0){
            
            var path = CGPathCreateMutable()
            CGContextSetFillColorWithColor(ctx, UIColor.blackColor().colorWithAlphaComponent(0.6).CGColor!)
            CGContextFillRect(ctx, rect)
            
            CGContextMoveToPoint(ctx, 0, 0)
            CGContextAddLineToPoint(ctx, 0, 100)
            CGContextAddLineToPoint(ctx, rect.width, 100)
            CGContextAddLineToPoint(ctx, rect.width, 0)
            CGContextClosePath(ctx)
            
            CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor!)
            CGContextAddPath(ctx, path)
            CGContextFillPath(ctx)

            
            //draw totals
            
            var bezierPath = UIBezierPath()
            var lineWidth:CGFloat = 5
            var startAngle:CGFloat = -90 * CGFloat(M_PI)/180.0
            var endAngle:CGFloat = (720 - startAngle) * (1.0 / 100.0) + startAngle
            
            
            let cr = CGRectMake(90, 325, 150, 150)
            //base circle
            bezierPath.addArcWithCenter(CGPointMake(cr.origin.x + cr.size.width * 0.5, cr.origin.y + cr.size.height * 0.5), radius: (cr.size.width/2) - (lineWidth*0.5), startAngle: startAngle, endAngle: endAngle, clockwise: true)
            bezierPath.lineWidth = lineWidth
            UIColor(white: 0.71, alpha:1).setStroke()
            bezierPath.stroke()
            
            
            //longestGame
            bezierPath = UIBezierPath()
            var percent:CGFloat = CGFloat(self.game!.totalsContainer!.longestGamePlay!.minutesPlayed) / CGFloat(self.game!.totalsContainer!.totalMinutesPlayedInAllGames)
            
            endAngle = (625 - startAngle) * (percent / 100.0) + startAngle;
            bezierPath.addArcWithCenter(CGPointMake(cr.origin.x + cr.size.width * 0.5, cr.origin.y + cr.size.height * 0.5), radius: (cr.size.width/2) - (lineWidth*0.5), startAngle: startAngle, endAngle: endAngle, clockwise: true)
            bezierPath.lineWidth = lineWidth;
            UIColor(red: 0, green: 0.75, blue: 1, alpha: 1).setStroke()
            bezierPath.stroke()
            
            
            
            //this game
            bezierPath = UIBezierPath()
            percent = CGFloat(self.game!.minutesPlayed) / CGFloat(self.game!.totalsContainer!.totalMinutesPlayedInAllGames)
            
            endAngle = (625 - startAngle) * (percent / 100.0) + startAngle;
            bezierPath.addArcWithCenter(CGPointMake(cr.origin.x + cr.size.width * 0.5, cr.origin.y + cr.size.height * 0.5), radius: (cr.size.width/2) - (lineWidth*0.5), startAngle: startAngle, endAngle: endAngle, clockwise: true)
            bezierPath.lineWidth = lineWidth;
            UIColor(red: 1, green: 0.75, blue: 0, alpha: 1).setStroke()
            bezierPath.stroke()
            
            
            
            
            drawState = 1
            //let it blit to screen
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.001 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue(), {
                UIGraphicsBeginImageContext(self.frame.size)
                var ctx = UIGraphicsGetCurrentContext()
                self.layer.renderInContext(ctx)
                self.cachedImageRepresentation = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                self.setNeedsDisplay()
                self.label!.removeFromSuperview()
                self.descriptionLabel!.removeFromSuperview()
                self.CreateFragments()
            })
        }
        else if(drawState == 1)
        {
            CGContextClearRect(ctx, rect)
        }
    }
    
    func allowDrag()
    {
        spinTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.01), target: self, selector:Selector("update"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(spinTimer!, forMode:NSRunLoopCommonModes)
    }
    
    func stopDrag()
    {
        spinTimer?.invalidate()
    }
    
    func update()
    {
        self.layer.transform = CATransform3DRotate(self.layer.transform, degrees * 0.01745329251, 0, 1, 0)
        degrees *= CGFloat(0.92)
        if(isnan(degrees))
        {
            degrees = 0
        }
        else if(isinf(degrees))
        {
            degrees = 360
        }
    }
    
}