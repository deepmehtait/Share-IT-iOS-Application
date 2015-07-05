//
//  SIUploadPhotoViewController.h
//  ShareIt
//
//  Created by student on 4/26/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import "SIMainViewController.h"

#import <MessageUI/MessageUI.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "SIMainView.h"
#import "SIPhoto.h"
#import "SIDashboardViewController.h"


@interface SIMainViewController ()

@property (nonatomic, strong) UIActionSheet *shareActionSheet;
@end

@implementation SIMainViewController
{
  NSArray *_photos;
}

#pragma mark - Class Methods

+ (NSArray *)demoPhotos
{
  return @[
           [SIPhoto photoWithObjectURL:[NSURL URLWithString:@"http://s24.postimg.org/qfgie43z9/goofy.png"]
                                 title:@"Make a Goofy Face"
                                rating:5
                                 image:[UIImage imageNamed:@"Goofy"]],
           [SIPhoto photoWithObjectURL:[NSURL URLWithString:@"http://s8.postimg.org/65wp736id/liking.png"]
                                 title:@"Happy Sharing"
                                rating:3
                                 image:[UIImage imageNamed:@"Viking"]],
           [SIPhoto photoWithObjectURL:[NSURL URLWithString:@"http://s9.postimg.org/u9b7avlpb/viking.png"]
                                 title:@"Happy Liking, Happy Viking"
                                rating:4
                                 image:[UIImage imageNamed:@"Liking"]],
           ];
}

#pragma mark - View Management

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)pickButton
{
    if([FBSDKAccessToken currentAccessToken]){
    self.continueButton.hidden=YES;
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [self pickButton];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    self.myDashboard.hidden=NO;
    self.continueButton.hidden=NO;
    [self pickButton];
    
  //self.loginButton.publishPermissions = @[@"publish_actions"];
  self.loginButton.readPermissions = @[@"email", @"public_profile", @"user_friends"];
 [_loginButton setDelegate:self];
  [self _configurePhotos];
}


- (void) loginButton: (FBSDKLoginButton *)loginButton
didCompleteWithResult: 	(FBSDKLoginManagerLoginResult *)result
               error: 	(NSError *)error{
     self.continueButton.hidden=YES;
     self.myDashboard.hidden=NO;
    NSLog(@"Logged in");
    
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
    self.continueButton.hidden=NO;
    self.myDashboard.hidden=YES;

    NSLog(@"Logged out");
    
}



#pragma mark - Paging

- (IBAction)changePage:(id)sender
{
  UIScrollView *scrollView = self.scrollView;
  CGFloat x = floorf(self.pageControl.currentPage * scrollView.frame.size.width);
  [scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
  [self _updateViewForCurrentPage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView.isDragging || scrollView.isDecelerating){
    UIPageControl *pageControl = self.pageControl;
    pageControl.currentPage = floorf(scrollView.contentOffset.x /
                                     (scrollView.contentSize.width / pageControl.numberOfPages));
    [self _updateViewForCurrentPage];
  }
}

#pragma mark - Helper Methods

- (void)_configurePhotos
{
  _photos = [[self class] demoPhotos];
  [self _updateViewForCurrentPage];
  [self _mainView].images = [_photos valueForKeyPath:@"image"];
}

- (SIPhoto *)_currentPhoto
{
  return _photos[self.pageControl.currentPage];
}

- (SIMainView *)_mainView
{
  UIView *view = self.view;
  return ([view isKindOfClass:[SIMainView class]] ? (SIMainView *)view : nil);
}

- (void)_updateViewForCurrentPage{
  SIPhoto *photo = [self _currentPhoto];
  [self _mainView].photo = photo;
}

- (IBAction)continue:(id)sender {
    SIDashboardViewController *dashboardController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SIDashboardViewController"];
    dashboardController.myAccessToken = [FBSDKAccessToken currentAccessToken];
    dashboardController.uid = @"0";
    [self.navigationController pushViewController:dashboardController animated:YES];
}

- (IBAction)myDashboard:(id)sender {
    SIDashboardViewController *dashboardController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SIDashboardViewController"];
    dashboardController.myAccessToken = [FBSDKAccessToken currentAccessToken];
    [self.navigationController pushViewController:dashboardController animated:YES];
}

@end
