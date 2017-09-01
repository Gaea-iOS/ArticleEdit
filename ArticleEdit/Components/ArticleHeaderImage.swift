//
//  ArticleHeaderImage.swift
//  ArticleEditDemo
//
//  Created by ChenGuangchuan on 2017/8/31.
//  Copyright © 2017年 cgc. All rights reserved.
//

import UIKit

public class ArticleHeaderImage: ArticleComponent {

    public var preview: Bool = false {
        didSet {
            addedButton.isHidden = preview
            changeButton.isHidden = preview
        }
    }
    
    public var setImage: UIImage? {
        didSet {
            
            if setImage == nil {
                bringSubview(toFront: addedButton)
                addedButton.isHidden = false
                backgroundImageView.isHidden = true
                changeButton.isHidden = true
            } else {
                addedButton.isHidden = true
                backgroundImageView.isHidden = false
                changeButton.isHidden = preview
            }
            
            backgroundImageView.image = setImage
        }
    }

    public var changeImageAction: (() -> Void)?

    private lazy var backgroundImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    private lazy var addedButton: UIButton = { [unowned self] in
        let content = UIButton()
        content.titleLabel?.font = AEUIConfig.shared.headImageContentConfig.addedButtonTitleFont
        content.setTitleColor(AEUIConfig.shared.headImageContentConfig.addedButtonTitleColor, for: .normal)
		content.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        content.setImage(AEUIConfig.shared.headImageContentConfig.addedButtonImage, for: .normal)
        content.setTitle(AEUIConfig.shared.headImageContentConfig.addedButtonTitle, for: .normal)
        content.addTarget(self, action: #selector(addBackgrounImage(_:)), for: .touchUpInside)
        return content
    }()
    
    private lazy var changeButton: UIButton = { [unowned self] in
        let content = UIButton()
        content.titleLabel?.font = AEUIConfig.shared.headImageContentConfig.changeButtonTitleFont
        content.setTitleColor(AEUIConfig.shared.headImageContentConfig.changeButtonTitleColor, for: .normal)
        content.setImage(AEUIConfig.shared.headImageContentConfig.changeButtonImage, for: .normal)
        content.setBackgroundImage(AEUIConfig.image(name: "bg_img.png"), for: .normal)
        content.setTitle(AEUIConfig.shared.headImageContentConfig.changeButtonTitle, for: .normal)
        content.addTarget(self, action: #selector(changebackgroundImage(_:)), for: .touchUpInside)
        return content
    }()
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
		
		backgroundColor = .white
		
        addSubview(backgroundImageView)
        addSubview(addedButton)
        addSubview(changeButton)
		
		changeButton.isHidden = true
		
        backgroundImageView.snp.makeConstraints { (make) in
            make.height.equalTo(AEUIConfig.shared.headImageContentConfig.height)
            make.edges.equalToSuperview()
        }
        
        addedButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(AEUIConfig.shared.headImageContentConfig.insets)
        }
        
        changeButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.size.equalTo(AEUIConfig.shared.headImageContentConfig.changeButtonSize)
        }
		
		let sep = UIView()
		sep.backgroundColor = AEUIConfig.shared.headImageContentConfig.bottomSeparatorColor
		addSubview(sep)
		sep.snp.makeConstraints { (make) in
			make.left.right.bottom.equalToSuperview()
			make.height.equalTo(AEUIConfig.shared.headImageContentConfig.bottomSeparatorHeight)
		}
		
        addedButton.frame = CGRect(x: AEUIConfig.shared.headImageContentConfig.insets.left,
                                   y: AEUIConfig.shared.headImageContentConfig.insets.top,
                                   width: UIScreen.main.bounds.size.width - AEUIConfig.shared.headImageContentConfig.insets.left - AEUIConfig.shared.headImageContentConfig.insets.right,
                                   height: AEUIConfig.shared.headImageContentConfig.height - AEUIConfig.shared.headImageContentConfig.insets.top - AEUIConfig.shared.headImageContentConfig.insets.bottom)
        addedButton.drawLine(type: .dashed, in: [.left, .right, .top, .bottom])
        
    }
    
    @objc private func addBackgrounImage(_ sender: Any) {
        choiceImage()
    }
    
    @objc private func changebackgroundImage(_ sender: Any) {
        choiceImage()
    }
    
    private func choiceImage() {
        changeImageAction?()
    }

}
