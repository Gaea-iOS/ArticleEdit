//
//  ArticleEditingView.swift
//  ArticleEditDemo
//
//  Created by Garen on 2017/8/30.
//  Copyright © 2017年 cgc. All rights reserved.
//

import UIKit

public protocol ArticleViewDataSource: NSObjectProtocol {

	/// 初始化数据
	///
	/// - Parameter articleView: articleView实例
	/// - Returns: 返回初始化后的component
	func articleViewInitComponents(in articleView: ArticleView) -> [ArticleComponent]

	
	/// 配置component数据
	///
	/// - Parameters:
	///   - articleView: articleView实例
	///   - component: 需要配置的component
	///   - row: component 所在 row
	/// - Returns: Void
	func articleView(_ articleView: ArticleView, configComponent component: ArticleComponent, forRowAt row: Int) -> Void
}

open class ArticleView: UIScrollView, UIScrollViewDelegate {
	
	public var components: [ArticleComponent] = []
	
	public weak var dataSource: ArticleViewDataSource?

	public lazy var contentView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	
	override open var contentSize: CGSize {
		didSet {
			super.contentSize = contentSize
			var cframe = contentView.frame
			cframe.size = contentSize
			contentView.frame = cframe
		}
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
	}
	
	deinit {
		endKeyboardHandle()
	}
	
	override open func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		reloadData()
	}
	
	private func setupViews() {
		delegate = self
		backgroundColor = .white
		isScrollEnabled = true
		isDirectionalLockEnabled = true
		addSubview(contentView)
		contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height + 1)
        startKeyboardHandle(couldScrollBack: false)
	}
	
	/// 重新刷新所有Components对象、数据和布局
	public func reloadData() {
		components = dataSource?.articleViewInitComponents(in: self) ?? []
		setupComponent()
		layoutViews()
	}
	
	/// 刷新数据和布局
	public func refreshComponents() {
		setupComponent()
		layoutViews()
	}
	
	/// 刷新布局
	public func updateLayout() {
		updateConstraints()
		layoutIfNeeded()
		needRefreshOffSet()
	}
	
	/// 插入数行
	///
	/// - Parameters:
	///   - components: 插入的内容
	///   - row: row index
	public func insert(components: [ArticleComponent], at row: Int) {
		assert(row <= self.components.count, "row you want to insert out of range!")
		self.components.insert(contentsOf: components, at: row)
		setupComponent()
		layoutViews()
	}
	
	
	/// 删除一行
	///
	/// - Parameter row: row index
	public func removeComponent(at row: Int) {
		assert(row < components.count, "row you want to delete out of range!")
		components.remove(at: row)
		setupComponent()
		layoutViews()
	}
	
	
	/// 获取指定 component
	///
	/// - Parameter row: row index
	/// - Returns: ArticleComponent
	public func component(in row: Int) -> ArticleComponent {
		assert(row < components.count, "row you want to check out of range!")
		return components[row]
	}
	
    private func setupComponent() {
        for (row, component) in self.components.enumerated() {
			
			dataSource?.articleView(self, configComponent: component, forRowAt: row)
        }
    }
	
	/// layout components
	private func layoutViews() {
		
		contentView.subviews.forEach { $0.removeFromSuperview() }
		
		var lastView: UIView? = nil
		
		for (index, view) in components.enumerated() {
			
			contentView.addSubview(view)
			
			if index == 0 {
				view.snp.remakeConstraints({ (make) in
					make.width.equalTo(UIScreen.main.bounds.size)
					make.left.right.top.equalToSuperview()
				})
			} else if index == components.count - 1 {
				view.snp.remakeConstraints({ (make) in
					make.left.right.equalToSuperview()
					make.top.equalTo(lastView!.snp.bottom)
				})
			} else {
				view.snp.remakeConstraints({ (make) in
					make.left.right.equalToSuperview()
					make.top.equalTo(lastView!.snp.bottom)
				})
			}
			
			lastView = view
		}
        
        self.layoutIfNeeded()
        
        guard let lastFrame = contentView.subviews.last?.frame else {
            return
        }

		let contentHeight = max(lastFrame.origin.y + lastFrame.size.height + 350, UIScreen.main.bounds.size.height + 1)

		contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: contentHeight)
	}
	
	// MARK: - UIScrollView delegate
	public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		endEditing(true)
	}
	
}


