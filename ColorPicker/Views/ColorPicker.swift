//
//  ColorPicker.swift
//  ColorPicker
//
//  Created by Holy Light on 16.12.2021.
//

import UIKit
import PhotosUI

class ColorPicker: UIViewController, CPImagePresenter {
    
    private var provider = ImageProvider()
    var imageToShow: UIImage? {
        willSet {
            mainImage.image = newValue
        }
        didSet {
            updateScrollViewContentSize()
        }
    }
    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = imageToShow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.shutter.button"), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(showCamera), for: .touchUpInside)
        return button
    }()
    private lazy var galleryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(showGallery), for: .touchUpInside)
        return button
    }()
    private lazy var clipboardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "doc.on.clipboard"), for: .normal)
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
        view.addSubview(scrollView)
        updateScrollViewContentSize()
        scrollView.addSubview(mainImage)
        view.addSubview(bottomButtonsStackView)
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
    
    private func updateScrollViewContentSize(){
        if let safeSize = mainImage.image?.size {
            scrollView.contentSize = safeSize
        }
    }
    
    func show(image: UIImage) {
        imageToShow = image
    }
    
    @objc internal func showCamera() {
        let photoPicker = UIImagePickerController()
        photoPicker.sourceType = .camera
        photoPicker.delegate = self
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    @objc internal func showGallery() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        provider.presenter = self
    }
    
    @objc private func pointTapped(_ sender:UITapGestureRecognizer) {
        print("point tapped")
    }
    
    @objc private func importFromClipboard(_ sender: UIButton) {
        provider.makeImage(.clipboard)
    }

    internal func showNotification(text: String, mode: NotificationType) {
        let notification = NotificationLabel(text: text, type: mode)
        view.addSubview(notification)
        setupNotificationConstraints(notification)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            notification.removeFromSuperview()
        }

    }
    
    private func setupNotificationConstraints(_ notification: NotificationLabel) {
        NSLayoutConstraint.activate([
            notification.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            notification.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notification.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notification.heightAnchor.constraint(equalToConstant: 50)
        ])
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

extension ColorPicker: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImage
    }
}
extension ColorPicker: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let result = results.first, !results.isEmpty {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                    guard let image = reading as? UIImage, error == nil else {return}
                    self?.provider.outputImage = image
                }
            }
            picker.dismiss(animated: true, completion: {
                self.provider.makeImage(.gallery)
            })
        }
}

extension ColorPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
            self.provider.outputImage = image
            picker.dismiss(animated: true, completion: {
                self.provider.makeImage(.camera)
            })
        }
}
