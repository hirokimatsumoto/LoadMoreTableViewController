//
//  ViewController.swift
//  LoadMoreTableViewController
//
//  Created by mishimay on 10/22/2015.
//  Copyright (c) 2015 istyle Inc. All rights reserved.
//

import UIKit
import LoadMoreTableViewController

//セルが表示された日時と遅延時間を表示する関数
func delay(_ delay: TimeInterval, block: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        block()
    }
}

class ViewController: LoadMoreTableViewController {

    private var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        //クリアボタンの設置
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear))
        //リフレッシュボタンの設置
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refresh))

        //refreshControl = UIRefreshControl()
        //refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        //cellReuseIdentifierの指定
        tableView.register(UINib(nibName: "SampleCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        // tableView.register(UINib(nibName: "AdCell", bundle: nil), forCellReuseIdentifier: "Ad")

        //リトライボタンのテキストを指定
        LoadMoreTableViewController.retryText = "Custom Retry Text"
        
        /*//AdCellを作成する
        fetchCellReuseIdentifier = { [weak self] row in
            return self?.sourceObjects[row] is NSNull ? "Ad" : nil
        }*/
        
        //５個ずつSampleCellセルを作成する
        fetchSourceObjects = { [weak self] completion in
            var newNumbers = [Int]()
            for _ in 0..<5 {
                self?.count += 1
                newNumbers.append(self?.count ?? 0)
            }
            
            delay(1) { // データをフェッチする

                /*
                // 20セル表示されるたびに、retry buttonを表示る
                let showRetryButton = newNumbers.filter { $0 % 20 == 0 }.count > 0
                if showRetryButton {
                    delay(0.1) {
                        self?.showRetryButton()
                    }
                }*/

                let refreshing = self?.refreshControl?.isRefreshing == true
                if refreshing {
                    self?.refreshControl?.endRefreshing()
                }

                delay(refreshing ? 0.3 : 0) {
                    completion(newNumbers.map { "sample \($0)" } + [NSNull()], true)
                }
            }
        }
        //セルの表示内容の設定
        configureCell = { [weak self] cell, row in
            if cell.reuseIdentifier == self?.cellReuseIdentifier {
                cell.textLabel?.text = self?.sourceObjects[row] as? String
                cell.detailTextLabel?.text = NSDate().description
            }
            return cell
        }
        //セルを選択した時の処理
        didSelectRow = { [weak self] row in
            if let title = self?.sourceObjects[row] as? String {
                print("did select \(title)")
            }
        }
    }

    /*
    //クリアボタンの処理
    func clear() {
        count = 0
        refreshData(immediately: true)
    }

    //リフレッシュボタンの処理
    func refresh() {
        count = 0
        refreshData(immediately: false)
    }*/

}
