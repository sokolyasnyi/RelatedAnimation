//
//  ViewController.swift
//  RelatedAnimation
//
//  Created by Станислав Соколов on 07.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    lazy private var square: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy private var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
        
    }()
    
    var squareViewLeadingConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(self.square)
        view.addSubview(self.slider)
        
        slider.addTarget(self, action: #selector(changeSliderValue), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        squareViewLeadingConstraint = square.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        squareViewLeadingConstraint.isActive = true

        square.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        square.heightAnchor.constraint(equalToConstant: 100).isActive = true
        square.widthAnchor.constraint(equalTo: square.heightAnchor, multiplier: 1).isActive = true
        
        slider.topAnchor.constraint(equalTo: square.bottomAnchor, constant: 50).isActive = true
        slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    }
    
    @objc private func changeSliderValue(_ sender: UISlider) {
        let progress = CGFloat(sender.value)
        let scale = 1.0 + 0.5 * progress
        let scaleTransform = CGAffineTransform(scaleX: scale,
                                               y: scale)
        let rotationTransform = CGAffineTransform(rotationAngle: .pi / 2 * progress)
        let combinedTransform = scaleTransform.concatenating(rotationTransform)
        
        let sliderFrame = slider.convert(slider.bounds, to: view)
        let viewWidth = 100 * scale
        let maxLeading = sliderFrame.maxX - viewWidth
        let newLeading = maxLeading * progress
        
        UIView.animate(withDuration: 0.5,
                       delay: 0) {
            self.square.transform = combinedTransform
            self.squareViewLeadingConstraint.constant = newLeading
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func sliderChanged(_ sender: UISlider) {
        UIView.animate(withDuration: 0.5,
                       delay: 0) {
            sender.setValue(1.0, animated: true)
        } completion: { _ in
            self.changeSliderValue(sender)
        }
    }
}

