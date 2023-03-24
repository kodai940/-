//
//  QuestionText.swift
//  MyPracticeLayout
//
//  Created by user on 2023/03/11.
//

import UIKit

class QuestionText: UITextView {
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
}
