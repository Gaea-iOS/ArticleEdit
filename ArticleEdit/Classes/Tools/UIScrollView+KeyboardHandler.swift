//
//  UIScrollView+KeyboardHandler.swift
//  Football
//
//  Created by Garen on 2017/8/29.
//  Copyright © 2017年 bet007. All rights reserved.
//

import Foundation
import UIKit

@objc protocol KeyboardHandler: NSObjectProtocol {
	
	@objc func startKeyboardHandle(couldScrollBack: Bool)
	
	@objc func endKeyboardHandle()
	
	@objc func needRefreshOffSet()
	
	@objc func keyboardWillChangeHandle(_ notification: Notification)

}

extension UIScrollView: KeyboardHandler {
	
	private struct AssosiateKey {
		static var viewOriginContentOffsetY = "View_Origin_Content_Offset_Y"
		static var keyboardVisiableHeight = "Keyboard_Visiable_Height"
		static var viewCouldScrollBack = "View_Could_Scroll_Back"
	}
	
	private var viewCouldScrollBack: Bool {
		get {
			guard let value = objc_getAssociatedObject(self, &AssosiateKey.viewCouldScrollBack) as? NSNumber else {
				return false
			}
			return value.boolValue
		}
		set {
			objc_setAssociatedObject(self, &AssosiateKey.viewCouldScrollBack, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN)
		}
		
	}
	
	private var viewOriginContentOffsetY: CGFloat {
		get {
			guard let value = objc_getAssociatedObject(self, &AssosiateKey.viewOriginContentOffsetY) as? NSNumber else {
				return 0
			}
			return CGFloat(value.doubleValue)
		}
		set {

			objc_setAssociatedObject(self, &AssosiateKey.viewOriginContentOffsetY, NSNumber(value: Double(newValue)), .OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	private var keyboardVisiableHeight: CGFloat {
		get {
			guard let value = objc_getAssociatedObject(self, &AssosiateKey.keyboardVisiableHeight) as? NSNumber else {
				return 0
			}
			return CGFloat(value.doubleValue)
		}
		set {
			objc_setAssociatedObject(self, &AssosiateKey.keyboardVisiableHeight, NSNumber(value: Double(newValue)), .OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	func startKeyboardHandle(couldScrollBack: Bool) {
		
		viewCouldScrollBack = couldScrollBack
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeHandle(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
	}
	
	func endKeyboardHandle() {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
	}
	
	func needRefreshOffSet() {
		refresh(with: 0.05)
	}

	private func refresh(with duration: Double) {
		
		guard let firstResponder = findFirstResponder() else { return }
		
		if keyboardVisiableHeight <= 20 && viewCouldScrollBack {
			
			let originOffset = CGPoint(x: contentOffset.x, y: viewOriginContentOffsetY)
			UIView.animate(withDuration: duration) {
				self.setContentOffset(originOffset, animated: true)
			}
			return
		}
		
		let contentPosition = firstResponder.convert(firstResponder.bounds, to: UIApplication.shared.keyWindow!)
		
		let contentPositonBottom = contentPosition.origin.y + contentPosition.size.height
		
		let delta = contentPositonBottom - (UIApplication.shared.keyWindow!.bounds.size.height - keyboardVisiableHeight)
		
		guard delta > 0 else { return }
		
		let newContentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y + delta)
		
		UIView.animate(withDuration: duration) { 
			self.setContentOffset(newContentOffset, animated: true)
		}
		
	}
	
	@objc func keyboardWillChangeHandle(_ notification: Notification) {

		guard let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
			return
		}
		
		guard let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
			return
		}
		
		var visibleHeight: CGFloat {
			return UIScreen.main.bounds.height - endFrame.origin.y
		}
		
		keyboardVisiableHeight = visibleHeight
		
		/// 记录弹出键盘前的contentOffset
		if visibleHeight > 150 {
			viewOriginContentOffsetY = contentOffset.y
		}
		
		if !(visibleHeight < 20 && !viewCouldScrollBack) {
			refresh(with: duration)
		}
		
	}
	
}

extension UIView {
	
	func findFirstResponder() -> UIView? {
		
		if self.isFirstResponder { return self }
		
		for subview in subviews {
			if let firstResponderView = subview.findFirstResponder() {
				return firstResponderView
			}
		}
		return nil
	}
}
