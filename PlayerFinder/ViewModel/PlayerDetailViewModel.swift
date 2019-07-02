//
//  PlayerDetailViewModel.swift
//  PlayerFinder
//
//  Created by Sarika on 02/07/19.
//  Copyright © 2019 Airadmin. All rights reserved.
//

import Foundation

class PlayerDetailViewModel
{
    var data : [PlayerDetail] = []
    var removeKeyList = ["provider","ttl","creditsLeft","pid", "data", "v", "imageURL", "fullName"]
    var profileImageUrlStr = ""
    var pidStr = ""
    
    func downloadImage(completion: @escaping ((Data?, Error?) ->Void))
    {
        NetworkService.getImageData(from: URL(string: profileImageUrlStr)!) { data, response, error in
            guard let data = data, error == nil
                else
            {
                return
            }
            DispatchQueue.main.async() {
                completion(data, nil)
            }
        }
    }

    func getData(completion: @escaping ((Bool, Error?) ->Void))
    {
        NetworkService.getData(PLAYER_STATS_WS_URL, parameters: ["pid":pidStr], completion: { (data, error) in
            guard error == nil, let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                {
                    self.profileImageUrlStr = AppUtility.isValid(json["imageURL"] as? String) ? json["imageURL"] as! String : ""
                    var skillDetail = [SkillDetail]()
                    for bioKey in Array(json.keys)
                    {
                        if !(self.checkKeyPresent(bioKey))
                        {
                            let skillValue = AppUtility.isValid(json[bioKey] as? String) ? (json[bioKey] as! String) : ""
                            if bioKey == "name"
                            {
                                skillDetail.insert((SkillDetail(skillKey : bioKey, skillValue : skillValue)), at: 0)
                            }
                            else
                            {
                                skillDetail.append(SkillDetail(skillKey : bioKey, skillValue : skillValue))
                            }
                        }
                    }
                    self.data.append(PlayerDetail(title : "Bio", highlight : true, isOpen : true, sectionType: .Bio , skillDetail : skillDetail))
                    if let skillData = json["data"] as? [String : Any]
                    {
                        for skillKey in skillData.keys
                        {
                            skillDetail = []
                            
                            let sectionType : TableSection = skillKey == "batting" ? .Batting : .Bowling
                            self.data.append(PlayerDetail(title : skillKey, highlight : true, isOpen : false, sectionType: sectionType , skillDetail : skillDetail))
                            skillDetail = []
                            
                            if let gameType = skillData[skillKey] as? [String : Any]
                            {
                                if gameType.keys.count == 0
                                {
                                    self.data.removeLast()
                                }
                                for gameKey in gameType.keys
                                {
                                    if let gameDetails = gameType[gameKey] as? [String : Any]
                                    {
                                        for key in Array(gameDetails.keys)
                                        {
                                            skillDetail.append(SkillDetail(skillKey : key, skillValue : gameDetails[key] as! String))
                                        }
                                        self.data.append(PlayerDetail(title : gameKey, highlight : false , isOpen : false, sectionType: sectionType, skillDetail : skillDetail))
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async
                        {
                            completion(true, nil)
                    }
                }
                else
                {
                    throw (ErrorStatement.FoundNil("PlayerData"))
                }
            }
            catch
            {
                print("Error: \(error)")
            }
        })
        
    }

    func checkKeyPresent( _ toSearchKey : String) -> Bool
    {
        var isPresent = false
        for key in removeKeyList
        {
            if key == toSearchKey
            {
                isPresent = true
                break
            }
        }
        return isPresent
    }

}
