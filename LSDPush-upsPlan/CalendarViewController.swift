//
//  CalendarViewController.swift
//  LSDPush-upsPlan
//
//  Created by LSD on 2017/1/13.
//  Copyright © 2017年 LSD. All rights reserved.
//

import UIKit
import RealmSwift
import JTAppleCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var pushUpsLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!

    let result = try! Realm().objects(PushUpModel.self)
    
    var firstLaunched = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstLaunched {
            reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func calendarInit() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.registerCellViewXib(file: "CellView")
        calendarView.cellInset = CGPoint(x: 0, y: 0)
    }
    
    func reloadData() {
        firstLaunched = false
        calendarView.reloadData(withAnchor: Date(), animation: true)
        updateUI(date: Date())
    }
    
    func updateUI(date: Date) {
        dateLabel.text = DateFormatter().string(format: "yyyy年MMM", from: date)
        let monthModel = result.filter("date BEGINSWITH %@", DateFormatter().string(format: "yyyy-MM", from: date))
        if monthModel.count > 0 {
            daysLabel.text = String(monthModel.count)
            let count: Int = monthModel.sum(ofProperty: "pushUpCount")
            pushUpsLabel.text = String(count)
        } else {
            daysLabel.text = "0"
            pushUpsLabel.text = "0"
        }
    }
    
    
}


extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = DateFormatter().date(format: nil, from: "2017-01-13")
        var dateComponents = DateComponents()
        dateComponents.month = 1
        let endDate = Calendar.current.date(byAdding: dateComponents, to: Date())!
        
        let parameters = ConfigurationParameters.init(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let dateString = DateFormatter().string(format: nil, from: date)
        
        
        if let count = result.filter("date == %@", dateString).first?.pushUpCount {
            (cell as? CellView)?.handleCell(cellState: cellState, date: date, marking: count > 0)
            return
        }
        
        (cell as? CellView)?.handleCell(cellState: cellState, date: date, marking: false)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
//        selectedDate = date
//        (cell as? CellView)?.cellSelectionChanged(cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
//        (cell as? CellView)?.cellSelectionChanged(cellState, date: date)
    }
    
//    func calendar(_ calendar: JTAppleCalendarView, willResetCell cell: JTAppleDayCellView) {
//        (cell as? CellView)?.resetCell()
//    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let startDate = visibleDates.monthDates.first
        updateUI(date: startDate!)
    }
}

