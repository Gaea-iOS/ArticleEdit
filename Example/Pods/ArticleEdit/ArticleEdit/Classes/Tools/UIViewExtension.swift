//
//  Extension.swift
//  ArticleEditDemo
//
//  Created by Garen on 2017/8/14.
//  Copyright © 2017年 cgc. All rights reserved.
//

import UIKit

enum DrawSeparatorType {
	case dashed
	case solid
}

enum DrawSeparatorPosition {
	case left
	case right
	case top
	case bottom
}

extension UITableViewCell {
	static var reusedId: String {
		return String(describing: self)
	}
}

extension UIView {

	func drawLine(type: DrawSeparatorType,
	              in positions: [DrawSeparatorPosition],
	              edgeInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
	              color: UIColor = .lightGray) {
        
        var start: CGPoint = .zero
        var end: CGPoint = .zero
        let viewWidth = self.bounds.size.width
        let viewHeight = self.bounds.size.height
        
        positions.forEach { (position) in
            switch position {
            case .left:
                start = CGPoint(x: edgeInset.left, y: 0 - edgeInset.top)
                end = CGPoint(x: edgeInset.left, y: viewHeight - edgeInset.bottom)
                
            case .right:
                start = CGPoint(x: viewWidth - edgeInset.right, y: 0 - edgeInset.top)
                end = CGPoint(x: viewWidth - edgeInset.right, y: viewHeight - edgeInset.bottom)
                
            case .top:
                start = CGPoint(x: edgeInset.left, y: 0 - edgeInset.top)
                end = CGPoint(x: viewWidth - edgeInset.right, y: 0 - edgeInset.top)
                
            case .bottom:
                start = CGPoint(x: edgeInset.left, y: viewHeight - edgeInset.bottom)
                end = CGPoint(x: viewWidth - edgeInset.right, y: viewHeight - edgeInset.bottom)
            }
            
            drawLine(type: type, from: start, to: end, color: color)
        }
	}
	
	func drawLine(type: DrawSeparatorType,
	                from start: CGPoint,
	                to end: CGPoint,
	                lineWidth: CGFloat = 1 / UIScreen.main.scale,
	                lineLength: CGFloat = 3,
	                lineSpace: CGFloat = 1,
	                color: UIColor? = nil) {
		let shapeLayer = CAShapeLayer()
		shapeLayer.frame = self.bounds
		shapeLayer.fillColor = UIColor.clear.cgColor
		
		shapeLayer.strokeColor = color == nil ? UIColor.lightGray.cgColor : color!.cgColor
		
		shapeLayer.lineWidth = lineWidth
		shapeLayer.lineJoin = kCALineJoinRound
		
        shapeLayer.lineDashPattern = (type  == DrawSeparatorType.dashed) ? [NSNumber(value: Double(lineLength)), NSNumber(value: Double(lineSpace))] : nil
		
		let path = CGMutablePath()
		path.move(to: start)
		path.addLine(to: end)
		
		shapeLayer.path = path
		self.layer.addSublayer(shapeLayer)
	}
	
}

/// find controller
extension UIView {

    func nearestController() -> UIViewController? {
        
        var next = self.superview
        
        while next != nil {
            
            if let nextResponder = next?.next as? UIViewController {
                return nextResponder
            }
            
            next = next?.superview
        }
        return nil
    }
	
}

/// find topMost view controller
extension UIViewController {
	
	/// Returns the current application's top most view controller.
	open class var topMost: UIViewController? {
		var rootViewController: UIViewController?
		let currentWindows = UIApplication.shared.windows
		
		for window in currentWindows {
			if let windowRootViewController = window.rootViewController {
				rootViewController = windowRootViewController
				break
			}
		}
		
		return self.topMost(of: rootViewController)
	}
	
	/// Returns the top most view controller from given view controller's stack.
	open class func topMost(of viewController: UIViewController?) -> UIViewController? {
		// UITabBarController
		if let tabBarController = viewController as? UITabBarController,
			let selectedViewController = tabBarController.selectedViewController {
			return self.topMost(of: selectedViewController)
		}
		
		// UINavigationController
		if let navigationController = viewController as? UINavigationController,
			let visibleViewController = navigationController.visibleViewController {
			return self.topMost(of: visibleViewController)
		}
		
		// UIPageController
		if let pageViewController = viewController as? UIPageViewController,
			pageViewController.viewControllers?.count == 1 {
			return self.topMost(of: pageViewController.viewControllers?.first)
		}
		
		// presented view controller
		if let presentedViewController = viewController?.presentedViewController {
			return self.topMost(of: presentedViewController)
		}
		
		// child view controller
		for subview in viewController?.view?.subviews ?? [] {
			if let childViewController = subview.next as? UIViewController {
				return self.topMost(of: childViewController)
			}
		}
		
		return viewController
	}
	
}

