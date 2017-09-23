//
//  TTTHighscoreViewModel.swift
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
        self.contentView.backgroundColor = .gray
        self.position.textColor = .white
        self.time.textColor = .white
        self.moves.textColor = .white
        self.name.textColor = .white

        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.position.text =  nil
        self.time.text =  nil
        self.moves.text =  nil
        self.name.text =  nil
    }
    
    func configure(with highscore : TTTHighscoreViewModel) {
        self.position.text = highscore.position
        self.time.text = highscore.time
        self.moves.text = highscore.moves
        self.name.text = highscore.name
    }

   

}
