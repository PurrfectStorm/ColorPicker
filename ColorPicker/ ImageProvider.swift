//
//  ImageProvider.swift
//  ColorPicker
//
//  Created by Holy Light on 28.12.2021.
//

import UIKit

enum ImageCreatingMode {
    case clipboard
    case url (url: String)
    case camera
    case gallery
}

struct ImageProvider {
    var outputImage: UIImage?
    
    mutating func makeImage(in mode:ImageCreatingMode) {
        switch mode {
        case .clipboard:
            outputImage = UIPasteboard.general.image
        case .url( _):
            return
        case .camera:
            return
        case .gallery:
            return 
        }
    }
    
}
