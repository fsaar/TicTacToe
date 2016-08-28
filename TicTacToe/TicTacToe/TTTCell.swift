
import UIKit

extension TTTState {
    func stateImage() -> UIImage? {
        var image : UIImage?
        switch self {
        case .greenSelected:
            image = UIImage(named: "Green")
        case .redSelected:
            image = UIImage(named: "Red")
        default:
            break
        }
        return image
    }
}


public class TTTCell : UIImageView {
    
    var state = TTTState.undefined {
        didSet {
            self.unHighlight()
            self.image  = state.stateImage()
        }
    }
    
    var position : TTTBoardPosition = (-1,-1)
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled  = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = false
    }
    
    func highlight() {
        self.backgroundColor = UIColor.white
    }

    func unHighlight() {
        self.backgroundColor = UIColor.clear
    }
}
