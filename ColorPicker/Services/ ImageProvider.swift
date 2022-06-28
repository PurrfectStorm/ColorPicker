//
//  ImageProvider.swift
//  ColorPicker
//
//  Created by Holy Light on 28.12.2021.
//

import UIKit

enum ImageCreatingMode {
    case clipboard
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
                presenter?.showImage(imageData: (image?.pngData()!)!)
            } else if pasteboard.hasStrings {
                if let possibleLink = pasteboard.strings?.first {
                    if let possibleURL = URL(string: possibleLink) {
                        if UIApplication.shared.canOpenURL(possibleURL) {
                            DispatchQueue.main.async { [weak self] in
                                guard let data = try? Data(contentsOf: possibleURL) else {return}
                                if let testImage = UIImage(data: data) {
                                    self?.presenter?.showNotification(text: "Pasted item from URL", mode: .regular)
                                    self?.presenter?.showImage(imageData: testImage.pngData()!)
                                }
                            }
                        }
                    }
                }
            }
        case .cache(let fileName):
            let imageData = StorageManager.shared.restoreFromCache(named: fileName)
            presenter?.showNotification(text: "Restored from cache", mode: .regular)
            presenter?.showImage(imageData: imageData)
        }
    }
} 
