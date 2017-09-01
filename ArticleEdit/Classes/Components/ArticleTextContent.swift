//
//  ArticleTextContent.swift
//  ArticleEditDemo
//
//  Created by Garen on 2017/8/30.
//  Copyright © 2017年 cgc. All rights reserved.
//

import UIKit
import SnapKit

public class ArticleTextContent: ArticleComponent, UITextViewDelegate {
	
    public var preview: Bool = false {
        didSet {
            textView.isEditable = !preview
            
        }
    }
    
    public var contentText: String? {
        didSet {
            textView.text = contentText
        }
    }
    
    public var placeholderText: String? {
        didSet {
            textView.placeholder = placeholderText
			textView.setNeedsDisplay()
        }
    }
    
    public var didDeleteLine:(() -> Void)?
    
    public var becomeEditing: Bool = false {
        didSet {
            _ = becomeEditing ? textView.becomeFirstResponder() : self.endEditing(true)
        }
    }
    
    public var didChanged: ((String?) -> Void)?
    
    public var didHappenLinefeed:(() -> Void)?
    
	public lazy var textView: AEPlaceholderTextView = {
        let tv = AEPlaceholderTextView()
        tv.isScrollEnabled = false
        tv.font = AEUIConfig.shared.textContentConfig.font
        tv.textColor = AEUIConfig.shared.textContentConfig.textColor
        tv.placeholder = AEUIConfig.shared.textContentConfig.placeholder
        tv.placeholderColor = AEUIConfig.shared.textContentConfig.placeholderColor
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
		addSubview(textView)
        textView.delegate = self
		textView.snp.makeConstraints { (make) in
			make.height.greaterThanOrEqualTo(AEUIConfig.shared.textContentConfig.leastTextHeight)
			make.edges.equalToSuperview().inset(AEUIConfig.shared.textContentConfig.insets)
		}
    
        textView.didDeleteBackwardHandler = { [weak self] in
            guard let `self` = self else { return }
            guard self.textView.text.characters.count <= 0 else {
                return
            }
            self.didDeleteLine?()
        }
	}
    
    public func textViewDidChange(_ textView: UITextView) {
        didChanged?(textView.text)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            placeholderText = nil
            self.endEditing(true)
            didHappenLinefeed?()
            return false
        }
        return true
    }
	
}
