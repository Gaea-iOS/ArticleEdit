//
//  AriticleSeparator.swift
//  ArticleEditDemo
//
//  Created by ChenGuangchuan on 2017/8/31.
//  Copyright © 2017年 cgc. All rights reserved.
//

import UIKit
import SnapKit

public class AriticleSeparator: ArticleComponent {
    
    private lazy var separator: UIView = {
        let sp = UIView()
        sp.backgroundColor = AEUIConfig.shared.separatorConfig.color
        return sp
    }()

    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        
        addSubview(separator)
        separator.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(AEUIConfig.shared.separatorConfig.height)
            make.edges.equalToSuperview().inset(AEUIConfig.shared.separatorConfig.insets)
        }
    
    }
}
