//
//  ImageProvider.swift
//  ColorPicker
//
//  Created by Holy Light on 28.12.2021.
//

import UIKit

enum ImageCreatingMode {
    case clipboard
    case camera
    case gallery
}

struct ImageProvider {
    var outputImage: UIImage?
    
    mutating func makeImage(in mode:ImageCreatingMode) {
        switch mode {
        case .clipboard:
            if let image = UIPasteboard.general.image {
                outputImage = image
            } else if let link = UIPasteboard.general.string {
                let data = try? Data(contentsOf: URL(string: link)!) //need to do it more safely
                if let imageData = data {
                    outputImage = UIImage(data: imageData)
                }
            }
        case .camera:
            return
        case .gallery:
            return
        }
    }
    
}
