//
//  UIView+Extensions.swift
//  AvitoTestApp
//
//  Created by Максим Батрасов on 18.10.2022.
//

import Foundation
import UIKit

extension UIView {
    func getRounded (cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
}
