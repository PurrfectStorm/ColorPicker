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
    
    func makeImage(in mode:ImageCreatingMode) -> UIImage? {
        switch mode {
        case .clipboard:
            let board = UIPasteboard()
            if board.hasImages {
                print ("got an image")
                return board.image
            } else {
                print ("no image for you")
                return nil
            }
        case .url(let url):
            return nil
        case .camera:
            return nil
        case .gallery:
            return nil
        }
    }
    
}
