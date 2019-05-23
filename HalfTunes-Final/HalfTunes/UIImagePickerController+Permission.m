//
//  UIImagePickerController+Permission.m
//  Tafseel
//
//  Created by Vivek on 31/1/17.
//  Copyright © 2017 vivekMac. All rights reserved.
//

#import "UIImagePickerController+Permission.h"
#import <Photos/Photos.h>

@implementation UIImagePickerController (Permission)

+ (void)obtainPermissionForMediaSourceType:(UIImagePickerControllerSourceType)sourceType
                        withSuccessHandler:(void (^) ())successHandler
                                andFailure:(void (^) ())failureHandler
{
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary || sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        // Denied when photo disabled, authorized when photos is enabled. Not affected by camera
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
        {
            switch (status)
            {
                case PHAuthorizationStatusAuthorized:
                {
                    if (successHandler)
                    {
                        dispatch_async (dispatch_get_main_queue (), ^
                        {
                            successHandler ();
                        });
                    }
                    
                    break;
                }
                case PHAuthorizationStatusRestricted:
                case PHAuthorizationStatusDenied:
                {
                    if (failureHandler)
                    {
                        dispatch_async (dispatch_get_main_queue (), ^
                        {
                            failureHandler ();
                        });
                    }
                    
                    break;
                }
                default:
                    break;
            }
        }];
    }
    else if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // Checks for Camera access:
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (status)
        {
            case AVAuthorizationStatusAuthorized:
            {
                if (successHandler)
                {
                    dispatch_async (dispatch_get_main_queue (), ^
                    {
                        successHandler ();
                    });
                }
                
                break;
            }
            case AVAuthorizationStatusNotDetermined:
            {
                // seek access first:
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
                {
                    if(granted)
                    {
                        if (successHandler)
                        {
                            dispatch_async (dispatch_get_main_queue (), ^
                            {
                                successHandler ();
                            });
                        }
                    }
                    else
                    {
                        if (failureHandler)
                        {
                            dispatch_async (dispatch_get_main_queue (), ^
                            {
                                failureHandler ();
                            });
                        }
                    }
                }];
                
                break;
            }
                
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
            default:
            {
                if (failureHandler)
                {
                    dispatch_async (dispatch_get_main_queue (), ^
                    {
                        failureHandler ();
                    });
                }
                
                break;
            }
        }
    }
    else
    {
        NSAssert(NO, @"Permission type not found");
    }
}

+ (UIAlertController *)noPermissionAlertForSource:(UIImagePickerControllerSourceType)sourceType
{
    NSString *message;
    
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary || sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        message = @"PTMIP doesn't have permission to access Photos. To enable access, Tap setting and enable Photos.";
    }
    else if(sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        message = @"PTMIP doesn't have permission to access camera. To enable access, Tap setting and enable Camera.";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"PTMIP"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *setting = [UIAlertAction actionWithTitle:@"Settings"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alert addAction:setting];
    [alert addAction:cancel];
    
    return alert;
}

@end

//self.selectImageFrom(sourceType: .photoLibrary)
/*
 func selectImageFrom(sourceType type:UIImagePickerController.SourceType) {
 
 UIImagePickerController.obtainPermission(forMediaSourceType: type, withSuccessHandler: {
 
 let imagePicker = UIImagePickerController()
 
 imagePicker.allowsEditing = true
 imagePicker.delegate = self
 imagePicker.sourceType = type
 
 self.present(imagePicker, animated: true, completion: nil)
 
 }) {
 
 let alert = UIImagePickerController.noPermissionAlert(for: type)
 self.present(alert!, animated: true, completion: nil)
 }
 }
 */
