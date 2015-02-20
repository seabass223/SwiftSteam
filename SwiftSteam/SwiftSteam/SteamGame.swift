//
//  SteamGame.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/3/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import UIKit


class SteamGame : NSObject{
    
    var appid:String = ""
    var name:String = ""
    var iconHash:String = ""
    var logoHash:String = ""
    var minutesPlayed = 0
    var logoData:NSData?
    var achievements:Array<SteamAchievementsObject>?
    var totalsContainer:GamesTotalContainer?
    
    
    init(info:JSON)
    {
        self.appid = info["appid"].stringValue
        self.name = info["name"].stringValue
        self.iconHash = info["img_icon_url"].stringValue
        self.logoHash = info["img_logo_url"].stringValue
        self.minutesPlayed = info["playtime_forever"].intValue
    }
    
    
    func downloadIcon()->NSData
    {
        let url:String = "http://media.steampowered.com/steamcommunity/public/images/apps/\(appid)/\(iconHash).jpg"
        let data = NSData(contentsOfURL: NSURL(string: url)!)!
        return data
    }
    
    func getIcondImage()->UIImage
    {
        return UIImage(data:self.downloadIcon())!
    }
    
    func downloadLogo()->NSURLRequest
    {
        var url:String = "http://media.steampowered.com/steamcommunity/public/images/apps/\(appid)/\(logoHash).jpg"
        return NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5)
    }
    
    func downloadNews()->NSURLRequest
    {
        var url:String = "http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=\(appid)&count=1&maxlength=200&format=json"
        return NSURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5)
    }
    
    func downloadAchieveMents()->Array<SteamAchievementsObject>?
    {
        var url:String = "http://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v0001/?appid=\(appid)&key=\(APIKEY)&steamid=\(STEAMID)"
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        var sAchs = Array<SteamAchievementsObject>()
        if(data != nil)
        {
            let json = JSON (data:data!)
            let acheivementsArray:Array = json["playerstats"]["achievements"].array!

            
            for item in acheivementsArray
            {
                sAchs.append(SteamAchievementsObject(info: item))
            }
            
        
            
        
        }
        
        self.achievements = sAchs
        return sAchs
    }


}