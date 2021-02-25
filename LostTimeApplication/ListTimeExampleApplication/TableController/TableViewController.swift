//
//  TableViewController.swift
//  LostTimeApplication
//
//  Created by Andrew Romanov on 31.12.2020.
//

import UIKit
import GameKit

struct IncrementTimer: Hashable, Equatable {
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
    @IBOutlet var progressView : UIProgressView!
    var progress: Progress?
    var progressObservation: NSKeyValueObservation?
    let updateProgressOperationsQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
        return queue
    }()
    let timersScheduler = TimersScheduler()

    var models = ModelsList() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var incrementTimersList = Set<IncrementTimer>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let add100Items = UIBarButtonItem(title: "100",
                                         style: .plain,
                                         target: self,
                                         action: #selector(schedule100Timers))
        let add1000Items = UIBarButtonItem(title: "100000",
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
        let countModels = 10_000_000
        let progress = Progress(totalUnitCount: Int64(countModels))
        self.progressObservation = progress.observe(\.fractionCompleted,
                                                    changeHandler: { [weak self](sender:Progress, _) in
                                                      self?.scheduleUpdateProgress(with: sender.fractionCompleted)
                                                    })
        self.progress = progress
        DispatchQueue.global(qos: .userInitiated).async {
            var models = ModelsList()
            models.reserveCapacity(countModels)

            let randomGenerator = GKRandomDistribution(lowestValue: 1, highestValue: 10)
            let bigValuesGenerator = GKRandomDistribution(lowestValue: 1, highestValue: 10000000)
            for index in 0..<countModels {
                let model = DataModel(text: "Hello \(bigValuesGenerator.nextInt())", value: randomGenerator.nextInt(), numberOfItems: UInt(randomGenerator.nextInt()))
                models.append(model)
                if index % 10000 == 0 {
                    progress.completedUnitCount = Int64(index + 1)
                }
            }

            DispatchQueue.main.async {
                completion(models)
                self.progressObservation = nil
                self.progress = nil
            }
        }
    }

    private func scheduleTimer(forModelAt index: Int) {
        let model = IncrementTimer(modelIndex: index)
        guard !self.incrementTimersList.contains(model) else {
            return
        }
        guard index >= 0 && index<self.models.count else {
            return
        }
        self.incrementTimersList.insert(model)
        self.timersScheduler.scheduleBlock({ [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.execSyncOnMain {
                let model = self.models[index]
                model.value += 1
                guard let visibleIndexes = self.tableView.indexPathsForVisibleRows else {
                    return
                }
                guard let visibleRowIndex = visibleIndexes.first(where: {$0.row == index}) else {
                    return
                }
                guard let cell = self.tableView.cellForRow(at: visibleRowIndex) as? DataTableViewCell else {
                    return
                }
                cell.valueLabel.text = "\(model.value)"
            }
        },
                                           withTime: 0.4)
    }


    @objc private func schedule100Timers() {
        self.scheduleNext(100)
    }

    @objc private func schedule1000Timers() {
        self.scheduleNext(100000)
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

    private func scheduleUpdateProgress(with value: Double) {
        let operations = self.updateProgressOperationsQueue.operations
        operations.forEach { (op:Operation) in
            guard !op.isCancelled && !op.isExecuting && !op.isFinished else {
                return
            }
            op.cancel()
        }
        self.updateProgressOperationsQueue.schedule {
            DispatchQueue.main.sync {
                self.progressView.progress = Float(value)
            }
        }
    }
}
