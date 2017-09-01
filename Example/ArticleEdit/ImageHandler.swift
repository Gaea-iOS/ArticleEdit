//
//  ImageHandler.swift
//  ArticleEdit
//
//  Created by Garen on 2017/9/1.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import ArticleEdit

/// 默认没有上传
class DefaulImageUpLoader: ImageUploadType {
	
	func upload(_ image: UIImage, success: @escaping (String) -> Void, failure: ((Error?) -> Void)? = nil) {
		success("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1504179414487&di=51cd5866a4cfa388302f643777457de8&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01007358084d3ca84a0d304f974f6b.jpg%40900w_1l_2o_100sh.jpg")
	}
}

public class DefaultImageSelector: NSObject, ImageSelectorType, SinglePhotoSelectViewDelegate {
	
	let imagePicker = PhotoSelectManager()
	
	var successHandler: ((UIImage) -> Void)?
	
	public func selectImage(success: @escaping (UIImage) -> Void) {
		successHandler = success
		
		imagePicker.selectImageDelegate = self
		imagePicker.show(in: UIViewController.topMostController, allowEdit: true)
	}
	
	public func didFinishChoiseImage(_ image: UIImage, fromSelectView manager: PhotoSelectManager) {
		successHandler?(image)
	}
}

class DefaultImageDownloader: ImageDownloadType {
	
	func loadImage(from urlString: String?, success: @escaping ((UIImage) -> Void), failure: ((Error?) -> Void)?) {
		guard let url = URL(string: urlString ?? "") else {
			failure?(NSError(domain: "create URL from urlString fail", code: 9999, userInfo: nil))
			return
		}
		DispatchQueue.global().async {
			do {
				let data = try Data(contentsOf: url)
				guard let image = UIImage(data: data) else {
					failure?(NSError(domain: "download image is nil", code: 9999, userInfo: nil))
					return
				}
				DispatchQueue.main.async {
					success(image)
				}
			} catch let exception {
				failure?(NSError(domain: "download image fail", code: 9999, userInfo: nil))
				debugPrint(exception)
			}
		}
	}
}
