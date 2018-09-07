//
//  TTTTicTacToeView.swift
//  TicTacToe
//
//  Created by Frank Saar on 27/08/2016.
//  Copyright © 2016 SAMedialabs. All rights reserved.
//
import WatchKit
import UIKit


enum TTTBoardPlayer : Int {
    case machine
    case human
}


public class TTTWatchBoard : NSObject {
    var cells : [TTTWatchCell] = []
    var config = TTTBoardConfig.empty() {
        didSet {
            config.states.enumerated().forEach { index,state in
                self.cells[index].state = state
            }
        }
    }
    
    subscript(index : Int) -> TTTWatchCell?
    {
        guard index < cells.count else {
            return nil
        }
        return cells[index]
    }
    
    init(cells : [WKInterfaceButton]) {
        super.init()
        setupCellPositions(sortedCells : cells)
        clear()
    }
    

    func clear() {
        self.config = TTTBoardConfig.empty()
        self.cells.forEach { $0.clear() }
    }
}

/// MARK : Setup
private extension TTTWatchBoard {
    func setupCellPositions(sortedCells : [WKInterfaceButton]) {
        let positions = Array(TTTBoardPositionSequence())
        let sortedCellsPositions = zip(sortedCells,positions)
        sortedCellsPositions.forEach { cell,position in
            let watchCell = TTTWatchCell(position: position, button: cell)
            self.cells += [watchCell]
        }
    }
    
}
