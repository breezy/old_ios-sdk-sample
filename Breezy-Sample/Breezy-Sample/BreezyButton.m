//  
//  Copyright 2012 BreezyPrint Corporation. All rights reserved.
//

#import "BreezyButton.h"

@implementation BreezyButton

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUpCustomButton];
    }
    
    return self;
}

-(void)setUpCustomButton
{

        UIImage *buttonImageNormal = [[UIImage imageNamed:@"iphone_button_normal.png"] stretchableImageWithLeftCapWidth:4   topCapHeight:0];
        UIImage *buttonImageDisabled = [[UIImage imageNamed:@"iphone_button_disabled.png"]stretchableImageWithLeftCapWidth:4 topCapHeight:0];
        UIImage *buttonImagePressed = [[UIImage imageNamed:@"iphone_button_pressed.png"]stretchableImageWithLeftCapWidth:4 topCapHeight:0];
        
        [self setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
        [self setBackgroundImage:buttonImageDisabled forState:UIControlStateDisabled];
        [self setBackgroundImage:buttonImagePressed forState:UIControlEventTouchDown];
       
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlEventTouchDown];
    [self setTitleColor:[UIColor colorWithRed:112.0/255.0 green:170.0/255.0 blue:201.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
}

@end
