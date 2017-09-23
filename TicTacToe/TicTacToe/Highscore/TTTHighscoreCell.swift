//
//  TTTHighscoreCell.swift
//  TicTacToe
//
//  Created by Frank Saar on 23/09/2017.
//  Copyright © 2017 SAMedialabs. All rights reserved.
//

import UIKit

class TTTHighscoreCell: UITableViewCell {
    @IBOutlet var position : UILabel!
    @IBOutlet var time : UILabel!
    @IBOutlet var moves : UILabel!
    @IBOutlet var name : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.position.text =  nil
        self.time.text =  nil
        self.moves.text =  nil
        self.name.text =  nil
    }
    
    func configure(with highscore : TTTHighscore) {
        self.position.text = "\(highscore.position)"
        self.time.text = "\(highscore.time)"
        self.moves.text = "\(highscore.moves)"
        self.name.text = "\(highscore.name ?? "")"
    }

   

}
