//  
//  Copyright 2012 BreezyPrint Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PrintModule.h"
#import "PrintModuleDelegate.h"


@interface Breezy_SampleViewController : UIViewController <UIImagePickerControllerDelegate, UIDocumentInteractionControllerDelegate, PrintModuleDelegate, UIAlertViewDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIButton *button;
    IBOutlet UIButton *printButton;
    IBOutlet UIImageView *image;
    UIImagePickerController *imgPicker;
    NSURL *imageURL;
    UIProgressView *progressView;
}
typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) UIProgressView *progressView;

@end
