//
//  HighScoreRouter.swift
//  highscoreserverPackageDescription
//
//  Created by Frank Saar on 17/09/2017.
//

import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import SwiftyJSON


extension HighscoreItem {
    init?(with json :JSON)  {
        guard let jsonName = json["name"].string,
            let jsonTime = json["time"].float,
            let jsonMoves = json["moves"].int else {
                return nil
        }
        position = nil
        identifier = NSUUID().uuidString
        name = jsonName
        time = jsonTime
        moves = jsonMoves
    }
}

class HighScoreRouter {
    let highScore = Highscore()
    
    func postScore(request : RouterRequest,response : RouterResponse, next : @escaping () -> Void) throws -> Void {
        guard let json = request.body?.asJSON else {
            try response.status(.badRequest).end()
            return
        }
        if let item = HighscoreItem(with: json) {
            highScore.addScore(item)
        }
        _ = response.send(status: .OK)
        next()
    }
    
   
    func getJSONScores(request : RouterRequest,response : RouterResponse, next : @escaping () -> Void) throws -> Void {
        let list = highScore.all()
        defer {
            next()
        }
        guard let jsonData = try? JSONEncoder().encode(list) else {
            response.status(.OK).send(json: [[]])
            return
        }
        let jsonArray = JSON(data:jsonData).arrayObject ?? []
        response.status(.OK).send(json: jsonArray)
    }
    
    func getHTMLScores(request : RouterRequest,response : RouterResponse, next : @escaping () -> Void) throws -> Void {
        defer {
            next()
        }
        let list = highScore.all()
        let descriptions = list.map { [($0.position ?? 0)+1,$0.name,$0.time,$0.moves] }
        let context = ["highscore" : descriptions]
        try response.render("home", context: context)
        
    }
}
