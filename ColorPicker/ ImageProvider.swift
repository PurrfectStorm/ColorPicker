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

class ImageProvider : PHPickerViewControllerDelegate {
    
    private(set) var outputImage: UIImage?
    
    func makeImage(_ mode:ImageCreatingMode) {
        switch mode {
        case .clipboard:
            if let image = UIPasteboard.general.image {
                outputImage = image
            } else if let link = UIPasteboard.general.string { // as URL?
                let data = try? Data(contentsOf: URL(string: link)!) //add concurrency?
                if let imageData = data {
                    outputImage = UIImage(data: imageData)
                }
            }
        case .gallery:
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.filter = .images
            let vc = PHPickerViewController(configuration: config)
            vc.delegate = self
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            let mainVC = window?.rootViewController as? ColorPickerVC // god this is so ugly
            mainVC?.present(vc, animated: true)
        case .camera:
            //TBI
            return
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            let mainVC = window?.rootViewController as? ColorPickerVC // look at this copy-paste code
            mainVC?.mainImage.image = self.outputImage
        })
        if let result = results.first, !results.isEmpty {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let image = reading as? UIImage, error == nil else {return}
                self?.outputImage = image
            }
        }
    }
}
