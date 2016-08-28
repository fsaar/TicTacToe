
import UIKit

extension TTTState {
    func stateImage() -> UIImage? {
        var image : UIImage?
        switch self {
        case .GreenSelected:
            image = UIImage(named: "Green")
        case .RedSelected:
            image = UIImage(named: "Red")
        default:
            break
        }
        return image
    }
}


public class TTTCell : UIImageView {
    
    var state = TTTState.Undefined {
        didSet {
            self.unHighlight()
            self.image  = state.stateImage()
        }
    }
    
    var position : TTTBoardPosition = (-1,-1)
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        self.contentMode = .ScaleAspectFit
        self.userInteractionEnabled  = true
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
        self.clipsToBounds = false
    }
    
    func highlight() {
        self.backgroundColor = UIColor.whiteColor()
    }

    func unHighlight() {
        self.backgroundColor = UIColor.clearColor()
    }
}
