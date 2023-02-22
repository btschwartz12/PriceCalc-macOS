//
//  ViewController.swift
//  food_calc
//
//  Created by Ben Schwartz on 12/12/21.
//

import Cocoa


// MARK: Properties
class ViewController: NSViewController {
    //all objects in view
    @IBOutlet weak var order_field: NSTextField!
    @IBOutlet weak var num_label: NSTextField!
    @IBOutlet weak var stepper: NSStepper!
    @IBOutlet weak var name_field: NSTextField!
    @IBOutlet weak var sub_field: NSTextField!
    @IBOutlet weak var total_field: NSTextField!
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var table_view: NSTableView!
    // struct that contains everything in an order
    struct Order {
        var name : String
        var subtotal : Double
        var total : Double?
    }
    // all orders stored here
    var orders : [Order] = []
    // amount of orders present, starts with one
    var num_orders : Int = 1
    // bool that remembers if there is confirming going on
    var confirming : Bool = false
    // index of the current order being presented
    var cur_order : Int = 0
    // ran at start
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override var representedObject: Any? {
        didSet {
            print("piper" + representedObject.debugDescription)
        }
    }
    
}
// MARK: view update functions ( initialize(), update() and load() )
extension ViewController {
    // sets initial conditions
    func initialize() {
        // table_view.reloadData();
        table_view.delegate = self;
        table_view.dataSource = self;
        orders.append(Order(name: "#" + String(cur_order + 1), subtotal: 0.00))
        label.stringValue = "enter first order"
        order_field.stringValue = "1 order"
        load(true)
    }
    // updates order info from fields *DOES NOT UPDATE TABLE*
    func update() -> Bool  {
        // reading from name_field and sub_field, storing into order if they are valid inputs
        if let name = name_field.stringValue as String?, let sub = Double(sub_field.stringValue) {
            if name != "" && sub >= 0 {
                orders[cur_order].name = name
                orders[cur_order].subtotal = sub
                load()
                return true
            }
        }
        label.stringValue = "check order " + String(cur_order + 1)
        return false
    }
    // loads in different order for modification *DOES NOT UPDATE*
    func load(_ is_first : Bool = false) {
        // take order and load the fields with the order data
        let order = orders[cur_order]
        sub_field.stringValue = d_str(d: order.subtotal)
        name_field.stringValue = order.name
        // update other labels accordingly
        order_field.stringValue = "order " + String(cur_order + 1)
        num_label.stringValue = String(num_orders) + (num_orders == 1 ? " order" : " orders")
        label.stringValue = is_first ? "enter first order" : "press submit when finished"
        // reset the confirmation variable
        confirming = false
        // updates the values in the table
        table_view.reloadData()
    }
}
// MARK: movement functions ( next() and prev() )
extension ViewController {
    // moves to the right *LOADS* used by forward and stepper buttons
    func next() {
        cur_order = cur_order == num_orders - 1 ? 0 : cur_order + 1
        label.stringValue = "press submit when finished"
        load()
        
    }
    // moves to the left *LOADS* used by forward and backward buttons
    func prev() {
        cur_order = cur_order == 0 ? 0 : cur_order - 1
        label.stringValue = "press submit when finished"
        load()
    }
}
// MARK: Inputs
extension ViewController {
    
    // when the name field is done editing
    @IBAction func name_field(_ sender: Any) {
        if !update() {
            label.stringValue = "check order " + String(cur_order + 1) + " name"
        }
    }
    // when the subtotal field is done editing
    @IBAction func sub_field(_ sender: Any) {
        if !update() {
            label.stringValue = "check order " + String(cur_order + 1) + " subtotal"
        }
    }
    // when the stepper is clicked
    @IBAction func stepper(_ sender: NSStepper?) {
        guard let sender = sender else {
            label.stringValue = "please try again (error: 913)"
            return
        }
        // if clicked during confirming or when fields arent valid
        if confirming || !update() {
            return
        }
        // if the up button was clicked
        if sender.integerValue == 1 {
            if update() {
                // adds new order to end of array if current inputs are valid
                orders.append(Order(name: "#" + String(cur_order + 2), subtotal: 0.00))
                num_orders += 1
                next()
            }
            sender.integerValue = 0
            return
        }
        // if the down button was clicked
        else if sender.integerValue == 0 && num_orders > 1 {
            // start confirming process
            label.stringValue = "<- cancel   |   " + "delete order " + String(cur_order + 1) + "->"
            confirming = true
            return
        }
        // code should not reach here unless num_orders == 1
        if num_orders != 1 { label.stringValue = "please try again (error: 410)" }
    }
    // when forward button is touched
    @IBAction func forward_touched(_ sender: Any) {
        // if confirming a delete
        if confirming {
            orders.remove(at: cur_order)
            num_orders -= 1
            prev()
        }
        // going forward to next order in list
        else if update() {
            num_orders <= 1 ? label.stringValue = "add another order" : next()
        }
    }
    // when backward button is touched
    @IBAction func backward_touched(_ sender: Any) {
        // if canceling a delete
        
        //backward on one
        if confirming {
            load()
        }
        // going backward to next order in list
        else if update() {
            num_orders <= 1 ? label.stringValue = "add another order" : prev()
        }
    }
    @IBAction func submit_touched(_ sender: Any) {
        // if inputs arent entered correctly
        if !update() {
            return
        }
        // see if any orders have subtotal of 0
        for (i, _) in orders.enumerated() {
            if orders[i].subtotal == 0 {
                cur_order = i
                load()
                label.stringValue = "check order " + String(cur_order + 1)
                return
            }
        }
        // getting total from totalfield
        guard let total = total_field.doubleValue as Double? else {
            label.stringValue = "please enter a number"
            return
        }
        var cur_sub : Double = 0
        for order in orders {
            cur_sub += order.subtotal
        }
        // checking that entered value is reasonable
        if total < cur_sub {
            label.stringValue = "please enter the correct amount"
            return
        }
        // computes the total for each order
        for (i, _) in orders.enumerated() {
            orders[i].total = orders[i].subtotal / cur_sub * total
        }
        label.stringValue = "finished"
        table_view.reloadData()
    }
}
// MARK: misc
extension ViewController {
    
    func d_str(d : Double) -> String {
        if d == 0 {
            return "0.00"
        }
        return String(format: "%.2f", d)
    }
}
// MARK: NSTableViewDataSource
extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return orders.count
    }
}
// MARK: NSTableViewDelegate
extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        let CELL_ID = NSUserInterfaceItemIdentifier(rawValue: "cell")
        let NAME_ID = NSUserInterfaceItemIdentifier(rawValue: "name_cell")
        let SUB_ID = NSUserInterfaceItemIdentifier(rawValue: "sub_cell")
        let TOT_ID = NSUserInterfaceItemIdentifier(rawValue: "tot_cell")
        
        let cur_order = orders[row]
        
        switch tableColumn?.identifier {
        case NAME_ID:
            guard let cellView = table_view.makeView(withIdentifier: CELL_ID, owner: self) as? NSTableCellView else { label.stringValue = "please try again (error: 337)"; return nil }
            cellView.textField?.stringValue = cur_order.name
            return cellView
        case SUB_ID:
            guard let cellView = table_view.makeView(withIdentifier: CELL_ID, owner: self) as? NSTableCellView else { label.stringValue = "please try again (error: 003)"; return nil }
            cellView.textField?.stringValue = "$" + d_str(d: cur_order.subtotal)
            return cellView
        case TOT_ID:
            guard let cellView = table_view.makeView(withIdentifier: CELL_ID, owner: self) as? NSTableCellView else { label.stringValue = "please try again (error: 432)"; return nil }
            if let total = cur_order.total {
                cellView.textField?.stringValue = "$" + d_str(d: total)
            }
            else {
                cellView.textField?.stringValue = ""
            }
            return cellView
        default:
            label.stringValue = "please try again (error: 129)"
            return nil
        }
    }
}









