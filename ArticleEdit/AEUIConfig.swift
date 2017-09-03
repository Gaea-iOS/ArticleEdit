//
//  AEUIConfig.swift
//  ArticleEditDemo
//
//  Created by ChenGuangchuan on 2017/8/30.
//  Copyright © 2017年 cgc. All rights reserved.
//

import Foundation
import UIKit

public class AEUIConfig: NSObject {
	
	public static let shared = AEUIConfig()
	
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
	
	public class TextContentConfig {
		public var placeholder: String? = "请输入招商内容"
		
		public var placeholderColor: UIColor = .lightGray
		
		public var font: UIFont = UIFont.systemFont(ofSize: 16)
		
		public var textColor: UIColor = .black
		
		public var leastTextHeight: CGFloat = 20
		
		public var insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
	}
	
	public class SeparatorConfig {
		public var height: CGFloat = 1 / UIScreen.main.scale
		
		public var color: UIColor = .lightGray
		
		public var insets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 15, bottom: 4, right: 15)
	}
	
	public class HeadImageContentConfig {
		
		public var height: CGFloat = UIScreen.main.bounds.size.width / 3
		
        public var headImagePlaceholder: UIImage? = AEUIConfig.image(name: "icon_headImage_loading.png")
        
		public var addedButtonTitle: String? = "添加宣传图"
		public var addedButtonTitleFont: UIFont = UIFont.systemFont(ofSize: 16)
		public var addedButtonTitleColor: UIColor = UIColor.gray
		public var addedButtonImage: UIImage? = AEUIConfig.image(name: "icon_addimg99.png")
	
		
		public var changeButtonTitle: String? = "选择宣传图"
		public var changeButtonTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
		public var changeButtonTitleColor: UIColor = UIColor.white
		public var changeButtonImage: UIImage? = AEUIConfig.image(name: "icon_changeimg.png")

		public var changeButtonSize: CGSize = CGSize(width:128, height: 44)
		
		public var bottomSeparatorColor: UIColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
		
		public var bottomSeparatorHeight: CGFloat = 4
		
		public var insets: UIEdgeInsets = UIEdgeInsets(top: 13, left: 15, bottom: 13, right: 15)
	}
	
	public class ImageContentConfig {
		public var minimumsHeight: CGFloat = 100
		
        public var imageContentPlaceholder: UIImage? = AEUIConfig.image(name: "icon_imageContent_loading.png")
        
		public var deletedButtonImage: UIImage? = AEUIConfig.image(name: "btn_del.png")
		
		public var editingViewBackgroundColor: UIColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
		
		public var editingContentTextFont: UIFont = UIFont.systemFont(ofSize: 14)
		
		public var editingContentTextColor: UIColor = .white
		
		public var editingButtonImage: UIImage? = AEUIConfig.image(name: "icon_editor.png")
		
		public var editingButtonTextFont: UIFont = UIFont.systemFont(ofSize: 14)
		
		public var editingButtonText: String? = "编辑描述"
		
		public var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
	}
	
	public class TitleConfig {
		public var placeholder: String? = "请输入招商标题"
		
		public var placeholderColor: UIColor = .lightGray
		
		public var maxTextCount: Int = 20
		
		public var titleFont: UIFont = {
			if #available(iOS 8.2, *) {
				return UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
			} else {
				return UIFont.boldSystemFont(ofSize: 16)
			}
		}()
		
		public var titleColor: UIColor = .black
		
		public var leastTextHeight: CGFloat = 20
		
		public var insets: UIEdgeInsets = UIEdgeInsets(top: 14, left: 15, bottom: 14, right: 15)
	}
	
	public class PosterConfig {
		public var avaterHeight: CGFloat = 44
        public var avatarPlaceholder: UIImage? = AEUIConfig.image(name: "user.png")
		public var nameColor: UIColor = UIColor.darkGray
		public var nameFont: UIFont = UIFont.systemFont(ofSize: 15)
		public var timeTextColot: UIColor = UIColor.lightGray
        public var separatorColor: UIColor = UIColor.lightGray
		public var timeFont: UIFont = UIFont.systemFont(ofSize: 15)
		public var insets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
	}
	
	public var headImageContentConfig = HeadImageContentConfig()
	public var separatorConfig = SeparatorConfig()
	public var textContentConfig = TextContentConfig()
	public var imageContentConfig = ImageContentConfig()
	public var titleConfig = TitleConfig()
	public var posterConfig = PosterConfig()
}
