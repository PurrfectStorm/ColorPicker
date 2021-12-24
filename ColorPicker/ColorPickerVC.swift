//
//  ColorPickerVC.swift
//  ColorPicker
//
//  Created by Holy Light on 16.12.2021.
//

import UIKit

class ColorPickerVC: UIViewController {
    
    var mainImage: UIImageView!
    var colorPreview: UIView!
    var colorDescription: UILabel!
    
    override func loadView() {
        view = UIView()
        mainImage = UIImageView()
        //mainImage.image = UIImage(named: "test.jpg")
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (pointTapped(_:))))
        view.addSubview(mainImage)
        
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
            
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.setNeedsDisplay()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let url = Bundle.main.url(forResource: "colors", withExtension: "png")!
        //        let scaleFactor = UIScreen.main.scale
        //        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let image = resizedImage(at: url, for: mainImage.bounds.size)
        self.mainImage.image = image
    }
    
    @objc func pointTapped(_ sender:UITapGestureRecognizer) {
        let color = mainImage.image!.getPixelColor(pos: sender.location(in: mainImage))
        print("Tapped at \(sender.location(in: view))")
        colorPreview.backgroundColor = color
        colorDescription.text = colorToHex(color: color)
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
        ////        var a = Float(1.0)
        //
        //        if components.count >= 4 {
        //            a = Float(components[3])
        //        }
        
        //        if alpha {
        //            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        //        } else {
        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        //        }
        
    }
}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        //        let pixelData = self.cgImage!.dataProvider!.data
        //        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
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
