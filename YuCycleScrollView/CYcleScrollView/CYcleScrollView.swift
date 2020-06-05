//
//  CYcleScrollView.swift
//  U17Test
//
//  Created by Ai on 2020/6/5.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

open class CYcleScrollView: UIView {
    // MARK: 图片数据源
    var images:[String] = [] {
        didSet {
            totalItemsCount = infiniteLoop ? images.count * 100 : images.count
            if images.count > 1 {
                collectionView?.isScrollEnabled = true
                if autoScroll {
                    setupTimer()
                }
            } else {
                collectionView?.isScrollEnabled = false
                invalidateTimer()
            }
            collectionView?.reloadData()

        }
    }

    //自动轮播
    var autoScroll: Bool = true {
        didSet {
            invalidateTimer()
            if autoScroll && infiniteLoop {
                setupTimer()
            }
        }
    }

    //无线轮播
    var infiniteLoop: Bool = true {
        didSet {
            if images.count > 0 {
                let temp = images
                images = temp

            }
        }
    }
    //滚动方向 默认横向滚动
    open var scrollDirection: UICollectionView.ScrollDirection? = .horizontal {
        didSet {
            flowLayout!.scrollDirection = scrollDirection!
            if scrollDirection == .horizontal {
                position = .centeredHorizontally
            }else{
                position = .centeredVertically
            }
        }
    }
    // 滚动间隔 默认2s
    var autoScrollTimeInterval: Double = 2.0 {
        didSet {
            autoScroll = true
        }
    }

    var collectionViewBackgroundColor: UIColor = .white
    var placeHolderImage: UIImage? = nil {
        didSet {
            if placeHolderImage != nil {
                placeHolderViewImage = placeHolderImage
            }
        }
    }
    var imageViewContentModel: UIView.ContentMode? {
        didSet {
            collectionView?.reloadData()
        }
    }
    // MARK: 文字的属性
    var textColor: UIColor = .white
    var numberOfLines: NSInteger = 2
    var titleLeading: CGFloat = 15
    var font: UIFont = UIFont.systemFont(ofSize: 15)
    var titleBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)

    // MARK: pageControl
    var pageControl: CYclePageControl?

    var pageControlTintColor: UIColor = UIColor.lightGray {
        didSet {

        }
    }
    var pageControlCurrentPageColor: UIColor = UIColor.white {
        didSet {

        }
    }
    

    // MARK: private
    //总数量
    fileprivate var totalItemsCount: NSInteger = 1
    //是否纯文本
    var isOnlyText: Bool = false
    // 高度
    fileprivate var cellHeight: CGFloat = 50
    //collection滚动方向
    fileprivate var position: UICollectionView.ScrollPosition! = .centeredHorizontally
    // placeholer
    fileprivate var placeHolderViewImage: UIImage! = UIImage(named: "llplaceholder")
    //定时器
    fileprivate var timer: DispatchSourceTimer?
    // UIcollectionView
    fileprivate var collectionView: UICollectionView?
    //uicollectionflowLayout
    lazy fileprivate var flowLayout: UICollectionViewFlowLayout? = {
        let tempFlowLayout = UICollectionViewFlowLayout.init()
        tempFlowLayout.minimumLineSpacing = 0
        tempFlowLayout.scrollDirection = .horizontal
        return tempFlowLayout
    }()
    fileprivate var maxSwipeSize: CGFloat = 0

    //回调
    typealias cycleItemSelectClouse = (NSInteger) -> Void

    var didSelectItemAtindex: cycleItemSelectClouse?
     override internal init(frame: CGRect) {
           super.init(frame: frame)
           setUpdaeUI()
       }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpdaeUI() -> Void {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout!)
        collectionView?.register(CYcleScrollCollectionViewCell.self, forCellWithReuseIdentifier: "CycleScrollViewCell")
        collectionView?.backgroundColor = collectionViewBackgroundColor
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.scrollsToTop = false
        addSubview(collectionView!)

        pageControl = CYclePageControl()
        pageControl!.indicatorPadding = 8.0
        pageControl?.activeTint = .white
        pageControl?.inactiveTint = UIColor(white: 1, alpha: 0.3)

        addSubview(pageControl!)

    }

    open override func layoutSubviews() {
        superview?.layoutSubviews()
        collectionView?.frame = self.bounds
        cellHeight = self.frame.size.height
        flowLayout!.itemSize = self.frame.size
        pageControl?.pageCount = images.count
        let oldFrame = pageControl?.frame
        pageControl?.frame = CGRect.init(x: UIScreen.main.bounds.width - (oldFrame?.size.width)! - 30 * 0.5, y: self.frame.size.height - 10, width: UIScreen.main.bounds.width, height: 10)
    }
    override open func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            if autoScroll && infiniteLoop {
                setupTimer()
            }
        } else {
            invalidateTimer()
        }
    }
    func setupTimer() -> Void {
        //只有一张图的时候不作滚动
        if self.images.count <= 1 {
            return

        }
        invalidateTimer()
        let time = DispatchSource.makeTimerSource()
        time.schedule(deadline: .now() + autoScrollTimeInterval, repeating: autoScrollTimeInterval)
        time.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.automaticScroll()
            }
        }
        time.resume()
        timer = time
    }
    func invalidateTimer() -> Void {
        timer?.cancel()
        timer = nil
    }
    //自动轮播
    @objc func automaticScroll() {
        if totalItemsCount == 0 { return }
        let targetIndex = currentIndex() + 1
        scollToIndex(targetIndex: targetIndex)

    }
    //滚动到指定位置
    func scollToIndex(targetIndex: Int) {
        if targetIndex >= totalItemsCount {
            if infiniteLoop {
                collectionView?.scrollToItem(at: IndexPath(item: Int(totalItemsCount/2), section: 0), at: position, animated: false)
            }
            return
        }
        collectionView?.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: position, animated: true)
    }
    //当前位置
    func currentIndex() -> NSInteger {
        if collectionView?.frame.size.width == 0 || collectionView?.frame.size.height == 0 {
            return 0
        }
        var index = 0
        if flowLayout!.scrollDirection == .horizontal {
            index = NSInteger(collectionView?.contentOffset.x ?? 0 + (flowLayout!.itemSize.width) * 0.5)/NSInteger((flowLayout!.itemSize.width))
        } else {
            index = NSInteger(collectionView?.contentOffset.y ?? 0 + (flowLayout!.itemSize.height) * 0.5)/NSInteger((flowLayout!.itemSize.height))
        }
        return index
    }
    // pagecontrol index
    func pageControlIndexWithCurrentCellIndex(index: NSInteger) -> (Int) {
        return images.count == 0 ? 0 : Int(index % images.count)
    }

}

extension CYcleScrollView: UICollectionViewDelegate,UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CycleScrollViewCell", for: indexPath) as! CYcleScrollCollectionViewCell
        cell.titleFont = font
        cell.titleLabelTextColor = textColor
        cell.titleBackViewgroundColor = titleBackgroundColor
        cell.titleLines = numberOfLines
        cell.titleLabelLeading = titleLeading
        if isOnlyText && images.count > 0 {
            cell.titleLabelHeight = cellHeight
            let itemIndex = pageControlIndexWithCurrentCellIndex(index: indexPath.item)
            cell.title = images[itemIndex]

        } else {
            let itemIndex = pageControlIndexWithCurrentCellIndex(index: indexPath.item)
            let imagePath = images[itemIndex]
            if imagePath.hasPrefix("http") {
//                cell.imageView.kf.setImage(with: URL(string: imagePath), placeholder: placeHolderImage, options: [], progressBlock: nil, completionHandler: nil)
            } else {
                cell.imageView.image = UIImage(named: imagePath)
            }


        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if didSelectItemAtindex != nil {
            didSelectItemAtindex?(pageControlIndexWithCurrentCellIndex(index: indexPath.item))
        }
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if images.count == 0 {
            return
        }

        calsScrollViewToScroll(scrollView)
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoScroll {
            invalidateTimer()
        }
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if images.count == 0 {
            return
        }

        if autoScroll {
            setupTimer()
        }

    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if images.count == 0 {
            return
        }
        if timer == nil && autoScroll {
            setupTimer()
        }
    }
    fileprivate func calsScrollViewToScroll(_ scrollView: UIScrollView) {
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: currentIndex())
        var progress: CGFloat = 999
        var currentOffsetX = scrollView.contentOffset.x - (CGFloat(totalItemsCount) * scrollView.frame.size.width) / 2
        if currentOffsetX < 0 {
            if currentOffsetX >= -scrollView.frame.size.width{
                currentOffsetX = CGFloat(indexOnPageControl) * scrollView.frame.size.width
            }else if currentOffsetX <= -maxSwipeSize{
                collectionView!.scrollToItem(at: IndexPath.init(item: Int(totalItemsCount/2), section: 0), at: position, animated: false)
            }else{
                currentOffsetX = maxSwipeSize + currentOffsetX
            }
        }
        if currentOffsetX >= CGFloat(self.images.count) * scrollView.frame.size.width && infiniteLoop{
            collectionView!.scrollToItem(at: IndexPath.init(item: Int(totalItemsCount/2), section: 0), at: position, animated: false)
        }
        progress = currentOffsetX / scrollView.frame.size.width
        if progress == 999 {
            progress = CGFloat(indexOnPageControl)
        }
        pageControl?.progress = progress
    }
    
}
