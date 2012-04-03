//
//  Breezy_SampleViewController.h
//  Breezy-Sample
//
//  Created by James on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface Breezy_SampleViewController : UIViewController <UIImagePickerControllerDelegate, UIDocumentInteractionControllerDelegate>
{
    IBOutlet UIButton *button;
    IBOutlet UIButton *printButton;
    IBOutlet UIImageView *image;
    UIImagePickerController *imgPicker;
}
typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

@property (nonatomic, retain) UIImagePickerController *imgPicker;


@end
