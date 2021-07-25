//
//  CenterItemTableViewCell.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit

class CenterItemTableViewCell: UITableViewCell {

    @IBOutlet weak var centerAddressLabel: UILabel!
    @IBOutlet weak var centerTypeLabel: UILabel!
    @IBOutlet weak var centerNameLabel: UILabel!
    @IBOutlet weak var centerImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.roundUp(20)
        centerImageView.addBorder(cornerRadius: 20, color: .brandGreen, borderWidth: 3)
    }
    
    func fillCell(with centerData: CenterListElement) {
        centerNameLabel.text = centerData.name
        centerTypeLabel.text = "نوع : \(centerData.centerType.title)"
        centerAddressLabel.text = "آدرس : \(centerData.address)"
        centerImageView.image = centerData.image.base64ToImage
    }

}
