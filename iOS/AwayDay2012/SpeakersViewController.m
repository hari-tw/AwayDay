//
//  ViewController.m
//  ExpandedTableViewCell
//
//  Created by safadmoh on 12/09/13.
//  Copyright (c) 2013 safadmoh. All rights reserved.
//

#import "SpeakersViewController.h"
#import "customTableCell.h"
#import "expandCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomSlider.h"
#import "customTableCell.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "RNFrostedSidebar.h"
#import "CustomSlider.h"

#define COMMENT_LABEL_WIDTH 230
#define COMMENT_LABEL_MIN_HEIGHT 21


@interface SpeakersViewController ()<CustomTableDelegate , RNFrostedSidebarDelegate>
{
    CustomSlider *slider;
}
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;


@end

@implementation SpeakersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"Speakers_Info"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSLog(@"%@",data);
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&error];
    
     speakersInfo = [[NSMutableArray alloc] init];
    for (NSDictionary *speaker in json)
    {
        NSMutableDictionary *speakerInfo = [[NSMutableDictionary alloc]init];
        [speakerInfo setObject:[speaker valueForKey:@"speaker_name"] forKey:@"speakerName"];
        [speakerInfo setObject:[speaker valueForKey:@"speaker_image"] forKey:@"image"];
        [speakerInfo setObject:[speaker valueForKey:@"speaker_topic"] forKey:@"topic"];
        [speakerInfo setObject:[speaker valueForKey:@"speaker_details"] forKey:@"detail"];
        [speakersInfo addObject:speakerInfo];
    }
    
    
    
    selectedIndex=-1;
    
   
   
       
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [speakersInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
       
    
    if(selectedIndex == indexPath.row)
    {
        
        static NSString *CellIdentifier = @"expandCell";

        expandCell *cell = (expandCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
         [cell setLabelFontsColor];
        
        cell.timeTextLabel.text=[[speakersInfo objectAtIndex:indexPath.row] valueForKey:@"time"];
        
        cell.nameTextLabel.text=[NSString stringWithFormat:@"-%@",[[speakersInfo objectAtIndex:indexPath.row] valueForKey:@"speakerName"]] ;
        
        cell.topicTextLabel.text=[NSString stringWithFormat:@" \"%@ \" ",
        [[speakersInfo objectAtIndex:indexPath.row] valueForKey:@"topic"]];
        
        cell.speakerImageView.image =[UIImage imageNamed:
                                 [[speakersInfo objectAtIndex:indexPath.row] valueForKey:@"image"]];
        NSLog(@"%@",[[speakersInfo objectAtIndex:indexPath.row]valueForKey:@"detail"]);
       cell.descriptionTextlabel.text=[[speakersInfo objectAtIndex:indexPath.row]valueForKey:@"detail"];
        
        cell.speakerImageView.layer.cornerRadius = cell.speakerImageView.frame.size.width/2.0;
        cell.speakerImageView.layer.masksToBounds=YES;
        
        
              
        
        
        CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.row];
       
        
        
        
        
        cell.descriptionTextlabel.frame = CGRectMake(cell.descriptionTextlabel.frame.origin.x,
                                                 cell.descriptionTextlabel.frame.origin.y,
                                                 cell.descriptionTextlabel.frame.size.width,
                                                 labelHeight);
        
        return cell;
    }
    else
    {
        
        static NSString *CellIdentifier = @"customCell";
       
        
        customTableCell *cell = (customTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
         [cell setLabelFontsColor];
        
        cell.indexPath=indexPath;
        cell.delegate=self;
         cell.nameTextLabel.text=[NSString stringWithFormat:@"-%@",[[speakersInfo objectAtIndex:indexPath.row] valueForKey:@"speakerName"]] ;
        
        cell.topicTextLabel.text=[NSString stringWithFormat:@" \"%@ \" ",
                                  [[speakersInfo objectAtIndex:indexPath.row] valueForKey:@"topic"]];
        
        cell.speakerImageView.image =[UIImage imageNamed:
                                  [[speakersInfo objectAtIndex:indexPath.row] valueForKey:@"image"]];
        
    
        return cell;
    
    
    }
    
}



//This just a convenience function to get the height of the label based on the comment text
-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    CGSize maximumSize = CGSizeMake(COMMENT_LABEL_WIDTH, 10000);
    
    CGSize labelHeighSize = [[[speakersInfo objectAtIndex:index] valueForKey:@"detail"] sizeWithFont: [UIFont fontWithName:@"Helvetica" size:13.0f]
                                                        constrainedToSize:maximumSize
                                                            lineBreakMode:NSLineBreakByWordWrapping];
    return labelHeighSize.height;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If this is the selected index we need to return the height of the cell
    //in relation to the label height otherwise we just return the minimum label height with padding
    if(selectedIndex == indexPath.row)
    {
        return [self getLabelHeightForIndex:indexPath.row] + 123;
    }
    else {
        return 120;
    }
}



-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //We only don't want to allow selection on any cells which cannot be expanded
    if([self getLabelHeightForIndex:indexPath.row] > COMMENT_LABEL_MIN_HEIGHT)
    {
        return indexPath;
    }
    else {
        return nil;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIndex == indexPath.row)
    {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex >= 0)
    {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if(indexPath.row==5)
    {
        [self.speakerTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]
                                     atScrollPosition:UITableViewScrollPositionTop
                                             animated:YES];
    }
    else
    [self.speakerTableView scrollToRowAtIndexPath:indexPath
                                 atScrollPosition:UITableViewScrollPositionTop
                                         animated:YES];

    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //The user is selecting the cell which is currently expanded
    //we want to minimize it back
   
}

-(void)didButtonTappedAt:(NSIndexPath *)indexPath
{
    
    NSLog(@"%d",indexPath.row);
    if(selectedIndex == indexPath.row)
    {
        selectedIndex = -1;
        [self.speakerTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex >= 0)
    {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [self.speakerTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    
    [self.speakerTableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    NSLog(@"%@",indexPath);
    [self.speakerTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}


-(void)sideMenuTapped:(id)sender
{
  
    slider = [[CustomSlider alloc]init];
    [slider showSliderMenu];
    slider.callout.delegate=self;
    
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    
    switch (index) {
        case 0:
        {
            [slider showHomeScreen];
            [sidebar dismiss];
        }
            break;
            
        case 1:
        {
            [slider showAgendaScreen];
            [sidebar dismiss];
            
        }
            break;
        case 2 :
        {
            [slider showSpeakersScreen];
            [sidebar dismiss];
            
        }
            break;
        case 3 :
        {
            [slider showMapScreen];
            [sidebar dismiss];
            
        }
            break;
        case 4 :
        {
            [slider showMyEventsScreen];
            [sidebar dismiss];
            
        }
            break;
        case 5 :
        {
            [slider showBreakOutSessionScreen];
            [sidebar dismiss];
            
        }
            break;
        case 6 :
        {
            [slider showVideoScreen];
            [sidebar dismiss];
            
        }
            break;

            
            
        default:
            break;
    }
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
