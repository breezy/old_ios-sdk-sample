//  
//  Copyright 2012 BreezyPrint Corporation. All rights reserved.
//

#import "PrintModule.h"

#import "ASIHTTPRequest.h"
#import "JSON.h"


@interface PrintModule ()

@end

@implementation PrintModule

NSOperationQueue *requestQueue;

@synthesize delegate, requestQueue;

#pragma logic
-(void)sendDocumentToBreezy:(NSURL *)documentUrl/*:(UIProgressView *)progressIndicator*/
{
    NSLog(@"print Document fired");
    NSLog(@"Sending document at path %@",documentUrl);
    Document *documentToPrint = [[Document alloc] initWithDocumentPath:documentUrl];
    
    NSMutableData *mutableDocData = [[NSMutableData alloc] initWithData:documentToPrint.documentData];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@breezy_cloud_print?friendly_name=%@&file_extension=%@&client_id=%@&client_secret=%@&is_breezy_cloud_print=%@", @"http://api.local:3000/", [documentToPrint.documentName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], documentToPrint.extension, @"", @"",@"1"];
    
   
    ![self requestQueue] ? [self setRequestQueue:[[[NSOperationQueue alloc] init] autorelease]] : nil;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString: url]];
    [url release];
    [request setDelegate:self];
    
//    if (progressIndicator != nil)
//    {
//        [request setUploadProgressDelegate:progressIndicator];
//    }
    [request addRequestHeader:@"content-type" value:@"application/octet-stream"];
    [request setPostBody:mutableDocData];
    [mutableDocData release];
  
    [request setDidStartSelector:@selector(sendingDocument)];
    [request setDidFailSelector:@selector(sendingRequestFailed:)];
    [request setDidFinishSelector:@selector(sendingDocumentComplete)];
    [[self requestQueue] addOperation:request];
   
    
    [documentToPrint release];
    
}



////Sends a request with which printer and the file that is for printing
//-(void)printDocument:(Printer *)printer: (NSURL *)documentUrl: (UIProgressView *)progressIndicator: (bool)encrypt
//{
//    Document *documentToPrint = [[Document alloc] initWithDocumentPath:documentUrl];
//    
//    NSString *encryptedDataUrl = [[NSString alloc] init];
//
//    if (encrypt)
//    {
//
//    }
//    if (documentToPrint.documentData != nil)
//    {
//        if (![self requestQueue])
//        {
//            [self setRequestQueue:[[[NSOperationQueue alloc] init] autorelease]];
//        }
//
//        NSMutableData *mutableDocData = [[NSMutableData alloc] initWithData:documentToPrint.documentData];
//               
//        if (printer.numberOfCopies <= 0) { printer.numberOfCopies = 1; }
//        NSString *url = [[NSString alloc] initWithFormat:@"%@document?oauth_token=%@&friendly_name=%@&file_extension=%@&endpoint_id=%ld&use_coversheet=%@&use_color=%@&use_duplex=%@&number_of_copies=%i%@&landscape=%@", @"BASE SERVICE ADDRESS", @"OAUTH TOKEN", [documentToPrint.documentName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], documentToPrint.extension, printer.printerId, (printer.includeCoverSheet == YES) ? @"true": @"false", (printer.useColor == YES) ? @"true": @"false", (printer.useDuplex == YES) ? @"true": @"false", printer.numberOfCopies,encryptedDataUrl,(printer.useLandscape == YES) ? @"true": @"false"];
//        
//        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString: url]];
//        [url release];
//        
//        [request setDelegate:self];
//               
//        if (progressIndicator != nil)
//        {
//            [request setUploadProgressDelegate:progressIndicator];
//        }
//        [request addRequestHeader:@"content-type" value:@"application/octet-stream"];
//        [request setPostBody:mutableDocData];
//        [mutableDocData release];
//        
//        [request setDidStartSelector:@selector(printingDocument)];
//        [request setDidFailSelector:@selector(printRequestFailed:)];
//        [request setDidFinishSelector:@selector(printingDocumentComplete)];
//        [[self requestQueue] addOperation:request];
//    }
//    
//    [documentToPrint release];
//}

//delegate method used for showing that the document is printing
-(void)sendingDocument
{
    if([[self delegate] respondsToSelector:@selector(sendingDocument)])
    {
        [[self delegate] sendingDocument];
    }
}

//delegate method used for showing that the print request has failed
-(void)sendingRequestFailed: (ASIHTTPRequest *)request
{
    NSLog(@"fail");
    [self sendingDocumentFailed:[request error]];
}

//delegate method used for logging an error that the printing request has failed
-(void)sendingDocumentFailed:(NSError *)error
{
    if([[self delegate] respondsToSelector:@selector(sendingDocumentFailed:)])
    {
        [[self delegate] sendingDocumentFailed:error];
    }
}

//delegate method used for showing that the print request is complete
-(void)printRequestComplete: (ASIHTTPRequest *)request
{
    [self sendingDocumentComplete];
}

//delegate method used for showing that the printing is complete
-(void)sendingDocumentComplete
{
    if([[self delegate] respondsToSelector:@selector(sendingDocumentComplete)])
    {
        [[self delegate] sendingDocumentComplete];
    }
}

//Used to cancel printing by clearing the delegates
-(void)cancelPrinting
{
    NSLog(@"cancel print");
    for (ASIHTTPRequest *request in self.requestQueue.operations) 
    {
        [request clearDelegatesAndCancel];
        request.uploadProgressDelegate = nil;
    }
}

#pragma teardown

- (void)dealloc
{
    NSLog(@"dalloc");
    for (ASIHTTPRequest *request in self.requestQueue.operations) 
    {
        [request clearDelegatesAndCancel];
        request.uploadProgressDelegate = nil;
    }
    
    [super dealloc];
}

@end
