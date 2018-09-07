//
//  TTTHighscoreTableViewController.swift
//  TicTacToe
//
//  Created by Frank Saar on 22/09/2017.
//  Copyright © 2017 SAMedialabs. All rights reserved.
//
import CoreData
import UIKit

class TTTHighscoreTableViewController: UITableViewController {
    fileprivate lazy var fetchRequest : NSFetchRequest<TTTHighscore> = {
        let fetchRequest = NSFetchRequest<TTTHighscore>(entityName:String(describing:TTTHighscore.self))
        let descriptor = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [descriptor]
        return fetchRequest
        
    }()
    
    lazy var fetchResultsController : NSFetchedResultsController<TTTHighscore> = {
        let context = TTTCoreDataStack.sharedDataStack.mainQueueManagedObjectContext
        
        let resultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        try? resultsController.performFetch()
        return resultsController
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Highscore"
        return label
    }()
    
 
    let client = TTTBackendClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = self.titleLabel
        self.navigationController?.navigationBar.barTintColor = .black
        client.getHighScore { _,_ in
            self.tableView.reloadData()
        }
    }

  
    @IBAction func closeButtonHandler(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

/// MARK: UITableViewDatasource

extension TTTHighscoreTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.fetchResultsController.fetchedObjects?.count ?? 0
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:TTTHighscoreCell.self), for: indexPath)
        if let cell = cell as? TTTHighscoreCell,let score = self.fetchResultsController.fetchedObjects?[indexPath.row] {
            let viewModel = TTTHighscoreViewModel(with: score)
            cell.configure(with: viewModel)
        }
        return cell
    }


}
/// MARK: NSFetchedResultsControllerDelegate
extension TTTHighscoreTableViewController : NSFetchedResultsControllerDelegate {
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath ,let newIndexPath = newIndexPath {
                self.tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }

    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
