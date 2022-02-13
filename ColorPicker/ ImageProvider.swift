//
//  ImageProvider.swift
//  ColorPicker
//
//  Created by Holy Light on 28.12.2021.
//

import UIKit
import PhotosUI

enum ImageCreatingMode {
    case clipboard
    case camera
    case gallery
}

class ImageProvider {
    
    var outputImage: UIImage?
    var presenter: CPImagePresenter!

    func makeImage(_ mode:ImageCreatingMode) {
        switch mode {
        case .clipboard:
            if let image = UIPasteboard.general.image {
                presenter.showNotification(text: "Pasted item from clipboard", mode: .regular)
                outputImage = image
                presenter.show(image: outputImage!)
            }
            //            } else if let link = UIPasteboard.general.string { // as URL?
            //                let data = try? Data(contentsOf: URL(string: link)) //add concurrency?
            //                if let imageData = data {
            //                    presenter.show(image: UIImage(data: imageData)!) //add safety
            //                }
            
        case .gallery:
            presenter.show(image: outputImage!)
            presenter.showNotification(text: "Pasted item from gallery", mode: .regular)
        case .camera:
            presenter.show(image: outputImage!)
            presenter.showNotification(text: "Pasted item from camera", mode: .regular)
        }
    }
}
