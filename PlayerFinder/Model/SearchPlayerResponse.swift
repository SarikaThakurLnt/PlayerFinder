//
//  SearchPlayerResponse.swift
//  PlayerFinder
//
//  Created by Sarika Thakur on 01/07/19.
//  Copyright © 2019 Airadmin. All rights reserved.
//

import Foundation

struct SearchPlayerResponse : Codable
{
    var data : [SearchPlayerData]
}

struct SearchPlayerData : Codable
{
    var pid : Int
    var fullName : String
    var name : String
}


