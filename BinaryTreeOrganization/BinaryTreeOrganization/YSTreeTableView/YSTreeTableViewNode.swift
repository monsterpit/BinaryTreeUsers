//
//  YSTreeTableViewNode.swift
//  YSTreeTableView
//
//  BinaryTreeOrganization
//
//  Created by Vikas S on 01/10/21.
//


import UIKit

class YSTreeTableViewNode: Equatable {
    static func == (lhs: YSTreeTableViewNode, rhs: YSTreeTableViewNode) -> Bool {
        lhs.nodeID ==  rhs.nodeID
    }
    
    
    var parentNode:YSTreeTableViewNode?{
        didSet{
            if let parentN = parentNode, !parentN.subNodes.contains(self) {
                parentN.subNodes.append(self)
            }
        }
    }
    
    var subNodes:[YSTreeTableViewNode] = [YSTreeTableViewNode](){
        didSet{
            for childNode in subNodes{
                childNode.parentNode = self
            }
        }
    }
    
 
    var nodeID:Int = 0
    
  
    var nodeName:String = ""

  
    var isExpand:Bool = false
    
   
    var depth:Int{
        if let parentN = parentNode{
            return parentN.depth + 1
        }
        return 0
    }

    
    convenience init?(nodeID:Int,nodeName:String,isExpand:Bool = false){
        
        self.init()
        
        if nodeName == ""{
            return nil
        }
        else{
            self.nodeID = nodeID
            self.nodeName = nodeName
           
            self.isExpand = isExpand
        }
    }

    func addChildNode(childNode:YSTreeTableViewNode?){
        childNode?.parentNode = self
    }
}
