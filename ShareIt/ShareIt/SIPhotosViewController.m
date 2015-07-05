//
//  SIPhotosViewController.m
//  ShareIt
//
//  Created by student on 4/25/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import "SIPhotosViewController.h"
#import "SIImageViewController.h"
#import "SIUploadPhotoViewController.h"
#import "AFNetworking.h"


static NSString * getPhotoURL;

//=@"http://52.8.15.49:8080/photoshare/api/v1/users/10204183147442507/album/549/photo/593";

@implementation SIPhotosViewController

NSString *tempUrl;
NSInteger i;
NSMutableArray *photoID;

- (void) viewWillAppear:(BOOL)animated{
    NSLog(@"In Reloader");
    [super viewWillAppear:YES];
    
    [self fetchPhotos];
    
//    [self.collectionView reloadData];
//    [self.collectionView performBatchUpdates:^{
//        [self.collectionView.collectionViewLayout invalidateLayout];
//    } completion:^(BOOL finished) {
//    }];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view setNeedsDisplay];
    [self fetchPhotos];
}

-(void) fetchPhotos{
    NSLog(@"Album ID: %@", self.albumID);
    
    NSLog(@"userID: %@", _userID);
    
    getPhotoURL = @"http://52.8.15.49:8080/photoshare/api/v1/users/";
    getPhotoURL = [getPhotoURL stringByAppendingString:_userID];
    getPhotoURL = [getPhotoURL stringByAppendingString:@"/album/"];
    getPhotoURL = [getPhotoURL stringByAppendingString:_albumID];
    getPhotoURL = [getPhotoURL stringByAppendingString:@"/photos/"];
    
    NSLog(@"getPhotoURL: %@", getPhotoURL);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:getPhotoURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response object count: %@",responseObject);
        
        if ([responseObject count]) {
            
            NSMutableArray *mutableImages = [NSMutableArray arrayWithCapacity:[responseObject count]];
            photoID = [NSMutableArray arrayWithCapacity:[responseObject count]];
            
            NSLog(@"response object count: %lu",[responseObject count]);
            
            //NSLog(@"response object count2: %@",[responseObject objectAtIndex:0]);
            NSDictionary *dataDict = (NSDictionary *) [responseObject objectAtIndex:0];
            NSLog(@"dataDict: %@",dataDict);
            NSLog(@"URL: %@",dataDict[@"photoUrl"]);
            
            
            for (i=0; i<[responseObject count]; i++) {
                NSDictionary *obj = (NSDictionary *) [responseObject objectAtIndex:i];
                NSLog(@"OBJ: %@",obj);
                NSString *ImgUrl = obj[@"photoUrl"];
                NSLog(@"url %lu : %@",i,ImgUrl);
                NSString *ph_id = obj[@"photoId"];
                NSLog(@"ph_id %lu : %@",i,ph_id);
                
                UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImgUrl]] ];
                if(image){
                    [mutableImages addObject:image];
                    NSLog(@"OBJ Ph_id: %@",obj[@"photoId"]);
                    [photoID addObject:ph_id];
                    NSLog(@"photoID Array: %@",photoID);
                }
                //@"https://photoshareappcmpe277.s3-us-west-1.amazonaws.com/pic-st-loup-herault-le-languedoc1430071277595.gif?AWSAccessKeyId=AKIAJRSSTBSKXU62UWUA&Expires=1461607278&Signature=1dMau3wbine58Y9wiai5J5n0DNU%3D"
                
                //            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.appcoda.com/wp-content/uploads/2013/04/Camera-App-Main-Screen.jpg"]]];
                // UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImgUrl]]];
                
                //NSLog(@"image : %@",image);
                
                
            }
            
            _images = [NSArray arrayWithArray:mutableImages];
            
            //self.zImages=[NSArray arrayWithArray:myPhotos];
            [self.collectionView reloadData];
            
        }
        
        //        NSLog(@"myPhotos1 count: %lu",[myPhotos count]);
        //        NSLog(@"myPhotos1 : %@",myPhotos);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"In numberOfItemsInSection");

    
    
    
    return _images.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"Cell";
//    NSLog(@"In numberOfItemsInSection");
//    NSLog(@"tableData : %@",_images);
//    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    
//    UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:100];
////    NSString *imageName=[myPhotos objectAtIndex:indexPath.row];
////    photoImageView.image = [UIImage imageNamed:imageName];
//    NSLog(@"%@",[UIImage imageWithData:[NSData
//                                  dataWithContentsOfURL:[NSURL URLWithString:[_images objectAtIndex:indexPath.row]]]]);
//    photoImageView.image = [UIImage imageWithData:[NSData
//                                                   dataWithContentsOfURL:[NSURL URLWithString:[_images objectAtIndex:indexPath.row]]]];
//    
//    
//    return cell;
    
     static NSString *identifier = @"Cell";
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
   UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:100];
    photoImageView.image = self.images[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    SIImageViewController *imageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SIImageViewController"];
    imageViewController.userID = self.userID;
    imageViewController.albumID = self.albumID;
    //imageViewController.photoID = [@(indexPath.row)description];
    //imageViewController.photoID = [@(indexPath.row)description];
    
    imageViewController.photoID = photoID[indexPath.row];

   // imageViewController.photoImageName = myPhotos[indexPath.row];
    [self.navigationController pushViewController:imageViewController animated:YES];
    
}

- (IBAction)addMoreButton:(id)sender {
    
    SIUploadPhotoViewController *uploadController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SIUploadPhotoViewController"];
    uploadController.userID = self.userID;
    uploadController.albumID = self.albumID;
    [self.navigationController pushViewController:uploadController animated:YES];
}

@end



/*
 
 
 -(void) fetchAlbumPhotos{
 myPhotos = [[NSMutableArray alloc] init];
 //NSInteger *i=0;
 
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 [manager GET:getPhotoURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 //        NSLog(@"%@",responseObject);
 //                 NSString *zees=[responseObject objectAtIndex:0][@"album"][2][@"albumId"];
 //               NSLog(@"%@",zees);
 NSLog(@"response object count: %@",responseObject);
 //        NSError *error;
 //        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
 //       // NSDictionary *dataDict = (NSDictionary *) responseObject;
 //        for (NSDictionary *i in  jsonData) {
 //            <#statements#>
 //        }
 //
 //
 //        NSArray *dataArary = jsonData[@"array"][@"photoUrl"];
 //
 //        NSLog(@"dataArary : %@",dataArary);
 
 
 
 
 //NSLog(@"response object count: %lu",[[responseObject objectForKey:@"photoId"] count]);
 NSLog(@"response object count1: %lu",[[responseObject objectAtIndex:4] count]);
 NSLog(@"response object count2: %lu",[responseObject count]);
 
 NSLog(@"response object count2: %@",[responseObject objectAtIndex:0]);
 NSDictionary *dataDict = (NSDictionary *) [responseObject objectAtIndex:0];
 NSLog(@"response object count2: %@",dataDict);
 NSLog(@"URL: %@",dataDict[@"photoUrl"]);
 //[myPhotos1 addObject:@""];
 for (i=0; i<[responseObject count]; i++) {
 NSDictionary *obj = (NSDictionary *) [responseObject objectAtIndex:i];
 // NSLog(@"dictionary : %@",obj);
 
 NSString *ImgUrl = obj[@"photoUrl"];
 NSLog(@"url : %@",ImgUrl);
 //NSLog(@"image : %@",[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImgUrl]]]);
 
 UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.appcoda.com/wp-content/uploads/2013/04/Camera-App-Main-Screen.jpg"]]];
 
 //[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImgUrl]]];
 NSLog(@"image : %@",image);
 //myPhotos = [NSArray arrayWithObjects: @"Goofy.png", @"Liking.png", @"Viking.png", nil];
 [myPhotos addObject:image];
 
 }
 
 NSLog(@"myPhotos1 count: %lu",[myPhotos count]);
 NSLog(@"myPhotos1 : %@",myPhotos);
 //NSLog(@"tableId : %@",tableID);
 //[self.tableView reloadData];
 
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

 */
