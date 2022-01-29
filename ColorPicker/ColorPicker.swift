//
//  ColorPicker.swift
//  ColorPicker
//
//  Created by Holy Light on 16.12.2021.
//

import UIKit

class ColorPicker: UIViewController {
    
    var mainImage: UIImageView!
    private var provider = ImageProvider()
    private var colorPreview: UIView!
    private var colorDescription: UILabel!
    private var cameraButton: UIButton!
    private var galleryButton: UIButton!
    private var clipboardButton: UIButton!
    private var galleryImage:UIImage?
    
    //layout views
    
    override func loadView() {  // do i really need to do all that stuff in loadview method?
        
        view = UIView()
        view.backgroundColor = .white
        cameraButton = UIButton()
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.setImage(UIImage(systemName: "camera.shutter.button"), for: .normal)
        cameraButton.frame = CGRect(origin: .zero, size: .init(width: 50, height: 50)) // look at this, thats how you create a view somewhere and then position it with constraints later (omg it actually works)
        cameraButton.isUserInteractionEnabled = true
        cameraButton.addTarget(self, action: #selector(importFromCamera), for: .touchUpInside)
        
        galleryButton = UIButton()
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        galleryButton.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        galleryButton.frame = CGRect(origin: .zero, size: .init(width: 50, height: 50))
        galleryButton.isUserInteractionEnabled = true
        galleryButton.addTarget(self, action: #selector(importFromGallery), for: .touchUpInside)
        
        clipboardButton = UIButton()
        clipboardButton.translatesAutoresizingMaskIntoConstraints = false
        clipboardButton.setImage(UIImage(systemName: "arrow.right.doc.on.clipboard"), for: .normal)
        clipboardButton.frame = CGRect(origin: .zero, size: .init(width: 50, height: 50))
        clipboardButton.isUserInteractionEnabled = true
        clipboardButton.addTarget(self, action: #selector(importFromClipboard), for: .touchUpInside)
        
        mainImage = UIImageView()
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.isUserInteractionEnabled = true
        view.addSubview(mainImage)
        view.addSubview(cameraButton)
        view.addSubview(galleryButton)
        view.addSubview(clipboardButton)
        
        colorPreview = UIView(frame: CGRect(x: view.center.x + 80 , y: view.center.y + 700 , width: 50, height: 50)) //change this line and add constraints for the view
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
            
            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -25),
            
            galleryButton.bottomAnchor.constraint(equalTo: cameraButton.bottomAnchor),
            galleryButton.centerXAnchor.constraint(equalTo: cameraButton.centerXAnchor, constant: 100),

            clipboardButton.bottomAnchor.constraint(equalTo: cameraButton.bottomAnchor),
            clipboardButton.centerXAnchor.constraint(equalTo: cameraButton.centerXAnchor, constant: -100)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (pointTapped(_:))))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainImage.image = resizeImage(image: provider.outputImage, for: mainImage.bounds.size)
    }
    
    @objc private func pointTapped(_ sender:UITapGestureRecognizer) {
        if mainImage.image != nil {
            let color = mainImage.image!.getPixelColor(pos: sender.location(in: mainImage))
            colorPreview.backgroundColor = color
            if let description = UIColor.convertToHex(color: color) {
                colorDescription.text = "#\(description)FF"
            }
        }
    }
    
    @objc private func importFromClipboard(_ sender: UIButton) {
        provider.makeImage(.clipboard)
        mainImage.image = provider.outputImage
    }
    
    @objc private func importFromGallery() {
        provider.makeImage(.gallery)
    }
    
    @objc private func importFromCamera() {
        provider.makeImage(.camera)
    }
    
    private func resizeImage(image: UIImage?, for size: CGSize) -> UIImage? {
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

