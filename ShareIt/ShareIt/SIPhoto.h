//
//  SIUploadPhotoViewController.h
//  ShareIt
//
//  Created by student on 4/26/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIPhoto : NSObject

+ (instancetype)photoWithObjectURL:(NSURL *)objectURL
                             title:(NSString *)title
                            rating:(NSUInteger)rating
                             image:(UIImage *)image;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *objectURL;
@property (nonatomic, assign) NSUInteger rating;
@property (nonatomic, strong) NSString *title;

@end
