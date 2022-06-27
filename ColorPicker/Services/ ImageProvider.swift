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
    case cache(fileName:String)
}

final class ImageProvider {
    
    var outputImageData: Data?
    
    private weak var presenter: CPImagePresenter?
    
    init(presenter: CPImagePresenter) {
        self.presenter = presenter
    }
    
    func makeImage(_ mode:ImageCreatingMode) {
        switch mode {
        case .clipboard:
            let pasteboard = UIPasteboard.general
            if pasteboard.hasImages {
                let image = pasteboard.images?.first
                presenter?.showNotification(text: "Pasted item from clipboard", mode: .regular)
                outputImageData = image?.pngData()
                presenter?.show(imageData: outputImageData!)
            } else if pasteboard.hasStrings {
                if let possibleLink = pasteboard.strings?.first {
                    if let possibleURL = URL(string: possibleLink) {
                        if UIApplication.shared.canOpenURL(possibleURL) {
                            DispatchQueue.main.async { [weak self] in
                                let data = try? Data(contentsOf: possibleURL)
                                if let imageData = data {
                                    self?.outputImageData = imageData
                                    self?.presenter?.showNotification(text: "Pasted item from URL", mode: .regular)
                                    self?.presenter?.show(imageData: (self?.outputImageData!)!)
                                }
                            }
                        } else {
                            presenter?.showNotification(text: "Invalid input URL", mode: .error)
                        }
                    }
                }
                presenter?.showNotification(text: "No valid images to paste", mode: .error)
            }
        case .gallery:
            if outputImageData != nil {
                presenter?.show(imageData: outputImageData!)
                presenter?.showNotification(text: "Pasted item from gallery", mode: .regular)
            }
            else {
                presenter?.showNotification(text: "Gallery import: something went wrong, try again", mode: .error)
            }
        case .camera:
            if outputImageData != nil {
                presenter?.show(imageData: outputImageData!)
                presenter?.showNotification(text: "Pasted item from camera", mode: .regular)
            }
            else {
                presenter?.showNotification(text: "Camera import: something went wrong, try again", mode: .error)
            }
        case .cache(let fileName):
            let imageData = StorageManager.shared.restoreFromCache(named: fileName)
            self.outputImageData = imageData
            self.presenter?.showNotification(text: "Restored from cache", mode: .regular)
            self.presenter?.show(imageData: (self.outputImageData)!)
        }
    }
} 
