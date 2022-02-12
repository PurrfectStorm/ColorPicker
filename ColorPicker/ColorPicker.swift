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
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.shutter.button"), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(importFromCamera), for: .touchUpInside)
        return button
    }()
    private lazy var galleryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.shutter.button"), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(importFromGallery), for: .touchUpInside)
        return button
    }()
    private lazy var clipboardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.shutter.button"), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(importFromClipboard), for: .touchUpInside)
        return button
    }()
    private lazy var bottomButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        return scrollView
    }()
    
    //layout views
    
    private func setupViews() {
        bottomButtonsStackView.addArrangedSubview(cameraButton)
        bottomButtonsStackView.addArrangedSubview(galleryButton)
        bottomButtonsStackView.addArrangedSubview(clipboardButton)
        let scrollRecognizer = UITapGestureRecognizer(target: self, action: #selector (pointTapped))
        scrollView.addGestureRecognizer(scrollRecognizer)
        view.addSubview(bottomButtonsStackView)
        view.addSubview(scrollView)
    }
    
    private func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            bottomButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            cameraButton.heightAnchor.constraint(equalToConstant: 50),
            cameraButton.widthAnchor.constraint(equalToConstant: 50),
            
            clipboardButton.heightAnchor.constraint(equalToConstant: 50),
            clipboardButton.widthAnchor.constraint(equalToConstant: 50),
            
            galleryButton.heightAnchor.constraint(equalToConstant: 50),
            galleryButton.widthAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
//    override func loadView() {  // do i really need to do all that stuff in loadview method?
        
//        view = UIView()
//        view.backgroundColor = .red
        
//        cameraButton.frame = CGRect(origin: .zero, size: .init(width: 50, height: 50)) // look at this, thats how you create a view somewhere and then position it with constraints later (omg it actually works)
//        galleryButton.frame = CGRect(origin: .zero, size: .init(width: 50, height: 50))
//        clipboardButton.frame = CGRect(origin: .zero, size: .init(width: 50, height: 50))
        
        
//        scrollView = UIScrollView(frame: CGRect(origin: .zero, size: view.frame.size))
//        scrollView.backgroundColor = .green
        
//        mainImage = UIImageView()
        //        mainImage.translatesAutoresizingMaskIntoConstraints = false
//        mainImage.isUserInteractionEnabled = true
        //        view.addSubview(mainImage)
        
        //        colorPreview = UIView(frame: CGRect(x: view.center.x + 80 , y: view.center.y + 700 , width: 50, height: 50)) //change this line and add constraints for the view
        //        colorPreview.backgroundColor = .clear
        //        colorDescription = UILabel()
        //        colorDescription.isUserInteractionEnabled = false
        //        colorDescription.font = UIFont.systemFont(ofSize: 15)
        //        colorDescription.textAlignment = .center
        //        colorDescription.textColor = .systemBlue
        //        colorDescription.text = "HEX CODE"
        //        colorDescription.translatesAutoresizingMaskIntoConstraints = false
        //        colorPreview.translatesAutoresizingMaskIntoConstraints = false
        //
        //        view.addSubview(colorPreview)
        //        view.addSubview(colorDescription)
        
//        NSLayoutConstraint.activate([
//
//            //            mainImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//            //            mainImage.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//            //            mainImage.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//            //            mainImage.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -200),
//
//            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            cameraButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -25),
//
//            galleryButton.bottomAnchor.constraint(equalTo: cameraButton.bottomAnchor),
//            galleryButton.centerXAnchor.constraint(equalTo: cameraButton.centerXAnchor, constant: 100),
//
//            clipboardButton.bottomAnchor.constraint(equalTo: cameraButton.bottomAnchor),
//            clipboardButton.centerXAnchor.constraint(equalTo: cameraButton.centerXAnchor, constant: -100),
//
//            //            colorDescription.bottomAnchor.constraint(equalTo: cameraButton.topAnchor, constant: -50),
//            //            colorDescription.widthAnchor.constraint(equalToConstant: 100),
//            //            colorDescription.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100)
//        ])
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        //        mainImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (pointTapped(_:))))
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        mainImage.image = resizeImage(image: provider.outputImage, for: mainImage.bounds.size)
        //        scrollView.contentSize = mainImage.frame.size
        //
        //        mainImage.center = scrollView.center
        //        scrollView.delaysContentTouches = false
    }
    
    @objc private func pointTapped(_ sender:UITapGestureRecognizer) {
        if mainImage.image != nil {
            let color = mainImage.image!.getPixelColor(pos: sender.location(in: mainImage))
            //do smthg with color
            //            colorPreview.backgroundColor = color
            //            if let description = UIColor.convertToHex(color: color) {
            //                colorDescription.text = "#\(description)FF"
            //            }
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

extension ColorPicker : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImage
    }
}

