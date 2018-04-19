import UIKit

func ColorHelper(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat = 1.0) -> UIColor {
    // RETURN THE COLOR
    return UIColor.init(
                red:CGFloat(red/255.0),
                green:CGFloat(green/255.0),
                blue:CGFloat(blue/255.0),
                alpha:CGFloat(alpha)
            )
}
