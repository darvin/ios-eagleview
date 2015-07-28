//
//  AppDelegate.h
//  EAGLEView
//
//  Created by Jens Willy Johannsen on 23/11/13.
//  Copyright (c) 2013 Greener Pastures. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;

#define DROPBOX_APP_KEY @"y9ok9xfc11qsfgn"
#define DROPBOX_APP_SECRET @"q0hktu2ay2nd7v0"
#define GLOBAL_TINT_COLOR 0xe25454 // 0xff8d3a //0x9b3aff

// Extern user defaults keys
extern NSString *const kUserDefaults_lastDropboxPath;
extern NSString *const kUserDefaults_lastFilePath;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) ViewController *viewController;

@end
