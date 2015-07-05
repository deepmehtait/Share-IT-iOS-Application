//
//  SIUploadPhotoViewController.h
//  ShareIt
//
//  Created by student on 4/26/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import "SIAppDelegate.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>


@implementation SIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [FBSDKLoginButton class];

  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                  didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
  return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                        openURL:url
                                              sourceApplication:sourceApplication
                                                     annotation:annotation];
}

@end
