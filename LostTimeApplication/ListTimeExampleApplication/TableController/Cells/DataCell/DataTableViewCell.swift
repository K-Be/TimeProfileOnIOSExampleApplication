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

    static func hintHeight(for longText: String, valueText: String, withWidth width: CGFloat) -> CGFloat {
        let widthForLayout: CGFloat = width - 16.0 - 16.0
        let labelsPadding: CGFloat = 10.0

        let sizeForValue: CGSize = valueText.boundingRect(with: CGRect.infinite.size,
                                                          options: .usesLineFragmentOrigin,
                                                          attributes: [.font: UIFont.systemFont(ofSize: 17.0)],
                                                          context: nil).size
        let widthForDescription = widthForLayout - sizeForValue.width - labelsPadding
        let heightOfDescription = longText.height(withConstrainedWidth: widthForDescription,
                                                  font: .systemFont(ofSize: 17.0))
        return heightOfDescription + 16.0 * 2.0
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
