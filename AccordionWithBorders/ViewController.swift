//
//  ViewController.swift
//  AccordionWithBorders
//
//  Created by K Rajeshwar on 22/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var hiddenSections = Set<Int>()
    let tableViewData = [
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
        ["1","2","3","4","5"],
    ]
    var sections = sectionsData

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item: Item = sections[indexPath.section].items[indexPath.row]
        
        cell.textLabel?.text = item.name
     //   cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.subtitleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius: CGFloat = 8
        cell.backgroundColor = UIColor.clear
        let layer: CAShapeLayer = CAShapeLayer()
        let pathRef: CGMutablePath = CGMutablePath()
        //dx leading an trailing margins
        let bounds: CGRect = cell.bounds.insetBy(dx: 0, dy: 0)
        var addLine: Bool = false
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == 0 {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.minY),
                           radius: 0)
            
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: 0)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            addLine = true
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY),
                           radius: cornerRadius)
            
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        } else {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY),
                           radius: 0)
            
            pathRef.move(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: 0)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            addLine = true
        }
        
        layer.path = pathRef
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.lineWidth = 1.0
        layer.fillColor = UIColor.clear.cgColor
        
        if addLine == true {
            let lineLayer: CALayer = CALayer()
            let lineHeight: CGFloat = (1 / UIScreen.main.scale)
            lineLayer.frame = CGRect(x: bounds.minX, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
            lineLayer.backgroundColor = UIColor.clear.cgColor
            layer.addSublayer(lineLayer)
        }
        
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let backgroundView: UIView = UIView(frame: bounds)
        backgroundView.layer.insertSublayer(layer, at: 0)
        backgroundView.backgroundColor = .clear
        cell.backgroundView = backgroundView
        
    }
    
    @objc
    private func hideSection(sender: UITapGestureRecognizer) {
        
        guard let section = sender.view?.tag else { return }
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            for row in 0..<self.tableViewData[section].count {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }
            return indexPaths
        }
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.tableView.insertRows(at: indexPathsForSection(),
                                      with: .fade)

        } else {
            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)

        }
        self.tableView.reloadData()

    }
    
}

extension ViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}
