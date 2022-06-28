//
//  Extensions.swift
//  ColorPicker
//
//  Created by Holy Light on 17.01.2022.
//

import UIKit
import PhotosUI


protocol CPImagePresenter: AnyObject {
    func showImage(imageData: Data)
    func showNotification(text: String, mode: NotificationType)
}

// MARK: - getting pixel color from any point of non-empty UIImageView
extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = self.cgImage else { return .clear }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let pixelInfo = ((Int(size.width) * Int(pos.y)) + Int(pos.x)) * 4
        let r = CGFloat(pixelData[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(pixelData[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(pixelData[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(pixelData[pixelInfo+3]) / CGFloat(255.0)
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func rotateImage()-> UIImage?  {
        if (self.imageOrientation == UIImage.Orientation.up ) {
            return self
        }
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy
    }
}
// MARK: - creathng a string representation of hex value of a given UIColor
extension UIColor {
    static func convertToHex(color: UIColor) -> String? {
        guard let components = color.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
// MARK: - Photopicker extensions to choose photos from camera and gallery
//done: investigate strange bug with photos taken in portrait orientation is shown on screen correctly but in fact rotated into landscape bitwise rendering getPixelColor method useless
extension MainScreenViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let result = results.first, !results.isEmpty {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let image = reading as? UIImage, error == nil else {return}
                DispatchQueue.main.async {
                    switch image.imageOrientation.rawValue {
                    case 3: // rotate img 90 clockwise
                        self?.showImage(imageData: (image.rotateImage()?.pngData())!)
                        self?.showNotification(text: "Pasted item from gallery", mode: .regular)
                    default: self?.showImage(imageData: (image.pngData())!)
                        self?.showNotification(text: "Pasted item from gallery", mode: .regular)
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MainScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        switch image.imageOrientation.rawValue {
        case 3: // rotate img 90 clockwise
            self.showImage(imageData: (image.rotateImage()?.pngData())!)
            self.showNotification(text: "Pasted item from camera", mode: .regular)
        default: self.showImage(imageData: (image.pngData())!)
            self.showNotification(text: "Pasted item from camera", mode: .regular)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
