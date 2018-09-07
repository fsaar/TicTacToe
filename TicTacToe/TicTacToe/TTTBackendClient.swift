//
//  TTTBackendClient.swift
//  TicTacToe
//
//  Created by Frank Saar on 21/09/2017.
//  Copyright © 2017 SAMedialabs. All rights reserved.
//
import CoreData
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
        manager.getDataWithRelativePath(TTTBackendClientAPI.highscore.rawValue) { [weak self] data, error in
            
            if let data = data,
            let highscores = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]] {
                self?.merge(highscores: highscores)
                onQueue.addOperation {
                    completionBlock?([],nil)
                }
            }
            else {
                onQueue.addOperation {
                    let err = error ?? TTTBackendClientError.decoderError
                    completionBlock?([],err)
                }
            }
        }
    }
    
    func postHigscore(with name : String,moves : Int, time : Float,callBack onQueue: OperationQueue = .main,using completionBlock: ((_ error : Error?) -> ())? = nil) {
        let dict : [String : Any] = [ "name" : name, "moves" : moves, "time" : time]
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            manager.postData(data: data, withRelativePath: TTTBackendClientAPI.highscore.rawValue) { error in
                onQueue.addOperation {
                    completionBlock?(error)
                }
            }
        }
    }
}

/// MARK: Helper

extension TTTBackendClient {
    func dictionary(with identifier : String, in list: [[String : Any]]) -> [String : Any]? {
        let dict = list.filter { dict in
            let id = dict["identifier"] as? String ?? ""
            return id == identifier
        }.first
        return dict
    }
    func merge(highscores : [[String : Any]]) {
        let fetchRequest = NSFetchRequest<TTTHighscore>(entityName:String(describing:TTTHighscore.self))
        let context = TTTCoreDataStack.sharedDataStack.privateQueueManagedObjectContext
        defer {
            context.perform {
                try? context.save()
            }
        }
        context.performAndWait {
            var scores : [TTTHighscore]? = nil
            scores =  try? context.fetch(fetchRequest)
            
            guard let oldScores = scores else {
                _ = highscores.compactMap { try? TTTHighscore(from: $0, with: context)}
                return
            }
            let oldIdentifiers = oldScores.compactMap { $0.identifier }
            let newIdentifiers = highscores.compactMap { dict in dict["identifier"] as? String }
            let oldIdentifiersSet  = Set(oldIdentifiers)
            let newIdentifiersSet = Set(newIdentifiers)
            let toBeInserted = newIdentifiersSet.subtracting(oldIdentifiersSet)
            let toBeDeleted = oldIdentifiersSet.subtracting(newIdentifiersSet)
            let toBeUpdated = oldIdentifiersSet.intersection(newIdentifiersSet)
            toBeUpdated.forEach { identifier in
                let oldScore = oldScores.filter { $0.identifier == identifier}.first
                let newScoreDict = dictionary(with: identifier, in: highscores)
                if let oldScore = oldScore, let position = newScoreDict?["position"] as? Int16 {
                    oldScore.position = position
                }
            }
            
            toBeDeleted.forEach { identifier in
                if let oldScore = oldScores.filter ({ $0.identifier == identifier}).first {
                    context.delete(oldScore)
                }
            }
            
            toBeInserted.forEach { identifier  in
                if let newScoreDict = dictionary(with: identifier, in: highscores) {
                    _ = try? TTTHighscore(from: newScoreDict, with: context)
                }
            }
        }
        
    }
}
