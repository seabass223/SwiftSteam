// Playground - noun: a place where people can play

import UIKit

class Game{
    
    var name:String = ""
    var iconURL:String = ""
    var logoURL:String = ""
    var minutesPlayed = 0
    
    init(info:NSDictionary)
    {
        //self.name = info["name"] ?.stringValue
        //self.iconURL = info["img_icon_url"]
        //self.logoURL = info["img_logo_url"]
        // self.minutesPlayed = info["playtime_forever"]
    }
    
}


var str = "Hello, playground"




var apiURL = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=4A5F242E500E0A0F5763F1F9DBFFDAEE&steamid=76561197990901282&include_appinfo=1&format=json"


func getJSON(urlToRequest: String) -> NSData{
    return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
}

func parseJSON(inputData: NSData) -> NSDictionary{

    json
    
    var error: NSError?
    var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
    
    return boardsDictionary
}

println("hello")
//var data:NSData = getJSON(apiURL)
//var mySteamGamesData:NSDictionary = parseJSON(data)
//var mySteamGamesArray:Array = mySteamGamesData["games"]
//
//for item in mySteamGamesArray {
//    var g:Game = Game(item)
//}

//var g:Game = Game()
