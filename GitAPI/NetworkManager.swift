//
//  NetworkManager.swift
//  GitAPI
//
//  Created by Tharun on 01/12/17.
//  Copyright © 2017 Tharun. All rights reserved.
//

import Foundation

typealias networkCompletionHanlder = (_ response: URLResponse?, _ json: AnyObject?, _ error: Error?) -> (Void)

class NetworkManager: NSObject {
    
    static let shared: NetworkManager! = NetworkManager()
    
    private override init() {
        super.init()
    }
    
    func getPublicRepositories(forUser username:String, _ completionHandler: @escaping networkCompletionHanlder) {
        let baseUrlStr: String = "https://api.github.com/users/\(username)/repos"
        let url = URL(string: baseUrlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if let url = url {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completionHandler(response, nil, error)
                    }else if let jsonData = data {
                        let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                        completionHandler(response!, json as AnyObject, error)
                    }
                }
            })
            dataTask.resume()
        }
    }
}
