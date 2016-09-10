//
//  TTTBackendClient.swift
//  TicTacToe
//
//  Created by Frank Saar on 29/08/2016.
//  Copyright © 2016 SAMedialabs. All rights reserved.
//

import Foundation

class TTTBackendClient {
    let path = "https://fathomless-wildwood-36205.herokuapp.com/config"
    let session = URLSession(configuration: .default)
    init() {
        
    }
    
    func config(forStates states: String, usingCompletionBlock completionBlock : ((String?)->())?) {
        var components = URLComponents(string: path)
        components?.query = "\(states)"
        if let url = components?.url {
            let request = URLRequest(url: url)
            let dataTask = self.session.dataTask(with: request) { data,response,error in
                if let data = data {
                    OperationQueue.main.addOperation {
                        let configString = String(data: data, encoding:String.Encoding.utf8)
                        completionBlock?(configString)
                    }
                }
                else {
                    completionBlock?(nil)
                }
            }
            dataTask.resume()
        }
    }
}
