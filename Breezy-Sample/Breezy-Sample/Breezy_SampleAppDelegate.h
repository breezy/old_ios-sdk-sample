//
//  Breezy_SampleAppDelegate.h
//  Breezy-Sample
//
//  Created by James on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Breezy_SampleViewController;

@interface Breezy_SampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Breezy_SampleViewController *viewController;

@end
