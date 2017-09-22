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
    
    fileprivate lazy var session = URLSession(configuration: URLSessionConfiguration.default)
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
}
