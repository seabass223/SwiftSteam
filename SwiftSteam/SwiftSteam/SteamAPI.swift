//
//  SteamAPI.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/3/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import Foundation

protocol SteamAPIProtocol
{
    func SteamAPIDidLoadGameLogo(game:SteamGame)
    func SteamAPIDidLoadAllGames()
}



class SteamAPI:NSObject, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate{
    
    let cacheURL:NSURL = NSURL(string:"\(NSHomeDirectory())/Library/Caches/")!
    var session:NSURLSession?
    var downloadQueue:NSOperationQueue?
    var downloadLookup:Dictionary<String,SteamGame>?
    var delegate: SteamAPIProtocol?
 
    
    override init()
    {
        super.init()
        downloadLookup = Dictionary<String,SteamGame>()
        downloadQueue = NSOperationQueue()
        downloadQueue?.maxConcurrentOperationCount = 1
        var config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.URLCache = NSURLCache.sharedURLCache()
        config.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad;
        session = NSURLSession(configuration:config, delegate: self, delegateQueue: downloadQueue)

    }
    
    var apiURL = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=\(APIKEY)&steamid=\(STEAMID)&include_appinfo=1&format=json"

    //https://developer.valvesoftware.com/wiki/Steam_Web_API#GetOwnedGames_.28v0001.29
    func GetMyGames() -> Array<SteamGame>? {

        if let jData = NSData(contentsOfURL: NSURL(string: apiURL)!){
            let json = JSON (data:jData)
            var sGames = Array<SteamGame>()
            
            let jGames:Array = json["response"]["games"].array!
            for jGame in jGames
            {
                var g:SteamGame = SteamGame(info: jGame)
                sGames.append(g)
            }
            
            return sGames
        }
        else{
            println("could not get steam games")
            return nil
        }
    }
    
    func DownloadGameNews(game:SteamGame)
    {
        let request = game.downloadNews()
        var cachedResponse = NSURLCache.sharedURLCache().cachedResponseForRequest(request)
        if(cachedResponse == nil){
            let task = session?.downloadTaskWithRequest(request)
            downloadLookup![request.URL.absoluteString!] = game
            task?.resume()
        }
        else if (delegate != nil){
            game.logoData = cachedResponse!.data
            delegate?.SteamAPIDidLoadGameLogo(game);
        }

        
    }
    
    func DownloadGameLogo(game:SteamGame)
    {
        let request = game.downloadLogo()
        
        var cachedResponse = NSURLCache.sharedURLCache().cachedResponseForRequest(request)
        if(cachedResponse == nil){
            let task = session?.downloadTaskWithRequest(request)
            downloadLookup![request.URL.absoluteString!] = game
            task?.resume()
        }
        else if (delegate != nil){
            game.logoData = cachedResponse!.data
            delegate?.SteamAPIDidLoadGameLogo(game);
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL){
         println("Done downloading: \(location)")
        
        let data = NSData(contentsOfURL: location)!
        var cache = NSCachedURLResponse(response: downloadTask.response!, data:data)
        NSURLCache.sharedURLCache().storeCachedResponse(cache, forRequest: downloadTask.originalRequest)
        
        let key = downloadTask.originalRequest.URL.absoluteString!
        if(delegate != nil && downloadLookup![key] != nil)
        {
            let game = downloadLookup![key]
            game?.logoData = data
            downloadLookup!.removeValueForKey(key)
            
            delegate?.SteamAPIDidLoadGameLogo(game!)
            if(downloadLookup!.keys.array.count == 0){
                delegate?.SteamAPIDidLoadAllGames()
            }
        }
    }
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        var progress:Float = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        println("\(progress) from \(totalBytesWritten) / \(totalBytesExpectedToWrite)")
    }
}