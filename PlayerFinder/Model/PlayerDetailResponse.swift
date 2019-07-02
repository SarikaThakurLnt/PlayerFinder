//
//  PlayerDetailResponse.swift
//  PlayerFinder
//
//  Created by Sarika on 27/06/19.
//  Copyright © 2019 Airadmin. All rights reserved.
//

import Foundation

struct PlayerDetail
{
    var title : String
    var highlight : Bool
    var isOpen : Bool
    var sectionType : TableSection
    var skillDetail : [SkillDetail]
}

struct SkillDetail
{
    var skillKey : String
    var skillValue : String
}

enum TableSection : Int{
    case Bio = 0
    case Batting
    case Bowling
}

