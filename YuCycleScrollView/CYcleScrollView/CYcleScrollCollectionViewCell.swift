//
//  CYcleScrollCollectionViewCell.swift
//  U17Test
//
//  Created by Ai on 2020/6/5.
//  Copyright © 2020 yyk. All rights reserved.
//

import UIKit

class CYcleScrollCollectionViewCell: UICollectionViewCell {
    // 文字
    var titleLabel: UILabel!
    // 文字背景
    var titleBackView: UIView!
    // 图片
    var imageView: UIImageView!

    var title: String = "" {
        didSet {
            titleLabel.text = "\(title)"
            titleBackView.isHidden = title.count > 0 ? false : true
            titleLabel.isHidden = title.count > 0 ? false : true
        }
    }
    //标题颜色
    var titleLabelTextColor: UIColor = .white {
        didSet {
            titleLabel.textColor = titleLabelTextColor
        }
    }
    // 标题字体
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    //文字行数
    var titleLines: Int = 2 {
        didSet {
            titleLabel.numberOfLines = titleLines
        }
    }
    //标题与X轴距离
    var titleLabelLeading: CGFloat = 15 {
        didSet {
            setNeedsDisplay()
        }
    }
    //标题高度
    var titleLabelHeight: CGFloat = 50 {
        didSet {
            layoutSubviews()
        }
    }
    //标题背景色
    var titleBackViewgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3) {
        didSet {
            titleBackView.backgroundColor = titleBackViewgroundColor
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)

        titleBackView = UIView()
        titleBackView.backgroundColor = titleBackViewgroundColor
        titleBackView.isHidden = true
        addSubview(titleBackView)

        titleLabel = UILabel()
        titleLabel.isHidden = true
        titleLabel.textColor = titleLabelTextColor
        titleLabel.font = titleFont
        titleLabel.numberOfLines = titleLines
        titleLabel.backgroundColor = .clear
        titleBackView.addSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        titleBackView.frame = CGRect(x: 0, y: self.frame.size.height - titleLabelHeight, width: self.frame.size.width, height: titleLabelHeight)
        titleLabel.frame = CGRect(x: titleLabelLeading, y: 0, width: self.frame.size.width - titleLabelLeading * 2, height: titleLabelHeight)
    }
}
