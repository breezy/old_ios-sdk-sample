//
//  Breezy_SampleViewController.m
//  Breezy-Sample
//
//  Created by James on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Breezy_SampleViewController.h"


@implementation Breezy_SampleViewController
@synthesize imgPicker;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.allowsImageEditing = YES;
    self.imgPicker.delegate = self;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)grabImage {
    [self presentModalViewController:self.imgPicker animated:YES];
}

- (IBAction)printWithBreezy {
   
    
	//get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	NSString *fileName = [NSString stringWithFormat:@"%@/textfile.txt.breezy", 
						  documentsDirectory];
    
    
    NSURL *url = [NSURL fileURLWithPath:fileName];

	NSString *content = @"One\nTwo\nThree\nFour\nFive";
	
    NSError *error;
	BOOL ok = [content writeToFile:fileName 
			  atomically:NO 
				encoding:NSStringEncodingConversionAllowLossy 
				   error:&error];
    
    if (!ok)
    {
        NSLog(@"Error writing file at %@\n%@ %@",
              fileName, [error localizedFailureReason], [error description]);
    }
       UIDocumentInteractionController *doc=[[UIDocumentInteractionController interactionControllerWithURL:url] retain];

    doc.delegate = self;
    doc.UTI = @"com.breezy.ios";
    
    BOOL isValid = [doc presentOpenInMenuFromRect:CGRectZero inView:self.view.window animated:YES];
}


//delegates
-(void)documentInteractionController:(UIDocumentInteractionController *)controller 
       willBeginSendingToApplication:(NSString *)application {
    NSLog(@"1 willBeginSendingToApplication || %@",application);
    
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller 
          didEndSendingToApplication:(NSString *)application {
     NSLog(@"2");
}

-(void)documentInteractionControllerDidDismissOpenInMenu:
(UIDocumentInteractionController *)controller {
     NSLog(@"3");
}


- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
    UIImage *selectedImage;
    NSURL *mediaUrl;
	
    mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    if (mediaUrl == nil)
    {
        selectedImage = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        if (selectedImage == nil)
        {
            selectedImage = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
        }
        else
        {
        }
    }
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    
    if (selectedImage != nil)
    {
        image.image = selectedImage;
    }
    NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            UIImage *largeimage = [UIImage imageWithCGImage:iref];
            [largeimage retain];
            
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
            NSString* documentsDirectory = [paths objectAtIndex:0];
            
            NSString* imageFile = [documentsDirectory stringByAppendingPathComponent:@"test.jpg"];
            [UIImageJPEGRepresentation(largeimage, 10.0) writeToFile:imageFile atomically:YES];
            [printButton setHidden:NO];
       
        }
    };
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
    };
    

        ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
        [assetslibrary assetForURL:url 
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
@end
