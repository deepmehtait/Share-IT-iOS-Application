//
//  SIUploadPhotoViewController.h
//  ShareIt
//
//  Created by student on 4/26/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIUploadPhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageUploadView;
@property(nonatomic) NSString *userID;
@property(nonatomic) NSString *albumID;
@property (nonatomic) NSString *property;
//+ (NSNumber *)numberWithBool:(BOOL)value;

- (IBAction)choosePhoto:(id)sender;
- (IBAction)uploadToServer:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;


@property (weak, nonatomic) IBOutlet UILabel *locationLbl;

@property (weak, nonatomic) IBOutlet UITextField *locationTxtField;

@property (weak, nonatomic) IBOutlet UILabel *notelbl;
@property (weak, nonatomic) IBOutlet UITextField *noteTxtField;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;



@end
