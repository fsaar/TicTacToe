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



class HighScoreRouter {
    let highScore = Highscore()
    
    func postScore(request : RouterRequest,response : RouterResponse, next : @escaping () -> Void) throws  {
        guard let json = request.body?.asJSON else {
            try response.status(.badRequest).end()
            return
        }
        if let item = HighscoreItem.item(with: json) {
            highScore.addScore(item)
        }
        _ = response.send(status: .OK)
        next()
    }
    
   
    func getJSONScores(request : RouterRequest,response : RouterResponse, next : @escaping () -> Void) throws {
        let list = highScore.all()
        defer {
            next()
        }
        response.status(.OK).send(json: list)
    }
    
    func getHTMLScores(request : RouterRequest,response : RouterResponse, next : @escaping () -> Void) throws {
        defer {
            next()
        }
        let list = highScore.all()
        let descriptions = list.map { [($0.position ?? 0)+1,$0.name,$0.time,$0.moves] }
        let context = ["highscore" : descriptions]
        try response.render("home", context: context)
        
    }
}
