//

//  SISearchPhotosController.m

//  ShareIt

//

//  Created by Saikrishna on 4/29/15.

//  Copyright (c) 2015 Example. All rights reserved.

//



#import "SISearchPhotosController.h"

#import "AFNetworking.h"

#import "SIImageViewController.h"



#define ResultsTableView self.searchResultsTableViewController.tableView



#define Identifier @"Cell"



@interface SISearchPhotosController ()



@property (strong, nonatomic) NSArray *cities;



@end

NSMutableArray *imageText;

NSMutableArray *userIDs;

NSMutableArray *photoIDs;

NSMutableArray *albumIDs;

NSMutableArray *mutableImages;

static NSString * getPhotoURL;

@implementation SISearchPhotosController {
    
    
    
}



#pragma mark - View Life Cycle



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    NSLog(@"Album ID: %@", self.albumID);
//    
//    
//    
//    NSLog(@"userID: %@", _userID);
//    
//    
//    
//    getPhotoURL = @"http://52.8.15.49:8080/photoshare/api/v1/users/";
//    
//    getPhotoURL = [getPhotoURL stringByAppendingString:_userID];
//    
//    getPhotoURL = [getPhotoURL stringByAppendingString:@"/album/"];
//    
//    getPhotoURL = [getPhotoURL stringByAppendingString:@"0"];
//    
//    getPhotoURL = [getPhotoURL stringByAppendingString:@"/photos/"];
//    
//    
//    
//    NSLog(@"getPhotoURL: %@", getPhotoURL);
//    
//    
    
    [self fetchPublicPhotos:@"get"];
    
    
    
    
    
    //    // Arrays init & sorting.
    
    //    self.cities = [@[@"Boston", @"New York", @"Oregon", @"Tampa", @"Los Angeles", @"Dallas", @"Miami", @"Olympia", @"Montgomery", @"Washington", @"Orlando", @"Detroit"] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
    
    //        return [obj2 localizedCaseInsensitiveCompare:obj1] == NSOrderedAscending;
    
    //    }];
    
    
    
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



- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    
    // Hide search bar.
    
    [self dismissSearchBarAnimated:NO];
    
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





#pragma mark - Table View Data Source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:ResultsTableView]) {
        
        if (self.results) {
            
            return self.results.count;
            
        } else {
            
            return 0;
            
        }
        
    } else {
        
        
        
        return mutableImages.count;
        
    }
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    //CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    if (cell == nil)
        
    {
        
        // NSLog(@"In Nil of table");
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
        
    }
    
    //  NSLog(@"Index path row=%lu",indexPath.row);
    
    
    
    // NSLog(@"Deep ");
    
    //cell.textLabel.text=imageText[indexPath.row];
    
    // cell.imageView.image=mutableImages[indexPath.row];
    
    //NSLog(@"****MUt:%@",mutableImages[indexPath.row]);
    
    //NSLog(@"*****Ima:%@",imageText[indexPath.row]);
    
    // cell.textLabel.text=@"hello Deep";
    
    //cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:mutableImages[indexPath.row]]] ];
    
    //  cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://cache.gawkerassets.com/assets/images/2010/10/custom_1286555358292_awesome.jpg"]] ];
    
    
    
    // UIImage *imgt=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:mutableImages[indexPath.row]]]];
    
    UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:mutableImages[indexPath.row]]]];
    
    if(image)
        
    {
        
        
        
        
        
        cell.imageView.image= image;
        
        cell.imageView.frame=CGRectMake(10, 10,10,10);
        
        cell.textLabel.text=imageText[indexPath.row];
        
        
        
    }
    
    else{
        
        cell.textLabel.text=imageText[indexPath.row];
        
    }
    
    
    
    //NSString *text=@"Deep";
    
    // self.label.text=text;
    
    //cell.image.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://cache.gawkerassets.com/assets/images/2010/10/custom_1286555358292_awesome.jpg"]] ];;
    
    //    NSString *text;
    
    //    if ([tableView isEqual:ResultsTableView]) {
    
    //        text = self.results[indexPath.row];
    
    //    } else {
    
    //        text = self.cities[indexPath.row];
    
    //    }
    
    //cell.label.text=@"hello hello";
    
    //cell.image.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://cache.gawkerassets.com/assets/images/2010/10/custom_1286555358292_awesome.jpg"]] ];;
    
    
    
    //cell.textLabel.text = text;
    
    
    
    return cell;
    
}



#pragma mark - Table View Delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSLog(@"userid=%@ Albumid=%@ photoid=%@",[userIDs objectAtIndex:indexPath.row],[albumIDs objectAtIndex:indexPath.row],[photoIDs objectAtIndex:indexPath.row]);
    
    SIImageViewController *imageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SIImageViewController"];
    
//    imageViewController.userID=@"10204183147442507";
//    
//    imageViewController.albumID=@"549";
//    
//    imageViewController.photoID=@"777";
    
    //
    
        imageViewController.userID=[userIDs objectAtIndex:indexPath.row];
    
        imageViewController.albumID=[albumIDs objectAtIndex:indexPath.row];
    
    imageViewController.photoID=[photoIDs objectAtIndex:indexPath.row];
    
    imageViewController.arriveFromSearch=@"true";
    
    
    
    [self.navigationController pushViewController:imageViewController animated:YES];
    
    
    
}



#pragma mark - Search Results Updating



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    
    
    UISearchBar *searchBar = searchController.searchBar;
    
    [searchBar setValue:@"GO" forKey:@"_cancelButtonText"];
    
    if (searchBar.text.length > 0) {
        
        NSString *text = searchBar.text;
        
        NSLog(@"Test entered==%@",text);
        
        //        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *photo, NSDictionary *bindings) {
        
        //            NSRange range = [photo rangeOfString:text options:NSCaseInsensitiveSearch];
        
        //
        
        //            return range.location != NSNotFound;
        
        //        }];
        
        
        
        // Set up results.
        
        //     NSArray *searchResults = [self.cities filteredArrayUsingPredicate:predicate];
        
        //self.results = searchResults;
        
        
        
        [self fetchPublicPhotosSearch:searchBar.text];
        
        // Reload search table view.
        
        //  [self.searchResultsTableViewController.tableView reloadData];
        
        [self.tableView reloadData];
        
    }
    
}



#pragma mark - Search Controller Delegate



- (void)didDismissSearchController:(UISearchController *)searchController {
    
    UISearchBar *searchBar = searchController.searchBar;
    
    NSLog(@"Pressed Enter%@",searchBar);
    
    // [self fetchPublicPhotos:searchBar.text];
    
    [self dismissSearchBarAnimated:YES];
    
}







-(void) fetchPublicPhotos:(NSString *) type

{
    
    //   tableData = [[NSMutableArray alloc] init];
    
    // tableID = [[NSMutableArray alloc] init];
    
    
    
    NSString *URL;
    
    
    
    
    
    NSLog(@"Alwasy Get");
    
    URL=@"http://52.8.15.49:8080/photos";
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON Respomnse%@",responseObject);
        
        NSLog(@"LENGTH%lu@",[responseObject count]);
        
        
        
        
        
        if ([responseObject count]) {
            
            NSInteger i=0;
            
            mutableImages = [NSMutableArray arrayWithCapacity:[responseObject count]-1];
            
            imageText=[NSMutableArray arrayWithCapacity:[responseObject count]-1];
            
            userIDs=[NSMutableArray arrayWithCapacity:[responseObject count]-1];
            
            photoIDs=[NSMutableArray arrayWithCapacity:[responseObject count]-1];
            
            albumIDs=[NSMutableArray arrayWithCapacity:[responseObject count]-1];
            
            for(i=0;i<[responseObject count];i++)
                
            {
                
                NSString *ImgUrl = responseObject[i][@"photoUrl"];
                
                NSString *photoName=responseObject[i][@"photoName"];
                
                NSString *photoID=responseObject[i][@"photoId"];
                
                NSString *albumID=responseObject[i][@"albumId"];
                
                NSString *userID=responseObject[i][@"userId"];
                
                if(ImgUrl && photoName){
                    
                    [mutableImages addObject:ImgUrl];
                    
                    // NSLog(@"Image Url%@",ImgUrl);
                    
                    [userIDs addObject:userID];
                    
                    [photoIDs addObject:photoID];
                    
                    [albumIDs addObject:albumID];
                    
                    
                    
                    
                    
                    //NSLog(@" mutable arr%@",mutableImages);
                    
                    [imageText addObject:photoName ];
                    
                    
                    
                    
                    
                }
                
                
                
                
                
            }
            
            // NSLog(@" mutable arr%@",mutableImages);
            
            //  NSLog(@" Photo Name%@",imageText);
            
            
            
        }
        
        
        
        
        
        [self.tableView reloadData];
        
        //   _images = [NSArray arrayWithArray:mutableImages];
        
        //NSLog(@"****Imag array photo:%@",_image);
        
        //NSLog(@"Imag array text:%@",imageText);
        
        
        
        
        
        //                 NSString *zees=[responseObject objectAtIndex:0][@"album"][2][@"albumId"];
        
        //               NSLog(@"%@",zees);
        
        //        NSLog(@"response object count: %lu",[[responseObject objectAtIndex:0][@"album"] count]);
        
        //        for (i=0; i<[[responseObject objectAtIndex:0][@"album"] count]; i++) {
        
        //           // [tableID addObject:[responseObject objectAtIndex:0][@"album"][i][@"albumId"]];
        
        //           // [tableData addObject:[responseObject objectAtIndex:0][@"album"][i][@"albumName"]];
        
        //
        
        //        }
        
        //
        
        //        NSLog(@"tableData count: %lu",[tableData count]);
        
        //        NSLog(@"tableData : %@",tableData);
        
        //        NSLog(@"tableId : %@",tableID);
        
        //        [self.tableView reloadData];
        
        //
        
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



-(void) fetchPublicPhotosSearch:(NSString *) type

{
    
    //   tableData = [[NSMutableArray alloc] init];
    
    // tableID = [[NSMutableArray alloc] init];
    
    NSString *URL;
    
    NSLog(@"Text got%@",type);
    
    URL=@"http://52.8.15.49:8080/search?q=";
    
    URL = [URL stringByAppendingString:type];
    
    NSLog(@"%@",URL);
    
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON Respomnse%@",responseObject);
        
        NSLog(@"LENGTH%lu@",[responseObject count]);
        
        
        
        
        
        if ([responseObject count]) {
            
            NSInteger i=0;
            
            mutableImages = [NSMutableArray arrayWithCapacity:[responseObject count]-1];
            
            imageText=[NSMutableArray arrayWithCapacity:[responseObject count]-1];
            
            userIDs=[NSMutableArray arrayWithCapacity:[responseObject count]-1];
            
            photoIDs=[NSMutableArray arrayWithCapacity:[responseObject count]-1];
            
            albumIDs=[NSMutableArray arrayWithCapacity:[responseObject count]-1];
            
            for(i=0;i<[responseObject count];i++)
                
            {
                
                NSString *ImgUrl = responseObject[i][@"photoUrl"];
                
                NSString *photoName=responseObject[i][@"photoName"];
                
                NSString *photoID=responseObject[i][@"photoId"];
                
                NSString *albumID=responseObject[i][@"albumId"];
                
                NSString *userID=responseObject[i][@"userId"];
                
                if(ImgUrl && photoName){
                    
                    [mutableImages addObject:ImgUrl];
                    
                    // NSLog(@"Image Url%@",ImgUrl);
                    
                    [userIDs addObject:userID];
                    
                    [photoIDs addObject:photoID];
                    
                    [albumIDs addObject:albumID];
                    
                    
                    
                    //NSLog(@" mutable arr%@",mutableImages);
                    
                    [imageText addObject:photoName ];
                    
                    
                    
                    
                    
                }
                
                
                
                
                
            }
            
            // NSLog(@" mutable arr%@",mutableImages);
            
            //  NSLog(@" Photo Name%@",imageText);
            
            
            
        }
        
        
        
        [self.searchResultsTableViewController.tableView reloadData];
        
        
        
        [self.tableView reloadData];
        
        //   _images = [NSArray arrayWithArray:mutableImages];
        
        //NSLog(@"****Imag array photo:%@",_image);
        
        //NSLog(@"Imag array text:%@",imageText);
        
        
        
        
        
        //                 NSString *zees=[responseObject objectAtIndex:0][@"album"][2][@"albumId"];
        
        //               NSLog(@"%@",zees);
        
        //        NSLog(@"response object count: %lu",[[responseObject objectAtIndex:0][@"album"] count]);
        
        //        for (i=0; i<[[responseObject objectAtIndex:0][@"album"] count]; i++) {
        
        //           // [tableID addObject:[responseObject objectAtIndex:0][@"album"][i][@"albumId"]];
        
        //           // [tableData addObject:[responseObject objectAtIndex:0][@"album"][i][@"albumName"]];
        
        //
        
        //        }
        
        //
        
        //        NSLog(@"tableData count: %lu",[tableData count]);
        
        //        NSLog(@"tableData : %@",tableData);
        
        //        NSLog(@"tableId : %@",tableID);
        
        //        [self.tableView reloadData];
        
        //
        
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









@end