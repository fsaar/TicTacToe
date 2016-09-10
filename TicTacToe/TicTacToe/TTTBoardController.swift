

import UIKit


class TTTBoardController: UIViewController {
    @IBOutlet weak var board : TTTBoard!
    var humanIsRed = true
    @IBOutlet private var startButton : UIButton!
    @IBOutlet private var machineStartsButton : UIButton!
    var state : TTTBoardControllerState = .started  {
        didSet {
            switch state {
            case .started:
                self.board.clear()
                self.board.isUserInteractionEnabled = true
            case .ended:
                self.board.isUserInteractionEnabled = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.state = .started
        self.board.delegate = self

        self.startButton.setTitle(NSLocalizedString("start_button_copy", comment: ""), for: UIControlState())
        self.machineStartsButton.setTitle(NSLocalizedString("computer_starts_button_copy", comment: ""), for: UIControlState())
    }
    
    @IBAction func restart() {
        self.state = .started
    }
    
    @IBAction func machineStart() {
        self.state = .started
        playMachine()
    }
}

/// MARK: TTTBoardDelegate

extension TTTBoardController : TTTBoardDelegate {
    
    func evaluateBoardChange(_ board : TTTBoard,player : TTTBoardPlayer,config: TTTBoardConfig,position : TTTBoardPosition)
    {
        play(board, player: player, config: config, position: position)
        if self.state != .ended
        {
            playMachine()   
        }
    }
}

/// MARK: Private

private extension TTTBoardController {
    func playMachine() {
        let config = board.config
        let machinePosition = config.winningMove(forPartySelectingRed: !humanIsRed) ??
                                config.defenseMove(forPartySelectingRed: !humanIsRed) ??
                                config.attackMove(forPartySelectingRed: !humanIsRed)
        if let machinePosition = machinePosition
        {
            play(board, player: .machine, config: board.config, position: machinePosition)
        }
        
    }
    func play(_ board : TTTBoard,player : TTTBoardPlayer,config: TTTBoardConfig,position : TTTBoardPosition)
    {
        let newHumanState : TTTState = humanIsRed ? .redSelected : .greenSelected
        let newMachineState : TTTState = humanIsRed ? .greenSelected : .redSelected
        let newState = player == .human ? newHumanState : newMachineState
        let newConfig = TTTBoardConfig(board: config.states, newState: newState, atPosition: position)
        board.config = newConfig
        if let winningRow = board.config.isComplete() {
            board.highlight(winningRow)
            self.state = .ended
        }
    }
}
