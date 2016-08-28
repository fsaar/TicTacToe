//
//  TTTTicTacToeView.swift
//  TicTacToe
//
//  Created by Frank Saar on 27/08/2016.
//  Copyright © 2016 SAMedialabs. All rights reserved.
//

import UIKit


@objc enum TTTBoardPlayer : Int {
    case Machine
    case Human
}

protocol TTTBoardDelegate : class {
    func evaluateBoardChange(board : TTTBoard,player : TTTBoardPlayer,config: TTTBoardConfig,position : TTTBoardPosition)
}

public class TTTBoard : UIView {
    weak var delegate : TTTBoardDelegate?
    @IBOutlet private var cells : [TTTCell]!
    var config = TTTBoardConfig.empty() {
        didSet {
            let positions = TTTBoardPositionSequence().map { $0 }
            let statePositions = zip(config.board,positions)
            for (state,position) in statePositions {
                self[position]?.state = state
            }
        }
    }
    
    
    public subscript(position : TTTBoardPosition) -> TTTCell? {
        guard position.column < 3 && position.row < 3 && position.column >= 0 && position.row >= 0 else {
            return nil
        }
        return cells?[Int(position.column + position.row * 3)]
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = self.cells.first?.layer.borderColor
        setupCellPositions()
        setupTouchHandler() 
    }
    func cellTouchHandler(recognizer : UITapGestureRecognizer) {
        if let cell = recognizer.view as? TTTCell where cell.state == .Undefined {
            self.delegate?.evaluateBoardChange(self, player: .Human, config: config, position: cell.position)
        }
    }
    
    
    func highlight(positions : [TTTBoardPosition]) {
        let indexList = positions.map { $0.column + $0.row * 3 }
        let cells = self.cells.filter { indexList.contains($0.position.column + $0.position.row * 3 ) }

        for cell in cells {
            cell.highlight()
        }
    }

    func unHighlight(positions : [TTTBoardPosition]) {
        let indexList = positions.map { $0.column + $0.row * 3 }
        let cells = self.cells.filter { indexList.contains($0.position.column + $0.position.row * 3 ) }
        for cell in cells {
            cell.unHighlight()
        }
    }

    func clear() {
        self.config = TTTBoardConfig.empty()
        unHighlight(self.cells.map { $0.position})
    }
}

/// MARK : Setup
private extension TTTBoard {
    func setupCellPositions() {
        let sortedCells = cells.sort { cell1,cell2 in
            let isLeftOf =  cell1.frame.origin.x < cell2.frame.origin.x
            let isInSameRow = cell1.frame.origin.y == cell2.frame.origin.y
            let isAbove = cell1.frame.origin.y < cell2.frame.origin.y
            let isSortedBefore = isInSameRow ? isLeftOf : isAbove
            return isSortedBefore
        }
        let positions = TTTBoardPositionSequence().map{ $0 }
        let sortedCellsPositions = zip(sortedCells,positions)
        for (cell,position) in sortedCellsPositions
        {
            cell.position = position
        }
    }
    
    func setupTouchHandler() {
        for cell in cells {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(cellTouchHandler(_:)))
            cell.addGestureRecognizer(recognizer)
        }
    }
}

