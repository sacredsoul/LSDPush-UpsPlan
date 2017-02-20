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
    @IBOutlet weak var markView: UIImageView!
    
    
    func handleCell(cellState: CellState, date: Date, marking: Bool) {
        
        //InDate, OutDate
        if cellState.dateBelongsTo != .thisMonth {
            self.isUserInteractionEnabled = false
            self.dayLabel.text = ""
            markView.image = nil
        } else {
            self.isUserInteractionEnabled = true
            dayLabel.text = cellState.text
            if marking {
                markView.image = UIImage.init(named: "Mark")
            } else {
                markView.image = nil
            }
        }
        
        dayLabel.textColor = UIColor.init(red: 213.0/255.0, green: 217.0/255.0, blue: 186.0/255.0, alpha: 1.0)
        
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            self.dayLabel.textColor = UIColor.init(red: 222.0/255.0, green: 54.0/255.0, blue: 105.0/255.0, alpha: 1.0)
        }
    }
    
//    func resetCell() {
//        markView.image = nil
//    }

}
