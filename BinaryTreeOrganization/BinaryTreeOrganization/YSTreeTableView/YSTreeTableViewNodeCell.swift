//
//  YSTreeTableViewCell.swift
//  YSTreeTableView
//
//  BinaryTreeOrganization
//
//  Created by Vikas S on 01/10/21.
//


import UIKit

class YSTreeTableViewNodeCell: UITableViewCell {
    
    var node:YSTreeTableViewNode?{
        didSet{
            indentationLevel = node?.depth ?? 0
            indentationWidth = 30
            
            textLabel?.text = node?.nodeName
        }
    }
    
}
