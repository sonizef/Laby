//
//  Extension.swift
//  Laby
//
//  Created by Joris ZEFIRINI on 27/10/2017.
//  Copyright © 2017 SoniWeb. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    /// Rounds the double to decimal places value
    func roundedCG(toPlaces places:Int) -> CGFloat {
        let divisor = pow(10.0, Double(places))
        let nb = (self * divisor).rounded() / divisor
        
        return CGFloat(nb)
    }
}
