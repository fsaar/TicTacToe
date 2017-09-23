//
//  TTTHighscoreViewModel.swift
//  TicTacToe
//
//  Created by Frank Saar on 23/09/2017.
//  Copyright © 2017 SAMedialabs. All rights reserved.
//

import UIKit

struct TTTHighscoreViewModel {
    let position : String
    let time : String
    let moves : String
    let name : String
    
    
    init(with highscore : TTTHighscore) {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 2
        position  = "\(highscore.position + 1)."
        time = (formatter.string(from: NSNumber(value:highscore.time)) ?? "") + " secs"
        moves = "\(highscore.moves)"
        name = "\(highscore.name ?? "")"
    }

}
