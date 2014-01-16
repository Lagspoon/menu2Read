//
//  menuPageBig.m
//  menu
//
//  Created by Olivier Delecueillerie on 28/10/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "menuPageBig.h"
#import "Drink.h"
#import <MediaPlayer/MediaPlayer.h>

@interface menuPageBig ()
@property (strong, nonatomic) IBOutlet UILabel *mainTitle;
@property (strong, nonatomic) IBOutlet UILabel *volume;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UITextView *about;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIImageView *containingPicture;

@end

@implementation menuPageBig

/////////////////////////////////////////////////////////////////////////////////
//LIFE CYCLE MANAGEMENT
/////////////////////////////////////////////////////////////////////////////////

- (void) viewWillAppear:(BOOL)animated
{
    id dataObject = [self.dataDictionary valueForKey:@"object" ];
    if ([dataObject isKindOfClass:[Drink class]]) {
        Drink * drink = (Drink *) dataObject;
        self.mainTitle.text = drink.name;
        self.price.text = [NSString stringWithFormat:@"%@ €",drink.price];
        self.volume.text = [NSString stringWithFormat:@"%@ cl",drink.volume];
        self.image.image =  [UIImage imageWithData:drink.photo];
        self.about.text = drink.about;

        if ([drink.containing isEqualToString:@"Verre"]) self.containingPicture.image = [UIImage imageNamed:@"glass.png"];
            else self.containingPicture.image = [UIImage imageNamed:@"bottle.png"];
    }
}






@end
