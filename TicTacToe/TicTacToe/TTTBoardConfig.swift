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

public typealias TTTBoardPosition = (column:Int, row:Int)

public class TTTBoardPositionGenerator: IteratorProtocol {
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

public struct TTTBoardPositionSequence : Sequence {
    public func makeIterator() -> TTTBoardPositionGenerator {
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
    
    private func isComplete(_ row : [TTTBoardPosition]) -> Bool {
        let redCount = row.filter { self[$0] == .redSelected }.count
        let greenCount =  row.filter { self[$0] == .greenSelected }.count
        let complete = redCount == 3 || greenCount == 3
        return complete
    }
    
    static func empty() -> TTTBoardConfig {
        let emptyStates = (1...9).map { _ in return TTTState.undefined }
        return TTTBoardConfig(board: emptyStates)
    }
    
    var isEmpty : Bool {
        get {
           return  self.board.filter { $0 != .undefined }.count == self.board.count
        }
    }
    private var redCount : Int {
        get {
            return  self.board.filter { $0 == .redSelected }.count
        }
    }
    private var greenCount : Int {
        get {
            return  self.board.filter { $0 == .greenSelected }.count
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

// MARK: Move Logic

extension TTTBoardConfig {
    private func consecutiveCellStateCount(_ row : [TTTBoardPosition],state : TTTState) -> Int {
        var count = 0
        var previousPosition : TTTBoardPosition? = nil
        let invalidState : TTTState = state == .greenSelected ? .redSelected :  .greenSelected
        for position in row {
            if let previousPosition = previousPosition , self[previousPosition] == invalidState {
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
            if self[newPosition] == .undefined {
                position = newPosition
            }
            index += 1
        }
        return position
    }
    
    private func findPositionToSelect(inRowStates rowStates: [(Int,[TTTBoardPosition])]) -> TTTBoardPosition?
    {
        var positionToSelect : TTTBoardPosition? = nil

        for consecutiveRowsState in rowStates where positionToSelect == nil {
            let positions = consecutiveRowsState.1
            positionToSelect = positions.filter { self[$0] == .undefined }.first
        }
        return positionToSelect
    }
    
    func defenseMove(forPartySelectingRed selectingRed : Bool) -> TTTBoardPosition? {
        let stateToCheck : TTTState = selectingRed ? .greenSelected   : .redSelected
        let consecutiveStates = self.validationRows.map { self.consecutiveCellStateCount($0, state: stateToCheck) }
        let consecutiveRowsStates = zip(consecutiveStates,self.validationRows).sorted { $0.0 > $1.0 }.filter { $0.0 == 2 }
        let positionToSelect  = findPositionToSelect(inRowStates: consecutiveRowsStates)
        return positionToSelect
    }

    func winningMove(forPartySelectingRed selectingRed : Bool) -> TTTBoardPosition? {
        let stateToCheck : TTTState = selectingRed ?  .redSelected : .greenSelected
        
        let consecutiveStates = self.validationRows.map { self.consecutiveCellStateCount($0, state: stateToCheck) }
        let consecutiveRowsStates = zip(consecutiveStates,self.validationRows).sorted { $0.0 > $1.0 }
        let consecutiveWinningRowsStates = consecutiveRowsStates.filter { $0.0 == 2 }
        let positionToSelect  = findPositionToSelect(inRowStates: consecutiveWinningRowsStates)
        return positionToSelect
    }

    
    func attackMove(forPartySelectingRed selectingRed : Bool) -> TTTBoardPosition? {
        if (self.redCount == 0) && selectingRed  {
            if (self[TTTBoardPosition(column:1, row: 1)] == .undefined) {
                return TTTBoardPosition(column:1, row: 1)
            }
            let startIndex = Int(arc4random() % 9)
            return nextUndefinedPosition(startingAtIndex:startIndex)
        }
        if (self.greenCount == 0) && !selectingRed {
            if (self[TTTBoardPosition(column:1, row: 1)] == .undefined) {
                return TTTBoardPosition(column:1, row: 1)
            }
            let startIndex = Int(arc4random() % 9)
            return nextUndefinedPosition(startingAtIndex:startIndex)
        }

        let stateToCheck : TTTState = selectingRed ?  .redSelected : .greenSelected
        
        let consecutiveStates = self.validationRows.map { self.consecutiveCellStateCount($0, state: stateToCheck) }
        let consecutiveRowsStates = zip(consecutiveStates,self.validationRows).sorted { $0.0 > $1.0 }
        let positionToSelect  = findPositionToSelect(inRowStates: consecutiveRowsStates)
        return positionToSelect
        
    }
    
}
