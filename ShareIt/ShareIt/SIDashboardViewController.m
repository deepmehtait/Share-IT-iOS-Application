//
//  SIDashboardViewController.m
//  ShareIt
//
//  Created by student on 4/25/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import "SIDashboardViewController.h"
#import "SIAlbumsViewController.h"
#import "SISearchPhotosController.h"
#import "SIMainViewController.h"
#import "AFNetworking.h"


@implementation SIDashboardViewController

static NSString * const registerUserURL=@"http://52.8.15.49:8080/photoshare/api/v1/users";

- (void) tapped

{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(320, 700);
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tapScroll];
    
    NSLog(@"Access Token: %@",_myAccessToken);
    NSLog(@"User ID: %@",_uid);
    
    
    if(_myAccessToken){
        [self returnUserProfileData];        
    }
    else{
        _albumButton.hidden=YES;
    
    }
}

-(void) returnUserProfileData {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"name, email"}]
     
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog( @"%@",result);
             
             NSLog(@"fetched user name :%@  and Email : %@", result[@"name"],result[@"email"]);
             FBSDKProfilePictureView *profilePictureview = [[FBSDKProfilePictureView alloc]init];
             [profilePictureview setProfileID:result[@"id"]];
             [self.view addSubview:profilePictureview];
             
             NSLog(@"%@",result[@"id"]);
             _uid=result[@"id"];
             NSLog(@"%@",result[@"name"]);
             self.nameLabel.text=result[@"name"];
             
             NSLog(@"%@",@"Trying to post now");
             
             AFHTTPRequestOperationManager *newManager = [AFHTTPRequestOperationManager manager];
             
             newManager.requestSerializer=[AFJSONRequestSerializer serializer];
             
             NSString *email=result[@"email"];
             NSString *userId=result[@"id"];
             NSString *name=result[@"name"];
             
             
             NSDictionary *jsonSignUpDictionary = @{@"userId":userId, @"name":name, @"email":email};
             
             NSLog(@"Dictionary: %@", [jsonSignUpDictionary description]);
             
             [newManager POST:registerUserURL parameters:jsonSignUpDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 NSLog(@"JSON: %@", responseObject);
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *errorr) {
                 
                 NSLog(@"Error: %@", errorr);
                 
             }];
         }
         else{
             
             NSLog(@"error");
         }
     }];
}


//
//-(void) returnGuestProfileData {
//    self.nameLabel.text=@"Dude, Login!!";
//    
//    AFHTTPRequestOperationManager *newManager = [AFHTTPRequestOperationManager manager];
//    
//    newManager.requestSerializer=[AFJSONRequestSerializer serializer];
//    
//    NSString *userId= self.uid;
//    
//    NSDictionary *jsonSignUpDictionary = @{@"userId":userId};
//    
//    NSLog(@"Dictionary: %@", [jsonSignUpDictionary description]);
//    
//    [newManager POST:registerUserURL parameters:jsonSignUpDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"JSON: %@", responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *errorr) {
//        
//        NSLog(@"Error: %@", errorr);
//        
//    }];
//
//}

- (IBAction)displayAlbums:(id)sender {
    SIAlbumsViewController *albumsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SIAlbumsViewController"];
    albumsController.userID = _uid;
    [self.navigationController pushViewController:albumsController animated:YES];
}
- (IBAction)searchPublicPhotos:(id)sender {
    SISearchPhotosController *searchPhotosController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SISearchPhotosController"];
  
    [self.navigationController pushViewController:searchPhotosController animated:YES];
    
    
}
@end
