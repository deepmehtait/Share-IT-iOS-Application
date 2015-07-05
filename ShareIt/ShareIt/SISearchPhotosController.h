//
//  SIUploadPhotoViewController.m
//  ShareIt
//
//  Created by student on 4/26/15.
//  Copyright (c) 2015 Example. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SISearchPhotosController : UITableViewController <UISearchResultsUpdating, UISearchControllerDelegate>

@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) UITableViewController *searchResultsTableViewController;

@property (weak, nonatomic) IBOutlet UITableView *myTable;

@property (strong, nonatomic) NSArray *results;

@property(nonatomic) NSString *userID;

@property(nonatomic) NSString *albumID;

@property (nonatomic, strong) NSArray *images;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end