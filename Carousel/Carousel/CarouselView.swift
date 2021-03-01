//
//  CarouselView.swift
//  Carousel
//
//  Created by 松島勇貴 on 2021/03/01.
//

import UIKit

protocol CarouselViewDelegate: AnyObject {
    func itemDidTap(index: Int)
}

class CarouselView: UIView {
    
    static var carouselViewWidth: CGFloat {
        return UIScreen.main.bounds.width - 16 * 2
    }
    
    static var carouselViewHeight: CGFloat {
        return carouselViewWidth * (120 / 343)
    }
    
    weak var delegate: CarouselViewDelegate?
    
    var items: [String] = [] {
        didSet {
            
            stackView.arrangedSubviews.forEach { self.stackView.removeArrangedSubview($0) }
            
            if items.count <= 10 && items.count > 1 {
                for _ in 0..<items.count {
                    let dotView = UIView(frame: .zero)
                    dotView.layer.cornerRadius = 2
                    dotView.backgroundColor = .white
                    NSLayoutConstraint.activate([
                        dotView.heightAnchor.constraint(equalToConstant: 4),
                        dotView.widthAnchor.constraint(equalToConstant: 4),
                    ])
                    stackView.addArrangedSubview(dotView)
                }
            }

            UIView.animate(withDuration: 0, animations: {
                self.collectionView.reloadData()
            }, completion: { _ in
                guard self.items.count > 1 else { return }
                self.collectionView.contentOffset.x = CarouselView.carouselViewWidth // 2枚目から表示
            })
        }
    }
    
    var timer: Timer?

    private weak var collectionView: UICollectionView!
    private weak var stackView: UIStackView!
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        initializeViews()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CarouselViewCell.self, forCellWithReuseIdentifier: CarouselViewCell.reuseIdentifier)
        collectionView.isPagingEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewDidAppear() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            self.showNextPage()
        }
    }
    
    func viewWillDisappear() {
        timer?.invalidate()
    }
    
    private func showNextPage() {
        guard items.count > 1 else { return }
        let newContentOffsetX: CGFloat = collectionView.contentOffset.x + CarouselView.carouselViewWidth
        let newContentOffset: CGPoint = CGPoint(x: newContentOffsetX, y: collectionView.contentOffset.y)
        self.collectionView.setContentOffset(newContentOffset, animated: true)
    }
    
    func initializeViews() {
        self.layer.cornerRadius = 8
        self.backgroundColor = .darkGray
        self.clipsToBounds = true
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
        flowLayout.itemSize = CGSize(width: Self.carouselViewWidth, height: Self.carouselViewHeight)
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
        self.collectionView = collectionView

        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        self.addSubview(stackView)
        self.stackView = stackView
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalToConstant: 4),
        ])
    }
}

extension CarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if items.count > 1 {
            return 1 + items.count + 1 // itemsの最後の要素 + items + itemsの最初の要素。無限スクロールのため。
        } else {
            return items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index: Int
        if items.count > 1 {
            index = (items.count + indexPath.row - 1) % items.count
        } else {
            index = indexPath.row
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselViewCell.reuseIdentifier, for: indexPath) as! CarouselViewCell
        cell.imageView.image = UIImage(named: items[index])
        return cell
    }
}

extension CarouselView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard items.count > 1 else { return }
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x = CarouselView.carouselViewWidth * CGFloat(items.count)
        } else if scrollView.contentOffset.x == CarouselView.carouselViewWidth * CGFloat(items.count + 1) {
            scrollView.contentOffset.x = CarouselView.carouselViewWidth * 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("*** willDIsplay indexPath.row: \(indexPath.row)")
        guard items.count > 1 else { return }
        let displayedIndex = (indexPath.row - 1) % items.count
        stackView.arrangedSubviews.enumerated().forEach { index, view in
            view.alpha = index == displayedIndex ? 1.0 : 0.5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("*** indexPath.row: \(indexPath.row)")
        delegate?.itemDidTap(index: indexPath.row)
    }
}
