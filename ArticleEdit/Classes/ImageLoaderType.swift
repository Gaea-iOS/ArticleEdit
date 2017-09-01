//
//  ImageLoaderType.swift
//  ArticleEditDemo
//
//  Created by Garen on 2017/8/31.
//  Copyright © 2017年 cgc. All rights reserved.
//

import Foundation
import UIKit


/// 图片上传协议
public protocol ImageUploadType {
	func upload(_ image: UIImage, success: (String) -> Void, failure: ((Error?) -> Void)?)
}

/// 图片选择协议
public  protocol ImageSelectorType {
	func selectImage(success:@escaping  (UIImage) -> Void)
}

/// 图片加载协议
public protocol ImageDownloadType {
	func loadImage(from urlString: String?, success:@escaping ((UIImage) -> Void), failure: ((Error?) -> Void)?)
}


