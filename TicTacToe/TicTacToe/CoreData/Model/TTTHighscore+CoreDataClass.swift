//
//  TTTHighscore+CoreDataClass.swift
//  TicTacToe
//
//  Created by Frank Saar on 21/09/2017.
//  Copyright © 2017 SAMedialabs. All rights reserved.
//
//

import Foundation
import CoreData


@objc(TTTHighscore)
public class TTTHighscore: NSManagedObject,Codable {
    enum TTTHighscore : Error {
        case decoder_no_entity_description
    }

    private enum CodingKeys : String,CodingKey {
        case position
        case name
        case time
        case moves
        case identifier
      
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.position, forKey: .position)
        try container.encode(self.moves, forKey: .moves)
        try container.encode(self.time, forKey: .time)
        try container.encode(self.identifier, forKey: .identifier)
    }
    
    public required override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required init(from decoder: Decoder) throws {
        let context = TTTCoreDataStack.sharedDataStack.privateQueueManagedObjectContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: String(describing:TTTHighscore.self), in: context) else {
            throw TTTHighscore.decoder_no_entity_description
        }
        super.init(entity: entityDescription, insertInto: context)
        
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            name = try? container.decode(String.self, forKey: .name)
            position = (try? container.decode(Int16.self, forKey: .position)) ?? 0
            moves = (try? container.decode(Int16.self, forKey: .moves)) ?? 0
            time = (try? container.decode(Float.self, forKey: .time)) ?? 0
            identifier = try? container.decode(String.self, forKey: .identifier)
        }
    }
    
    public init(from dict: [String : Any], with context : NSManagedObjectContext) throws {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: String(describing:TTTHighscore.self), in: context) else {
            throw TTTHighscore.decoder_no_entity_description
        }
        super.init(entity: entityDescription, insertInto: context)
        
        name = dict[CodingKeys.name.rawValue] as? String
        position = dict[CodingKeys.position.rawValue] as? Int16 ?? 0
        moves = dict[CodingKeys.moves.rawValue] as? Int16 ?? 0
        time = dict[CodingKeys.time.rawValue] as? Float ?? 0
        identifier = dict[CodingKeys.identifier.rawValue] as? String
    }
}




