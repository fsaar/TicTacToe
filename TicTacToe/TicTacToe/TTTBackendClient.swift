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
}
