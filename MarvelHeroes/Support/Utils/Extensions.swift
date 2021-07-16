//
//  Extensions.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import Foundation
import UIKit
import CommonCrypto
import SDWebImage

extension String {
    
    /// Converts the string to MD5 format
    var md5Value: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

extension UIColor {

    /// Converts hex string to initialize a UIColor
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }

}

extension UIImageView {
    
    /// Method that gets an image from url. Shows a temp image while downloading from url
    func setNetworkImage(urlString: String) {
        let imageURL = URL(string: urlString)
        self.sd_setImage(with: imageURL,
                         placeholderImage: notFoundImage,
                         options: SDWebImageOptions(rawValue: 0),
                         completed: { [weak self] (image, error, cacheType, imgURL) in
                            if (error == nil) {
                                self?.image = image
                            } else {
                                self?.image = notFoundImage
                            }
                         })
    }
}

extension UIApplication {
    
    /// Varible that supports the topViewController of the app on every moment
    var topViewController: UIViewController? {
        if keyWindow?.rootViewController == nil{
            return keyWindow?.rootViewController
        }
        
        var pointedViewController = keyWindow?.rootViewController
        
        while  pointedViewController?.presentedViewController != nil {
            switch pointedViewController?.presentedViewController {
            case let navagationController as UINavigationController:
                pointedViewController = navagationController.viewControllers.last
            default:
                pointedViewController = pointedViewController?.presentedViewController
            }
        }
        return pointedViewController
    }
}
