//
//  ArticleTitleView.swift
//  ArticleEditDemo
//
//  Created by Garen on 2017/8/30.
//  Copyright © 2017年 cgc. All rights reserved.
//

import UIKit

public class ArticleTitleView: ArticleComponent, UITextViewDelegate {
    
    public var preview: Bool = false {
        didSet {
            textView.isEditable = !preview
        }
    }
    
    public var titleText: String? {
        didSet {
            textView.text = titleText
            textView.setNeedsDisplay()
        }
    }
    
    public var placeholderText: String? {
        didSet {
            textView.placeholder = placeholderText
        }
    }
    
    public var maxTextCount: Int = AEUIConfig.shared.titleConfig.maxTextCount
    
    public var didChanged: ((String) -> Void)?

	private lazy var textView: AEPlaceholderTextView = {
		let tv = AEPlaceholderTextView()
		tv.isScrollEnabled = false
		tv.font = AEUIConfig.shared.titleConfig.titleFont
		tv.textColor = AEUIConfig.shared.titleConfig.titleColor
		tv.placeholder = AEUIConfig.shared.titleConfig.placeholder
        tv.placeholderColor = AEUIConfig.shared.titleConfig.placeholderColor
		tv.showsHorizontalScrollIndicator = false
		tv.showsVerticalScrollIndicator = false
		return tv
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
		
		let config = AEUIConfig.shared.titleConfig
		
		addSubview(textView)
		textView.delegate = self
		textView.snp.makeConstraints { (make) in
			make.height.greaterThanOrEqualTo(config.leastTextHeight)
			make.edges.equalToSuperview().inset(config.insets)
		}
		
        let dashedView = UIView()
        addSubview(dashedView)
        dashedView.frame = CGRect(x: config.insets.left, y: self.bounds.size.height - 1, width: UIScreen.main.bounds.size.width - config.insets.left - config.insets.right, height: 1)
        dashedView.drawLine(type: .dashed, in: [.bottom])
        dashedView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AEUIConfig.shared.titleConfig.insets.left)
            make.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.size.width - AEUIConfig.shared.titleConfig.insets.left)
            make.height.equalTo(10)
        }
	}
    
    public func textViewDidChange(_ textView: UITextView) {
        
        if (textView.text?.characters.count ?? 0) > maxTextCount {
            if textView.markedTextRange != nil { return }
            let text = textView.text ?? ""
            textView.text = textView.text?.substring(to: text.index(text.startIndex, offsetBy: maxTextCount))
        }
        
        didChanged?(textView.text)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.layoutIfNeeded()
        if text == "\n" {
            self.endEditing(true)
            return false
        }
        return true
    }

}
