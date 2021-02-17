//
//  DataTableViewCell.swift
//  LostTimeApplication
//
//  Created by Andrew Romanov on 31.12.2020.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet var longTextLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!

    private var numberOfItems = 0
    private var items = Array<UIView>()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setNumber(ofItems number:Int) {
        self.numberOfItems = number
        self.updateItems()
    }

    static func hintHeight() -> CGFloat {
        return UITableView.automaticDimension
    }

    private func updateItems() {
//        self.items.forEach {
//            $0.removeFromSuperview()
//        }
//        if self.items.count > self.numberOfItems {
//            self.items.removeLast(self.items.count - self.numberOfItems)
//        }
//        if self.items.count < self.numberOfItems {
//
//        }
    }

    private func createItemView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.red
        return view
    }

}
