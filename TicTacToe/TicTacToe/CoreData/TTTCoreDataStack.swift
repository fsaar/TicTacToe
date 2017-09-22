//
//  TTTCoreDataStack.swift
//  TicTacToe
//
//  Created by Frank Saar on 21/09/2017.
//  Copyright © 2017 SAMedialabs. All rights reserved.
//
import CoreData
import Foundation

class TTTCoreDataStack {
    static let sharedDataStack = TTTCoreDataStack()
    
    lazy public fileprivate(set) var privateQueueManagedObjectContext : NSManagedObjectContext =  {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.storeCoordinator
        return context
        
    }()
    
    fileprivate var storeCoordinator : NSPersistentStoreCoordinator
    
    fileprivate var backgroundNotificationObserver : TTTNotificationObserver?
    
    init() {
        func initCoreData(_ coordinator : NSPersistentStoreCoordinator) -> Bool {
            guard let _ = try? coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil) else {
                return false
            }
            return true
        }
        
        let models = NSManagedObjectModel.mergedModel(from: nil)!
        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: models)
        _ = initCoreData(storeCoordinator)
        
        self.backgroundNotificationObserver = TTTNotificationObserver(notification: NSNotification.Name.UIApplicationDidEnterBackground.rawValue, handlerBlock: { [weak self] (notification) in
            self?.privateQueueManagedObjectContext.performAndWait {
                _ = try? self?.privateQueueManagedObjectContext.save()
            }
        });
    }
}
