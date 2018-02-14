//
//  MHHeroListViewController.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/12.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHHeroListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var herosTableView: UITableView!
    //view model for handling all intermediate jobs, such as data formating, data fetching
    var heroListViewModel:MHHeroListViewModel = MHHeroListViewModel()
    
    var indicatorView:MHLoadingMoreIndicatorView!
    var listResultView:MHListHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set title
        self.title = "Super Heros"
        
        //register xib for tableview cell
        let nib = UINib(nibName: "MHHeroSummaryTableViewCell", bundle: nil)
        herosTableView.register(nib, forCellReuseIdentifier: "MHHeroSummaryTableViewCell")
        
        //set delegate and data source
        herosTableView.delegate = self
        herosTableView.dataSource = self
        
        
        //configure refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading ...")
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        
        self.herosTableView.refreshControl = refreshControl
        
        
        
        //init loading more view
        self.indicatorView = Bundle.main.loadNibNamed("MHLoadingMoreIndicatorView", owner: nil, options: nil)?.last as? MHLoadingMoreIndicatorView
        
        
        //init loading more view
        self.listResultView = Bundle.main.loadNibNamed("MHListHeaderView", owner: nil, options: nil)?.last as? MHListHeaderView
        //self.herosTableView.tableHeaderView = self.listResultView
        
        //configure search bar
        self.listResultView.characterSearchBar.delegate = self
        
        
        //load data
        self.herosTableView.refreshControl?.beginRefreshing()
        self.heroListViewModel.offset = 0
        
        self.loadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.herosTableView.reloadData()
    }
    //load data
    func loadData() {
        
        self.heroListViewModel.loadHerosWithCompletionHandler(handler: { (success:Bool, error: String?)->Void in
            
            DispatchQueue.main.sync() {
                self.herosTableView.refreshControl?.endRefreshing()
                self.herosTableView.reloadData()
                 self.herosTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
                
                if success == false {
                    //TODO: display error message to let user know what happend
                    
                }
                MHActivityIndicatorWrapper.sharedInstance.stopActivityIndicator(vc: self.navigationController!)
                self.herosTableView.scrollsToTop = true
                if self.heroListViewModel.total == 0 {
                    self.listResultView.resultDescriptionLabel.text = "No records found."
                } else {
                    self.listResultView.resultDescriptionLabel.text = "Total records are: \(self.heroListViewModel.total)"
                }
                
                if self.heroListViewModel.total > self.heroListViewModel.arrayHeros.count {
                    //show loading indicator
                    self.indicatorView.loadingLabel.isHidden = true
                    self.indicatorView.loadingIndicator.isHidden = true
                    self.indicatorView.pullToRefreshLabel.isHidden = false
                    self.herosTableView.tableFooterView = self.indicatorView
                    
                } else {
                    //hide
                    self.herosTableView.tableFooterView = nil
                    
                }
            }
            
            
            
            
        })
    }
    
    //another way to load data: pull down to refresh
     @objc func refreshData() {
        
        
        self.heroListViewModel.offset = 0
        self.heroListViewModel.loadHerosWithCompletionHandler(handler: { (success:Bool, error: String?)->Void in
            
            DispatchQueue.main.sync() {
                self.herosTableView.refreshControl?.endRefreshing()
                self.herosTableView.reloadData()
                
                if success == false {
                    //TODO: display error message to let user know what happend
                    
                }
                if self.heroListViewModel.total == 0 {
                    self.listResultView.resultDescriptionLabel.text = "No records found."
                } else {
                    self.listResultView.resultDescriptionLabel.text = "Total records are: \(self.heroListViewModel.total)"
                }
                
                if self.heroListViewModel.total > self.heroListViewModel.arrayHeros.count {
                    //show loading indicator
                    self.indicatorView.loadingLabel.isHidden = true
                    self.indicatorView.loadingIndicator.isHidden = true
                    self.indicatorView.pullToRefreshLabel.isHidden = false
                    self.herosTableView.tableFooterView = self.indicatorView
                    
                } else {
                    //hide
                    self.herosTableView.tableFooterView = nil
                        
                }
            }
            
            
            
            
        })
    }
    
    //pull up to load more
     @objc func loadMoreData() {
        if self.heroListViewModel.total <= self.heroListViewModel.arrayHeros.count {
            
            return
        }
        
        //display loading info
        //show loading indicator
        self.indicatorView.loadingLabel.isHidden = false
        self.indicatorView.loadingIndicator.isHidden = false
        self.indicatorView.pullToRefreshLabel.isHidden = true
        self.herosTableView.tableFooterView = self.indicatorView
        
        self.heroListViewModel.offset = self.heroListViewModel.offset + 1
        self.heroListViewModel.loadHerosWithCompletionHandler(handler: { (success:Bool, error: String?)->Void in
            
            DispatchQueue.main.sync() {
                //self.herosTableView.tableFooterView = nil;
                
                
                if success == false {
                    //TODO: display error message to let user know what happend
                    
                } else {
                    if self.heroListViewModel.total == 0 {
                        self.listResultView.resultDescriptionLabel.text = "No records found."
                    } else {
                        self.listResultView.resultDescriptionLabel.text = "Total records are: \(self.heroListViewModel.total)"
                    }
                    if self.heroListViewModel.total > self.heroListViewModel.arrayHeros.count {
                        //show loading indicator
                        self.indicatorView.loadingLabel.isHidden = true
                        self.indicatorView.loadingIndicator.isHidden = true
                        self.indicatorView.pullToRefreshLabel.isHidden = false
                        self.herosTableView.tableFooterView = self.indicatorView
                        
                    } else {
                        //hide
                        self.herosTableView.tableFooterView = nil
                        
                    }
                    
                    self.herosTableView.reloadData()
                    
                    self.herosTableView.reloadSectionIndexTitles()
                }
            }
            
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listResultView.characterSearchBar.resignFirstResponder()
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //check offset on y axis
        let currentOffset:CGFloat = scrollView.contentOffset.y;
        let maximumOffset:CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        //NSInteger result = maximumOffset - currentOffset;
        
        // Change 10.0 to adjust the distance from bottom
        if (maximumOffset - currentOffset <= 10.0) {
            self.loadMoreData()
            //[self methodThatAddsDataAndReloadsTableView];
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.listResultView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 86
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.heroListViewModel.arrayHeros.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MHHeroSummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MHHeroSummaryTableViewCell", for: indexPath) as! MHHeroSummaryTableViewCell

        let character:MHCharacterModel = self.heroListViewModel.arrayHeros[indexPath.row]
        
        //cell.characterImageView.image = UIImage(data: da)
        cell.nameLabel.text = character.name;
        cell.modifiedLabel.text = "Last updated: \(character.modifiedDate!)"
        if let id = character.id {
            cell.recordID = id
            if MHFavoriteCharacterWrapper.sharedInstance.checkIsFavoriteCharacter(characterId: cell.recordID) {
                
                cell.favoriteButton.setImage(UIImage(named: "star-filled.png"), for: UIControlState.normal)
            } else {
                cell.favoriteButton.setImage(UIImage(named: "star-unfilled.png"), for: UIControlState.normal)
            }
        }
        
        if character.id != nil && character.modifiedDate != nil && character.thumbnailPath != nil && character.thumbnailExtension != nil {
            MHImageDowloader.loadImage(imageName: "\(character.id!)_\(character.modifiedDate!.replacingOccurrences(of: ":", with: "")).\(character.thumbnailExtension!)", imageUrl: "\(character.thumbnailPath!).\(character.thumbnailExtension!)", completionHandler: { (image:UIImage?)->Void in
                
                cell.characterImageView.image = image
                
            })
        } else {
             cell.characterImageView.image = UIImage(named: "imageNotFound.jpg")
        }
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.listResultView.characterSearchBar.resignFirstResponder()
        
        //show hero detail info
        let detaiViewControll:MHHeroDetailViewController = MHHeroDetailViewController(nibName: "MHHeroDetailViewController", bundle: nil)
        
        //set characterId
        let character:MHCharacterModel = self.heroListViewModel.arrayHeros[indexPath.row]
        detaiViewControll.detailViewModel.detailModel.characterModel = character
        
        self.navigationController?.pushViewController(detaiViewControll, animated: true)
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.resignFirstResponder()
        
        if let text = searchBar.text {
            self.heroListViewModel.nameFilter = text
            self.heroListViewModel.offset = 0
            
            //self.herosTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Loading ...")
            MHActivityIndicatorWrapper.sharedInstance.startActivityIndicator(vc: self.navigationController!)
            self.loadData()
        }
        
        
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            self.heroListViewModel.nameFilter = text
        }
    }
    
}
