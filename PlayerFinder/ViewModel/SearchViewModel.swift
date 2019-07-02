//
//  SearchViewModel.swift
//  PlayerFinder
//
//  Created by Sarika on 02/07/19.
//  Copyright © 2019 Airadmin. All rights reserved.
//

import Foundation

class SearchViewModel
{
     var data : [SearchPlayerData] = []
    
    func searchPlayer(_ userNameToSearch:String, completion: @escaping ((Bool, Error?) ->Void))
    {
        NetworkService.getData(PlAYER_FINDER_WS_URL, parameters: ["name": userNameToSearch], completion: { (responseData, error) in
            guard error == nil, let responseData = responseData else {
                //handle the error here
                return
            }
            do {
                let decoder = JSONDecoder()
                if let playerData  = try? decoder.decode(SearchPlayerResponse.self, from: responseData)
                {
                    DispatchQueue.main.async
                        {
                            self.data.removeAll()
                            self.data = playerData.data
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
    
    
    

    
    
}
