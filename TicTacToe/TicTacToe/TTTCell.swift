
import UIKit

extension TTTState {
    func stateImage() -> UIImage? {
        var image : UIImage?
        switch self {
        case .greenSelected:
            image = #imageLiteral(resourceName: "Green")
        case .redSelected:
            image = #imageLiteral(resourceName: "Red")
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
    
    var position = TTTBoardPosition(column:-1,row:-1)
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled  = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = false
    }
    
    func highlight() {
        self.backgroundColor = .white
    }

    func unHighlight() {
        self.backgroundColor = .clear
    }
}
