//
//  AEKeyboardToolbar.swift
//  ArticleEditDemo
//
//  Created by Garen on 2017/8/15.
//  Copyright © 2017年 cgc. All rights reserved.
//

import UIKit

public enum BarButtonItemType: Int {
	case photo = 0
	case separator = 1
}

public class AEKeyboardToolbar: UIToolbar {

	public var didClickButtonItem: ((BarButtonItemType) -> Void)?
	
	public convenience init(frame: CGRect, clickHandler: ((BarButtonItemType) -> Void)?) {
		self.init(frame: frame)
		self.didClickButtonItem = clickHandler
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		
		barStyle = .default

		let photoBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 44))
		photoBtn.setImage(AEUIConfig.image(name: "icon_image.png"), for: .normal)
		photoBtn.addTarget(self, action: #selector(clickBarButtonItem(sender:)), for: .touchUpInside)
		photoBtn.tag = BarButtonItemType.photo.rawValue
		
		let separatorBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 44))
		separatorBtn.setImage(AEUIConfig.image(name: "icon_splitline.png"), for: .normal)
		separatorBtn.addTarget(self, action: #selector(clickBarButtonItem(sender:)), for: .touchUpInside)
		separatorBtn.tag = BarButtonItemType.separator.rawValue
		
		items = [UIBarButtonItem(customView: photoBtn), UIBarButtonItem(customView: separatorBtn)]
	}
	
	func clickBarButtonItem(sender: UIBarButtonItem) {
		guard let type = BarButtonItemType(rawValue: sender.tag) else {
			return
		}
		didClickButtonItem?(type)
	}
	
}
