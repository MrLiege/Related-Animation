//
//  ViewController.swift
//  Related Animation
//
//  Created by Artyom on 07.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var square: UIView!
    var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        square = UIView()
        square.backgroundColor = .systemBlue
        square.layer.cornerRadius = 10
        square.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(square)

        slider = UISlider()
        slider.addTarget(self, action: #selector(sliderMove(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderReleased(_:)), for: [.touchUpInside, .touchUpOutside])
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)

        
        NSLayoutConstraint.activate([
            square.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            
            square.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            square.widthAnchor.constraint(equalToConstant: 100),
            square.heightAnchor.constraint(equalToConstant: 100),

            slider.topAnchor.constraint(equalTo: square.bottomAnchor, constant: 40),
            
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    @objc func sliderMove(_ sender: UISlider) {
        
        let scaleConstant: CGFloat = 1.0 + CGFloat(sender.value) * 0.5
        let rotationAngle: CGFloat = CGFloat(sender.value) * .pi / 2.0
//        Справа нет отступа у вьюшки, так как она перемещается, поэтому здесь и определим ширину перемещения, тем самым у нас будет отступ справа у вью
        let availableWidth = view.frame.width - square.frame.width - view.layoutMargins.left - view.layoutMargins.right
        let newPositionX = view.layoutMargins.left + square.frame.width / 2.0 + availableWidth * CGFloat(sender.value)

        UIView.animate(withDuration: 0.1) {
            self.square.transform = CGAffineTransform.identity
                .scaledBy(x: scaleConstant, y: scaleConstant)
                .rotated(by: rotationAngle)
            self.square.center.x = newPositionX
        }
    }

    @objc func sliderReleased(_ sender: UISlider) {
//        - Когда отпускаем слайдер, анимация идет до конца с текущего места.
        UIView.animate(withDuration: 1.0 - Double(sender.value), delay: 0, options: .beginFromCurrentState, animations: {
//            - В конечной точке вью должна быть справа (минус отступ), увеличится в 1.5 раза и повернуться на 90 градусов.
            self.square.transform = CGAffineTransform.identity
                .scaledBy(x: 1.5, y: 1.5)
                .rotated(by: .pi/2)
            self.square.center.x = self.view.frame.width - self.square.frame.width / 2 - self.view.layoutMargins.right
            self.slider.value = 1.0
        }, completion: nil)
    }
}
