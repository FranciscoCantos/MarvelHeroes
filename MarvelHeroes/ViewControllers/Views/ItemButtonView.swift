//
//  ItemButtonView.swift
//  MarvelHeroes
//
//  Created by Francisco Cantos
//

import UIKit

protocol ItemButtonViewDelegate {
    func buttonTapped(withType: AppearanceType)
}

/// Button used to navigate to the appearance details of a character
class ItemButtonView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconView: UIImageView!
    
    var delegate: ItemButtonViewDelegate?
    var viewType: AppearanceType = .comics
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        let nib = UINib(nibName: "ItemButtonView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    func configureView(viewModel: AppearanceButtonViewModel) {
        titleLabel.font = UIFont(name: comicsFontName, size: 16.0)
        titleLabel.text = viewModel.getResources().title
        
        iconView.image = viewModel.getResources().icon
        iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = .white
        
        viewType = viewModel.type
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.buttonTapped(withType: viewType)
    }
}
