//
//  SIUploadPhotoViewController.h
//  ShareIt
//
//  Created by student on 4/26/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import "SIPhoto.h"

@implementation SIPhoto

+ (instancetype)photoWithObjectURL:(NSURL *)objectURL
                             title:(NSString *)title
                            rating:(NSUInteger)rating
                             image:(UIImage *)image
{
  SIPhoto *photo = [[self alloc] init];
  photo.objectURL = objectURL;
  photo.title = title;
  photo.rating = rating;
  photo.image = image;
  return photo;
}

@end
