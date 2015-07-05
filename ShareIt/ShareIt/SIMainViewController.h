//
//  SIUploadPhotoViewController.h
//  ShareIt
//
//  Created by student on 4/26/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface SIMainViewController : UIViewController <UIScrollViewDelegate,FBSDKLoginButtonDelegate>

@property (nonatomic, strong) IBOutlet FBSDKLoginButton *loginButton;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;
@property (nonatomic, strong) IBOutlet UIButton *myDashboard;
- (IBAction)changePage:(id)sender;
- (IBAction)continue:(id)sender;
- (IBAction)myDashboard:(id)sender;




@end
