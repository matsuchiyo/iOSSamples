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
    
    weak var delegate: CarouselViewDelegate?
    
    var items: [String] = [] {
        didSet {
            reload()
        }
    }
    
    var timer: Timer?

    private weak var collectionView: UICollectionView!
    private weak var stackView: UIStackView!
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        initializeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createAndInsertCollectionView() // itemSizeにこのviewのサイズを渡すために、ここでcollectionViewを生成。
        reload()
    }
    
    func viewDidAppear() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            self.showNextPage()
        }
    }
    
    func viewWillDisappear() {
        timer?.invalidate()
    }
    
    private func reload() {
        guard collectionView != nil else { return }
        
        createPageControl()

        UIView.animate(withDuration: 0, animations: {
            self.collectionView?.reloadData()
            
        }, completion: { _ in
            guard self.items.count > 1 else { return }
            self.collectionView?.contentOffset.x = self.frame.width // 2枚目から表示
        })
    }
    
    private func showNextPage() {
        guard items.count > 1 && collectionView != nil else { return }
        let newContentOffsetX: CGFloat = collectionView.contentOffset.x + frame.width
        let newContentOffset: CGPoint = CGPoint(x: newContentOffsetX, y: collectionView.contentOffset.y)
        self.collectionView.setContentOffset(newContentOffset, animated: true)
    }
    
    func initializeViews() {
        self.layer.cornerRadius = 8
        self.backgroundColor = .darkGray
        self.clipsToBounds = true

        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        self.addSubview(stackView)
        self.stackView = stackView
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalToConstant: 4),
        ])
    }

    private func createAndInsertCollectionView() {
        guard collectionView == nil else { return }

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
        flowLayout.itemSize = CGSize(width: frame.width, height: frame.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CarouselViewCell.self, forCellWithReuseIdentifier: CarouselViewCell.reuseIdentifier)
        
        self.insertSubview(collectionView, at: 0)
        self.collectionView = collectionView
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
    
    private func createPageControl() {
        stackView.arrangedSubviews.forEach {
            self.stackView.removeArrangedSubview($0)
            $0.removeFromSuperview() // これもやらないとsubViewがstackView内に残る。
        }

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
            scrollView.contentOffset.x = frame.width * CGFloat(items.count)
        } else if scrollView.contentOffset.x == frame.width * CGFloat(items.count + 1) {
            scrollView.contentOffset.x = frame.width * 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard items.count > 1 else { return }
        let displayedIndex = (indexPath.row - 1) % items.count
        stackView.arrangedSubviews.enumerated().forEach { index, view in
            view.alpha = index == displayedIndex ? 1.0 : 0.5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.itemDidTap(index: indexPath.row)
    }
}
