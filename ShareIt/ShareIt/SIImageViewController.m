//
//  SIImageViewController.m
//  ShareIt
//
//  Created by student on 4/25/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import "SIPhotosViewController.h"
#import "SIImageViewController.h"
#import "SIUploadPhotoViewController.h"
#import "AFNetworking.h"

static NSString * getImageURL;

@implementation SIImageViewController


NSString *tempUrl;
NSString *message=@"";
NSString *pic_name;
NSString *pic_loc;
NSString *pic_meta;
NSInteger i;


- (void) tapped

{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Album ID: %@", self.albumID);
    
    NSLog(@"userID: %@", _userID);
    NSLog(@"photoID: %@", _photoID);
    
    
    if([_arriveFromSearch isEqual:@"true"]){
        self.deleteButton.hidden=YES;
    }
    
    
    getImageURL = @"http://52.8.15.49:8080/photoshare/api/v1/users/";
    getImageURL = [getImageURL stringByAppendingString:_userID];
    getImageURL = [getImageURL stringByAppendingString:@"/album/"];
    getImageURL = [getImageURL stringByAppendingString:_albumID];
    getImageURL = [getImageURL stringByAppendingString:@"/photo/"];
    getImageURL = [getImageURL stringByAppendingString:_photoID];
    
    NSLog(@"getPhotoURL: %@", getImageURL);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:getImageURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response object: %@",responseObject);
        
        if ([responseObject count]) {
            
            NSLog(@"response object: %@",[responseObject objectForKey:@"photoUrl"]);
            tempUrl=[responseObject objectForKey:@"photoUrl"];
            _displayImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[responseObject objectForKey:@"photoUrl"]]]];
            
            pic_name = @"Name: ";
            pic_name = [pic_name stringByAppendingString:[responseObject objectForKey:@"photoName"]];
            _picName.text= pic_name;
            pic_loc = @"Location: ";
            pic_loc = [pic_loc stringByAppendingString:[responseObject objectForKey:@"location"]];
            _picLocation.text= pic_loc;
            pic_meta = @"Note: ";
            pic_meta = [pic_meta stringByAppendingString:[responseObject objectForKey:@"metadata"]];
            _picMeta.text= pic_meta;
            
            
        }
                
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
    
    
    
    
    
    
    
    
    
    
    
    
    // scroll view
    self.scrollView.contentSize = CGSizeMake(320, 700);
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tapScroll];

    
    
    //    _displayImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.appcoda.com/wp-content/uploads/2013/04/Camera-App-Main-Screen.jpg"]]];
    //[super viewDidLoad];
    
    
    
    
    //self.displayImage.image = [UIImage imageNamed:self.photoImageName];
    
}



- (IBAction)sharePic:(id)sender {
    
        // Email Subject
        NSString *emailTitle = @"ShareIt! iOS App";
        //NSString
        // Email Content
        NSArray *tiniurl;
        tiniurl = [tempUrl componentsSeparatedByString:@"?"];
        NSString *small= tiniurl[0];
        NSString *bodyText =@"<html>";
        bodyText = [bodyText stringByAppendingString:@"<head>"];
        bodyText = [bodyText stringByAppendingString:@"</head>"];
        bodyText = [bodyText stringByAppendingString:@"<body>"];
        bodyText = [bodyText stringByAppendingString:@"<p>Hey buddy Check out this cool pic @ShareIt!<p>"];
        bodyText = [bodyText stringByAppendingString:@"<a href="];
        bodyText = [bodyText stringByAppendingString:small];
        bodyText = [bodyText stringByAppendingString:@">View with ShareIt!"];
        bodyText = [bodyText stringByAppendingString:@"</a>"];
        //[mailComposer setMessageBody:bodyText isHTML:YES];
        message = [message stringByAppendingString:@"Hey, Checkout this Photo!! \n"];
        message = [message stringByAppendingString:small];
        NSLog(@"%@",tempUrl);
        NSString *messageBody = message;
        NSLog(@"Message!!:%@",messageBody);
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@""];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:bodyText isHTML:YES];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    
    
//    // Email Subject
//    NSString *emailTitle = @"ShareIt! iOS App";
//    // Email Content
//    
//    message = [message stringByAppendingString:@"Hey, Checkout this Photo!! \n"];
//    message = [message stringByAppendingString:tempUrl];
//    NSLog(@"%@",message);
//    NSString *messageBody = message;
//    // To address
//    NSArray *toRecipents = [NSArray arrayWithObject:@""];
//    
//    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//    mc.mailComposeDelegate = self;
//    [mc setSubject:emailTitle];
//    [mc setMessageBody:messageBody isHTML:NO];
//    [mc setToRecipients:toRecipents];
//    
//    // Present mail view controller on screen
//    [self presentViewController:mc animated:YES completion:NULL];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)deletePic:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager DELETE:getImageURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"delete response object: %@",responseObject);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
