//
//  AppDelegate.h
//  MyYoutube
//
//  Created by Jenn on 9/14/12.
//  Copyright (c) 2012 Jenn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) ViewController *viewController;

@end
