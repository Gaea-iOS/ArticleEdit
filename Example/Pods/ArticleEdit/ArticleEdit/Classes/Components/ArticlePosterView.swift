//
//  ArticlePosterView.swift
//  ArticleEditDemo
//
//  Created by Garen on 2017/9/1.
//  Copyright © 2017年 cgc. All rights reserved.
//

import UIKit
import SnapKit

public class ArticlePosterData: CustomDebugStringConvertible {
	public var avatar: String?
	public var name: String?
	public var dateString: String?

	public var debugDescription: String {
		return "avatar: \(String(describing: avatar)), name: \(String(describing: name)), dateString: \(String(describing: dateString)) "
	}
}

class ArticlePosterView: ArticleComponent {
	
	private lazy var avatarView: UIImageView = {
		let avatarView = UIImageView()
		return avatarView
	}()
	
	private lazy var nameLabel: UILabel = {
		let nameLabel = UILabel()
		nameLabel.font = AEUIConfig.shared.posterConfig.nameFont
		nameLabel.textAlignment = .left
		nameLabel.textColor = AEUIConfig.shared.posterConfig.nameColor
		return nameLabel
	}()
	
	private lazy var timeLabel: UILabel = {
		let timeLabel = UILabel()
		timeLabel.font = AEUIConfig.shared.posterConfig.timeFont
		timeLabel.textAlignment = .right
		timeLabel.textColor = AEUIConfig.shared.posterConfig.timeTextColot
		return timeLabel
	}()
	
	public var setImage: UIImage? {
		didSet {
			avatarView.image = setImage
		}
	}
	
	public var posterData: ArticlePosterData? {
		didSet {
			guard let posterData = posterData else { return }
			nameLabel.text = posterData.name
			timeLabel.text = posterData.dateString
		}
	}
	
	public convenience init() {
		self.init(frame: .zero)
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupViews()
	}
	
	private func setupViews() {
		
		addSubview(avatarView)
		addSubview(nameLabel)
		addSubview(timeLabel)
		
		avatarView.layer.cornerRadius = AEUIConfig.shared.posterConfig.avaterHeight / 2
		avatarView.layer.masksToBounds = true
		avatarView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(AEUIConfig.shared.posterConfig.insets.left)
			make.top.equalToSuperview().offset(AEUIConfig.shared.posterConfig.insets.top)
			make.bottom.equalToSuperview().offset(-AEUIConfig.shared.posterConfig.insets.bottom)
			make.width.height.equalTo(AEUIConfig.shared.posterConfig.avaterHeight)
		}
		
		nameLabel.snp.makeConstraints { (make) in
			make.left.equalTo(self.avatarView)
			make.centerY.equalToSuperview()
		}
		
		timeLabel.snp.makeConstraints { (make) in
			make.right.equalToSuperview().offset(-AEUIConfig.shared.posterConfig.insets.right)
			make.centerY.equalToSuperview()
		}
		
	}
	
	
}
