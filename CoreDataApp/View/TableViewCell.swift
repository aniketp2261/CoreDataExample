//
//  TableViewCell.swift
//  CoreDataApp
//
//  Created by Aniket Patil on 23/01/23.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var orgName: UILabel!
    @IBOutlet weak var memName: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var mobNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img.superview?.dropShadowWithCornerRaduis()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
