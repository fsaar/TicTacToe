

import UIKit


class TTTBoardController: UIViewController {
    @IBOutlet weak var board : TTTBoard!
    private var humanIsRed = true
    @IBOutlet private var startButton : UIButton!
    @IBOutlet private var machineStartsButton : UIButton!
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

        self.startButton.setTitle(NSLocalizedString("start_button_copy", comment: ""), forState: .Normal)
        self.machineStartsButton.setTitle(NSLocalizedString("computer_starts_button_copy", comment: ""), forState: .Normal)
    }
    
    @IBAction func restart() {
        self.state = .Started
    }
    
    @IBAction func machineStart() {
        self.state = .Started
        playMachine()
    }
}

/// MARK: TTTBoardDelegate

extension TTTBoardController : TTTBoardDelegate {
    
    func evaluateBoardChange(board : TTTBoard,player : TTTBoardPlayer,config: TTTBoardConfig,position : TTTBoardPosition)
    {
        play(board, player: player, config: config, position: position)
        if self.state != .Ended
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
            play(board, player: .Machine, config: board.config, position: machinePosition)
        }
        
    }
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
}
