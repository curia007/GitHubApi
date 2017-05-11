//
//  GithubServices.swift
//  GithubServices
//
//  Created by Carmelo I. Uria on 5/11/17.
//  Copyright © 2017 Carmelo I. Uria. All rights reserved.
//

import Foundation

public let PROCESSED_GITHUB_SERVICE_PULL_REQUEST: String = "PROCESSED_GITHUB_SERVICE_PULL_REQUEST"

public class GithubService : NSObject
{
    private let HOST: String = "https://api.github.com/"
    
    private let REPOS : String = "repos"
    private let PULLS : String = "pulls"
    
    //private let PULL_REQUEST  : String = "repos/magicalpanda/MagicalRecord/pulls"
    
    //private let personalToken: String = "cd5a8dee2a0ad1b82a514ce1e1f02196d027a5b0"
    
    private var session: URLSession?
    private var dataSessionTask: URLSessionDataTask?
    private let authorization : [String : String] = ["Authorization" : "token c5dda78451314480d41c5a981e306433176b1319"]
    
    override public init()
    {
        super.init()
    }
    
    public func retrievePullRequests(_ owner: String, repos: String)
    {
        let urlString : String = HOST + REPOS + "/" + owner + "/" + repos + "/" + PULLS
        let url : URL = URL(string: urlString)!
        
        debugPrint("[\(#function)] url: \(url)")
        
        var request : URLRequest = URLRequest(url: url)
        request.allHTTPHeaderFields = authorization
        
        self.dataSessionTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if (error == nil)
            {
                if (response != nil)
                {
                    let httpResponse: HTTPURLResponse = response as! HTTPURLResponse
                    
                    if (httpResponse.statusCode == 200)
                    {
                        debugPrint("[\(#function)] status code: \(httpResponse.statusCode)")
                        
                        if let urlContent = data
                        {
                            do
                            {
                                let jsonResult : Any = try JSONSerialization.jsonObject(with: urlContent, options:
                                    JSONSerialization.ReadingOptions.mutableContainers)
                                
                                debugPrint("[\(#function)] json: \(String(describing: jsonResult))")
                            
                                NotificationCenter.default.post(name: Notification.Name(rawValue: PROCESSED_GITHUB_SERVICE_PULL_REQUEST), object: jsonResult)

                            }
                            catch
                            {
                                print("JSON Processing Failed")
                            }
                        }
                    }
                    else
                    {
                        debugPrint("[\(#function)] status code: \(httpResponse.statusCode)")
                    }
                }
            }
            else
            {
                print("\(#function):: error: \(error?.localizedDescription ?? "Lotto Processing Error...")")
            }
            
            
        })
        
        self.dataSessionTask?.resume()
    }
}

