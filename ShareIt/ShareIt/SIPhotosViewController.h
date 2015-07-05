//
//  SIPhotosViewController.h
//  ShareIt
//
//  Created by student on 4/25/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIPhotosViewController : UICollectionViewController 
@property(nonatomic) NSString *userID;
@property(nonatomic) NSString *albumID;
@property (nonatomic, strong) NSArray *images;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

- (IBAction)addMoreButton:(id)sender;


@end
