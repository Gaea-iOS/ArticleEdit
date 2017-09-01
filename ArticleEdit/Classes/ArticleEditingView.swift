//
//  ArticleEditingView.swift
//  ArticleEditDemo
//
//  Created by Garen on 2017/8/31.
//  Copyright © 2017年 cgc. All rights reserved.
//

import UIKit

public enum ArticleEditingItemType {
	case headImage(String?)
	case title(String?)
	case textContent(String?)
	case imageContent(ArticleImageContentData)
	case separator
}

public class ArticleEditingView: ArticleView, ArticleViewDataSource {
	
	public static let defaultEditingItems: [ArticleEditingItemType] = [
		.headImage(nil),
		.title(nil),
		.textContent(nil)
		]
	
	public var imageUploader: ImageUploadType?
	public var imageSelector: ImageSelectorType?
	public var imageDownloader: ImageDownloadType?
	
	public var getAllItems: [ArticleEditingItemType] {
		return editingItems
	}

	private var editingItems: [ArticleEditingItemType] = ArticleEditingView.defaultEditingItems  {
		didSet {
			debugPrint(editingItems.debugDescription)
		}
	}
	
	public convenience init(frame: CGRect,
	                 items: [ArticleEditingItemType] = ArticleEditingView.defaultEditingItems,
	                 imageSelector: ImageSelectorType?,
	                 imageUploader: ImageUploadType?,
	                 imageDownloader: ImageDownloadType?) {
		self.init(frame: frame)
		self.editingItems = items
		self.imageSelector = imageSelector
		self.imageUploader = imageUploader
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
		
		let components = editingItems.enumerated().flatMap({ (itemType: (offset: Int, element: ArticleEditingItemType)) -> ArticleComponent? in
			
			switch itemType.element {
			case .headImage:
				let headImageComponent = ArticleHeaderImage()
				return headImageComponent
				
			case .title:
				let titleComponent = ArticleTitleView()
				return titleComponent
				
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
			
			self.imageDownloader?.loadImage(from: imageKey, success: {[weak headImageComponent] (image) in
				headImageComponent?.setImage = image
			}, failure: nil)
			
			headImageComponent.changeImageAction = { [weak self, weak headImageComponent] in
				self?.imageSelector?.selectImage(success: { [weak self, weak headImageComponent] (image) in
					headImageComponent?.setImage = image
					self?.imageUploader?.upload(image, success: { [weak self] (urlKey) in
						self?.editingItems[row] = .headImage(urlKey)
						}, failure: nil)
				})
			}
			
		case .title(let title):
			guard let titleComponent = component as? ArticleTitleView else { return }
			titleComponent.titleText = title
			titleComponent.maxTextCount = 20
			titleComponent.placeholderText = "请输入招商标题"
			titleComponent.didChanged = { [weak self] text in
				self?.editingItems[row] = .title(text)
				self?.updateLayout()
			}
	
		case .textContent(let textContent):
			guard let textContentComponent = component as? ArticleTextContent else { return }
			textContentComponent.contentText = textContent
			textContentComponent.placeholderText = (row == 2 && editingItems.count <= 3) ? "请输入招商内容" : ""
			
			textContentComponent.textView.inputAccessoryView = AEKeyboardToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44), clickHandler: { [weak self] (type) in
				guard let `self` = self else { return }
				switch type {
				case .photo:
					self.choiceImage(in: row)
				case .separator:
					let separator = AriticleSeparator()
					let textContent = ArticleTextContent()
					textContent.placeholderText = nil
					textContent.contentText = nil
					
					self.editingItems.insert(contentsOf: [.separator, .textContent(nil)], at: row + 1)
					self.insert(components: [separator, textContent], at: row + 1)
					
					textContent.becomeEditing = true
				}
			})
			
			textContentComponent.didChanged = { [weak self] text in
				self?.editingItems[row] = .textContent(text)
				self?.updateLayout()
			}
			
			textContentComponent.didHappenLinefeed = { [weak self] in
				guard let `self` = self else { return }
				self.editingItems.insert(.textContent(nil), at: row + 1)
				self.insert(components: [ArticleTextContent()], at: row + 1)
				(self.component(in: row + 1) as? ArticleTextContent)?.becomeEditing = true
			}
			
			textContentComponent.didDeleteLine = { [weak self] in
				
				guard let `self` = self else { return }
				guard row > 0 else { return }
				
				let lastComponent = self.component(in: row - 1)
				
				if let _ = lastComponent as? ArticleTextContent {
					
					self.editingItems.remove(at: row)
					
					self.removeComponent(at: row)
					
					(self.component(in: row - 1) as? ArticleTextContent)?.becomeEditing = true
					
					return
				}
				
				if let _ = lastComponent as? AriticleSeparator {
					
					self.editingItems.remove(at: row - 1)
					
					self.removeComponent(at: row - 1)
					
					(self.component(in: row - 1) as? ArticleTextContent)?.becomeEditing = true
					
					return
				}
			}
			
		case .separator:
			break
			
		case .imageContent(let contentData):
			guard let imageContentComponent = component as? ArticleImageContent else { return }
			imageContentComponent.contentData = contentData
			imageContentComponent.maxTextCount = 20
			
			self.imageDownloader?.loadImage(from: contentData.url, success: {[weak imageContentComponent] (image) in
				imageContentComponent?.setImage = image
			}, failure: nil)
			
			imageContentComponent.didDeleteImage = { [weak self] in
				guard let `self` = self else { return }
				self.editingItems.remove(at: row)
				self.removeComponent(at: row)
				(self.component(in: row - 1) as? ArticleTextContent)?.becomeEditing = true
			}
			imageContentComponent.didChangeImageDescription = { [weak self] _ in
			}
		}
		
	}
	
	private func choiceImage(in row: Int) {
		imageSelector?.selectImage(success: { [weak self] (image) in
			
			let imageContentData = ArticleImageContentData()
			imageContentData.imageWidth = Int(image.size.width)
			imageContentData.imageHeight = Int(image.size.height)
			
			let imageContentComponent = ArticleImageContent()
			imageContentComponent.contentData = imageContentData
			imageContentComponent.setImage = image
			
			let textContent = ArticleTextContent()
			textContent.placeholderText = nil
			textContent.contentText = nil
			
			self?.editingItems.insert(contentsOf: [.imageContent(imageContentData), .textContent(nil)], at: row + 1)
			self?.insert(components: [imageContentComponent, textContent], at: row + 1)
			
			self?.imageUploader?.upload(image, success: { [weak imageContentData] (urlKey) in
				imageContentData?.url = urlKey
			}, failure: nil)
		})
	}

}
