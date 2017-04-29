//
//  ViewController.swift
//  FixedTableViewSample
//
//  Created by satorun on 2017/04/29.
//  Copyright © 2017年 satorun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var fixedViewController: FixedViewController {
        return childViewControllers[0] as! FixedViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addObserver(self, forKeyPath: "contentSize", options: [.new], context: nil)
        let insetY = fixedViewController.containerView.frame.height
        tableView.contentInset.top = insetY
        tableView.contentOffset.y = -insetY
        tableView.backgroundView?.alpha = 0.0
        tableView.showsVerticalScrollIndicator = false
        
        fixedViewController.emptyContainerView.targetView = tableView
        fixedViewController.didScrollClosure = {
            self.tableView.contentOffset.y = $0 - self.tableView.contentInset.top
        }
        
    }
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            print("\(String(describing: change))")
            fixedViewController.scrollViewContentSize = (change?[.newKey] as? CGSize) ?? CGSize.zero
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fixedViewController.didScroll(diff: scrollView.contentOffset.y + scrollView.contentInset.top)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        fixedViewController.scrollView.flashScrollIndicators()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(indexPath.section)-\(indexPath.row)"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: \(indexPath.section)-\(indexPath.row)")
    }
}
