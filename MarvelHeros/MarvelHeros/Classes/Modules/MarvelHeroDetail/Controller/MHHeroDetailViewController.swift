//
//  MHHeroDetailViewController.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/13.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHHeroDetailViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var recordDetailTableView: UITableView!
    
    var detailViewModel:MHHeroDetailViewModel = MHHeroDetailViewModel()
    
    var headerView : MHHeroDetailHeaderView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //set title
        self.title = self.detailViewModel.detailModel.characterModel?.name ?? ""
        
        //register xib for tableview cell
        let nib = UINib(nibName: "MHHeroDetailItemTableViewCell", bundle: nil)
        recordDetailTableView.register(nib, forCellReuseIdentifier: "MHHeroDetailItemTableViewCell")
        recordDetailTableView.sectionHeaderHeight = 36
        
        //set delegate and data source
        recordDetailTableView.delegate = self
        recordDetailTableView.dataSource = self
        
        
        //configure refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading ...")
        
        
        self.recordDetailTableView.refreshControl = refreshControl
        
        self.loadData()
        
        //set header view
        self.configureHeaderView()
        
        
    }
    func configureHeaderView() {
        if self.headerView == nil {
            self.headerView = Bundle.main.loadNibNamed("MHHeroDetailHeaderView", owner: nil, options: nil)?.last as? MHHeroDetailHeaderView
        }
        self.recordDetailTableView.tableHeaderView = self.headerView
        if let character = detailViewModel.detailModel.characterModel {
            self.headerView.configureHeaderViewWithCompletionHandler(character: character, handler: { (height:CGFloat)->Void in
                self.headerView.frame = CGRect(x: 0, y: 0, width:  self.recordDetailTableView.frame.size.width, height: height)
                //self.recordDetailTableView.tableHeaderView = self.headerView
            })
        }
        
        
        
    }
    //load data
    func loadData() {
        
        self.recordDetailTableView.refreshControl?.beginRefreshing()
        
        
        //load comics
        self.detailViewModel.loadCharacterComicsWithCompletionHandler(handler: { (success:Bool, error: String?)->Void in
            
            DispatchQueue.main.sync() {
                self.recordDetailTableView.refreshControl?.endRefreshing()
                self.recordDetailTableView.refreshControl = nil;
                self.recordDetailTableView.reloadData()
                
                if success == false {
                    //TODO: display error message to let user know what happend
                    
                }
                
            }
            
        })
        
        
        //load series
        self.detailViewModel.loadCharacterSeriesWithCompletionHandler(handler: { (success:Bool, error: String?)->Void in
            
            DispatchQueue.main.sync() {
                self.recordDetailTableView.refreshControl?.endRefreshing()
                self.recordDetailTableView.refreshControl = nil;
                self.recordDetailTableView.reloadData()
                
                if success == false {
                    //TODO: display error message to let user know what happend
                    
                }
                
            }
            
        })
        
        
        //load stories
        self.detailViewModel.loadCharacterStoriesWithCompletionHandler(handler: { (success:Bool, error: String?)->Void in
            
            DispatchQueue.main.sync() {
                self.recordDetailTableView.refreshControl?.endRefreshing()
                self.recordDetailTableView.refreshControl = nil;
                self.recordDetailTableView.reloadData()
                
                if success == false {
                    //TODO: display error message to let user know what happend
                    
                }
                
            }
            
        })
        
        
        //load events
        self.detailViewModel.loadCharacterEventsWithCompletionHandler(handler: { (success:Bool, error: String?)->Void in
            
            DispatchQueue.main.sync() {
                self.recordDetailTableView.refreshControl?.endRefreshing()
                self.recordDetailTableView.refreshControl = nil;
                self.recordDetailTableView.reloadData()
                
                if success == false {
                    //TODO: display error message to let user know what happend
                    
                }
                
            }
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //init loading more view
        let sectionHeaderView: MHHeroDetailSectionHeaderView = Bundle.main.loadNibNamed("MHHeroDetailSectionHeaderView", owner: nil, options: nil)?.last as! MHHeroDetailSectionHeaderView
        sectionHeaderView.titleLabel.text = ""
        if section == 0 {
            sectionHeaderView.titleLabel.text = "Latest 3 Comics"
        } else if section == 1 {
            sectionHeaderView.titleLabel.text = "Latest 3 Series "
        } else if section == 2 {
            sectionHeaderView.titleLabel.text = "Latest 3 Stories"
        } else if section == 3 {
            sectionHeaderView.titleLabel.text = "Latest 3 Events"
        }
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if section == 0 {
            count = self.detailViewModel.detailModel.arrayComics.count
            count = count == 0 ? 1 : count
        } else if section == 1 {
            count = self.detailViewModel.detailModel.arraySeries.count
            count = count == 0 ? 1 : count
        } else if section == 2 {
            count = self.detailViewModel.detailModel.arrayStories.count
            count = count == 0 ? 1 : count
        } else if section == 3 {
            count = self.detailViewModel.detailModel.arrayEvents.count
            count = count == 0 ? 1 : count
        }
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MHHeroDetailItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MHHeroDetailItemTableViewCell", for: indexPath) as! MHHeroDetailItemTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.itemNameLabel.text = "Name: NA"
        cell.itemDescriptionLabel.text = "Description: NA"
        
        if indexPath.section == 0 {
            if self.detailViewModel.detailModel.arrayComics.count > 0 {
                
                let character:MHCharacterComicsModel = self.detailViewModel.detailModel.arrayComics[indexPath.row]
                
                let name = character.itemName ?? "NA"
                let description = character.itemDescription ?? "NA"
                cell.itemNameLabel.text = "Name: \(name)";
                cell.itemDescriptionLabel.text = "Description: \(description)"
            } else {
                //show no results info
                cell.itemNameLabel.text = "No latest modified comics"
                cell.itemDescriptionLabel.text = ""
            }
            
            
            
        } else if indexPath.section == 1 {
            if self.detailViewModel.detailModel.arraySeries.count > 0 {
                
                let character:MHCharacterSeriesModel = self.detailViewModel.detailModel.arraySeries[indexPath.row]
                
                
                let name = character.itemName ?? "NA"
                let description = character.itemDescription ?? "NA"
                cell.itemNameLabel.text = "Name: \(name)";
                cell.itemDescriptionLabel.text = "Description: \(description)"
            } else {
                //show no results info
                cell.itemNameLabel.text = "No latest modified series"
                cell.itemDescriptionLabel.text = ""
            }
        } else if indexPath.section == 2 {
            if self.detailViewModel.detailModel.arrayStories.count > 0 {
                
                let character:MHCharacterStoriesModel = self.detailViewModel.detailModel.arrayStories[indexPath.row]
                
                
                let name = character.itemName ?? "NA"
                let description = character.itemDescription ?? "NA"
                cell.itemNameLabel.text = "Name: \(name)";
                cell.itemDescriptionLabel.text = "Description: \(description)"
            } else {
                //show no results info
                cell.itemNameLabel.text = "No latest modified stories"
                cell.itemDescriptionLabel.text = ""
            }
        } else if indexPath.section == 3 {
            if self.detailViewModel.detailModel.arrayEvents.count > 0 {
                
                let character:MHCharacterEventsModel = self.detailViewModel.detailModel.arrayEvents[indexPath.row]
                
                
                let name = character.itemName ?? "NA"
                let description = character.itemDescription ?? "NA"
                cell.itemNameLabel.text = "Name: \(name)";
                cell.itemDescriptionLabel.text = "Description: \(description)"
            } else {
                //show no results info
                cell.itemNameLabel.text = "No latest modified events"
                cell.itemDescriptionLabel.text = ""
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 140.0
        if indexPath.section == 0 {
            if self.detailViewModel.detailModel.arrayComics.count == 0 {
                height = 44.0
            }
        } else if  indexPath.section == 1 {
            
            if self.detailViewModel.detailModel.arraySeries.count == 0 {
                height = 44.0
            }
        } else if  indexPath.section == 2 {
            
            if self.detailViewModel.detailModel.arrayStories.count == 0 {
                height = 44.0
            }
        } else if  indexPath.section == 3 {
            
            if self.detailViewModel.detailModel.arrayEvents.count == 0 {
                height = 44.0
            }
        }
        
        return height
    }

}
