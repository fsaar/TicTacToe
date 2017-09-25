//
//  TTTBackendClient.swift
//  TicTacToe
//
//  Created by Frank Saar on 21/09/2017.
//  Copyright © 2017 SAMedialabs. All rights reserved.
//

import Foundation

enum TTTNetworkManagerErrorType : Error {
    case InvalidURL(String)
}

class TTTNetworkManager {
    public static let shared =  TTTNetworkManager()
    fileprivate lazy var session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    fileprivate let baseURL = URL(string:"http://127.0.0.1:8090")

    public func getDataWithRelativePath(_ path: String , completionBlock:@escaping ((_ data : Data?,_ error:Error?) -> Void)) {
        guard let url = URL(string:path,relativeTo:baseURL) else {
            completionBlock(nil,TTTNetworkManagerErrorType.InvalidURL(path))
            return
        }
        let task = self.session.dataTask(with: url, completionHandler: { (data, _, error) -> (Void) in
            completionBlock(data,error)
        })
        task.resume()
    }
    
    public func postData(data : Data,withRelativePath path: String , completionBlock: ((_ error:Error?) -> Void)? = nil) {
        guard let url = URL(string:path,relativeTo:baseURL) else {
            completionBlock?(TTTNetworkManagerErrorType.InvalidURL(path))
            return
        }
        
        var mutableRequest = URLRequest(url: url)
        mutableRequest.httpMethod = "POST"
        mutableRequest.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
     
        let task = self.session.uploadTask(with: mutableRequest, from: data) { _, _, error in
            completionBlock?(error)
        }
        task.resume()
        
    }
}


