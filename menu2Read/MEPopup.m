//
//  MEPopup.m
//  menu2Read
//
//  Created by Olivier Delecueillerie on 16/12/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "MEPopup.h"

@interface MEPopup ()

@end

@implementation MEPopup

- (void) viewWillAppear:(BOOL)animated {
    if (self.image) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:self.image];
        imageView.frame=self.view.frame;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
    }
}
- (IBAction)tapGesture:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

@end

