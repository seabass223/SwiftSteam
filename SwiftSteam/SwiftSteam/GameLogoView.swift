//
//  GameLogoView.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/10/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import UIKit

class GameLogoView : UIImageView
{    
    var game:SteamGame?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SetGame(game:SteamGame)
    {
        self.game = game
        self.image = UIImage(data: game.logoData!)
    }
    
    func SetBorderWidth(width:CGFloat, time:NSTimeInterval)
    {
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = width
    }
    
    func SetCornerRadius(radius:CGFloat, time:NSTimeInterval)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func tiltTo(degrees:CGFloat, time:NSTimeInterval)
    {
        var transform:CATransform3D = CATransform3DIdentity
        transform.m34 = perspective
        UIView.animateWithDuration(time, animations: {
            //start off on right rotation
            self.layer.transform = CATransform3DRotate(transform, degrees, 1, 0, 0)
        })
    }
}