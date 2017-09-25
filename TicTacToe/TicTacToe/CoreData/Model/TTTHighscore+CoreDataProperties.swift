//
//  TTTHighscore+CoreDataProperties.swift
//  TicTacToe
//
//  Created by Frank Saar on 23/09/2017.
//  Copyright © 2017 SAMedialabs. All rights reserved.
//
//

import Foundation
import CoreData


extension TTTHighscore {

    @NSManaged public var identifier: String?
    @NSManaged public var moves: Int16
    @NSManaged public var name: String?
    @NSManaged public var position: Int16
    @NSManaged public var time: Float

}
