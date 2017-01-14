//
//  CalendarViewController.swift
//  LSDPush-upsPlan
//
//  Created by LSD on 2017/1/13.
//  Copyright © 2017年 LSD. All rights reserved.
//

import UIKit
import JTAppleCalendar
//import CellView

class CalendarViewController: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    var firstLaunched = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDateLabel(date: Date())
        calendarInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstLaunched {
            reloadData()
        }
    }

    func setDateLabel(date: Date) {
        dateLabel.text = DateFormatter().string(format: "yyyy年MMM", from: date)
    }
    
    func calendarInit() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.registerCellViewXib(file: "CellView")
        calendarView.cellInset = CGPoint(x: 0, y: 0)
    }
    
    func reloadData() {
        firstLaunched = false
        calendarView.scrollToDate(Date())
    }
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = DateFormatter().date(format: nil, from: "2017-01-13")
        let endDate = DateFormatter().date(format: nil, from: "2018-12-31")
        
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
        
        (cell as? CellView)?.handleCellSelection(cellState: cellState, date: date, selectedDate: nil)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
//        selectedDate = date
//        (cell as? CellView)?.cellSelectionChanged(cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
//        (cell as? CellView)?.cellSelectionChanged(cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willResetCell cell: JTAppleDayCellView) {
//        (cell as? CellView)?.selectedView.isHidden = true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let startDate = visibleDates.monthDates.first
        setDateLabel(date: startDate!)
    }
}

