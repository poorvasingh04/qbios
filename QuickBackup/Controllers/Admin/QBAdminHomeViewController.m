//
//  QBAdminHomeViewController.m
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBAdminHomeViewController.h"
#import "QBContactCell.h"
#import "QBUserCell.h"

#define USERS_TABLEVIEW_TAG 1001
#define CONTACTS_TABLEVIEW_TAG 1002
#define CONNECTION_TAG_FETCH_RELATED_CONTACTS 1002
#define CONNECTION_TAG_DELETE_ALL 1003
#define CONNECTION_TAG_DELETE_CONTACTS 1004
#define CONNECTION_TAG_LOGOUT 1005

@interface QBAdminHomeViewController ()<UITableViewDataSource, UITableViewDelegate, QBConnectionDelegate> {
    NSArray *_contactsArray;
    NSArray *_displayedUsersArray;
    IBOutlet NSLayoutConstraint *_usersTableHeightCN;
    QBAppUser *_currentSelectedUser;
    QBAppUser *_prevSelectedUser;
    QBContact *_selectedContact;

}

@end

@implementation QBAdminHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _usersTableView.tag = USERS_TABLEVIEW_TAG;
    _contactsTableView.tag = CONTACTS_TABLEVIEW_TAG;
    
    [_usersTableView registerNib:[UINib nibWithNibName:NSStringFromClass([QBUserCell class]) bundle:nil] forCellReuseIdentifier:[QBUserCell reuseIdentifier]];
    [_contactsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([QBContactCell class]) bundle:nil] forCellReuseIdentifier:[QBContactCell reuseIdentifier]];
    [_contactsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([QBUserCell class]) bundle:nil] forCellReuseIdentifier:[QBUserCell reuseIdentifier]];

    _contactNameLabel.text = @"Please select a user.";
    self.title = [NSString stringWithFormat:@"Welcome %@!", [QBAppContext sharedInstance].currentUser.firstName];
    _deleteAllButton.hidden = YES;
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.tag == USERS_TABLEVIEW_TAG ? _displayedUsersArray.count + 1 : (_contactsArray.count > 0 ? _contactsArray.count : 1);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (tableView.tag == USERS_TABLEVIEW_TAG) {
        if (indexPath.row == 0) {
            QBUserCell *tempcell = [tableView dequeueReusableCellWithIdentifier:[QBUserCell reuseIdentifier]];
            tempcell.nameLabel.text = !_displayedUsersArray ? @"Select User" : @"Show Details";
            tempcell.tickImageView.image = nil;
            cell = tempcell;
        } else {
            QBUserCell *tempcell = [tableView dequeueReusableCellWithIdentifier:[QBUserCell reuseIdentifier]];
            tempcell.user = _displayedUsersArray[indexPath.row-1];
            cell = tempcell;
        }
        
    } else {
        if (_contactsArray.count > 0) {
            QBContactCell *tempcell = [tableView dequeueReusableCellWithIdentifier:[QBContactCell reuseIdentifier]];
            tempcell.contact = _contactsArray[indexPath.row];
            cell = tempcell;
        } else {
            QBUserCell *tempcell = [tableView dequeueReusableCellWithIdentifier:[QBUserCell reuseIdentifier]];
            tempcell.nameLabel.text = @"No Data Found.";
            cell = tempcell;
        }
       
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView.tag == USERS_TABLEVIEW_TAG ? 44.0 : (_contactsArray.count > 0 ? [QBContactCell heightForContact:_contactsArray[indexPath.row]] : 44.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == USERS_TABLEVIEW_TAG) {
        if (indexPath.row == 0) {
            if (_currentSelectedUser && _displayedUsersArray && (!_prevSelectedUser || ![_prevSelectedUser.userId isEqualToString:_currentSelectedUser.userId])) {
                _contactNameLabel.text = [NSString stringWithFormat:@"%@ %@", _currentSelectedUser.firstName, _currentSelectedUser.lastName];
                [self fetchDetailsForUser:_currentSelectedUser];
            }
            _displayedUsersArray = _displayedUsersArray ? nil : _usersArray;
            _usersTableHeightCN.constant = _displayedUsersArray.count * 44.0 + 44.0;
            [_usersTableView reloadData];
            
        } else {
            QBAppUser *user = _usersArray[indexPath.row-1];
            user.isSelected = YES;
            NSMutableArray *reloadIndexes = [NSMutableArray arrayWithObject:indexPath];
            if (_currentSelectedUser && ![user.userId isEqualToString:_currentSelectedUser.userId]) {
                _currentSelectedUser.isSelected = NO;
                [reloadIndexes addObject:[NSIndexPath indexPathForRow:[_displayedUsersArray indexOfObject:_currentSelectedUser] + 1 inSection:0]];
            }
            _currentSelectedUser = user;
            [_usersTableView reloadRowsAtIndexPaths:reloadIndexes withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } 

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _contactsArray.count > 0 ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete && _contactsArray.count > 0)
    {
        _selectedContact = _contactsArray[indexPath.row];
        [self deleteUserContact:_selectedContact];
    }
}

- (void)fetchDetailsForUser:(QBAppUser*)user {
    self.showActivityIndicator = YES;
    QBConnection *connection = [[QBConnection alloc] init];
    connection.delegate = self;
    connection.procedureName = @"fetchAllContacts";
    connection.connectionTag = CONNECTION_TAG_FETCH_RELATED_CONTACTS;
    connection.parameters = @{@"token":[QBAppContext sharedInstance].currentUser.token, @"user": user.userId};
    [connection connect];
}

#pragma mark QBConnectionDelegate methods
- (void)connection:(NSInteger)connectionTag successfulWithResponse:(NSDictionary *)response {

    if (connectionTag == CONNECTION_TAG_FETCH_RELATED_CONTACTS) {
        _prevSelectedUser = _currentSelectedUser;
        NSMutableArray *contacts = [NSMutableArray array];
        for (NSDictionary *dict in response[@"contacts"]) {
            [contacts addObject:[[QBContact alloc] initWithDictionary:dict]];

        }
        
        _contactsArray = contacts;
        [_contactsTableView reloadData];
        
        _deleteAllButton.hidden = _contactsArray.count > 0 ? NO : YES;
        self.showActivityIndicator = NO;

    } else if (connectionTag == CONNECTION_TAG_DELETE_ALL) {
        NSMutableArray *usersArray = [NSMutableArray arrayWithArray:_usersArray];
        [usersArray removeObject:_prevSelectedUser];
        _usersArray = usersArray;
        [_usersTableView reloadData];
        
        _prevSelectedUser = nil;
        _contactNameLabel.text = @"Please select a user.";
        _contactsArray = nil;
        [_contactsTableView reloadData];
        self.showActivityIndicator = NO;

        _deleteAllButton.hidden = YES;
    } else if (connectionTag == CONNECTION_TAG_DELETE_CONTACTS) {
        NSMutableArray *contacts = [NSMutableArray arrayWithArray:_contactsArray];
        [contacts removeObject:_selectedContact];
        _contactsArray = contacts;
        [_contactsTableView reloadData];
        
        _selectedContact = nil;
        _deleteAllButton.hidden = _contactsArray.count > 0 ? NO : YES;
        self.showActivityIndicator = NO;

    } else if (connectionTag == CONNECTION_TAG_LOGOUT) {
        //Logout
        self.showActivityIndicator = NO;
        [[QBAppContext sharedInstance] userDidLogout];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        
    }
}

- (void)connection:(NSInteger)connectionTag failedWithResponse:(NSString *)error {
    self.showActivityIndicator = NO;
    [self showOKAlertWithMessage:error];
    
}

#pragma mark - IBActions
- (IBAction)refreshDataAction:(id)sender {
    [self fetchDetailsForUser:_prevSelectedUser];
}

- (IBAction)deleteAllAction:(id)sender {
    self.showActivityIndicator = YES;
    QBConnection *connection = [[QBConnection alloc] init];
    connection.delegate = self;
    connection.procedureName = @"deleteContactsForUser";
    connection.connectionTag = CONNECTION_TAG_DELETE_ALL;
    connection.parameters = @{@"token":[QBAppContext sharedInstance].currentUser.token, @"userId": _prevSelectedUser.userId};
    [connection connect];
}

- (void)deleteUserContact:(QBContact*)contact {
    self.showActivityIndicator = YES;

    QBConnection *connection = [[QBConnection alloc] init];
    connection.delegate = self;
    connection.procedureName = @"deleteContacts";
    connection.connectionTag = CONNECTION_TAG_DELETE_CONTACTS;
    connection.parameters = @{@"token":[QBAppContext sharedInstance].currentUser.token, @"userId": _prevSelectedUser.userId, @"contactId" : _selectedContact.contactId};
    [connection connect];
}

- (IBAction)logoutButtonAction:(id)sender {
    QBConnection *connection = [[QBConnection alloc] init];
    connection.delegate = self;
    connection.procedureName = @"logout";
    connection.connectionTag = CONNECTION_TAG_LOGOUT;
    connection.parameters = @{@"token":[QBAppContext sharedInstance].currentUser.token};
    [connection connect];
    
}

@end
