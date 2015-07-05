//
//  SIUploadPhotoViewController.h
//  ShareIt
//
//  Created by student on 4/26/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SIPhoto.h"

@interface SIMainView : UIView

@property (nonatomic, copy) NSArray *images;
@property (nonatomic, strong) SIPhoto *photo;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end
