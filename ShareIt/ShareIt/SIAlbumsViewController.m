//
//  SIAlbumsViewController.m
//  ShareIt
//
//  Created by student on 4/25/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import "SIAlbumsViewController.h"
#import "SIPhotosViewController.h"
#import "AFNetworking.h"
#import "SIUploadPhotoViewController.h"

#define ResultsTableView self.searchResultsTableViewController.tableView

#define Identifier @"Cell"

@implementation SIAlbumsViewController

NSMutableArray *tableData;
NSMutableArray *tableID;
NSInteger i;
static NSString * getAlbumsURL;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSLog(@"userID: %@", _userID);
    
    getAlbumsURL = @"http://52.8.15.49:8080/photoshare/api/v1/users/";
    getAlbumsURL = [getAlbumsURL stringByAppendingString:_userID];
    getAlbumsURL = [getAlbumsURL stringByAppendingString:@"/album"];
    NSLog(@"getAlbumsURL: %@", getAlbumsURL);
    
    _myTable.dataSource=self;
    [self fetchAlbums];
    
    self.results = [[NSMutableArray alloc] init];
    
    // A table view for results.
    UITableView *searchResultsTableView = [[UITableView alloc] initWithFrame:self.tableView.frame];
    searchResultsTableView.dataSource = self;
    searchResultsTableView.delegate = self;
    
    // Registration of reuse identifiers.
    [searchResultsTableView registerClass:UITableViewCell.class forCellReuseIdentifier:Identifier];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:Identifier];
    
    // Init a search results table view controller and setting its table view.
    self.searchResultsTableViewController = [[UITableViewController alloc] init];
    self.searchResultsTableViewController.tableView = searchResultsTableView;
    
    // Init a search controller with its table view controller for results.
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsTableViewController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    // Make an appropriate size for search bar and add it as a header view for initial table view.
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // Enable presentation context.
    self.definesPresentationContext = YES;
    
}


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:ResultsTableView]) {
        if (self.results) {
            return self.results.count;
        } else {
            return 0;
        }
    } else {
        
        return [tableData count];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    NSString *text;
    if ([tableView isEqual:ResultsTableView]) {
        text = self.results[indexPath.row];
    }
    else{
        text=tableData[indexPath.row];
    }
 cell.textLabel.text = text;
    
    return cell;
    
//    
//    static NSString *simpleTableIdentifier = @"SimpleTableItem";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }    
//    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIPhotosViewController *photoController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SIPhotosViewController"];
    photoController.userID = self.userID;
    //NSString *aId=[@(indexPath.row)description];
    //photoController.albumID = [tableID objectAtIndex:[aId integerValue]];
    photoController.albumID = tableID [indexPath.row];
    [self.navigationController pushViewController:photoController animated:YES];
    }

- (IBAction)addAlbum:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Album Name"
                                                    message:@"  "
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *name = [alertView textFieldAtIndex:0].text;
        NSLog(@"%@",name);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"albumName": name};
        [manager POST:getAlbumsURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [self fetchAlbums];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        //[self didFinishLoadingwithData:name];
    }
}

//-(void) didFinishLoadingwithData:(NSString*) data {
//    [tableData addObject:data];
//    [self.tableView reloadData];
//}

-(void) fetchAlbums{
    tableData = [[NSMutableArray alloc] init];
    tableID = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:getAlbumsURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"%@",responseObject);
//                 NSString *zees=[responseObject objectAtIndex:0][@"album"][2][@"albumId"];
//               NSLog(@"%@",zees);
        NSLog(@"response object count: %lu",[[responseObject objectAtIndex:0][@"album"] count]);
        for (i=0; i<[[responseObject objectAtIndex:0][@"album"] count]; i++) {
            [tableID addObject:[responseObject objectAtIndex:0][@"album"][i][@"albumId"]];
            [tableData addObject:[responseObject objectAtIndex:0][@"album"][i][@"albumName"]];
            
        }
        
        NSLog(@"tableData count: %lu",[tableData count]);
        NSLog(@"tableData : %@",tableData);
        NSLog(@"tableId : %@",tableID);
        [self.tableView reloadData];
        
        //            NSArray *tableData2 = [NSArray arrayWithObjects:@"Default", @"Profile Pics", @"Uploads", nil];
        //            NSLog(@"tableData2 : %@",tableData2);
        
        //[tableData addObject:nil];
        
        //            NSString *zees=[responseObject objectForKey:@"feed"][@"author"][0][@"name"][@"$t"];
        //            NSLog(@"%@",zees);
        
        
        // NSLog(@"JSON: %@", responseObject);
        //    self.dataDict = (NSDictionary *) responseObject;
        //            self.dataArary = self.dataDict[@"feed"][@"author"][0][@"name"];
        //            NSString *zee=[self.dataArary valueForKey:@"$t"];
        //            NSLog(@"**************%@******%lu",self.dataArary,(unsigned long)self.dataArary.count);
        
        
        
        //NSError *error;
        
        // NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        //NSLog(@"%@",jsonData);
        //NSLog(@"JSON: %@", responseObject.description);
        //        NSString *idValue  = responseObject[@"_id"];
        //        NSLog(@"%@",idValue);
        //        NSArray *array = responseObject[@"JSON"];
        //        NSArray *array2  = [array valueForKey: @"album"];
        //tableData = [array2 valueForKey: @"albumName"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        SIPhotosViewController *photoController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SIPhotosViewController"];
        photoController.userID = self.userID;
        //NSString *aId=[@(indexPath.row)description];
        //photoController.albumID = [tableID objectAtIndex:[aId integerValue]];
        photoController.albumID = tableID [indexPath.row];
        NSString *albumId = photoController.albumID;
        NSString *userId = photoController.userID;
        NSLog(@"Album ID: %@", albumId);
        NSLog(@"userID: %@", userId);
        
        NSString *removeAlbumUrl;
        
        removeAlbumUrl = @"http://52.8.15.49:8080/photoshare/api/v1/users/";
        removeAlbumUrl = [removeAlbumUrl stringByAppendingString:userId];
        removeAlbumUrl = [removeAlbumUrl stringByAppendingString:@"/album/"];
        removeAlbumUrl = [removeAlbumUrl stringByAppendingString:albumId];
        
        NSLog(@"removeAlbumUrl: %@", removeAlbumUrl);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager DELETE:removeAlbumUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response object: %@",responseObject);
            [self fetchAlbums];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Album was deleted successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        //        alert.alertViewStyle = UIAlertViewStyleDefault;
        //        [alert show];
        
        
        
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        //        [self.results removeObjectAtIndex:indexPath.row];
        
        
    }
}




#pragma mark - Search Results Updating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    UISearchBar *searchBar = searchController.searchBar;
    if (searchBar.text.length > 0) {
        NSString *text = searchBar.text;
        NSLog(@"SEARCH STRING %@",text);
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *album, NSDictionary *bindings) {
           
            NSRange range = [album rangeOfString:text options:NSCaseInsensitiveSearch];
            // NSLog(range);
            return range.location != NSNotFound;
        }];
        
        // Set up results.
        NSArray *searchResults = [tableData filteredArrayUsingPredicate:predicate];
        self.results = searchResults;
         NSLog(@"SEARCH RESULTS %@",searchResults);
        // Reload search table view.
        [self.searchResultsTableViewController.tableView reloadData];
    }
}

#pragma mark - Search Controller Delegate

- (void)didDismissSearchController:(UISearchController *)searchController {
    [self dismissSearchBarAnimated:YES];
}

#pragma mark - Util methods

- (void)dismissSearchBarAnimated: (BOOL)animated {
    CGFloat offset = (self.searchController.searchBar.bounds.size.height) - (self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.contentOffset = CGPointMake(0, offset);
        }];
    } else {
        self.tableView.contentOffset = CGPointMake(0, offset);
    }
}


@end

