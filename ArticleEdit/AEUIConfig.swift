//
//  AEUIConfig.swift
//  ArticleEditDemo
//
//  Created by ChenGuangchuan on 2017/8/30.
//  Copyright © 2017年 cgc. All rights reserved.
//

import Foundation
import UIKit

class AEUIConfig: NSObject {
	
	static let shared = AEUIConfig()
	
	private override init() {
		super.init()
	}
	
	static func image(name: String) -> UIImage? {

		let path = Bundle(for: ArticleView.self).path(forResource: "ArticleEdit", ofType: "bundle") ?? ""
		
		let path2 = Bundle(path: path)?.path(forResource: "ArticleEdit", ofType: "bundle") ?? ""
		
		let bundle = Bundle(path: path2)
		
		let image = UIImage(named: name, in: bundle, compatibleWith: nil)
		
		return image
	}
	
	class TextContentConfig {
		var placeholder: String? = "请输入招商内容"
		
		var placeholderColor: UIColor = .lightGray
		
		var font: UIFont = UIFont.systemFont(ofSize: 16)
		
		var textColor: UIColor = .black
		
		var leastTextHeight: CGFloat = 20
		
		var insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
	}
	
	class SeparatorConfig {
		var height: CGFloat = 1 / UIScreen.main.scale
		
		var color: UIColor = .lightGray
		
		var insets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 15, bottom: 4, right: 15)
	}
	
	class HeadImageContentConfig {
		
		var height: CGFloat = UIScreen.main.bounds.size.width / 3
		
		var addedButtonTitle: String? = "添加宣传图"
		var addedButtonTitleFont: UIFont = UIFont.systemFont(ofSize: 16)
		var addedButtonTitleColor: UIColor = UIColor.gray
		var addedButtonImage: UIImage? = AEUIConfig.image(name: "icon_addimg99.png")
//			UIImage(named: "icon_addimg99.png")
		
		
		var changeButtonTitle: String? = "选择宣传图"
		var changeButtonTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
		var changeButtonTitleColor: UIColor = UIColor.white
		var changeButtonImage: UIImage? = AEUIConfig.image(name: "icon_changeimg.png")
//			UIImage(named: "icon_changeimg.png")
		var changeButtonSize: CGSize = CGSize(width:128, height: 44)
		
		var bottomSeparatorColor: UIColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
		
		var bottomSeparatorHeight: CGFloat = 4
		
		var insets: UIEdgeInsets = UIEdgeInsets(top: 13, left: 15, bottom: 13, right: 15)
	}
	
	class ImageContentConfig {
		var minimumsHeight: CGFloat = 100
		
		var deletedButtonImage: UIImage? = AEUIConfig.image(name: "btn_del.png")
//			UIImage(named: "btn_del.png")
		
		var editingViewBackgroundColor: UIColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
		
		var editingContentTextFont: UIFont = UIFont.systemFont(ofSize: 14)
		
		var editingContentTextColor: UIColor = .white
		
		var editingButtonImage: UIImage? = AEUIConfig.image(name: "icon_editor.png")
//			UIImage(named: "icon_editor.png")
		
		var editingButtonTextFont: UIFont = UIFont.systemFont(ofSize: 14)
		
		var editingButtonText: String? = "编辑描述"
		
		var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
	}
	
	class TitleConfig {
		var placeholder: String? = "请输入招商标题"
		
		var placeholderColor: UIColor = .lightGray
		
		var maxTextCount: Int = 20
		
		var titleFont: UIFont = {
			if #available(iOS 8.2, *) {
				return UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
			} else {
				return UIFont.boldSystemFont(ofSize: 16)
			}
		}()
		
		var titleColor: UIColor = .black
		
		var leastTextHeight: CGFloat = 20
		
		var insets: UIEdgeInsets = UIEdgeInsets(top: 14, left: 15, bottom: 14, right: 15)
	}
	
	class PosterConfig {
		var avaterHeight: CGFloat = 44
		var nameColor: UIColor = UIColor.darkGray
		var nameFont: UIFont = UIFont.systemFont(ofSize: 15)
		var timeTextColot: UIColor = UIColor.lightGray
		var timeFont: UIFont = UIFont.systemFont(ofSize: 15)
		var insets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
	}
	
	var headImageContentConfig = HeadImageContentConfig()
	var separatorConfig = SeparatorConfig()
	var textContentConfig = TextContentConfig()
	var imageContentConfig = ImageContentConfig()
	var titleConfig = TitleConfig()
	var posterConfig = PosterConfig()
}
