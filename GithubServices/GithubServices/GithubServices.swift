//
//  GithubServices.swift
//  GithubServices
//
//  Created by Carmelo I. Uria on 5/11/17.
//  Copyright © 2017 Carmelo I. Uria. All rights reserved.
//

import Foundation

public let PROCESSED_GITHUB_SERVICE_PULL_REQUEST: String = "PROCESSED_GITHUB_SERVICE_PULL_REQUEST"
public let PROCESSED_GITHUB_SERVICE_PULL_REQUEST_BY_NUMBER: String = "PROCESSED_GITHUB_SERVICE_PULL_REQUEST_BY_NUMBER"
public let PROCESSED_GITHUB_SERVICE_PULL_REQUEST_FILES: String = "PROCESSED_GITHUB_SERVICE_PULL_REQUEST_FILES"

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
        let urlString : String = HOST + REPOS + "/" + owner + "/" + repos + "/" + PULLS + "?state=open"
        let url : URL = URL(string: urlString)!
        
        debugPrint("[\(#function)] url: \(url)")
        
        let request : URLRequest = URLRequest(url: url)
        
        //GitHub doesn't allow Personal Access Tokens.  Needed to setup OAuth, but didn't have an authorized callback URL
        //request.allHTTPHeaderFields = authorization
        
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
                                
                                //debugPrint("[\(#function)] json: \(String(describing: jsonResult))")
                            
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
                        debugPrint("[\(#function)] Service Call failure: status code: \(httpResponse.statusCode)")
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
    
    public func retrievePullRequest(_ owner: String, repos: String, number: Int32)
    {
        //https://api.github.com/repos/magicalpanda/MagicalRecord/pulls/1228
        
        let urlString : String = HOST + REPOS + "/" + owner + "/" + repos + "/" + PULLS + "/" + String(number)
        let url : URL = URL(string: urlString)!
        
        debugPrint("[\(#function)] url: \(url)")
        
        let request : URLRequest = URLRequest(url: url)
        
        //GitHub doesn't allow Personal Access Tokens
        //request.allHTTPHeaderFields = authorization
        
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
                                
                                //debugPrint("[\(#function)] json: \(String(describing: jsonResult))")
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: PROCESSED_GITHUB_SERVICE_PULL_REQUEST_BY_NUMBER), object: jsonResult)
                                
                            }
                            catch
                            {
                                print("JSON Processing Failed")
                            }
                        }
                    }
                    else
                    {
                        debugPrint("[\(#function)] Service Call failure: status code: \(httpResponse.statusCode)")
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
    
    public func retrievePullRequestFileChanges(_ owner: String, repos: String, number: Int32)
    {
        //https://api.github.com/repos/magicalpanda/MagicalRecord/pulls/1228
        
        let urlString : String = HOST + REPOS + "/" + owner + "/" + repos + "/" + PULLS + "/" + String(number) + "/files"
        let url : URL = URL(string: urlString)!
        
        debugPrint("[\(#function)] url: \(url)")
        
        var request : URLRequest = URLRequest(url: url)
        
        //GitHub doesn't allow Personal Access Tokens
        //request.allHTTPHeaderFields = authorization
        
        //Add Accept header
        request.addValue("application/vnd.github.v3.diff", forHTTPHeaderField: "Accept")
        
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
                                
                                //debugPrint("[\(#function)] json: \(String(describing: jsonResult))")
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: PROCESSED_GITHUB_SERVICE_PULL_REQUEST_FILES), object: jsonResult)
                                
                            }
                            catch
                            {
                                print("JSON Processing Failed")
                            }
                        }
                    }
                    else
                    {
                        debugPrint("[\(#function)] Service Call failure: status code: \(httpResponse.statusCode)")
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

