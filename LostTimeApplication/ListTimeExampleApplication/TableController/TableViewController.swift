//
//  TableViewController.swift
//  LostTimeApplication
//
//  Created by Andrew Romanov on 31.12.2020.
//

import UIKit
import GameKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    typealias ModelsList = Array<DataModel>

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "DataTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "DataTableViewCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    var models = ModelsList() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.models = self.produceModels()
    }

    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as? DataTableViewCell
        let model = self.model(for: indexPath)
        cell.valueLabel.text = "\(model.value)";
        cell.longTextLabel.text = self.longText(forModel: model)
        cell.setNumber(ofItems: Int(model.numberOfItems))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.model(for: indexPath)
        let height = DataTableViewCell.hintHeight(for:self.longText(forModel: model),
                                                  valueText: "\(model.value)",
                                                  withWidth: tableView.bounds.width)
        return height
    }

    private func model(for indexPath: IndexPath) -> DataModel {
        return self.models[indexPath.row]
    }

    private func longText(forModel model: DataModel) -> String {
        var text = model.text
        if model.value > 1 {
            for _ in 1..<model.value {
                if !text.isEmpty {
                    text.append("\n")
                }
                text.append(model.text)
            }
        }
        return text
    }

    private func produceModels() -> ModelsList {
        var models = ModelsList()

        let randomGenerator = GKRandomDistribution(lowestValue: 1, highestValue: 10)
        let bigValuesGenerator = GKRandomDistribution(lowestValue: 1, highestValue: 10000000)
        for _ in 0..<10000 {
            Thread.sleep(forTimeInterval: 0.00001)
            let model = DataModel(text: "Hello \(bigValuesGenerator.nextInt())", value: randomGenerator.nextInt(), numberOfItems: UInt(randomGenerator.nextInt()))
            models.append(model)
        }

        return models
    }
}
