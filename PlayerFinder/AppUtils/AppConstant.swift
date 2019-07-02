//
//  AppConstant.swift
//  PlayerFinder
//
//  Created by Sarika on 27/06/19.
//  Copyright © 2019 Airadmin. All rights reserved.
//

import Foundation

let SERVER_ADDRESS = "https://cricapi.com/"

let BASE_WS_URL  = SERVER_ADDRESS + "api/"

//MARK: - Player Services
let PlAYER_FINDER_WS_URL = BASE_WS_URL + "playerFinder"
let PLAYER_STATS_WS_URL = BASE_WS_URL + "playerStats"

//MARK: - API Key
let API_KEY = "UgWxMDCmKcMmvVBMtLHJVcVOUSO2"

let STATUS = "status"
let MSG = "msg"
let RESULT = "result"
let ERROR = NSLocalizedString("Error", comment: "")
let OK = NSLocalizedString("OK", comment: "")
let DELETE = NSLocalizedString("Delete", comment: "")
let CANCEL = NSLocalizedString("Cancel", comment: "")
let DATA = "data"

let ACTIVITY_INDICATOR_TAG = 001

enum ErrorStatement: Error {
    case FoundNil(String)
}
