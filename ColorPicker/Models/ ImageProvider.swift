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

class ImageProvider {
    
    var outputImage: UIImage?
    private var presenter: CPImagePresenter
    
    init(presenter: CPImagePresenter) {
        self.presenter = presenter
    }
    
    func makeImage(_ mode:ImageCreatingMode) {
        switch mode {
        case .clipboard:
            let pasteboard = UIPasteboard.general
            if pasteboard.hasImages {
                let image = pasteboard.images?.first
                presenter.showNotification(text: "Pasted item from clipboard", mode: .regular)
                outputImage = image
                presenter.show(image: outputImage!)
            } else if pasteboard.hasStrings {
                if let possibleLink = pasteboard.strings?.first {
                    if let possibleURL = URL(string: possibleLink) {
                        if UIApplication.shared.canOpenURL(possibleURL) {
                            DispatchQueue.main.async { [self] in
                                let data = try? Data(contentsOf: possibleURL)
                                if let imageData = data {
                                    outputImage = UIImage(data: imageData)
                                    presenter.showNotification(text: "Pasted item from URL", mode: .regular)
                                    presenter.show(image: outputImage!)
                                }
                            }
                        }
                    } else {
                        presenter.showNotification(text: "Invalid input URL", mode: .error)
                    }
                }
                presenter.showNotification(text: "No valid images to paste", mode: .error)
            }
        case .gallery:
            if outputImage != nil {
                presenter.show(image: outputImage!)
                presenter.showNotification(text: "Pasted item from gallery", mode: .regular)
            }
            else {
                presenter.showNotification(text: "Gallery import: something went wrong, try again", mode: .error)
            }
        case .camera:
            if outputImage != nil {
                presenter.show(image: outputImage!)
                presenter.showNotification(text: "Pasted item from camera", mode: .regular)
            }
            else {
                presenter.showNotification(text: "Camera import: something went wrong, try again", mode: .error)
            }
        }
    }
} 