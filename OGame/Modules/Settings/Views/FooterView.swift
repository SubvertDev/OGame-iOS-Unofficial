//
//  FooterView.swift
//  OGame
//
//  Created by Subvert on 4/15/22.
//

import UIKit

final class FooterView: UIView {
    
    private let topTextView: UITextView = {
       let textView = UITextView()
        let attributedString = NSMutableAttributedString(string: "© 2002 Gameforge 4D GmbH. All rights reserved.")
        let url = URL(string: "http://www.gameforge.com/")!
        attributedString.setAttributes([.link: url], range: NSMakeRange(0, attributedString.length))
        textView.attributedText = attributedString
        textView.linkTextAttributes = [.foregroundColor: UIColor.systemBlue,
                                       .underlineStyle: NSUnderlineStyle.single.rawValue]
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 15)
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let bottomTextView: UITextView = {
       let textView = UITextView()
        let attributedString = NSMutableAttributedString(string: "Help | Forum | Rules | Legal")
        let helpUrl = URL(string: "http://wiki.ogame.org/")!
        let forumUrl = URL(string: "https://board.en.ogame.gameforge.com/")!
        let rulesUrl = URL(string: "Rules")!
        let legalUrl = URL(string: "https://agbserver.gameforge.com/rewrite.php?locale=en&type=imprint&product=ogame")!
        
        attributedString.setAttributes([.link: helpUrl], range: NSMakeRange(0, 4))
        attributedString.setAttributes([.link: forumUrl], range: NSMakeRange(7, 5))
        attributedString.setAttributes([.link: rulesUrl], range: NSMakeRange(15, 5))
        attributedString.setAttributes([.link: legalUrl], range: NSMakeRange(23, 5))
        textView.attributedText = attributedString
        textView.linkTextAttributes = [.foregroundColor: UIColor.systemBlue,
                                       .underlineStyle: NSUnderlineStyle.single.rawValue]
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 15)
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    private func addSubviews() {
        addSubview(topTextView)
        addSubview(bottomTextView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            topTextView.topAnchor.constraint(equalTo: topAnchor),
            topTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomTextView.topAnchor.constraint(equalTo: topTextView.bottomAnchor),
            bottomTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
