//
//  VideoViewController.h
//  YouTubePlayer
//
//  Created by safadmoh on 15/09/13.
//  Copyright (c) 2013 safadmoh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

    //IBOutlets
    @property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionView;

    //Action method.
    - (IBAction)sideMenuTapped:(id)sender;

@end
