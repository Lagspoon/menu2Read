//
//  menuMasterViewController.m
//  menu
//
//  Created by Olivier Delecueillerie on 04/10/13.
//  Copyright (c) 2013 Olivier Delecueillerie. All rights reserved.
//

#define DEFINE_entity1 @"CategoryDrink"
#define DEFINE_entity2 @"Drink"
#define DEFINE_entity3 @"Drink"

#define DEFINE_defaultViewControllerId @"menuWelcome"
#define DEFINE_drinkGlassViewControllerID @"MEPageProduct"
#define DEFINE_drinkBottleViewControllerID @"MEPageProduct"

#import "menuMasterViewController.h"
#import "SYCoreDataStackWithSyncStuff.h"
#import "SYSyncEngine.h"
#import "menuDetailPVC.h"



//Entity subclasses
#import "Drink.h"
#import "CategoryDrink.h"

//const Notification string
NSString * const kSDSyncEngineInitialCompleteKey1 = @"SDSyncEngineInitialSyncCompleted";
NSString * const kSDSyncEngineSyncCompletedNotificationName1 = @"SDSyncEngineSyncCompleted";

@interface menuMasterViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
//Generic Data property
@property (nonatomic, strong) SYCoreDataStackWithSyncStuff *dataController;
@property (nonatomic, strong) NSObject *idSelected;
@property (nonatomic, strong) NSString *entity;

//Generic Level Property
@property (nonatomic) NSUInteger choiceLevel; //level are 1, 2 or 3
@property (nonatomic, strong) NSMutableArray *dataForPages;


//Property used to give info from Level1 to Level2
@property (nonatomic, strong) CategoryDrink *categorySelected;

//Property used to give info from Level1 to Level2
@property (nonatomic, strong) NSArray *containingList;
@property (nonatomic, strong) NSString *containingSelected;


@end

@implementation menuMasterViewController

///////////////////////////////////////////////////////////////////////////
//Lazy instanciation @ Synthesize
///////////////////////////////////////////////////////////////////////////

- (SYCoreDataStackWithSyncStuff *) dataController {
    if (!_dataController) _dataController = [[SYCoreDataStackWithSyncStuff alloc]init];
    return _dataController;
}

- (NSString *) entity {
    if (!_entity) {
        switch (self.choiceLevel) {
            case 1:
                _entity = DEFINE_entity1;
                break;
            case 2:
                _entity = DEFINE_entity2;
                break;
            case 3:
                _entity = DEFINE_entity3;
                break;
            default:
                _entity = DEFINE_entity1;
                break;
        }
    }
    return _entity;
}

- (NSUInteger) choiceLevel {
    if (!_choiceLevel) _choiceLevel=1;
    return _choiceLevel;
}


- (NSMutableArray *) dataForPages {
    if (!_dataForPages) {
        // Get a reference to the DetailPVC.
        // DetailPVC is the delegate of our split view.
        menuDetailPVC *detailPVC = (menuDetailPVC*)self.splitViewController.delegate;
        _dataForPages = detailPVC.modelController.dataForPages;
    }
    return _dataForPages;
}
///////////////////////////////////////////////////////////////////////////
//LIFE CYCLE MANAGEMENT
///////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kSDSyncEngineInitialCompleteKey1 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kSDSyncEngineSyncCompletedNotificationName1 object:nil];

    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }

    switch (self.choiceLevel) {
        case 1:

            break;
        case 2:
        {
            NSMutableArray *mutableArrayOfContainingType = [[NSMutableArray alloc]init];
            NSString *previousContainingName = nil;
            for (Drink *drink in [self.fetchedResultsController fetchedObjects]) {
                if ([drink.containing isEqualToString:previousContainingName]) {
                    [mutableArrayOfContainingType addObject:drink.containing];
                }
                previousContainingName = drink.containing;
            }

            //with this kind of loop the first object is doubled and the last is not added, thus below we do the correction
            [mutableArrayOfContainingType addObject:previousContainingName];
            [mutableArrayOfContainingType removeObjectAtIndex:0];
            self.containingList = [NSArray arrayWithArray:mutableArrayOfContainingType];//this method is ok but not sorted[[self.fetchedResultsController fetchedObjects] valueForKeyPath:@"@distinctUnionOfObjects.containing"];

        }
        default:
            break;
    }

}

- (void)viewDidUnload
{
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}


///////////////////////////////////////////////////////////////////////////
//TABLE VIEW MANAGEMENT
///////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNb;
    switch (self.choiceLevel) {
        case 2:
            sectionNb =1;
            break;
        default:
            sectionNb = [[self.fetchedResultsController sections] count];
            break;
    }
    return sectionNb;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger sectionNb;
    switch (self.choiceLevel) {
        case 2:
            sectionNb = [[self containingList] count];
            break;
        default:
        {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
            sectionNb =[sectionInfo numberOfObjects];
            break;
        }
    }
            return sectionNb;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    self.idSelected = [self.fetchedResultsController objectAtIndexPath:indexPath];

    switch (self.choiceLevel) {

        case 1:
        {
            CategoryDrink *categoryDrink = (CategoryDrink *) self.idSelected;
            cell.textLabel.text = categoryDrink.label;
            cell.detailTextLabel.text=@"";
        }
            break;
        case 2:
        {
            cell.textLabel.text = [self.containingList objectAtIndex:[indexPath indexAtPosition:1]];
        }
            break;
        case 3:
        {
            Drink *drink = (Drink *) self.idSelected;
            cell.textLabel.text = drink.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ €",drink.price];
            //cell.imageCell.image = [UIImage imageWithData:drink.photo];
        }

            break;
        default:
            break;
    }
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle;
    switch (self.choiceLevel) {
        case 1:
            sectionTitle =[[[self.fetchedResultsController sections] objectAtIndex:section] name];
            break;
        case 2:
            sectionTitle = nil;
            break;
        case 3:
            //sectionTitle =[[[self.fetchedResultsController sections] objectAtIndex:section] name];

        default:
            sectionTitle=nil;
            break;
    }
    return sectionTitle;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.choiceLevel) {

        case 3:
        {
            NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            if ([object isKindOfClass:[Drink class]]) {
                Drink * drink = (Drink*) object;

                //Choose the good viewControllerId between glass, bottle, etc.
                NSString *viewControllerId;
                if ([drink.containing isEqualToString:@"Glass"]) {
                    viewControllerId = DEFINE_drinkGlassViewControllerID;
                } else viewControllerId = DEFINE_drinkBottleViewControllerID;

                //Add the selected drink to the PVC
                menuDetailPVC *detailPVC = (menuDetailPVC*)self.splitViewController.delegate;

                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:drink,@"object", viewControllerId,@"viewControllerId",nil];

                detailPVC.modelController.dataForPages = (NSMutableArray *)@[dictionary];


            [detailPVC.pageViewController setViewControllers:@[[detailPVC.modelController viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
                NULL;
            }];

        }
        }
            break;
            
        default:
            break;
    }

}

///////////////////////////////////////////////////////////////////////////
//DATA MANAGEMENT
///////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entity inManagedObjectContext:self.dataController.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    NSString *sectionName;
    NSArray *sortDescriptors;
    NSPredicate *predicate;

    switch (self.choiceLevel) {
        case 1:
        {
            // Edit the sort key as appropriate
            NSSortDescriptor *labelDescriptor = [[NSSortDescriptor alloc] initWithKey: @"label" ascending:YES];
            sortDescriptors= @[labelDescriptor];
            sectionName=nil;
        }
            break;
         case 2:
        {
            predicate = [NSPredicate predicateWithFormat:@"(type = %@)",self.categorySelected.label];
            NSSortDescriptor *containingDescriptor = [[NSSortDescriptor alloc] initWithKey: @"volume" ascending:YES];
            sortDescriptors= @[containingDescriptor];
            sectionName=nil;
        }
            break;


        case 3:
        {
            predicate = [NSPredicate predicateWithFormat:@"(containing = %@) AND (type = %@)",self.containingSelected,self.categorySelected.label];

            NSSortDescriptor *priceDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
            NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            sortDescriptors = @[priceDescriptor,nameDescriptor];

            sectionName =@"name";
        }

        default:
            break;
    }

    fetchRequest.predicate = predicate;
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSFetchedResultsController *FRC = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dataController.managedObjectContext sectionNameKeyPath:sectionName cacheName:nil];
    FRC.delegate = self;

    self.fetchedResultsController = FRC;
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    //abort();
	}
    return _fetchedResultsController;
}


//////////////////////////////////////////////////////////////////
//SEGUE MANAGEMENT
//////////////////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            menuMasterViewController * nextLevel = (menuMasterViewController*)segue.destinationViewController;

            //this selector perform before the "tableview didselect ... "
            switch (self.choiceLevel) {
            case 1:
                self.categorySelected =[[self fetchedResultsController] objectAtIndexPath:indexPath];
                break;
            case 2:
                {
                UITableViewCell *cell =(UITableViewCell *)sender;
                self.containingSelected= cell.textLabel.text;
                }
            default:
                break;

            }
            nextLevel.categorySelected=self.categorySelected;
            nextLevel.containingSelected = self.containingSelected;
            nextLevel.choiceLevel = (self.choiceLevel + 1);
            nextLevel.dataForPages = self.dataForPages;
        }
    }

}

//////////////////////////////////////////////////////////////////
//SYNC MANAGEMENT
//////////////////////////////////////////////////////////////////

- (IBAction)refresh
{
    // show the spinner if it's not already showing
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    [self.refreshControl beginRefreshing];
    dispatch_queue_t q = dispatch_queue_create("table view loading queue", NULL); dispatch_async(q, ^{
        //do something to get new data for this table view (which presumably takes time)
        [[SYSyncEngine sharedEngine] startSync];

        dispatch_async(dispatch_get_main_queue(), ^{
        //update the table view's Model to the new data, reloadData if necessary


            NSError *error = nil;
            if (![self.fetchedResultsController performFetch:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                //abort();
            }

            [self.tableView reloadData];
            // and let the user know the refresh is over (stop spinner)
            [self.refreshControl endRefreshing];
        });
    });
}


@end


