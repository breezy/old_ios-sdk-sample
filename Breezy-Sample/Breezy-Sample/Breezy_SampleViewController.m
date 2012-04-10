//  
//  Copyright 2012 BreezyPrint Corporation. All rights reserved.
//

#import "Breezy_SampleViewController.h"

@implementation Breezy_SampleViewController
@synthesize imgPicker, imageURL, progressView;



///////////////////////////////////
//Breezy SDK Required Code - Begin
///////////////////////////////////

- (IBAction)printWithBreezy {
    
    //Confirm Breezy is installed on iOS before launching the Breezy app. 
    //If it's not installed then alert the user to download the app.
    NSString *stringURL = [[NSString alloc] initWithString:@"breezy://"];
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
    [breezy sendDocumentToBreezy:imageURL:progressView];
    }
}

//delegate fired when document start sending
-(void)sendingDocument
{   
    [printButton setHidden:YES];
    [progressView setHidden:NO];
}

//delegate fired when document fails
-(void)sendingDocumentFailed: (NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"There was an error communicating with the Breezy print service.\nPlease try again."
                                                     delegate:nil
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
    [message show];
}

//delegate fired when document is sent successfully
-(void)sendingDocumentComplete:(int)documentId;
{
    
    [printButton setHidden:NO];
    [progressView setHidden:YES];
    
    NSString *stringURL = [[NSString alloc] initWithFormat:@"breezy://document_id=%i&customUrl=%@",documentId,@"breezyphoto"];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
    [stringURL release];
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

    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [self.view addSubview:progressView];
    progressView.frame = CGRectMake(printButton.frame.origin.x, printButton.frame.origin.y+10, printButton.frame.size.width, printButton.frame.size.height);
    [progressView setHidden:YES];
    
    self.imgPicker = [[UIImagePickerController alloc] init];
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
    [progressView release];
    [super dealloc];
}


@end

