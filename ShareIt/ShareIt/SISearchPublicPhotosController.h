//
//  SISearchPublicPhotosController.h
//  ShareIt
//
//  Created by Saikrishna on 4/29/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SISearchPublicPhotosController : UITableViewController <UISearchResultsUpdating, UISearchControllerDelegate>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UITableViewController *searchResultsTableViewController;
@property (strong, nonatomic) NSArray *results;

@property (weak, nonatomic) IBOutlet UITableView *myTable;


@end
