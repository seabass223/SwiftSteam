//
//  DetailViewController.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/11/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import UIKit
class DetailViewController : UIViewController
{
    var logoView:GameLogoView?
    var detailsSpinner:GameDetailsSpinner?
    var spinner:ReplicatorSpinner?
    var battleBG:EarthBoundBattleBg?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var detailsUI = DetailsUIView(frame: self.view.frame)
        self.view.addSubview(detailsUI)
    }
    
    func setGameLogoView(logoView:GameLogoView, detailsView:GameDetailsSpinner)
    {
        self.detailsSpinner = detailsView
        self.logoView = logoView
        
        battleBG = EarthBoundBattleBg(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        self.view.addSubview(battleBG!)
        battleBG!.setImage(logoView.game!.getIcondImage())
        
        self.view.addSubview(self.detailsSpinner!)
        self.detailsSpinner!.FragmentReveal()
        
        spinner = ReplicatorSpinner(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        self.view.addSubview(spinner!)
        
        var backBtn = UIButton(frame: CGRectMake(0, self.view.frame.size.height-35, 100, 35))
        self.view.addSubview(backBtn)
        backBtn.setTitle("< Back", forState: UIControlState.Normal)
        backBtn.addTarget(self, action: Selector("backButtonPressed:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func backButtonPressed(sender:UIButton)
    {
        self.detailsSpinner!.stopDrag()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.spinner!.cleanup()
            self.battleBG!.cleanup()
        })
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        detailsSpinner!.prevDragX = touches.anyObject()!.locationInView(self.view).x
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        var nowX = touches.anyObject()!.locationInView(self.view).x
        detailsSpinner!.degrees += (detailsSpinner!.prevDragX - nowX) * 0.1
        
        detailsSpinner!.degrees = min(max(-10,detailsSpinner!.degrees), 10)
        
        detailsSpinner!.prevDragX = nowX
    }
    
}