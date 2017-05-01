
import WatchKit

extension TTTState {
    func stateImage() -> UIImage? {
        var image : UIImage?
        switch self {
        case .greenSelected:
            image = UIImage(named: "Green")
        case .redSelected:
            image = UIImage(named: "Red")
        default:
            image = UIImage(named: "Gray")
        }
        return image
    }
}


public class TTTWatchCell : NSObject {
    
    var state = TTTState.undefined {
        didSet {
            self.unHighlight()
            if let image = state.stateImage() {
                self.button?.setBackgroundImage(image)
            }
          
        }
    }
    
    var position = TTTBoardPosition(column:-1,row:-1)
    var button : WKInterfaceButton?
    
    init(position : TTTBoardPosition,button : WKInterfaceButton) {
        super.init()
        self.position = position
        self.button = button
    }
    
    func highlight() {
        self.button?.setBackgroundColor(.white)
    }

    func unHighlight() {
        self.button?.setBackgroundColor(.gray)
    }
    
    func clear() {
        self.state = TTTState.undefined
    }
}
