//
//  ArticleImageContent.swift
//  ArticleEditDemo
//
//  Created by ChenGuangchuan on 2017/8/31.
//  Copyright © 2017年 cgc. All rights reserved.
//

import UIKit
import SnapKit

public class ArticleImageContentData: CustomDebugStringConvertible {
	public var url: String? = ""
	public var imageDescription: String?
	public var imageWidth: Int = 0
	public var imageHeight: Int = 0
	
	public init() {
	}
	
	public var debugDescription: String {
		return "url: \(String(describing: url)), imageDescription: \(String(describing: imageDescription)),{\(imageWidth),\(imageHeight)} "
	}
	
}

public class ArticleImageContent: ArticleComponent, UITextViewDelegate {

    public var preview: Bool = false {
        didSet {
            deletedButton.isHidden = preview
            editingButton.isHidden = preview
            editingContentTextView.isEditable = !preview
        }
    }
	
    public var contentData: ArticleImageContentData? {
        didSet {
			guard let contentData = contentData else { return }
			
			imageDescription = contentData.imageDescription
			guard contentData.imageWidth > 0 && contentData.imageHeight > 0 else {
				return
			}
			
			let config = AEUIConfig.shared.imageContentConfig
			
			guard CGFloat(contentData.imageWidth) > UIScreen.main.bounds.size.width - config.insets.left - config.insets.right else {
				height?.update(offset: CGFloat(max(contentData.imageHeight, Int(config.minimumsHeight))))
				backgroundImageView.contentMode = .scaleAspectFit
				return
			}
			
			height?.update(offset: max(CGFloat(contentData.imageHeight) / CGFloat(contentData.imageWidth) * (UIScreen.main.bounds.size.width  - config.insets.left - config.insets.right),config.minimumsHeight))
			backgroundImageView.contentMode = .scaleAspectFit
        }
    }
	
	public var setImage: UIImage? {
		didSet {
			backgroundImageView.image = setImage
		}
	}
	
    public var imageDescription: String? {
        didSet {
            guard let dec = imageDescription, dec.characters.count > 0 else {
                editingButton.isHidden = false
                editingContentTextView.text = nil
                editingContentTextView.endEditing(true)
                if preview {
                    editingView.isHidden = true
                }
                return
            }
            editingButton.isHidden = true
            editingContentTextView.text = dec
        }
    }
    
    private lazy var backgroundImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    private lazy var deletedButton: UIButton = { [unowned self] in
        let content = UIButton()
//        content.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        content.setImage(AEUIConfig.shared.imageContentConfig.deletedButtonImage, for: .normal)
        content.addTarget(self, action: #selector(deleteBackgroundImage(_:)), for: .touchUpInside)
        return content
    }()
    
    private lazy var editingView: UIView = { [unowned self] in
        let content = UIView()
        content.backgroundColor = AEUIConfig.shared.imageContentConfig.editingViewBackgroundColor
        return content
    }()
    
    private lazy var editingContentTextView: AEPlaceholderTextView = { [unowned self] in
        let tv = AEPlaceholderTextView()
        tv.isScrollEnabled = false
		tv.delegate = self
        tv.font = AEUIConfig.shared.imageContentConfig.editingContentTextFont
		tv.textAlignment = .center
        tv.textColor = AEUIConfig.shared.imageContentConfig.editingContentTextColor
		tv.backgroundColor = .clear
        return tv
    }()
    
    private lazy var editingButton: UIButton = { [unowned self] in
        let content = UIButton()
        content.titleLabel?.font = AEUIConfig.shared.imageContentConfig.editingButtonTextFont
        content.setImage(AEUIConfig.shared.imageContentConfig.editingButtonImage, for: .normal)
		content.setTitle(AEUIConfig.shared.imageContentConfig.editingButtonText, for: .normal)
        content.addTarget(self, action: #selector(editingImageDescription(_:)), for: .touchUpInside)
        return content
    }()
    
    var height : Constraint?
    
    public var maxTextCount: Int = 999
    
    public var didDeleteImage: (() -> Void)?
    
    public var didChangeImageDescription: ((String?) -> Void)?
	
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        
        backgroundColor = .white
        
        addSubview(backgroundImageView)
        addSubview(deletedButton)
        addSubview(editingView)
        editingView.addSubview(editingContentTextView)
        editingView.addSubview(editingButton)
        
        backgroundImageView.snp.makeConstraints { (make) in
            self.height = make.height.equalTo(AEUIConfig.shared.imageContentConfig.minimumsHeight).constraint
            make.edges.equalToSuperview().inset(AEUIConfig.shared.imageContentConfig.insets)
        }
		
		deletedButton.snp.makeConstraints { (make) in
			make.top.equalToSuperview()
			make.right.equalToSuperview().offset(-15)
			make.width.height.equalTo(44)
		}
		
		editingView.snp.makeConstraints { (make) in
			make.bottom.equalToSuperview()
			make.left.equalToSuperview().offset(15)
			make.right.equalToSuperview().offset(-15)
			make.height.equalTo(44)
		}
		
		editingContentTextView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview().inset(UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0))
		}
		
		editingButton.snp.makeConstraints { (make) in
			make.left.centerY.equalToSuperview()
			make.height.equalTo(24)
			make.width.equalTo(120)
		}
        
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        
        if (textView.text?.characters.count ?? 0) > maxTextCount {
            if textView.markedTextRange != nil { return }
            let text = textView.text ?? ""
            textView.text = textView.text?.substring(to: text.index(text.startIndex, offsetBy: maxTextCount))
        }
        
        contentData?.imageDescription = textView.text ?? ""
        didChangeImageDescription?(textView.text)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        editingButton.isHidden = true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        editingButton.isHidden = !textView.text.isEmpty
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.endEditing(true)
            return false
        }
        return true
    }
    
    @objc private func deleteBackgroundImage(_ sender: Any) {
        didDeleteImage?()
    }
    
    @objc private func editingImageDescription(_ sender: Any) {
        editingButton.isHidden = true
        editingContentTextView.becomeFirstResponder()
    }

}
