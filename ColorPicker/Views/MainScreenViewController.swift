//
//  MainScreenViewController.swift
//  MainScreenViewController
//
//  Created by Holy Light on 16.12.2021.
//

import UIKit
import PhotosUI

final class MainScreenViewController: UIViewController, UIScrollViewDelegate, CPImagePresenter {
    
    //MARK: - Setting initial variables
    private(set) lazy var provider = ImageProvider(presenter: self)
    
    private lazy var manipulator = ColorManipulator()
    
    private var colorPreview = ColorPreview()
    
    private var imageToShow: UIImage? {
        get {
            return mainImage.image
        }
        set {
            mainImage.image = newValue
            let size = newValue?.size ?? CGSize.zero
            mainImage.frame = CGRect(origin: .zero, size: size)
            setZoomScale()
            imageScrollView.contentSize = CGSize(width: size.width * imageScrollView.minimumZoomScale, height: size.height * imageScrollView.minimumZoomScale)
            centerImageOnZoom()
        }
    }
    
    lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        button.setImage(UIImage(systemName: "camera.shutter.button", withConfiguration: config), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(showCamera), for: .touchUpInside)
        return button
    }()
    
    private lazy var galleryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled", withConfiguration: config), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(showGallery), for: .touchUpInside)
        return button
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        button.setImage(UIImage(systemName: "list.bullet.rectangle.portrait", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var clipboardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        button.setImage(UIImage(systemName: "doc.on.clipboard", withConfiguration: config), for: .normal)
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
    
    private lazy var imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var buttonsBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var setEditingIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        view.isHidden = true
        return view
    }()
    
    //MARK: - Views setup and layout
    private func setupViews() {
        view.backgroundColor = .lightGray
        bottomButtonsStackView.addArrangedSubview(menuButton)
        bottomButtonsStackView.addArrangedSubview(cameraButton)
        bottomButtonsStackView.addArrangedSubview(galleryButton)
        bottomButtonsStackView.addArrangedSubview(clipboardButton)
        let colorRecognizer = UITapGestureRecognizer(target: self, action: #selector (pointTapped))
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector (resizeOnDoubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        // single tap gesture recognizer won't be activated at the same time with the double one because of next line
        colorRecognizer.require(toFail: doubleTapRecognizer)
        mainImage.addGestureRecognizer(colorRecognizer)
        imageScrollView.addGestureRecognizer(doubleTapRecognizer)
        view.addSubview(imageScrollView)
        imageScrollView.addSubview(mainImage)
        view.addSubview(buttonsBackgroundView)
        view.addSubview(bottomButtonsStackView)
        view.addSubview(setEditingIndicator)
    }
    private func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            
            imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            mainImage.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            mainImage.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            
            bottomButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            
            cameraButton.heightAnchor.constraint(equalToConstant: 50),
            cameraButton.widthAnchor.constraint(equalToConstant: 50),
            
            clipboardButton.heightAnchor.constraint(equalToConstant: 50),
            clipboardButton.widthAnchor.constraint(equalToConstant: 50),
            
            galleryButton.heightAnchor.constraint(equalToConstant: 50),
            galleryButton.widthAnchor.constraint(equalToConstant: 50),
            
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.widthAnchor.constraint(equalToConstant: 50),
            
            buttonsBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsBackgroundView.topAnchor.constraint(equalTo: bottomButtonsStackView.topAnchor , constant: -14),
            
            setEditingIndicator.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            setEditingIndicator.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            setEditingIndicator.widthAnchor.constraint(equalToConstant: 10),
            setEditingIndicator.heightAnchor.constraint(equalToConstant: 10),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        addObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerImageOnZoom()
    }
    
    func showImage(imageData: Data) {
        mainImage.image = nil
        removeColorPreview()
        imageToShow = UIImage(data: imageData)
    }
    
    private func setZoomScale() {
        let xScale = imageScrollView.bounds.width/(imageToShow?.size.width ?? 1)
        let yScale = imageScrollView.bounds.height/(imageToShow?.size.height ?? 1)
        imageScrollView.minimumZoomScale = min(xScale, yScale)
        imageScrollView.maximumZoomScale = 5 * imageScrollView.minimumZoomScale
        imageScrollView.zoomScale = imageScrollView.minimumZoomScale
    }
    
    private func centerImageOnZoom() {
        let offsetX = max((imageScrollView.bounds.width - imageScrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((imageScrollView.bounds.height - imageScrollView.contentSize.height) * 0.5, 0)
        imageScrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    //handling set editing indicator update in real time
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(trackObserver), name: NSNotification.Name("ColorPicker.StateChange"), object: nil)
    }
    
    @objc private func trackObserver() {
        setEditingIndicator.isHidden = ColorManipulator.operatingMode == .regularPicking
    }

    //MARK: - User intents
    
    //MARK: paste photo from clipboard
    @objc private func importFromClipboard(_ sender: UIButton) {
        removeColorPreview()
        provider.makeImage(.clipboard)
    }
    //MARK: take photo
    @objc private func showCamera() {
        removeColorPreview()
        let cameraPhotoPicker = UIImagePickerController()
        cameraPhotoPicker.sourceType = .camera
        cameraPhotoPicker.delegate = self
        self.present(cameraPhotoPicker, animated: true)
    }
    //MARK: choose photo from gallery
    @objc private func showGallery() {
        removeColorPreview()
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        let galleryPhotoPicker = PHPickerViewController(configuration: config)
        galleryPhotoPicker.delegate = self
        self.present(galleryPhotoPicker, animated: true)
    }
    //MARK: restore from cache
    func showCachedPhoto(named: String) {
        removeColorPreview()
        provider.makeImage(.cache(fileName: named))
    }
    //MARK: pick a color from photo
    @objc private func pointTapped(_ sender:UITapGestureRecognizer) {
        let xPosition = sender.location(in: view).x
        let yPosition = sender.location(in: view).y
        let xPosForColorPicking = sender.location(in: mainImage).x
        let yPosForColorPicking = sender.location(in: mainImage).y
        let colorToShow = mainImage.image?.getPixelColor(pos: CGPoint(x: xPosForColorPicking, y: yPosForColorPicking))
        let newPosition = calculateAdjustedPosition(originX: xPosition, originY: yPosition)
        if !colorPreview.isOnScreen {
            colorPreview = ColorPreview(color: colorToShow!)
            colorPreview.tapHandler = colorPrevivewTapped
            presentColorPreview(pointX: newPosition.x, pointY: newPosition.y)
        } else {
            colorPreview.isOnScreen = false
            colorPreview.removeFromSuperview()
            colorPreview = ColorPreview(color: colorToShow!)
            colorPreview.tapHandler = colorPrevivewTapped
            presentColorPreview(pointX: newPosition.x, pointY: newPosition.y)
        }
    }
    //MARK: show settings
    @objc private func showMenu() {
        let menuVC = MenuViewController()
        menuVC.title = "Menu"
        let navVC = UINavigationController(rootViewController: menuVC)
        removeColorPreview()
        present(navVC,animated: true) { [weak self] in
            menuVC.imageToSave = self?.mainImage.image //ugly but working
        }
    }
    //checking input coordinates to prevent color preview appearing offscreen
    private func calculateAdjustedPosition(originX: CGFloat, originY: CGFloat) -> (x:CGFloat, y:CGFloat){
        var adjX = originX
        var adjY = originY
        if originX > (view.bounds.width - 100) {
            adjX = originX - 90
        }
        if originY > (view.bounds.height - 100) {
            adjY = originY - 90
        }
        return (adjX,adjY)
    }
    //MARK: resize current photo to min zoom scale
    @objc private func resizeOnDoubleTap() {
        imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
        imageScrollView.scrollRectToVisible(view.bounds, animated: true)
    }
    //MARK: - show a view with picked color and actions
    private func presentColorPreview(pointX: CGFloat, pointY: CGFloat) {
        view.addSubview(colorPreview)
        colorPreview.isOnScreen = true
        NSLayoutConstraint.activate([
            colorPreview.topAnchor.constraint(equalTo: view.topAnchor, constant: pointY),
            colorPreview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: pointX),
            colorPreview.heightAnchor.constraint(equalToConstant: 60),
            colorPreview.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func colorPrevivewTapped() {
        guard let components = colorPreview.preview.backgroundColor!.cgColor.components, components.count >= 3 else {return}
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let a = Float(components[3])
        var colorsCount: Int
        switch ColorManipulator.operatingMode {
        case .regularPicking:
            colorsCount = manipulator.savedColors.count
        case .setEditing(let index):
            colorsCount = manipulator.savedColorSets[index].colors.count
        }
        let colorToSave = Color(title: "Color \(colorsCount)", rValue: r, gValue: g, bValue: b, aValue: a, dateTaken: Date())
        manipulator.saveColor(color: colorToSave)
        showNotification(text: "Color saved", mode: .regular)
    }
    //MARK: - removing color preview on user action
    private func removeColorPreview() {
        if colorPreview.isOnScreen {
            colorPreview.removeFromSuperview()
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        removeColorPreview()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeColorPreview()
    }
    //MARK: - Notification service
    func showNotification(text: String, mode: NotificationType) {
        let notification = NotificationLabel(text: text, type: mode)
        view.addSubview(notification)
        setupNotificationConstraints(notification)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            notification.removeFromSuperview()
        }
    }
    private func setupNotificationConstraints(_ notification: NotificationLabel) {
        NSLayoutConstraint.activate([
            notification.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            notification.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notification.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notification.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - UIScrollviewDelegate methods

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImage
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageOnZoom()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
