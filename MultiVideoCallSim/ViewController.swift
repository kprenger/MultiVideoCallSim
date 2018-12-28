//
//  ViewController.swift
//  MultiVideoCallSim
//
//  Created by Kurt Prenger on 12/27/18.
//  Copyright © 2018 MTS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Vars
    
    let colorOptions = [#colorLiteral(red: 1, green: 0.4484981298, blue: 0.3201509118, alpha: 1), #colorLiteral(red: 1, green: 0.7610647678, blue: 0.2355166376, alpha: 1), #colorLiteral(red: 0.999956429, green: 0.9997797608, blue: 0.3372722566, alpha: 1), #colorLiteral(red: 0.3613241315, green: 1, blue: 0.468061626, alpha: 1), #colorLiteral(red: 0.5873804092, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.5781947374, green: 0.7832044959, blue: 1, alpha: 1), #colorLiteral(red: 0.8297581673, green: 0.6736049652, blue: 1, alpha: 1)]
    var currentViews: [UIView] = []

    // MARK: - IBOutlets
    
    // Buttons
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    // User preview
    @IBOutlet weak var myPreview: UILabel!
    
    // Stacks
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var topStack: UIStackView!
    @IBOutlet weak var topLeftStack: UIStackView!
    @IBOutlet weak var topRightStack: UIStackView!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var bottomLeftStack: UIStackView!
    @IBOutlet weak var bottomRightStack: UIStackView!
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateStackViews(with: [])
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonTouched(_ sender: UIButton) {
        let newView = makeView(for: currentViews.count)
        currentViews.append(newView)
        
        if currentViews.count >= 7 {
            addButton.isUserInteractionEnabled = false
        }
        
        removeButton.isUserInteractionEnabled = true
        
        updateStackViews(with: currentViews)
    }
    
    @IBAction func removeButtonTouched(_ sender: UIButton) {
        let _ = currentViews.popLast()
        
        if currentViews.count <= 0 {
            removeButton.isUserInteractionEnabled = false
        }
        
        addButton.isUserInteractionEnabled = true
        
        updateStackViews(with: currentViews)
    }
    
    // MARK: - View creation
    
    private func makeView(for index: Int) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.backgroundColor = colorOptions[index]
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "User \((index + 1).description)'s video"
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.textAlignment = .center
        
        return label
    }
    
    // MARK: - Stack View updates
    
    private func updateStackViews(with views: [UIView]) {
        resetStackViews()
        
        switch views.count {
        case 7:
            bottomRightStack.insertArrangedSubview(views[6], at: 0)
            fallthrough
        case 6:
            bottomLeftStack.addArrangedSubview(views[5])
            fallthrough
        case 5:
            topRightStack.addArrangedSubview(views[4])
            fallthrough
        case 4:
            topLeftStack.addArrangedSubview(views[3])
            fallthrough
        case 3:
            topRightStack.isHidden = false
            topRightStack.insertArrangedSubview(views[2], at: 0)
            fallthrough
        case 2:
            bottomStack.isHidden = false
            bottomLeftStack.isHidden = false
            bottomLeftStack.insertArrangedSubview(views[1], at: 0)
            fallthrough
        case 1:
            topStack.isHidden = false
            topLeftStack.isHidden = false
            topLeftStack.insertArrangedSubview(views[0], at: 0)
        default: break
        }
        
        // If the user is the only person in a call, then we want their preview to fill the screen.
        // If there are more than 3 people in the call (including the user), we want their preview
        // to become part of the view stack.
        
        switch views.count {
        case let x where x == 0, let x where x >= 3:
            let myPreviewCopy = myPreview.naiveCopy()
            myPreview.isHidden = true
            
            bottomStack.isHidden = false
            bottomRightStack.isHidden = false
            bottomRightStack.addArrangedSubview(myPreviewCopy)
        case let x where x < 3:
            myPreview.isHidden = false
        default: break
        }
    }
    
    private func resetStackViews() {
        // hide all stacks
        [bottomStack, bottomLeftStack, bottomRightStack, topStack, topLeftStack, topRightStack].forEach { stack in
            stack.isHidden = true
        }
        
        // remove all views from inner stacks
        [bottomLeftStack, bottomRightStack, topLeftStack, topRightStack].forEach { stack in
            stack.arrangedSubviews.forEach { view in
                stack.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
    }
}

extension UILabel
{
    func naiveCopy() -> UILabel {
        let copiedLabel = UILabel(frame: frame)
        
        copiedLabel.backgroundColor = backgroundColor
        copiedLabel.textAlignment = textAlignment
        copiedLabel.text = text
        copiedLabel.textColor = textColor
        copiedLabel.font = font
        copiedLabel.lineBreakMode = lineBreakMode
        copiedLabel.numberOfLines = numberOfLines
        
        return copiedLabel
    }
}
