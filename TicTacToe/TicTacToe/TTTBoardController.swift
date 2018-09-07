

import UIKit


class TTTBoardController: UIViewController {
 
    
    @IBOutlet weak var board : TTTBoard!
    @IBOutlet weak var showHighScoreButton : UIButton! = nil {
        didSet {
            showHighScoreButton.isHidden = true
        }
    }
    var humanIsRed = true
    var playerWon = false
    var startTime : Date?
    var moves : Int = 1
    @IBOutlet private var startButton : UIButton!
    @IBOutlet private var machineStartsButton : UIButton!
    var state : TTTBoardControllerState = .started  {
        didSet {
            switch state {
            case .started:
                self.startTime = Date()
                self.playerWon = false
                self.moves = 1
                self.board.clear()
                self.board.isUserInteractionEnabled = true
            case .ended:
                if playerWon,let startTime = startTime {
                    let time = Date().timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
                    let name = humanIsRed ? "RED" : "GREEN"
                    self.client.postHigscore(with: name, moves: self.moves, time: Float(time))
                }
                self.board.isUserInteractionEnabled = false
            }
        }
    }
    let client = TTTBackendClient()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkHighscoreReachability()
        self.state = .started
        self.board.delegate = self
        self.startButton.setTitle(NSLocalizedString("start_button_copy", comment: ""), for:.normal)
        self.machineStartsButton.setTitle(NSLocalizedString("computer_starts_button_copy", comment: ""), for: .normal)
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
        moves += 1
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
            self.playerWon = player == .human
            self.state = .ended
        }
    }
}

/// Mark: Highscore

private extension TTTBoardController {
    func checkHighscoreReachability() {
        client.getHighScore { [weak self] _,error in
            if case .none = error {
                self?.showHighScoreButton.isHidden = false
            }
        }
    }

}
