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
- (IBAction)printWithBreezy {
    NSString *stringURL = [[NSString alloc] initWithString:@"breezy://document_id=?"];
    NSURL *url = [NSURL URLWithString:stringURL];
    if(![[UIApplication sharedApplication] canOpenURL:url])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Breezy Not Installed"
                                                          message:@"Breezy is the world's most secure mobile printing app.  Download it now to continue printing this document."
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Download",nil];
        message.tag = 1;
        [message show];
    }
    else
    {
    PrintModule *breezy = [[PrintModule alloc] init];
    breezy.delegate = self;
    [breezy sendDocumentToBreezy:imageURL];
    }
}

-(void)sendingDocument
{
    NSLog(@"Show loading modal with existing framework");
}
-(void)sendingDocumentFailed: (NSError *)error
{
    NSLog(@"Alert the user the process has failed with error %@",[error description]);
}
-(void)sendingDocumentComplete:(int)documentId;
{
    NSString *stringURL = [[NSString alloc] initWithFormat:@"breezy://document_id=%i",documentId];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://itunes.apple.com/us/app/breezy-print-and-fax/id438846342?mt=8&uo=6"]];
    }
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

