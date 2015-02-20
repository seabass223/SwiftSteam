//
//  ViewController.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/3/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SteamAPIProtocol, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, LoadingViewDelegate {
    
    @IBOutlet weak var gamesTableView: UITableView!
    var _myGames:Array<SteamGame>?
    var _selectedCell:ListViewCell?
    var _loadingView:LoadingView?
    var totalsContainer:GamesTotalContainer = GamesTotalContainer()
    var didAppear = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gamesTableView.backgroundColor! = UIColor.clearColor()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.gamesTableView.registerClass(ListViewCell.self, forCellReuseIdentifier: "CELL_ID")
        self.gamesTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        gamesTableView.dataSource = self;
        gamesTableView.delegate = self;
        
        var api:SteamAPI = SteamAPI()
        api.delegate = self
        if var myGames = api.GetMyGames(){
            _myGames = myGames
            totalsContainer.totalMinutesPlayedInAllGames = _myGames!.reduce(0){$0 + $1.minutesPlayed}
            let _maxTime = _myGames!.reduce(Int.min, { max($0, $1.minutesPlayed) })
            totalsContainer.longestGamePlay = _myGames!.filter(){$0.minutesPlayed == _maxTime}.first!
            
            for game in myGames
            {
                game.totalsContainer = totalsContainer
                api.DownloadGameLogo(game)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        if(didAppear == true)
        {
            for cell in self.gamesTableView.visibleCells() as Array<ListViewCell>
            {
                cell.transform=CGAffineTransformIdentity
            }
            self._selectedCell!.resetView()
            self.view.backgroundColor! = UIColor.whiteColor()
        }
        didAppear = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func AnimateOut()
    {
        self._selectedCell?.logoView!.tiltTo(-CGFloat(M_PI_4/2), time:NSTimeInterval(0.2))
        self._selectedCell?.logoView!.SetBorderWidth(CGFloat(2), time: NSTimeInterval(0))
        self._selectedCell?.logoView!.SetCornerRadius(CGFloat(10), time: NSTimeInterval(0))
        
        self._selectedCell?.logoView?.layer.zPosition = 100
        var index:Int = 0
        for cell in self.gamesTableView.visibleCells() as Array<ListViewCell>
        {
            
            if(cell != self._selectedCell!){
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    
                    var sign = (index % Int(2) == Int(0)) ? CGFloat(1) : CGFloat(-1)
                    cell.transform = CGAffineTransformMakeTranslation(cell.frame.size.width * sign, 0)
                    
                    }, completion: { finished in
                })
                
                index++
            }
        }
        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.backgroundColor! = UIColor.blackColor()
            }) { (finished) -> Void in
            self.BeginLoadingView()
        }
        
    }
    
    func BeginLoadingView()
    {
        self._loadingView = LoadingView(frame: self.view.frame)
        self._loadingView?.delegate = self
        self._loadingView!.setGameLogoView(self._selectedCell!.logoView!)
    }
    
    //MARK: - SteamAPIProtocol
    func SteamAPIDidLoadGameLogo(game: SteamGame) {
        
    }
    
    func SteamAPIDidLoadAllGames() {
    
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(69.0)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _myGames != nil ? _myGames!.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : ListViewCell? = tableView.dequeueReusableCellWithIdentifier("CELL_ID") as? ListViewCell
        if(cell == nil)
        {
            cell = ListViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL_ID")
            
        }
        
        let game:SteamGame = _myGames![indexPath.row]
        cell?.setGame(game)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? ListViewCell
        
        if(tableView.contentOffset.y <= 0)
        {
         scrollViewDidEndScrollingAnimation(tableView)
        }
        else{
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let yp = _selectedCell!.getLocalYPosition(self.gamesTableView.contentOffset.y)
        self.view.addSubview(_selectedCell!.logoView!)
        var rect = _selectedCell!.logoView!.frame
        rect.origin.y = yp-20
        _selectedCell!.logoView!.frame = rect
        
        AnimateOut()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        
        for cell in self.gamesTableView.visibleCells() as Array<ListViewCell>
        {
            cell.calculateWarp(yOffset, maxY: height)
        }
    }
    
    //MARK: - LoadingViewDelegate
    func LoadingViewFinishedLoading(gameLogoView: GameLogoView, gameDetailsView:GameDetailsSpinner) {
        var details = DetailViewController()
        var gameLogo = _selectedCell!.logoView!
        _loadingView?.delegate = nil
        _loadingView?.removeFromSuperview()
        self.presentViewController(details, animated: false) { () -> Void in
            details.setGameLogoView(gameLogo, detailsView:gameDetailsView)
        }
    }
}