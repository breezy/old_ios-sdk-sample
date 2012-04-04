//
//  Breezy_SampleViewController.m
//  Breezy-Sample
//
//  Created by James on 3/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Breezy_SampleViewController.h"


@implementation Breezy_SampleViewController
@synthesize imgPicker, imageURL;

///////////////////////////////////
//Breezy SDK Required Code - Begin
///////////////////////////////////
- (IBAction)printWithBreezy {
    
    PrintModule *breezy = [[PrintModule alloc] init];
    breezy.delegate = self;
    [breezy sendDocumentToBreezy:imageURL];
    
}

-(void)sendingDocument
{
    NSLog(@"*Alert the user the document is sending");
}
-(void)sendingDocumentFailed: (NSError *)error
{
    NSLog(@"Alert the user the process has failed.");
    NSLog(@"with error | %@",[error description]);
}
-(void)sendingDocumentComplete
{
    NSLog(@"*Alert the user the proess is complete and call the breezy app with the documentID");
}
/////////////////////////////////
//Breezy SDK Required Code - End
/////////////////////////////////


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
            
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
            NSString* documentsDirectory = [paths objectAtIndex:0];
            
            NSString* imageFile = [documentsDirectory stringByAppendingPathComponent:@"BreezyDemo.jpg"];
            [UIImageJPEGRepresentation(largeimage, 10.0) writeToFile:imageFile atomically:YES];
            
            NSLog(@"setting url %@",imageFile);
            imageURL = [[NSURL alloc] initFileURLWithPath:imageFile];
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


-(void) dealloc
{
    [imageURL release];
    [super dealloc];
}


@end

