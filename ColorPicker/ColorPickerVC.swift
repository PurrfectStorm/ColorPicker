//
//  ColorPickerVC.swift
//  ColorPicker
//
//  Created by Holy Light on 16.12.2021.
//

import UIKit

class ColorPickerVC: UIViewController {
    
    private var provider = ImageProvider()
    var mainImage: UIImageView!
    private var colorPreview: UIView!
    private var colorDescription: UILabel!
    private var importButton: UIButton!
    private var galleryImage:UIImage?
    
    //layout views
    
    override func loadView() {  // do i really need to do all that stuff in loadview method?
        
        view = UIView()
        view.backgroundColor = .white
        importButton = UIButton()
        importButton.translatesAutoresizingMaskIntoConstraints = false
        importButton.setTitle("+", for: .normal)
        importButton.frame = CGRect(origin: .zero, size: .init(width: 50, height: 50)) // look at this, thats how you create a view somewhere and then position it with constraints later (omg it actually works)
        importButton.backgroundColor = .gray
        importButton.isUserInteractionEnabled = true
        importButton.addTarget(self, action: #selector(importFromGallery), for: .touchUpInside)
        mainImage = UIImageView()
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.isUserInteractionEnabled = true
        view.addSubview(mainImage)
        view.addSubview(importButton)
        
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
        refreshImageFromProvider()
    }
    
    @objc private func pointTapped(_ sender:UITapGestureRecognizer) {
        if mainImage.image != nil {
            let color = mainImage.image!.getPixelColor(pos: sender.location(in: mainImage))
            colorPreview.backgroundColor = color
            if let description = UIColor.convertToHex(color: color) {
                colorDescription.text = description
            }
        }
    }
    
    @objc private func importButtonTapped(_ sender: UIButton) {
        provider.makeImage(.clipboard)
        mainImage.image = provider.outputImage
        //        view.setNeedsDisplay()
    }
    
    @objc private func importFromGallery() {
//        var config = PHPickerConfiguration(photoLibrary: .shared())
//        config.filter = .images
//        let vc = PHPickerViewController(configuration: config)
//        vc.delegate = self
//        present(vc, animated: true)
        provider.makeImage(.gallery)
        mainImage.image = provider.outputImage
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
    
    func refreshImageFromProvider(){
        mainImage.image = resizeImage(image: provider.outputImage, for: mainImage.bounds.size)
    }
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        if let result = results.first {
//            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
//                guard let image = reading as? UIImage, error == nil else {return}
//                self?.galleryImage = image
//                //print(self?.galleryImage)
//            }
//        }
//    }

}

