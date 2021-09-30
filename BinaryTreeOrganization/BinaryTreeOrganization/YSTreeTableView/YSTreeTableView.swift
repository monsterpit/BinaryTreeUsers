//
//  YSTreeTableView.swift
//  YSTreeTableView
//
//  BinaryTreeOrganization
//
//  Created by Vikas S on 01/10/21.
//


import UIKit

private let YSTreeTableViewNodeCellID:String = "YSTreeTableViewNodeCellID"
private let YSTreeTableViewContentCellID:String = "YSTreeTableViewContentCellID"

private let YSTreeTableViewNodeCellHeight:CGFloat = 50
private let YSTreeTableViewContentCellHeight:CGFloat = 50

protocol YSTreeTableViewDelegate:NSObjectProtocol {
    
    func treeCellClick(node:YSTreeTableViewNode,indexPath:IndexPath)
}

class YSTreeTableView: UITableView {
    
    var treeDelegate:YSTreeTableViewDelegate?

    var rootNodes:[YSTreeTableViewNode] = [YSTreeTableViewNode](){
        didSet{
            getExpandNodeArray()
            reloadData()
        }
    }
    
    fileprivate var tempNodeArray:[YSTreeTableViewNode] = [YSTreeTableViewNode]()

    fileprivate var insertIndexPaths:[IndexPath] = [IndexPath]()
    private var insertRow = 0
    
    fileprivate var deleteIndexPaths:[IndexPath] = [IndexPath]()
    
    override init(frame:CGRect, style: UITableView.Style){
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTableView()
    }
    
    private func setupTableView(){
        dataSource = self
        delegate = self
        register(YSTreeTableViewNodeCell.self, forCellReuseIdentifier: YSTreeTableViewNodeCellID)
        register(YSTreeTableViewContentCell.self, forCellReuseIdentifier: YSTreeTableViewContentCellID)
    }

    private func addExpandNodeToArray(node:YSTreeTableViewNode) -> Void{
        tempNodeArray.append(node)
        
        if node.isExpand{
            for childNode in node.subNodes{
                addExpandNodeToArray(node: childNode)
            }
        }
    }

    private func getExpandNodeArray() -> (){
        for rootNode in rootNodes{
            if rootNode.parentNode == nil{ 
                addExpandNodeToArray(node: rootNode)
            }
        }
    }

    fileprivate func isLeafNode(node:YSTreeTableViewNode) -> Bool{
        return node.subNodes.count == 0
    }
    

    fileprivate func insertChildNode(node:YSTreeTableViewNode){
        node.isExpand = true
        if node.subNodes.count == 0{
            return
        }
        
        insertRow = tempNodeArray.firstIndex(of: node)! + 1
        
        for childNode in node.subNodes{
            let childRow = insertRow
            let childIndexPath = IndexPath(row: childRow, section: 0)
            insertIndexPaths.append(childIndexPath)
            
            tempNodeArray.insert(childNode, at: childRow)
            
            insertRow += 1
            if childNode.isExpand{
                insertChildNode(node: childNode)
            }
        }
    }

    fileprivate func getDeleteIndexPaths(node:YSTreeTableViewNode){
        if node.isExpand{
            
            for childNode in node.subNodes{
                let childRow = tempNodeArray.firstIndex(of: childNode)!
                let childIndexPath = IndexPath(row: childRow, section: 0)
                deleteIndexPaths.append(childIndexPath)
                
                if childNode.isExpand{
                    getDeleteIndexPaths(node: childNode)
                }
            }
        }
    }

    fileprivate func deleteChildNode(node:YSTreeTableViewNode){
        getDeleteIndexPaths(node: node)
        
        node.isExpand = false
        
        for _ in deleteIndexPaths{
            tempNodeArray.remove(at: deleteIndexPaths.first!.row)
        }
    }
}

extension YSTreeTableView:UITableViewDataSource,UITableViewDelegate{
    // MARK: - cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempNodeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let node = tempNodeArray[indexPath.row]
        
        if isLeafNode(node: node){
            let cell:YSTreeTableViewNodeCell = tableView.dequeueReusableCell(withIdentifier: YSTreeTableViewNodeCellID, for: indexPath) as! YSTreeTableViewNodeCell
            
            cell.node = node
            
            return cell
        } else{
            let cell:YSTreeTableViewContentCell = tableView.dequeueReusableCell(withIdentifier: YSTreeTableViewContentCellID, for: indexPath) as! YSTreeTableViewContentCell
            
            cell.node = node
            
            return cell
        }
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let node = tempNodeArray[indexPath.row]
        
        if isLeafNode(node: node){
            return YSTreeTableViewContentCellHeight
        } else{
            return YSTreeTableViewNodeCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = tempNodeArray[indexPath.row]
        treeDelegate?.treeCellClick(node: node, indexPath: indexPath)
        
        if isLeafNode(node: node){
            return
        } else{
            if node.isExpand{
                deleteIndexPaths = [IndexPath]()
                deleteChildNode(node: node)
                deleteRows(at: deleteIndexPaths, with: .top)
            }
            else{
                insertIndexPaths = [IndexPath]()
                insertChildNode(node: node)
                insertRows(at: insertIndexPaths, with: .top)
            }
        }
    }
}
