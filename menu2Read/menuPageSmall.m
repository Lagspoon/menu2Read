//
//  menuPageSmall.m
//  menu
//
//  Created by Olivier Delecueillerie on 28/10/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//
//#import <UIKit/UIKit.h>
#import "menuPageSmall.h"
#import "SquareMenuAd.h"
#import "MEPopup.h"

@interface menuPageSmall ()
@property (strong, nonatomic) SquareMenuAd *menuAd;
@end

@implementation menuPageSmall



- (SquareMenuAd *) menuAd {
    if (!_menuAd) _menuAd=[[SquareMenuAd alloc]init];
    return _menuAd;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    id dataObject = [self.dataDictionary valueForKey:@"object"];
    if ([dataObject isKindOfClass:[SquareMenuAd class]]) {
    self.menuAd = (SquareMenuAd *)dataObject;
    }

}

- (void) viewDidLayoutSubviews {
    if (self.menuAd.thumbnail) {

        UIImage *image =[[UIImage alloc]initWithData:self.menuAd.thumbnail];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame=self.view.frame;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MEPopup"]) {
        MEPopup *destinationVC = segue.destinationViewController;
        UIImage *image = [[UIImage alloc]initWithData:self.menuAd.media];
        destinationVC.image = image;
    }


}

@end
