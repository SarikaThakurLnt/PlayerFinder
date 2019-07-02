//
//  NetworkService.swift
//  PlayerFinder
//
//  Created by Sarika on 27/06/19.
//  Copyright © 2019 Airadmin. All rights reserved.
//

import Foundation

class NetworkService
{
    /**
     * Use to communicate with server and notifies with server response
     - parameter wsURL: alias to form Web API.
     - parameters: request parameters to be send with request
     - withDelegate parameters: delegate to send server response.
     */
    class func getData(_ wsURL: String,  parameters : Dictionary <String,Any>?, completion: @escaping ((Data?, Error?) ->Void))
    {
        if AppUtility.isValid(wsURL)
        {
            var requestUrl : String = ""
            if wsURL.contains(BASE_WS_URL)
            {
                requestUrl = wsURL
            }
            else
            {
                requestUrl = BASE_WS_URL + wsURL
            }
            var requestDict = parameters
            var urlComponents = URLComponents(string: requestUrl)!
            let keyQueryItem = URLQueryItem(name: "apikey", value: API_KEY)
            var arrQueryItems = [URLQueryItem]()
            arrQueryItems.append(keyQueryItem)
            urlComponents.queryItems?.append(keyQueryItem)
            if let keyArr = requestDict?.keys
            {
                for key in Array(keyArr)
                {
                    arrQueryItems.append(URLQueryItem(name: key, value: (requestDict![key] as! String)))
                }
            }
            urlComponents.queryItems = arrQueryItems
            if let url = urlComponents.url
            {
                var request = URLRequest(url: url )
                request.httpMethod = "GET"
                URLSession.shared.dataTask(with: request, completionHandler: { receivedData, response, error -> Void in
                    if let receivedData = receivedData
                    {
                        let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                        print("response is \(String(describing: response))")
                        completion(receivedData, nil)
                    }
                    else
                    {
                        completion(nil, (error!.localizedDescription as! Error))
                    }
                }).resume()
            }
        }
    }
    
    class func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ())
    {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    class func getSearchData (_ wsURL: String,  parameters : Dictionary <String,String>?, completion: @escaping ((SearchPlayerResponse?, Error?) ->Void))
    {
        let url = URL(string: wsURL)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                if let playerData  = try? decoder.decode(SearchPlayerResponse.self, from: data)
                {
                    completion(playerData,nil)
                }
                else
                {
                    throw (ErrorStatement.FoundNil("Player Data"))
                }
            }
            catch
            {
                completion(nil, (error.localizedDescription as! Error))
            }
        }
        task.resume()
    }
    
}
