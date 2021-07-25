//
//  NoDataView.swift
//  HamrameMan
//
//  Created by ali on 9/1/20.
//  Copyright © 2020   Alireza. All rights reserved.
//

import UIKit

@IBDesignable class CustomCallout: UIView {
    
    @IBOutlet var customCalloutView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seeDetailButton: UIButton!
    
    
    //MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        nibSetup()
        customCalloutView?.prepareForInterfaceBuilder()
    }
    
    //MARK:- Lifecycle methods
    private func nibSetup() {
        guard let view = try? loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        customCalloutView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: CustomCallout.self)
        print("load nibName => \(nibName)")
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func fillCalloutView(with data: CenterListElement) {
        containerView.roundUp(20)
        imageView.addBorder(cornerRadius: 20, color: .brandGreen, borderWidth: 3)
        imageView.image = data.image.base64ToImage
        nameLabel.text = data.name
    }
}
