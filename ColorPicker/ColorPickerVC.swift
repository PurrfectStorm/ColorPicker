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
    
    //layout views
    
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
        let image = resizeImage(image: provider.outputImage, for: mainImage.bounds.size)
        self.mainImage.image = image
    }
    
    @objc func pointTapped(_ sender:UITapGestureRecognizer) {
        if mainImage.image != nil {
            let color = mainImage.image!.getPixelColor(pos: sender.location(in: mainImage))
            //        print("Tapped at \(sender.location(in: view))")
            colorPreview.backgroundColor = color
            if let description = UIColor.colorToHex(color: color) {
                colorDescription.text = description
            }
        }
    }
    
    @objc func importButtonTapped(_ sender: UIButton) {
        provider.makeImage(in: .clipboard)
        mainImage.image = provider.outputImage
        
        view.setNeedsDisplay()
    }
    
    func resizeImage(image: UIImage?, for size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        if let safeImage = image {
            return renderer.image { (context) in
                safeImage.draw(in: CGRect(origin: .zero, size: size))
            }
        }
        else {
            return nil
        }
    }
}

