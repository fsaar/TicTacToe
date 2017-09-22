import UIKit

private extension Selector {
    static let notificationHandler = #selector(TTTNotificationObserver.notificationHandler(_:))
}

public typealias TTTNotificationObserverBlock = (_ notification : Notification)-> Void

@objc public final class TTTNotificationObserver: NSObject {
    
    fileprivate let handlerBlock : TTTNotificationObserverBlock
    fileprivate var notification : String
    fileprivate var object : AnyObject? = nil
    public var enabled : Bool = true
    public init(notification: String,object : AnyObject? ,handlerBlock: @escaping TTTNotificationObserverBlock)
    {
        self.handlerBlock=handlerBlock
        self.object = object
        self.notification=notification
        super.init()
        __addObserver()
    }
    
    public convenience init(notification: String,handlerBlock: @escaping TTTNotificationObserverBlock)
    {
        self.init(notification: notification,object: nil,handlerBlock: handlerBlock)
    }
    
    deinit
    {
        __removeObserver()
    }
}

// MARK: Observer Handling

extension TTTNotificationObserver {
    fileprivate func __addObserver()
    {
        NotificationCenter.default.addObserver(self, selector: .notificationHandler, name:NSNotification.Name(rawValue: self.notification), object: self.object)
    }
    
    fileprivate func __removeObserver()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func notificationHandler(_ notification : Notification!)
    {
        if (enabled)
        {
            handlerBlock(notification)
        }
    }
}
