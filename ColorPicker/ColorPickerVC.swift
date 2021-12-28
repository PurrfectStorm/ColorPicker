//
//  ColorPickerVC.swift
//  ColorPicker
//
//  Created by Holy Light on 16.12.2021.
//

import UIKit

class ColorPickerVC: UIViewController {
    
    var provider = ImageProvider()
    
    var mainImage: UIImageView!
    var colorPreview: UIView!
    var colorDescription: UILabel!
    var importButton: UIButton!
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        importButton = UIButton()
        importButton.translatesAutoresizingMaskIntoConstraints = false
        importButton.setTitle("+", for: .normal)
        importButton.frame = CGRect(origin: .zero, size: .init(width: 50, height: 50))
        importButton.backgroundColor = .gray
        importButton.isUserInteractionEnabled = true
        importButton.addTarget(self, action: #selector(importButtonTapped), for: .touchUpInside)
        mainImage = UIImageView()
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.isUserInteractionEnabled = true
        view.addSubview(mainImage)
        view.addSubview(importButton)
        
        colorPreview = UIView(frame: CGRect(x: view.center.x + 80 , y: view.center.y + 700 , width: 50, height: 50))
        colorPreview.backgroundColor = .clear
        colorDescription = UILabel()
        colorDescription.isUserInteractionEnabled = false
        colorDescription.font = UIFont.systemFont(ofSize: 15)
        colorDescription.textAlignment = .center
        colorDescription.textColor = .systemBlue
        colorDescription.text = "HEX CODE"
        colorDescription.translatesAutoresizingMaskIntoConstraints = false
        colorPreview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(colorPreview)
        view.addSubview(colorDescription)
        
        NSLayoutConstraint.activate([
            
            mainImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mainImage.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            mainImage.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -200),
            
            colorDescription.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 60),
            colorDescription.widthAnchor.constraint(equalTo: mainImage.widthAnchor, multiplier: 0.5, constant: -50),
            colorDescription.trailingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: -20),
            
            importButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            importButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 350)
            
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (pointTapped(_:))))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let url = Bundle.main.url(forResource: "colors", withExtension: "png")!
//        let image = resizedImage(at: url, for: mainImage.bounds.size)
//        self.mainImage.image = image
    }
    
    @objc func pointTapped(_ sender:UITapGestureRecognizer) {
        let color = mainImage.image!.getPixelColor(pos: sender.location(in: mainImage))
        print("Tapped at \(sender.location(in: view))")
        colorPreview.backgroundColor = color
        colorDescription.text = colorToHex(color: color)
    }
    
    @objc func importButtonTapped(_ sender: UIButton) {
        print("button tapped, image \(mainImage.image)")
        mainImage.image = provider.makeImage(in: .clipboard)
        
        view.setNeedsDisplay()
    }
    
    func resizedImage(at url:URL, for size: CGSize) -> UIImage? {
        guard let image  = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func colorToHex(color: UIColor) -> String? {
        guard let components = color.cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
 
    }
}

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
        
        let pixelInfo: Int = ((Int(size.width) * Int(pos.y)) + Int(pos.x)) * 4
        //        print("pixelInfo: \(pixelInfo), data: \(data[pixelInfo]), image height: \(self.size.height), image width: \(self.size.width)")
        let r = CGFloat(pixelData[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(pixelData[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(pixelData[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(pixelData[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}
