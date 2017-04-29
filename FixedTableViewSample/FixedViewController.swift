//
//  FixedViewController.swift
//  FixedTableViewSample
//
//  Created by satorun on 2017/04/29.
//  Copyright © 2017年 satorun. All rights reserved.
//

import UIKit

class FixedViewController: UIViewController {
    let minFixHeight = CGFloat(100)
    
    @IBOutlet weak var emptyContainerView: ThroughableView!
    
    @IBOutlet private weak var emptyContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func buttonDidTapped(_ sender: UIButton) {
        print("tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var didScrollClosure: ((_: CGFloat) -> Void)?
    
    var scrollViewContentSize: CGSize = CGSize.zero {
        didSet {
            emptyContainerViewHeightConstraint.constant = scrollViewContentSize.height
            self.view.layoutIfNeeded()
            scrollView.contentSize = scrollViewContentSize
        }
    }
    
    func didScroll(diff: CGFloat) {
        scrollView.contentOffset.y = diff

        let maxContentOffsetY = containerView.frame.height - minFixHeight

        if diff < maxContentOffsetY {
            //scrollView.contentOffset.y = diff
            containerView.frame.origin.y = 0.0
        } else {
            //scrollView.contentOffset.y = maxContentOffsetY
            containerView.frame.origin.y = diff - maxContentOffsetY
        }
    }
    
}

extension FixedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let diff = scrollView.contentOffset.y + scrollView.contentInset.top
        didScrollClosure?(diff)
        didScroll(diff: diff)
    }
}

class ThroughableView: UIView {
    weak var targetView: UIView?
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else {
            return nil
        }
        if hitView == self,
            let convertedPoint = targetView?.convert(point, from: self) {
            return targetView?.hitTest(convertedPoint, with: event)
        }
        return hitView
    }
}
