//
//  CellView.swift
//  LSDPush-upsPlan
//
//  Created by LSD on 2017/1/13.
//  Copyright © 2017年 LSD. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CellView: JTAppleDayCellView {

    
    @IBOutlet weak var dayLabel: UILabel!
    
    
    func handleCellSelection(cellState: CellState, date: Date, selectedDate: Date?) {
        
        //InDate, OutDate
        if cellState.dateBelongsTo != .thisMonth {
            self.dayLabel.text = ""
            self.isUserInteractionEnabled = false
        } else {
            self.isUserInteractionEnabled = true
            dayLabel.text = cellState.text
//            dayLabel.textColor = selectableDateColor
        }
        
        dayLabel.textColor = UIColor.black
        
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            if !cellState.isSelected {
                self.dayLabel.textColor = UIColor.white
            }
        }
    }

}
