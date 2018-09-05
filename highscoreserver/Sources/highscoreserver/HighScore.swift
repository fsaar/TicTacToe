//
//  HighScore.swift
//  highscoreserverPackageDescription
//
//  Created by Frank Saar on 16/09/2017.
//

import Foundation

struct HighscoreItem : Codable,Equatable,CustomStringConvertible {
    public var description: String {
        guard let position = position else {
            return "\(name) \t\t \(time) \(moves)"
        }
        return "\(position).\t\t \(name) \t \(time) \(moves)"
    }
    let position : Int?
    let name : String
    let time : Float
    let moves : Int
    let identifier : String?
    
    static func item(with json :[String : Any]) -> HighscoreItem? {
        guard let jsonName = json["name"] as? String,
            let jsonTime = json["time"] as? Float,
            let jsonMoves = json["moves"] as? Int else {
                return nil
        }
        let identifier = NSUUID().uuidString
        let name = jsonName
        let time = jsonTime
        let moves = jsonMoves
        return HighscoreItem(position: nil, name: name, time: time, moves: moves, identifier: identifier)
    }
    
    func item(with position: Int) -> HighscoreItem {
        return HighscoreItem(position: position, name: name, time: time, moves: moves, identifier: identifier)
    }
    
    static func ==(lhs : HighscoreItem, rhs: HighscoreItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

class Highscore {
    let filePath : URL? =  {
        let filename = "highscore"
        guard let newPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
        }
        let url = newPath.appendingPathComponent(filename)
        return url
    }()
    var list : [HighscoreItem] = [] {
        didSet {
            if list != oldValue  {
                save(highscore:list)
            }
        }
    }
    
    init() {
        list = loadHighscore()
    }

    func addScore(_ score : HighscoreItem) {
        list = newList(with: score)
    }
    
    func all() -> [HighscoreItem] {
        return list
    }
}


//MARK: Private
fileprivate extension Highscore {
    func newList(with item : HighscoreItem) -> [HighscoreItem] {
        return (list + [item]).sorted { $0.time < $1.time }.enumerated().map { index,item in
            return item.item(with: index)
        }
    }
    
    func save(highscore : [HighscoreItem]) {
        guard let url = self.filePath,let data = try? JSONEncoder().encode(highscore) else {
            return
        }
            
        _ = try? data.write(to: url, options: .atomicWrite)
    }
    
    func loadHighscore() -> [HighscoreItem] {
        guard let url = filePath,FileManager.default.fileExists(atPath:url.path),let data = try? Data(contentsOf: url) else {
            return []
        }
        let list = try? JSONDecoder().decode([HighscoreItem].self,from:data)
        return list ?? []
    }
}
