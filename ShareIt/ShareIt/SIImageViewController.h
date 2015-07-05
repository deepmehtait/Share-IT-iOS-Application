//
//  SIImageViewController.h
//  ShareIt
//
//  Created by student on 4/25/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>


@interface SIImageViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *displayImage;
@property (weak, nonatomic) NSString *photoImageName;
@property(nonatomic) NSString *userID;
@property(nonatomic) NSString *albumID;
@property(nonatomic) NSString *photoID;
@property(nonatomic) NSString *arriveFromSearch;
- (IBAction)sharePic:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)deletePic:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *picName;

@property (weak, nonatomic) IBOutlet UILabel *picLocation;
@property (weak, nonatomic) IBOutlet UILabel *picMeta;


@end
