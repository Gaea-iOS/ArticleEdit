//
//  ViewController.swift
//  ArticleEdit
//
//  Created by GarenChen on 09/01/2017.
//  Copyright (c) 2017 GarenChen. All rights reserved.
//

import UIKit
import ArticleEdit

class ViewController: UIViewController {

	let tableView = ArticleEditingView(frame: .zero, imageSelector: DefaultImageSelector(), imageUploader: DefaulImageUpLoader(), imageDownloader: DefaultImageDownloader())
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		automaticallyAdjustsScrollViewInsets = false
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

