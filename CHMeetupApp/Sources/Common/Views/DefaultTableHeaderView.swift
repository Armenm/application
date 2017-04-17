//
//  DefaultTableHeaderView.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 18/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class DefaultTableHeaderView: UITableViewHeaderFooterView {

  @IBOutlet var headerLabel: UILabel! {
    didSet {
      headerLabel.font = UIFont.appFont(.avenirNextDemiBold(size: 16))
      headerLabel.textColor = UIColor(.gray)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.backgroundColor = UIColor(.lightGray).withAlphaComponent(1.0)
  }
}
