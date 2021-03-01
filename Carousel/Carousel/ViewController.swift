//
//  ViewController.swift
//  Carousel
//
//  Created by 松島勇貴 on 2021/03/01.
//

import UIKit

class ViewController: UIViewController {
    
    private weak var carouselView: CarouselView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let carouselView = CarouselView()
        view.addSubview(carouselView)
        self.carouselView = carouselView
        
        NSLayoutConstraint.activate([
            carouselView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            carouselView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            carouselView.heightAnchor.constraint(equalToConstant: CarouselView.carouselViewHeight),
            carouselView.widthAnchor.constraint(equalToConstant: CarouselView.carouselViewWidth),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.carouselView.items = [
            "image1",
//            "image2",
//            "image3",
        ]
        self.carouselView.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.carouselView.viewWillDisappear()
    }
}

