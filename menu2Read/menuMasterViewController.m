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

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kSDSyncEngineInitialCompleteKey1 object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kSDSyncEngineSyncCompletedNotificationName1 object:nil];

    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (void) viewWillAppear:(BOOL)animated {
    if (self.choiceLevel == 1) {
        self.categorySelected = nil;
    }
    menuDetailPVC *detailPVC = (menuDetailPVC*)self.splitViewController.delegate;
    detailPVC.modelController.dataForPages = [self createDataForPages];

    if ([detailPVC.modelController.dataForPages count] > 0) {
        detailPVC.modelController.index = 0;
        [detailPVC.pageViewController setViewControllers:@[[detailPVC.modelController viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished) {
            NULL;
        }];
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
            Drink *drink = (Drink *) self.idSelected;
            cell.textLabel.text = drink.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ €",drink.price];
        }

            break;
        default:
            break;
    }
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle;
    switch (self.choiceLevel) {

        case 2:
        {
            NSArray *objectsOfTheSection = [NSArray arrayWithArray:[[[self.fetchedResultsController sections] objectAtIndex:section] objects]];
            sectionTitle = [[objectsOfTheSection firstObject] valueForKey:@"containing"];
        }
            break;

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

        case 2:
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
                if ([detailPVC.modelController.dataForPages containsObject:dictionary])
                    [detailPVC.modelController.dataForPages removeObject:dictionary];
                [detailPVC.modelController.dataForPages insertObject:dictionary atIndex:0];


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
    [fetchRequest setFetchBatchSize:0];

    NSString *sectionName;
    NSArray *sortDescriptors;
    NSPredicate *predicate;

    switch (self.choiceLevel) {
        case 1:
        {
            // Edit the sort key as appropriate
            NSSortDescriptor *labelDescriptor = [[NSSortDescriptor alloc] initWithKey: @"rank" ascending:YES];
            sortDescriptors= @[labelDescriptor];
            sectionName=nil;
        }
            break;
         case 2:
        {
            predicate = [NSPredicate predicateWithFormat:@"(category = %@)",self.categorySelected.label];
            NSSortDescriptor *volumeDescriptor = [[NSSortDescriptor alloc] initWithKey: @"volume" ascending:YES];
            NSSortDescriptor *priceDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
            NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];

            sortDescriptors= @[volumeDescriptor, priceDescriptor, nameDescriptor];
            sectionName=@"volume";
        }
            break;

        default:
            break;
    }

    fetchRequest.predicate = predicate;
    [fetchRequest setSortDescriptors:sortDescriptors];

    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dataController.managedObjectContext sectionNameKeyPath:sectionName cacheName:nil];

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    return _fetchedResultsController;
}




- (NSMutableArray *) createDataForPages {
    NSMutableArray * dataForPages = [[NSMutableArray alloc]init];
    NSError *error;
    NSArray * arrayOfCategory;

    if (self.categorySelected) {
        arrayOfCategory = [NSArray arrayWithObject:self.categorySelected];
    } else {

        //Get the category in rank
        NSFetchRequest *fetchRequestForCategory = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityForCategory = [NSEntityDescription entityForName:DEFINE_entity1 inManagedObjectContext:self.dataController.managedObjectContext];
        [fetchRequestForCategory setEntity:entityForCategory];
        NSSortDescriptor *rankDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
        [fetchRequestForCategory setSortDescriptors:@[rankDescriptor]];
        NSFetchedResultsController *fetchedResultsControllerForCategory = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequestForCategory managedObjectContext:self.dataController.managedObjectContext sectionNameKeyPath:nil cacheName:nil];

        if (![fetchedResultsControllerForCategory performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }

        arrayOfCategory = [fetchedResultsControllerForCategory fetchedObjects];
    }


    NSFetchRequest *fetchRequestForDrinks = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityForDrinks = [NSEntityDescription entityForName:DEFINE_entity2 inManagedObjectContext:self.dataController.managedObjectContext];
    [fetchRequestForDrinks setEntity:entityForDrinks];

    //for each category we select the drinks and add it to the mutable array
    for (id object in arrayOfCategory){
        CategoryDrink *categoryDrink;
        if ([object isKindOfClass:[CategoryDrink class]]) {
            categoryDrink = (CategoryDrink *)object;
        } else categoryDrink = nil;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(category = %@)",categoryDrink.label];
        NSSortDescriptor *volumeDescriptor = [[NSSortDescriptor alloc] initWithKey: @"volume" ascending:YES];
        NSSortDescriptor *priceDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
        NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [fetchRequestForDrinks setSortDescriptors:@[volumeDescriptor, priceDescriptor, nameDescriptor]];
        [fetchRequestForDrinks setPredicate:predicate];

        NSFetchedResultsController *fetchedResultsControllerForDrinks = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequestForDrinks managedObjectContext:self.dataController.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        if (![fetchedResultsControllerForDrinks performFetch:&error])
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

        for (Drink *drink in [fetchedResultsControllerForDrinks fetchedObjects]) {
            NSDictionary *dictionary = @{@"object": drink, @"viewControllerId":DEFINE_drinkBottleViewControllerID};
            [dataForPages addObject:dictionary];
        }
    }

    return dataForPages;
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


