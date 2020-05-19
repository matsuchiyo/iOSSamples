//
//  ContentViewController.swift
//  PopoverSample
//
//  Created by 松島勇貴 on 2020/05/19.
//  Copyright © 2020 松島勇貴. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    weak var stackView: UIStackView!
    weak var titleLabel: UILabel!
    weak var descriptionLabel: UILabel!
    weak var button: UIButton!

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        initializeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        print("### ContentViewController.viewWillLayoutSubviews")
        super.viewWillLayoutSubviews()
//        fitPopoverHeightToContentHeight()
    }
    
    @objc func buttonDidTap(_ sender: UIButton) {
        print("Button is tapped.")
        dismiss(animated: true)
    }
    
    private func fitPopoverHeightToContentHeight() {
        let newHeight = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        let newY = (UIScreen.main.bounds.height - newHeight) / 2
        let oldFrame = self.view.frame
        self.view.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: oldFrame.width, height: newHeight)
        self.preferredContentSize = CGSize(width: oldFrame.width, height: newHeight)
    }

    private func initializeView() {
        view.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        view.addSubview(stackView)
        self.stackView = stackView
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.text = "TITLE"
        stackView.addArrangedSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 24)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = """
            aaaaaaaaaaaaaaaa
            aaaaaaaaaaaaaaaa
            aaaaaaaaaaaaaaaa
            aaaaaaaaaaaaaaaa
            aaaaaaaaaaaaaaaa
            aaaaaaaaaaaaaaaa
            aaaaaaaaaaaaaaaa
            aaaaaaaaaaaaaaaa
            aaaaaaaaaaaaaaaa
            aaaaaaaaaaaaaaaa
            """
        stackView.addArrangedSubview(descriptionLabel)
        self.descriptionLabel = descriptionLabel
        
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.black, for: .normal)
        stackView.addArrangedSubview(button)
        self.button = button
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }
}
