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
-(void)sendDocumentToBreezy:(NSURL *)documentUrl
{
    Document *documentToPrint = [[Document alloc] initWithDocumentPath:documentUrl];
    
    NSMutableData *mutableDocData = [[NSMutableData alloc] initWithData:documentToPrint.documentData];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@breezy_cloud_print?friendly_name=%@&file_extension=%@&client_id=%@&client_secret=%@&is_breezy_cloud_print=%@", @"http://api.local:3000/", [documentToPrint.documentName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], documentToPrint.extension, @"59568b2e-92c9-483e-b899-f0881dcd027a", @"f93f8073-f3dd-4c63-9512-2a4fe9302a49",@"1"];
    
   
    ![self requestQueue] ? [self setRequestQueue:[[[NSOperationQueue alloc] init] autorelease]] : nil;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString: url]];
    [url release];
    [request setDelegate:self];

    [request addRequestHeader:@"content-type" value:@"application/octet-stream"];
    [request setPostBody:mutableDocData];
    [mutableDocData release];
  
    [request setDidStartSelector:@selector(sendingDocument)];
    [request setDidFailSelector:@selector(sendingRequestFailed:)];
    [request setDidFinishSelector:@selector(sendingDocumentCompleteParse:)];
    [[self requestQueue] addOperation:request];
   
    
    [documentToPrint release];
    
}


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

-(void)sendingDocumentCompleteParse: (ASIHTTPRequest *)request
{
     NSLog(@"parse request %@",request.responseString);
 
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *responseStringDictionary = [jsonParser objectWithString:request.responseString error:nil];
    [jsonParser release], jsonParser = nil;
    int documentId = [[responseStringDictionary objectForKey:@"document_id"] intValue];
  
    NSLog(@"document id %i",documentId);
    
    [self sendingDocumentComplete:documentId];
}


//delegate method used for showing that the printing is complete
-(void)sendingDocumentComplete: (int)documentId
{
     
    if([[self delegate] respondsToSelector:@selector(sendingDocumentComplete:)])
    {
        [[self delegate] sendingDocumentComplete:documentId];
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
