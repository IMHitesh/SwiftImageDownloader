//
//  UIImagePickerController+Permission.h
//  Tafseel
//
//  Created by Vivek on 31/1/17.
//  Copyright © 2017 vivekMac. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIImagePickerController (Permission)

+ (void)obtainPermissionForMediaSourceType:(UIImagePickerControllerSourceType)sourceType
                        withSuccessHandler:(void (^) ())successHandler
                                andFailure:(void (^) ())failureHandler;

+ (UIAlertController *)noPermissionAlertForSource:(UIImagePickerControllerSourceType)sourceType;

@end
