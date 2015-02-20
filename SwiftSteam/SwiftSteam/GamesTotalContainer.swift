//
//  GamesTotalContainer.swift
//  SwiftSteam
//
//  Created by Kyle Sebestyen on 2/15/15.
//  Copyright (c) 2015 15three. All rights reserved.
//

import Foundation
class GamesTotalContainer:NSObject
{
    var totalMinutesPlayedInAllGames:Int = 0
    var longestGamePlay:SteamGame?
    
    override init()
    {
        super.init()
    }
}