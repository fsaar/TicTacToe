//
//  TTTBoardConfig.swift
//  TicTacToe
//
//  Created by Frank Saar on 28/08/2016.
//  Copyright © 2016 SAMedialabs. All rights reserved.
//

import Foundation


enum TTTBoardControllerState {
    case started
    case ended
}

public enum TTTState {
    case undefined
    case greenSelected
    case redSelected
}



public struct TTTBoardPosition : Equatable {
    var column : Int
    let row : Int
    var isValid : Bool {
        let valid =  (0...2 ~= self.column) && (0...2 ~= self.row)
        return valid
    }
    
    static public func ==(lhs : TTTBoardPosition, rhs :  TTTBoardPosition) -> Bool {
        return (lhs.column,lhs.row) == (rhs.column,rhs.row)
    }
    
    func toIndex() -> Int {
        return row * 3 + column
    }
    
    init( fromIndex index : Int) {
        column = index % 3
        row = index / 3
    }
    init (column : Int, row : Int) {
        self.column = column
        self.row = row
    }
}


public class TTTBoardPositionGenerator: IteratorProtocol {
    var currentPos: TTTBoardPosition
    init() {
        currentPos = TTTBoardPosition(column: -1 , row:0)
    }
    public func next() -> TTTBoardPosition? {
        currentPos = TTTBoardPosition(column: currentPos.column + 1 , row: currentPos.row)
        if currentPos.column < 3  {
            return currentPos
        }
        currentPos = TTTBoardPosition(column: 0 , row: currentPos.row + 1)
        currentPos.column = 0
        
        if (currentPos.row < 3) {
            return currentPos
        }
        return nil
    }
}

public struct TTTBoardPositionSequence : Sequence {
    public func makeIterator() -> TTTBoardPositionGenerator {
        return TTTBoardPositionGenerator()
    }
}


public struct TTTBoardConfig : Equatable {
    public static func ==(lhs: TTTBoardConfig, rhs: TTTBoardConfig) -> Bool {
        return lhs.states == rhs.states
    }

    let validationRows : [[TTTBoardPosition]] = {
        let firstRow = [TTTBoardPosition(column:0,row:0),TTTBoardPosition(column:1,row:0),TTTBoardPosition(column:2,row:0)]
        let secondRow = [TTTBoardPosition(column:0,row:1),TTTBoardPosition(column:1,row:1),TTTBoardPosition(column:2,row:1)]
        let thirdRow = [TTTBoardPosition(column:0,row:2),TTTBoardPosition(column:1,row:2),TTTBoardPosition(column:2,row:2)]
        let firstColumn = [TTTBoardPosition(column:0,row:0),TTTBoardPosition(column:0,row:1),TTTBoardPosition(column:0,row:2)]
        let secondColumn = [TTTBoardPosition(column:1,row:0),TTTBoardPosition(column:1,row:1),TTTBoardPosition(column:1,row:2)]
        let thirdColumn = [TTTBoardPosition(column:2,row:0),TTTBoardPosition(column:2,row:1),TTTBoardPosition(column:2,row:2)]
        let firstDiagonal = [TTTBoardPosition(column:0,row:0),TTTBoardPosition(column:1,row:1),TTTBoardPosition(column:2,row:2)]
        let secondDiagonal = [TTTBoardPosition(column:2,row:0),TTTBoardPosition(column:1,row:1),TTTBoardPosition(column:0,row:2)]
        let rows = [firstRow,secondRow,thirdRow,firstColumn,secondColumn,thirdColumn,firstDiagonal,secondDiagonal]
        return rows
    }()
    
    
    private func isComplete(_ row : [TTTBoardPosition]) -> Bool {
        let redCount = row.filter { self[$0] == .redSelected }.count
        let greenCount =  row.filter { self[$0] == .greenSelected }.count
        let complete = redCount == 3 || greenCount == 3
        return complete
    }
    
    static func empty() -> TTTBoardConfig {
        let emptyStates = (1...9).map { _ in return TTTState.undefined }
        return TTTBoardConfig(states: emptyStates)
    }
    
    static func codeForState(state : TTTState) -> String {
        switch state {
        case TTTState.undefined:
            return "-"
        case TTTState.greenSelected:
            return "O"
        case TTTState.redSelected:
            return "X"
        }
    }
    static func stateForCode(code : String) -> TTTState {
        switch code {
        case "O":
            return .greenSelected
        case "X":
            return .redSelected
        case "-":
            fallthrough
        default:
            return .undefined

        }
        
    }
    
    var configString : String {
        get {
            let configStateList = self.states.map (TTTBoardConfig.codeForState)
            let configString = configStateList.joined(separator: "")
            return configString
        }
    }
    
    var isEmpty : Bool {
        get {
           return  self.states.filter { $0 != .undefined }.count == self.states.count
        }
    }
    var redCount : Int {
        get {
            return  self.states.filter { $0 == .redSelected }.count
        }
    }
    var greenCount : Int {
        get {
            return  self.states.filter { $0 == .greenSelected }.count
        }
    }
    
    let states : [TTTState]
    subscript(column : Int, row : Int) -> TTTState? {
        return self[TTTBoardPosition(column:column, row: row)]
    }
    subscript(position : TTTBoardPosition) -> TTTState? {
        guard position.isValid else {
            return nil
        }
        return states[position.toIndex()]
    }
    
    init(states : [TTTState], newState: TTTState, atPosition position : TTTBoardPosition)
    {
        var newStates = states
        newStates[position.toIndex()] = newState
        self.states = newStates
    }
    init(states : [TTTState])
    {
        self.states = states
    }
    
    init(configString : String) {
        self.states = configString.characters.map { TTTBoardConfig.stateForCode(code:"\($0)") }
    }
    
    var isComplete : [TTTBoardPosition]? {
        var isComplete = false
        var completedRow : [TTTBoardPosition]?
        for row in self.validationRows where !isComplete {
            let normalizedRow = row.flatMap { $0 }
            isComplete = self.isComplete(normalizedRow )
            if (isComplete)
            {
                completedRow = normalizedRow
            }
        }
        return completedRow
    }
}


