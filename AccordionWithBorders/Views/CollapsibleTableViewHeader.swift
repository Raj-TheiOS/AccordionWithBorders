//
//  CollapsibleTableViewHeader.swift
//  AccordionWithBorders
//
//  Created by K Rajeshwar on 23/03/23.
//

import Foundation
import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let arrowLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Content View
       // contentView.backgroundColor = .lightGray

        let marginGuide = contentView.layoutMarginsGuide
        
        // Arrow label
        contentView.addSubview(arrowLabel)
       // arrowLabel.textColor = .none
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        // Title label
        contentView.addSubview(titleLabel)
     //   titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        
        // Sub-Title label
        contentView.addSubview(subtitleLabel)
     //   subtitleLabel.textColor = UIColor.white
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        
        //
        // Call tapHeader when tapping on this header
        //
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        //
        // Animate the arrow rotation (see Extensions.swf)
        //
        arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
        
        if collapsed == true {
            self.addBorders(withEdges: [.all], withColor: .lightGray, withThickness: 1, cornerRadius: 8)
        }else {
            self.addBorders(withEdges: [.top], withColor: .lightGray, withThickness: 1, cornerRadius: 8)
        }
        
    }
    
}

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    func addBorders(withEdges edges: [UIRectEdge],
                    withColor color: UIColor,
                    withThickness thickness: CGFloat,
                    cornerRadius: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = thickness
        layer.cornerRadius = cornerRadius
        edges.forEach({ edge in
            
            switch edge {
            case .left:
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
                
            case .right:
                layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                
            case .top:
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                
            case .bottom:
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .all:
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            default:
                break
            }
        })
    }
}
