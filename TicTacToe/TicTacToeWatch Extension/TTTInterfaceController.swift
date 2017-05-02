//
//  InterfaceController.swift
//  TicTacToeWatch Extension
//
//  Created by Frank Saar on 01/05/2017.
//  Copyright © 2017 SAMedialabs. All rights reserved.
//

import WatchKit
import Foundation


class TTTInterfaceController: WKInterfaceController {
    @IBOutlet var cells : [WKInterfaceButton]?
    @IBOutlet weak var cell0 : WKInterfaceButton!
    @IBOutlet weak var cell1 : WKInterfaceButton!
    @IBOutlet weak var cell2 : WKInterfaceButton!
    @IBOutlet weak var cell3 : WKInterfaceButton!
    @IBOutlet weak var cell4 : WKInterfaceButton!
    @IBOutlet weak var cell5 : WKInterfaceButton!
    @IBOutlet weak var cell6 : WKInterfaceButton!
    @IBOutlet weak var cell7 : WKInterfaceButton!
    @IBOutlet weak var cell8 : WKInterfaceButton!
    var humanIsRed = true
    var board : TTTWatchBoard?
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let cellList : [WKInterfaceButton]  = [cell0,cell1,cell2,cell3,cell4,cell5,cell6,cell7,cell8]
        self.board = TTTWatchBoard(cells: cellList )
        self.cells = cellList
    }
    var state : TTTBoardControllerState = .started  {
        didSet {
            switch state {
            case .started:
                self.board?.clear()
            case .ended:
                break
            }
        }
    }

    
    @IBAction func buttonTapped0() {
        buttonTapped(button: cell0)
    }
    @IBAction func buttonTapped1() {
        buttonTapped(button: cell1)
    }
    @IBAction func buttonTapped2() {
        buttonTapped(button: cell2)
    }
    @IBAction func buttonTapped3() {
        buttonTapped(button: cell3)
    }
    @IBAction func buttonTapped4() {
        buttonTapped(button: cell4)
    }
    @IBAction func buttonTapped5() {
        buttonTapped(button: cell5)
    }
    @IBAction func buttonTapped6() {
        buttonTapped(button: cell6)
    }
    @IBAction func buttonTapped7() {
        buttonTapped(button: cell7)
    }
    @IBAction func buttonTapped8() {
        buttonTapped(button: cell8)
    }
    
    func buttonTapped(button : WKInterfaceButton) {
        guard self.state == .started, let index = self.cells?.index(of: button),let board = board,let cell = board[index], cell.state == .undefined else {
            if self.state == .ended {
                gameOver()
            }
            return
        }
        
        play(board, player: .human, config: board.config, position: cell.position)
        if self.state != .ended
        {
            playMachine()
        }
        else
        {
            gameOver()
        }

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

/// MARK: Private

fileprivate extension TTTInterfaceController {
    func playMachine() {
        guard let board = board else {
            return
        }
        let machinePosition = board.config.winningMove(forPartySelectingRed: !humanIsRed) ??
            board.config.defenseMove(forPartySelectingRed: !humanIsRed) ??
            board.config.attackMove(forPartySelectingRed: !humanIsRed)
        if let machinePosition = machinePosition
        {
            play(board, player: .machine, config: board.config, position: machinePosition)
        }
        else
        {
            gameOver()
        }
        
    }
    func play(_ board : TTTWatchBoard,player : TTTBoardPlayer,config: TTTBoardConfig,position : TTTBoardPosition)
    {
        let newHumanState : TTTState = humanIsRed ? .redSelected : .greenSelected
        let newMachineState : TTTState = humanIsRed ? .greenSelected : .redSelected
        let newState = player == .human ? newHumanState : newMachineState
        let newConfig = TTTBoardConfig(board: config.states, newState: newState, atPosition: position)
        board.config = newConfig
        if let winningRow = board.config.isComplete() {
            self.state = .ended
        }
    }
    
    @IBAction func restart() {
        self.state = .started
    }
    
    func gameOver() {
        self.presentController(withName: "TTTGameOverController", context: self)
        self.state = .started
    }
}

