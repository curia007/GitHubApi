//
//  ViewController.swift
//  GithubClient
//
//  Created by Carmelo I. Uria on 5/11/17.
//  Copyright © 2017 Carmelo I. Uria. All rights reserved.
//

import UIKit
import GithubServices

class GithubClientViewController: UIViewController
{
    let githubService : GithubService = GithubService()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        githubService.retrievePullRequests("magicalpanda", repos: "MagicalRecord")
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

