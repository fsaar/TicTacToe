//
//  TTTGameOverController.swift
//  TicTacToe
//
//  Created by Frank Saar on 01/05/2017.
//  Copyright © 2017 SAMedialabs. All rights reserved.
//

import WatchKit


class TTTGameOverController : WKInterfaceController {
    @IBOutlet weak var cell0 : WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.setTitle("")
    }
    
    
    @IBAction func restart() {
        dismiss()
    }
    
}
