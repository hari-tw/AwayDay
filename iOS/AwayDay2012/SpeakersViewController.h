//
//  ViewController.h
//  ExpandedTableViewCell
//
//  Created by safadmoh on 12/09/13.
//  Copyright (c) 2013 safadmoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionsController.h"

@interface SpeakersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
//This array will store our coments
NSMutableArray *speakersInfo;

//This is the index of the cell which will be expanded
NSInteger selectedIndex;
}

//IBoutlets
@property (weak, nonatomic) IBOutlet UITableView *speakerTableView;

@property(nonatomic, strong) QuestionsController *questionsController;

//Action m
- (IBAction)sideMenuTapped:(id)sender;

@end
