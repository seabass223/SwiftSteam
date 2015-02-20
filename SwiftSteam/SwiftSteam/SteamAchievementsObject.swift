//
//  SteamAchievementsObject.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/15/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import Foundation
class SteamAchievementsObject : NSObject
{
    var achieved = false
    var name = ""
    
    init(info:JSON)
    {
        name = info["apiname"].stringValue
        achieved = info["achieved"].boolValue
    }
}