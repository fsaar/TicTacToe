

import UIKit


class TTTBoardController: UIViewController {
    @IBOutlet weak var board : TTTBoard!
    private var humanIsRed = true
    @IBOutlet private var startButton : UIButton!
    private var state : TTTBoardControllerState = .Started  {
        didSet {
            switch state {
            case .Started:
                self.board.clear()
                self.board.userInteractionEnabled = true
            case .Ended:
                self.board.userInteractionEnabled = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.state = .Started
        self.board.delegate = self
    }
    
    @IBAction func restart() {
        self.state = .Started
    }
    
}

/// MARK: TTTBoardDelegate

extension TTTBoardController : TTTBoardDelegate {
    func play(board : TTTBoard,player : TTTBoardPlayer,config: TTTBoardConfig,position : TTTBoardPosition)
    {
        let newHumanState : TTTState = humanIsRed ? .RedSelected : .GreenSelected
        let newMachineState : TTTState = humanIsRed ? .GreenSelected : .RedSelected
        let newState = player == .Human ? newHumanState : newMachineState
        let newConfig = config.updateConfig(withConfig: config, newState: newState, atPosition: position)
        board.config = newConfig
        if let winningRow = board.config.isComplete() {
            board.highlight(winningRow)
            self.state = .Ended
        }
    }
    
    func evaluateBoardChange(board : TTTBoard,player : TTTBoardPlayer,config: TTTBoardConfig,position : TTTBoardPosition)
    {
            play(board, player: player, config: config, position: position)
            if self.state == .Started
            {
                var machinePosition = board.config.winningMove(forPartySelectingRed: !humanIsRed) ?? board.config.defenseMove(forPartySelectingRed: !humanIsRed)
                if case .None = machinePosition {
                    machinePosition = board.config.attackMove(forPartySelectingRed: !humanIsRed)
                    print("selecting attack move \(machinePosition)")
                }
                else
                {
                    print("selecting defensive move \(machinePosition)")
                }
                print(machinePosition)
                if let position = machinePosition
                {
                    play(board, player: .Machine, config: board.config, position: position)
                }
            }
            

    }
}
