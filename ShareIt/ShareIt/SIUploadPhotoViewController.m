//
//  SIUploadPhotoViewController.m
//  ShareIt
//
//  Created by student on 4/26/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import "SIUploadPhotoViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "SIPhotosViewController.h"

@implementation SIUploadPhotoViewController

static NSString * uploadPhotoUrl;
//=@"http://52.8.15.49:8080/photoshare/api/v1/users/10204183147442507/album/549/photo"
- (void) tapped

{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // scroll view
    self.scrollView.contentSize = CGSizeMake(320, 700);
    self.property = @"true";
    
    uploadPhotoUrl = @"http://52.8.15.49:8080/photoshare/api/v1/users/";
    uploadPhotoUrl = [uploadPhotoUrl stringByAppendingString:_userID];
    uploadPhotoUrl = [uploadPhotoUrl stringByAppendingString:@"/album/"];
    uploadPhotoUrl = [uploadPhotoUrl stringByAppendingString:_albumID];
    uploadPhotoUrl = [uploadPhotoUrl stringByAppendingString:@"/photo"];
    
    NSLog(@"getPhotoURL: %@", uploadPhotoUrl);
    [self.mySwitch addTarget:self
                      action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    tapScroll.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tapScroll];
}

- (IBAction)choosePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //NSLog(@"%@",info[UIImagePickerControllerMediaURL]);
    self.imageUploadView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)uploadToServer:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    
    //NSString *userId= @"id"; // replace with user id
    //NSString *albumId= @"albumId"; // replace with
    
    NSDictionary *params = @{@"photoName":self.nameTxtField.text,
                             @"location":self.locationTxtField.text,
                             @"metadata":self.noteTxtField.text,
                             @"public":self.property};
    NSLog(@"Dictionary values %@",params);
    
    AFHTTPRequestOperationManager *sharedManager = [AFHTTPRequestOperationManager manager];;
    [sharedManager POST:uploadPhotoUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(_imageUploadView.image){
            [formData appendPartWithFileData:UIImageJPEGRepresentation(_imageUploadView.image, 0.5) name:@"thumbnail" fileName:@"avatar.jpg" mimeType:@"image/jpeg" ];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // [hud show:NO];
        NSLog(@"Success");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Uploaded!!" delegate:self
                                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        [hud hide:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail");
        [self.navigationController popViewControllerAnimated:YES];
    }];

    //api call for upload
    
//    SIPhotosViewController *photoController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SIPhotosViewController"];
//    photoController.userID = self.userID;
//    //NSString *aId=[@(indexPath.row)description];
//    //photoController.albumID = [tableID objectAtIndex:[aId integerValue]];
//    photoController.albumID = self.albumID;
//    [self.navigationController pushViewController:photoController animated:YES];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn]) {
        self.property = @"true";
    } else {
        self.property = @"false";
    }
    NSLog(@"%@",self.property);
}
@end
