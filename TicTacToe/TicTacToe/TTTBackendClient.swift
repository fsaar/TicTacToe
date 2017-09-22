//
//  TTTBackendClient.swift
//  TicTacToe
//
//  Created by Frank Saar on 21/09/2017.
//  Copyright © 2017 SAMedialabs. All rights reserved.
//

import Foundation

enum TTTBackendClientAPI : String {
    case highscore = "highscore.json"
}
enum TTTBackendClientError : Error {
    case decoderError
}

class TTTBackendClient {
    let manager = TTTNetworkManager.shared
    
    func getHighScore(callBack onQueue: OperationQueue = OperationQueue.main, using completionBlock: ((_ highscore: [TTTHighscore],_ error : Error?) -> ())? = nil) {
        manager.getDataWithRelativePath(TTTBackendClientAPI.highscore.rawValue) { data, error in
            
            if let data = data,
                let highscore = try? JSONDecoder().decode([TTTHighscore].self, from: data) {
                onQueue.addOperation({
                    completionBlock?(highscore,nil)
                })
            }
            onQueue.addOperation({
                let err = error ?? TTTBackendClientError.decoderError
                completionBlock?([],err)
            })
        }
    }
    
    func postHigscore(with name : String,moves : Int, time : Float,callBack onQueue: OperationQueue = OperationQueue.main,using completionBlock: ((_ error : Error?) -> ())? = nil) {
        let dict : [String : Any] = [ "name" : name, "moves" : moves, "time" : 0.0]
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            manager.postData(data: data, withRelativePath: TTTBackendClientAPI.highscore.rawValue) { error in
                onQueue.addOperation({
                    completionBlock?(error)
                })
            }
        }
    }
}
