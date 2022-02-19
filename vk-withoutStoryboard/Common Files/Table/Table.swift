//
//  Table.swift
//  vk-withoutStoryboard
//
//  Created by Ke4a on 19.02.2022.
//

import UIKit

class Table: UITableView, UITableViewDelegate, UITableViewDataSource{
    
    struct S {
        var name: String?
        var items = [I]()
    }
    
    struct I {
        var id: String?
        var data: Any?
    }
    
    var sections = [S]()
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        dataSource = self
        delegate = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = dequeueReusableCell(withIdentifier: item.id!) as! TableCell
        cell.setupCell(data: item.data)
        return  cell
    }
}


class TableCell: UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
    }
    
    func setupCell(data: Any?){
        
    }
    
}


class CheckTable: Table{
    func content(){
        sections = [
        
        ]
    }
}
