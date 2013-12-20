//
//  MEPopupVideo.m
//  menu2Read
//
//  Created by Olivier Delecueillerie on 16/12/2013.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#import "MEPopupVideo.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MEPopupVideo ()
@property (strong, nonatomic) MPMoviePlayerController *player;
@end

@implementation MEPopupVideo


- (MPMoviePlayerController *)player {
    if (!_player) _player = [[MPMoviePlayerController alloc] initWithContentURL:[self localMovieURL]];
    return _player;
}

- (void) viewWillAppear:(BOOL)animated{

    self.player.controlStyle = MPMovieControlStyleNone;
    [self playMovie:self.player];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    [self.player.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}

- (void) viewWillDisappear:(BOOL)animated {
    self.player = nil;

}

/* Returns a URL to a local movie in the app bundle. */
- (NSURL *)localMovieURL
{
	NSURL *theMovieURL = nil;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle)
	{
		NSString *moviePath = [bundle pathForResource:@"club1810" ofType:@"mov"];
		if (moviePath)
		{
			theMovieURL = [NSURL fileURLWithPath:moviePath];
		}
	}
    return theMovieURL;
}


//////////////////////////////////////////////////////////////////
//MOVIE MANAGEMENT
//////////////////////////////////////////////////////////////////

- (void)playMovie:(MPMoviePlayerController *)player {
    [player prepareToPlay];
    [player.view setFrame: self.view.bounds];  // player's frame must match parent's
    [self.view addSubview: player.view];
    [player play];
}



#pragma mark - gesture delegate
// this allows you to dispatch touches
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void) handleTapGesture {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}
@end
