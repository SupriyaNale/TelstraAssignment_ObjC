//
//  UIAlertController+show.m
//  TelstraAssignment_ObjC
//
//  Created by Yash on 16/05/18.
//  Copyright © 2018 infosys. All rights reserved.
//

#import "UIAlertController+show.h"
#import "AppDelegate.h"

@implementation UIAlertController (show)

+(void)showAlertMessage: (NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}


@end
