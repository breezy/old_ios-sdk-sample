//
//  Breezy_SampleViewController.h
//  Breezy-Sample
//
//  Created by James on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PrintModule.h"
#import "PrintModuleDelegate.h"


@interface Breezy_SampleViewController : UIViewController <UIImagePickerControllerDelegate, UIDocumentInteractionControllerDelegate, PrintModuleDelegate>
{
    IBOutlet UIButton *button;
    IBOutlet UIButton *printButton;
    IBOutlet UIImageView *image;
    UIImagePickerController *imgPicker;
    NSURL *imageURL;
}
typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) NSURL *imageURL;

@end
