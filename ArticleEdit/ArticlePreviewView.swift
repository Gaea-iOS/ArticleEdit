//
//  ArticlePreviewView.swift
//  ArticleEditDemo
//
//  Created by Garen on 2017/9/1.
//  Copyright © 2017年 cgc. All rights reserved.
//

import UIKit

public enum ArticlePreviewItemType {
	case headImage(String?)
	case title(String?)
	case poster(ArticlePosterData)
	case textContent(String?)
	case imageContent(ArticleImageContentData)
	case separator
}

public class ArticlePreviewView: ArticleView, ArticleViewDataSource {

	public var imageDownloader: ImageDownloadType?

	private var editingItems: [ArticlePreviewItemType] = [] {
		didSet {
			debugPrint(editingItems.debugDescription)
		}
	}
	
	public convenience init(frame: CGRect,
	                        items: [ArticlePreviewItemType],
	                        imageDownloader: ImageDownloadType?) {
		self.init(frame: frame)
		self.editingItems = items
		self.imageDownloader = imageDownloader
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}
	
	func setupView() {
		self.dataSource = self
	}
	
	// MARK: - ArticleViewDataSource
	public func articleViewInitComponents(in articleView: ArticleView) -> [ArticleComponent] {
		
		let components = editingItems.enumerated().flatMap({ (itemType: (offset: Int, element: ArticlePreviewItemType)) -> ArticleComponent? in
			
			switch itemType.element {
			case .headImage:
				let headImageComponent = ArticleHeaderImage()
				return headImageComponent
				
			case .title:
				let titleComponent = ArticleTitleView()
				return titleComponent
				
			case .poster:
				let posterComponent = ArticlePosterView()
				return posterComponent
				
			case .textContent:
				let textContentComponent = ArticleTextContent()
				return textContentComponent
				
			case .separator:
				return AriticleSeparator()
				
			case .imageContent:
				let imageContentComponent = ArticleImageContent()
				return imageContentComponent
			}
			
		})
		return components
	}
	
	
	public func articleView(_ articleView: ArticleView, configComponent component: ArticleComponent, forRowAt row: Int) -> Void {
		
		switch editingItems[row] {
		case .headImage(let imageKey):
			guard let headImageComponent = component as? ArticleHeaderImage else { return }
			
			headImageComponent.preview = true
			
			self.imageDownloader?.loadImage(from: imageKey, success: {[weak headImageComponent] (image) in
				headImageComponent?.setImage = image
			}, failure: nil)
			
			
		case .title(let title):
			guard let titleComponent = component as? ArticleTitleView else { return }
			titleComponent.preview = true
			titleComponent.titleText = title
			
		case .poster(let posterData):
			guard let posterComponent = component as? ArticlePosterView else {
				return
			}
			self.imageDownloader?.loadImage(from: posterData.avatar, success: {[weak posterComponent] (image) in
				posterComponent?.setImage = image
			}, failure: nil)
			posterComponent.posterData = posterData
			
		case .textContent(let textContent):
			guard let textContentComponent = component as? ArticleTextContent else { return }
			textContentComponent.contentText = textContent

		case .separator:
			break
			
		case .imageContent(let contentData):
			guard let imageContentComponent = component as? ArticleImageContent else { return }
			
			self.imageDownloader?.loadImage(from: contentData.url, success: {[weak imageContentComponent] (image) in
				imageContentComponent?.setImage = image
				}, failure: nil)
			
			imageContentComponent.contentData = contentData

		}
		
	}

}

