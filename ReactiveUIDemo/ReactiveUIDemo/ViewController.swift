//
//  ViewController.swift
//  ReactiveControlDemo
//
//  Created by Zhixuan Lai on 1/8/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit
import ReactiveUI

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        title = "ReactiveUI Demo"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Timer", style: .Plain) { _ in
            NSTimer.scheduledTimerWithTimeInterval(1, action: {timer in
                let alertController = UIAlertController(title: "Alert", message: "Time's up!", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in}
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in}
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }, repeats: false)
            return
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action) {_ in
            let alertController = UIAlertController(title: "ActionSheet", message: "You just tapped rightBarButtonItem.", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in}
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in}
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        let refreshControl = UIRefreshControl(forControlEvents: .ValueChanged) { r in
            let r = r as! UIRefreshControl
            let alertController = UIAlertController(title: "Alert", message: "You just pulled refreshControl.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                r.endRefreshing()
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                r.endRefreshing()
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        tableView.addSubview(refreshControl)
    }

    var controlSectionDetailLabels = [UILabel?](count: TableViewControllerSection.UIControlRow.Count.rawValue, repeatedValue: nil)
    var gestureRecognizerSectionDetailLabels = [UILabel?](count: TableViewControllerSection.UIControlRow.Count.rawValue, repeatedValue: nil)
    
    // MARK: - Cells
    enum TableViewControllerSection: Int {
        case UIControl, UIGestureRecognizer, Count
        
        enum UIControlRow: Int {
            case UIButton, UISwitch, UISlider, UISegmentedControl, UIStepper, UIDatePicker, Count
            var description: String {
                switch self {
                case .UIButton: return "Button"
                case .UISwitch: return "Switch"
                case .UISlider: return "Slider"
                case .UISegmentedControl: return "Segmented Control"
                case .UIStepper: return "Stepper"
                case .UIDatePicker: return ""
                default: return ""
                }
            }
            var height: CGFloat {
                switch self {
                case .UIButton, .UISwitch, .UISlider, .UISegmentedControl, .UIStepper: return 44.0
                case .UIDatePicker: return 216.0
                default: return 0
                }
            }
        }
        
        enum UIGestureRecognizerRow: Int {
            case UILongPressGestureRecognizer, UIPanGestureRecognizer, UIPinchGestureRecognizer, UITapGestureRecognizer, Count
            var description: String {
                switch self {
                case .UILongPressGestureRecognizer: return "Long Press"
                case .UIPanGestureRecognizer: return "Pan"
                case .UIPinchGestureRecognizer: return "Pinch"
                case .UITapGestureRecognizer: return "Tap"
                default: return ""
                }
            }
            var height: CGFloat {
                return 100.0
            }
        }
        
        static let sectionTitles = [UIControl: "UI Control", UIGestureRecognizer: "UI Gesture Recognizer"]
        static let sectionCount = [UIControl: UIControlRow.Count.rawValue, UIGestureRecognizer: UIGestureRecognizerRow.Count.rawValue];
        
        var sectionHeaderTitle: String {
            if let sectionTitle = TableViewControllerSection.sectionTitles[self] {
                return sectionTitle
            } else {
                return "Section"
            }
        }
        
        var sectionRowCount: Int {
            if let sectionCount = TableViewControllerSection.sectionCount[self] {
                return sectionCount
            } else {
                return 0
            }
        }
    }

    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TableViewControllerSection.Count.rawValue
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewControllerSection(rawValue:section)!.sectionRowCount
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TableViewControllerSection(rawValue:section)!.sectionHeaderTitle
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch TableViewControllerSection(rawValue:indexPath.section)! {
        case .UIControl: return TableViewControllerSection.UIControlRow(rawValue: indexPath.row)!.height
        case .UIGestureRecognizer: return TableViewControllerSection.UIGestureRecognizerRow(rawValue: indexPath.row)!.height
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = String(format: "s%li-r%li", indexPath.section, indexPath.row)
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell==nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: cellIdentifier)
        }
        
        cell.selectionStyle = .None
        switch TableViewControllerSection(rawValue:indexPath.section)! {
        case .UIControl:
            let row = TableViewControllerSection.UIControlRow(rawValue: indexPath.row)!
            cell.textLabel!.text = row.description
            controlSectionDetailLabels[indexPath.row] = cell.detailTextLabel
            switch row {
            case .UIButton:
                let acc = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
                acc.setTitle("Hit", forState: .Normal)
                acc.setTitleColor(view.tintColor, forState: .Normal)
                acc.addAction({control in
                    self.controlSectionDetailLabels[indexPath.row]?.text = "TouchDown"},
                    forControlEvents: .TouchDown)
                acc.addAction({control in
                    self.controlSectionDetailLabels[indexPath.row]?.text = "TouchUpInside"},
                    forControlEvents: .TouchUpInside)
                acc.addAction({control in
                    self.controlSectionDetailLabels[indexPath.row]?.text = "TouchDragOutside"},
                    forControlEvents: .TouchDragOutside)
                cell.accessoryView = acc
            case .UISwitch:
                let acc = UISwitch()
                acc.addAction({control in
                    let c = control as! UISwitch
                    self.controlSectionDetailLabels[indexPath.row]?.text = "\(c.on)"},
                    forControlEvents: .ValueChanged)
                cell.accessoryView = acc
            case .UISlider:
                let acc = UISlider()
                acc.addAction({control in
                    let c = control as! UISlider
                    self.controlSectionDetailLabels[indexPath.row]?.text = "\(c.value)"},
                    forControlEvents: .ValueChanged)
                cell.accessoryView = acc
            case .UISegmentedControl:
                let acc = UISegmentedControl(items: ["Zero","One"])
                acc.addAction({control in
                    let c = control as! UISegmentedControl
                    self.controlSectionDetailLabels[indexPath.row]?.text = "\(c.selectedSegmentIndex)"},
                    forControlEvents: .ValueChanged)
                cell.accessoryView = acc
            case .UIStepper:
                let acc = UIStepper()
                acc.addAction({control in
                    let c = control as! UIStepper
                    self.controlSectionDetailLabels[indexPath.row]?.text = "\(c.value)"},
                    forControlEvents: .ValueChanged)
                cell.accessoryView = acc
            case .UIDatePicker:
                let labelHeight = CGFloat(20)
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: labelHeight))
                label.textColor = UIColor.grayColor()
                label.textAlignment = .Center
                cell.addSubview(label)
                controlSectionDetailLabels[indexPath.row] = label

                let acc = UIDatePicker(frame: CGRect(x: 0, y: labelHeight, width: view.frame.width, height: row.height))
                acc.addAction({control in
                    let c = control as! UIDatePicker
                    self.controlSectionDetailLabels[indexPath.row]?.text = "\(c.date)"},
                    forControlEvents: .ValueChanged)
                cell.addSubview(acc)
            default:
                cell.textLabel!.text = "UIControl"
            }
        case .UIGestureRecognizer:
            let row = TableViewControllerSection.UIGestureRecognizerRow(rawValue: indexPath.row)!
            cell.textLabel!.text = row.description
            gestureRecognizerSectionDetailLabels[indexPath.row] = cell.detailTextLabel
            switch row {
            case .UILongPressGestureRecognizer:
                let gr = UILongPressGestureRecognizer()
                gr.addAction({gr in
                    let text = "\(gr.locationInView(gr.view))"
                    self.gestureRecognizerSectionDetailLabels[indexPath.row]?.text = text })
                cell.addGestureRecognizer(gr)
            case .UIPanGestureRecognizer:
                let gr = UIPanGestureRecognizer()
                gr.addAction({gr in
                    let text = "\(gr.locationInView(gr.view))"
                    self.gestureRecognizerSectionDetailLabels[indexPath.row]?.text = text })
                cell.addGestureRecognizer(gr)
            case .UIPinchGestureRecognizer:
                let gr = UIPinchGestureRecognizer()
                gr.addAction({gr in
                    let text = "\(gr.locationInView(gr.view))"
                    self.gestureRecognizerSectionDetailLabels[indexPath.row]?.text = text })
                cell.addGestureRecognizer(gr)
            case .UITapGestureRecognizer:
                let gr = UITapGestureRecognizer()
                gr.addAction({gr in
                    let text = "\(gr.locationInView(gr.view))"
                    self.gestureRecognizerSectionDetailLabels[indexPath.row]?.text = text })
                cell.addGestureRecognizer(gr)
            default:
                cell.textLabel!.text = "UIGestureRecognizer"
            }
        default:
            cell.textLabel!.text = "N/A"
        }
        
        return cell
    }
    
}

