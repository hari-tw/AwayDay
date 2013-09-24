//
//  GameSessionViewController.m
//  AwayDay2012
//
//  Created by safadmoh on 24/09/13.
//
//

#import "GameSessionViewController.h"
#import "gameExpandedTableViewCell.h"
#import "CustomSlider.h"
#import "gameTableViewCell.h"
#define COMMENT_LABEL_WIDTH 230
#define COMMENT_LABEL_MIN_HEIGHT 21

@interface GameSessionViewController ()<CustomTableDelegate,RNFrostedSidebarDelegate>
{
    NSMutableArray *gameInfo;
    NSInteger selectedIndex;
     CustomSlider *slider;
}

@end



@implementation GameSessionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"GameSession"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSLog(@"%@",data);
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:kNilOptions
                                                error:&error];
    
    gameInfo = [[NSMutableArray alloc] init];
    for (NSDictionary *game in json)
    {
        NSMutableDictionary *speakerInfo = [[NSMutableDictionary alloc]init];
        [speakerInfo setObject:[game valueForKey:@"game_name"] forKey:@"game_name"];
        [speakerInfo setObject:[game valueForKey:@"game_capacity"] forKey:@"game_capacity"];
        [speakerInfo setObject:[game valueForKey:@"game_details"] forKey:@"game_details"];
        [gameInfo addObject:speakerInfo];
    }
    
    self.gameSessionTableView.delegate=self;
    self.gameSessionTableView.dataSource=self;
    
    selectedIndex=-1;

	// Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [gameInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    if(selectedIndex == indexPath.row)
    {
        
        static NSString *CellIdentifier = @"expandCell";
        
        gameExpandedTableViewCell *cell = (gameExpandedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
       // [cell setLabelFontsColor];
        
        cell.gameNameTextLabel.text=[[gameInfo objectAtIndex:indexPath.row] valueForKey:@"game_name"];
        
        cell.capacityCountTextLabel.text=[NSString stringWithFormat:@"%@",[[gameInfo objectAtIndex:indexPath.row] valueForKey:@"game_capacity"]] ;
        
         
        CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.row];
        
        
        
        NSLog(@"%f",labelHeight);
        
        cell.descriptionTextLabel.frame = CGRectMake(cell.descriptionTextLabel.frame.origin.x,
                                                     cell.descriptionTextLabel.frame.origin.y,
                                                     cell.descriptionTextLabel.frame.size.width,
                                                     labelHeight);
        
     //   NSUInteger numberOfLines=labelHeight/21.0f;
        
        cell.descriptionTextLabel.text=[[gameInfo objectAtIndex:indexPath.row]valueForKey:@"game_details"];
        NSLog(@"%@",NSStringFromCGRect(cell.descriptionTextLabel.frame));
        
        return cell;
    }
    else
    {
        
        static NSString *CellIdentifier = @"customCell";
        
        
        gameTableViewCell *cell = (gameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        cell.gameNameTextLabel.text=[[gameInfo objectAtIndex:indexPath.row] valueForKey:@"game_name"];
        cell.indexPath=indexPath;
        cell.delegate=self;
        
        return cell;
        
        
    }
    
}



//This just a convenience function to get the height of the label based on the comment text
-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    CGSize maximumSize = CGSizeMake(COMMENT_LABEL_WIDTH, 10000);
    
    NSLog(@"%@",[[gameInfo objectAtIndex:index] valueForKey:@"game_details"]);
    
    CGSize labelHeighSize = [[[gameInfo objectAtIndex:index] valueForKey:@"game_details"] sizeWithFont: [UIFont fontWithName:@"Helvetica" size:13.0f]
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
        return [self getLabelHeightForIndex:indexPath.row] +120 ;
    }
    else
    {
        return 60;
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
        [self.gameSessionTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]
                                     atScrollPosition:UITableViewScrollPositionTop
                                             animated:YES];
    }
    else
        [self.gameSessionTableView scrollToRowAtIndexPath:indexPath
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
        [self.gameSessionTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex >= 0)
    {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [self.gameSessionTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    
    [self.gameSessionTableView scrollToRowAtIndexPath:indexPath
                                 atScrollPosition:UITableViewScrollPositionTop
                                         animated:YES];
    NSLog(@"%@",indexPath);
    [self.gameSessionTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}


-(void)sideMenuTapped:(id)sender
{
    
    slider = [[CustomSlider alloc]init];
    [slider showSliderMenu];
    slider.callout.delegate=self;
    
    
}

#pragma mark -RNFrostedSidebar delegate method.
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
            [slider showBreakOutSessionScreen];
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
            [slider showVideoScreen];
            [sidebar dismiss];
            
            
        }
            break;
        case 6 :
        {
            [slider showMapScreen];
            [sidebar dismiss];
            
        }
            break;
        case 7:
        {
            [slider showGameInfoSCreen];
            [sidebar dismiss];
            
            // Do any additional setup after loading the view, typically from a nib.
//            self.shareCircleView = [[CFShareCircleView alloc] init];
//            self.shareCircleView.delegate = self;
//            [self.shareCircleView show];
            
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
