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

class ImageProvider: NSObject, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private(set) var outputImage: UIImage?
    private var mainVC: ColorPicker? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.rootViewController as? ColorPicker
    }
    
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
            mainVC?.present(vc, animated: true)
        case .camera:
            let photoPicker = UIImagePickerController()
            photoPicker.sourceType = .camera
            photoPicker.delegate = self
            mainVC?.present(photoPicker, animated: true)
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let result = results.first, !results.isEmpty {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let image = reading as? UIImage, error == nil else {return}
                self?.outputImage = image
            }
        }
        picker.dismiss(animated: true, completion: { [weak self] in
            self?.mainVC?.mainImage.image = self?.outputImage
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        outputImage = image
        picker.dismiss(animated: true, completion: { [weak self] in
            self?.mainVC?.mainImage.image = self?.outputImage
        })
    }
}
