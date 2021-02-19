//
//  TableViewController.swift
//  LostTimeApplication
//
//  Created by Andrew Romanov on 31.12.2020.
//

import UIKit
import GameKit

struct IncrementTimer {
    let timer: Timer
    let modelIndex: Int
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    typealias ModelsList = Array<DataModel>
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 100.0
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
    var incrementTimersList = Array<IncrementTimer>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let add100Items = UIBarButtonItem(title: "100",
                                         style: .plain,
                                         target: self,
                                         action: #selector(schedule100Timers))
        let add1000Items = UIBarButtonItem(title: "1000",
                                           style: .plain,
                                           target: self,
                                           action: #selector(schedule1000Timers))
        self.navigationItem.rightBarButtonItems = [add100Items, add1000Items]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.produceModels(withCompletion: { (list:ModelsList) in
            self.models = list
        })
    }

    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as! DataTableViewCell
        let model = self.model(for: indexPath)
        cell.valueLabel.text = "\(model.value)";
        cell.longTextLabel.text = self.longText(forModel: model)
        cell.setNumber(ofItems: Int(model.numberOfItems))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = DataTableViewCell.hintHeight()
        return height
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.scheduleTimer(forModelAt: indexPath.row)
    }

    private func model(for indexPath: IndexPath) -> DataModel {
        return self.models[indexPath.row]
    }

    private func longText(forModel model: DataModel) -> String {
        var text = model.text
        if model.numberOfItems > 1 {
            for _ in 1..<model.numberOfItems {
                if !text.isEmpty {
                    text.append("\n")
                }
                text.append(model.text)
            }
        }
        return text
    }

    private func produceModels(withCompletion completion: @escaping (_ list: ModelsList) -> Void) -> Void {
        DispatchQueue.global(qos: .userInitiated).async {
            var models = ModelsList()

            let randomGenerator = GKRandomDistribution(lowestValue: 1, highestValue: 10)
            let bigValuesGenerator = GKRandomDistribution(lowestValue: 1, highestValue: 10000000)
            for _ in 0..<10000 {
                Thread.sleep(forTimeInterval: 0.00001)
                let model = DataModel(text: "Hello \(bigValuesGenerator.nextInt())", value: randomGenerator.nextInt(), numberOfItems: UInt(randomGenerator.nextInt()))
                models.append(model)
            }

            DispatchQueue.main.async {
                completion(models)
            }
        }
    }

    private func scheduleTimer(forModelAt index: Int) {
        guard !self.incrementTimersList.contains(where: {$0.modelIndex == index})  else {
            return
        }
        guard index >= 0 && index<self.models.count else {
            return
        }
        let timer = Timer(timeInterval: 0.4, repeats: true) { [weak self] (_) in
            guard let self = self else {
                return
            }
            let model = self.models[index]
            model.value += 1
            //наблюдаются интересные глюки
            //self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            self.tableView.reloadData()
        }
        self.incrementTimersList.append(IncrementTimer(timer: timer, modelIndex: index))
        RunLoop.current.add(timer, forMode: .common)
    }


    @objc private func schedule100Timers() {
        self.scheduleNext(100)
    }

    @objc private func schedule1000Timers() {
        self.scheduleNext(1000)
    }

    var lastScheduledIndex = -1
    private func scheduleNext(_ num: Int) {
        let startIndex = lastScheduledIndex + 1
        guard  startIndex < self.models.count  else {
            return
        }
        for i in startIndex..<min(startIndex+num, self.models.count - 1) {
            self.scheduleTimer(forModelAt: i)
        }
    }
}
