//
//  TTTBoardConfig.swift
//  TicTacToe
//
//  Created by Frank Saar on 28/08/2016.
//  Copyright © 2016 SAMedialabs. All rights reserved.
//

import Foundation


enum TTTBoardControllerState {
    case Started
    case Ended
}

public enum TTTState {
    case Undefined
    case GreenSelected
    case RedSelected
}

public typealias TTTBoardPosition = (column:Int, row:Int)

public class TTTBoardPositionGenerator: GeneratorType {
    var currentPos: TTTBoardPosition
    init() {
        currentPos = (-1,0)
    }
    public func next() -> TTTBoardPosition? {
        currentPos.column += 1
        if currentPos.column < 3  {
            return currentPos
        }
        currentPos.column = 0
        currentPos.row += 1
        
        if (currentPos.row < 3) {
            return currentPos
        }
        return nil
    }
}

public struct TTTBoardPositionSequence : SequenceType {
    public func generate() -> TTTBoardPositionGenerator {
        return TTTBoardPositionGenerator()
    }
}

public func ==(lhs: TTTBoardConfig, rhs: TTTBoardConfig) -> Bool {
    return lhs.board == rhs.board
}

public struct TTTBoardConfig : Equatable {
    private let validationRows : [[TTTBoardPosition]] = {
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
    
    private func isComplete(row : [TTTBoardPosition]) -> Bool {
        let redCount = row.filter { self[$0] == .RedSelected }.count
        let greenCount =  row.filter { self[$0] == .GreenSelected }.count
        let complete = redCount == 3 || greenCount == 3
        return complete
    }
    
    static func empty() -> TTTBoardConfig {
        let emptyStates = (1...9).map { _ in return TTTState.Undefined }
        return TTTBoardConfig(board: emptyStates)
    }
    
    var isEmpty : Bool {
        get {
           return  self.board.filter { $0 != .Undefined }.count == self.board.count
        }
    }
    private var redCount : Int {
        get {
            return  self.board.filter { $0 == .RedSelected }.count
        }
    }
    private var greenCount : Int {
        get {
            return  self.board.filter { $0 == .GreenSelected }.count
        }
    }
    
    let board : [TTTState]
    subscript(column : Int, row : Int) -> TTTState? {
        return self[TTTBoardPosition(column:column, row: row)]
    }
    subscript(position : TTTBoardPosition) -> TTTState? {
        guard position.column < 3 && position.row < 3 && position.column >= 0 && position.row >= 0 else {
            return nil
        }
        return board[Int(position.column + position.row * 3)]
    }
    
    func updateConfig(withConfig config : TTTBoardConfig, newState: TTTState, atPosition position : TTTBoardPosition) -> TTTBoardConfig
    {
        var newBoard = board
        let index = position.column + position.row*3
        newBoard[index] = newState
        return TTTBoardConfig(board: newBoard)
    }
    
    func isComplete() -> [TTTBoardPosition]? {
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

extension TTTBoardConfig {
    private func consecutiveCellStateCount(row : [TTTBoardPosition],state : TTTState) -> Int {
        var count = 0
        var previousPosition : TTTBoardPosition? = nil
        let invalidState : TTTState = state == .GreenSelected ? .RedSelected :  .GreenSelected
        for position in row {
            if let previousPosition = previousPosition where self[previousPosition] == invalidState {
                count = 0
            }
            if self[position] == state {
                count += 1
            }
            previousPosition = position
        }
        return count
    }
    
    
    
    private func nextUndefinedPosition(startingAtIndex startIndex : Int) -> TTTBoardPosition? {
        guard self.isComplete() == nil else {
            return nil
        }
        var index = startIndex
        var position : TTTBoardPosition?
        while position == nil {
            let column = index % 3
            let row = index / 3
            let newPosition = TTTBoardPosition(column:column,row:row)
            if self[newPosition] == .Undefined {
                position = newPosition
            }
            index += 1
        }
        return position
    }
    
    func defenseMove(forPartySelectingRed selectingRed : Bool) -> TTTBoardPosition? {
        guard !self.isEmpty else {
            return nil
        }
        if (self.redCount <= 1) && !selectingRed  {
            return nil
        }
        if (self.greenCount <= 1) && selectingRed {
            return nil
        }
        
        
        let stateToCheck : TTTState = selectingRed ? .GreenSelected   : .RedSelected
        
        var positionToSelect : TTTBoardPosition? = nil
        let consecutiveStates = self.validationRows.map { self.consecutiveCellStateCount($0, state: stateToCheck) }
        let consecutiveRowsStates = zip(consecutiveStates,self.validationRows).sort { $0.0 > $1.0 }
        
        for consecutiveRowsState in consecutiveRowsStates where positionToSelect == nil {
            let positions = consecutiveRowsState.1
            let emptyPosition = positions.filter { self[$0] == .Undefined }.first
            if let emptyPosition =  emptyPosition
            {
                positionToSelect = emptyPosition
            }
        }
        return positionToSelect
        
    }

    
    func attackMove(forPartySelectingRed selectingRed : Bool) -> TTTBoardPosition? {
        if (self.redCount == 0) && selectingRed  {
            if (self[TTTBoardPosition(column:1, row: 1)] == .Undefined) {
                return TTTBoardPosition(column:1, row: 1)
            }
            let startIndex = Int(arc4random() % 9)
            return nextUndefinedPosition(startingAtIndex:startIndex)
        }
        if (self.greenCount == 0) && !selectingRed {
            if (self[TTTBoardPosition(column:1, row: 1)] == .Undefined) {
                return TTTBoardPosition(column:1, row: 1)
            }
            let startIndex = Int(arc4random() % 9)
            return nextUndefinedPosition(startingAtIndex:startIndex)
        }

        let stateToCheck : TTTState = selectingRed ?  .RedSelected : .GreenSelected
        
        let consecutiveStates = self.validationRows.map { self.consecutiveCellStateCount($0, state: stateToCheck) }
        let consecutiveRowsStates = zip(consecutiveStates,self.validationRows).sort { $0.0 > $1.0 }
        var selectedPosition : TTTBoardPosition?
        for consecutiveRowState in consecutiveRowsStates where selectedPosition == nil {
            let emptyPosition = consecutiveRowState.1.filter { self[$0] == .Undefined }.first
            if let emptyPosition =  emptyPosition
            {
                selectedPosition = emptyPosition
            }
        }
        return selectedPosition
        
    }
    
    func winningMove(forPartySelectingRed selectingRed : Bool) -> TTTBoardPosition? {
        let stateToCheck : TTTState = selectingRed ?  .RedSelected : .GreenSelected
        
        let consecutiveStates = self.validationRows.map { self.consecutiveCellStateCount($0, state: stateToCheck) }
        let consecutiveRowsStates = zip(consecutiveStates,self.validationRows).sort { $0.0 > $1.0 }
        let consecutiveWinningRowsStates = consecutiveRowsStates.filter { $0.0 == 2 }

        var selectedPosition : TTTBoardPosition?
        for consecutiveRowState in consecutiveWinningRowsStates where selectedPosition == nil {
            let emptyPosition = consecutiveRowState.1.filter { self[$0] == .Undefined }.first
            if let emptyPosition =  emptyPosition
            {
                selectedPosition = emptyPosition
            }
        }
        return selectedPosition
        
    }
}