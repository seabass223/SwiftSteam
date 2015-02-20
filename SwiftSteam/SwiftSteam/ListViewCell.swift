//
//  ListViewCell.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/8/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import UIKit

class ListViewCell:UITableViewCell
{
    let threshold = CGFloat(87.0)
    let xAnchor = CGFloat(0.48)
    let logoView:GameLogoView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.logoView = GameLogoView(frame: CGRectMake(0, 0, 184, 69))
        self.contentView.addSubview(self.logoView!)
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        resetView()
    }

    func resetView()
    {
        self.contentView.addSubview(self.logoView!)
        logoView!.transform = CGAffineTransformIdentity
        logoView!.layer.transform = CATransform3DIdentity
        
        self.contentView.frame = CGRectMake(0, 0, 600, 69)
        self.logoView!.frame = CGRectMake(90, 0, 184, 69)
        
        self.logoView!.SetBorderWidth(CGFloat(0), time: NSTimeInterval(0))
        self.logoView!.SetCornerRadius(CGFloat(0), time: NSTimeInterval(0))
        self.logoView!.layer.zPosition = 0
        

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGame(game:SteamGame)
    {
        self.logoView?.SetGame(game)
    }
    
    func calculateWarp(offset:CGFloat, maxY:CGFloat)
    {
        let l = self.contentView.layer
        
        var val:CGFloat = (self.frame.origin.y - offset)
        
        if(val < threshold || val > maxY - threshold){

            var rot = CGFloat(1.0)
            
            if(val < threshold)
            {
                l.anchorPoint = CGPointMake(xAnchor, 1)
                val = val / threshold;
                if(val < 0){
                    val = 0
                }
            }
            else if(val > maxY-threshold)
            {
                rot = CGFloat(-1.0)
                l.anchorPoint = CGPointMake(xAnchor, 0)
                val = (val - (maxY - threshold)) / threshold
                
                if(val > 1){
                    val = 1
                }
                val = 1 - val
            }
            
            var mpi2float:CGFloat = CGFloat(M_PI_2)
            var transform = CATransform3DIdentity
            transform.m34 = perspective
            transform = CATransform3DRotate(transform, mpi2float * (1-val), rot, 0, 0)
            l.transform = transform
        }
        else{
            l.transform = CATransform3DIdentity
        }
    }
    
    func getLocalYPosition(offset:CGFloat)->CGFloat
    {
        return (self.frame.origin.y - offset)
    }
    
    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
        
        
//        println("drawRect");
//    }
    
    
}