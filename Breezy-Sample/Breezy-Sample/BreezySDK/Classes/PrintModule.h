//  
//  Copyright 2012 BreezyPrint Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PrintModuleDelegate.h"

@interface PrintModule : NSObject <PrintModuleDelegate>
{
    id <PrintModuleDelegate> delegate;
    NSOperationQueue *requestQueue;
}

@property (assign) id<PrintModuleDelegate> delegate;
@property (retain) NSOperationQueue *requestQueue;


//-(void)printDocument:(Printer *)printer: (NSURL *)documentUrl: (UIProgressView *)progressIndicator :(bool)encrypt;

-(void)sendDocumentToBreezy:(NSURL *)documentUrl;

-(void)cancelPrinting;


@end
