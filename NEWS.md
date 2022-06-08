
## [4.3] - 2020-02-04

- Replace getDatabaseRecordTable() with getQuantityTable(databaseId, folderId)

## [4.2] - 2020-01-23

### Fixed
- queryTable() will fail with error for empty boolean columns

## [4.5] - 2020-03-02

### Added
- Add getDatabaseUsers(), addDatabaseUser(), and deleteDatabaseUser() for managing users


## [4.6]

### Fixed
- queryTable() fails in some cases with missing values

## [4.7]

### Fixed
- updated getQuantityTable() to match updated Export Jobs API
- fixed deleteDatabaseUser()

## [4.8]

### Added

- Add getDatabaseUser(), updateUserRole()


## [4.9]

### Fixed

- Ensure `queryTable()` functions correctly if column names include spaces


## [4.10]

### Added

- Add updateRole(), which allows updating the definition of a role within a database.

## [4.11]

### Added

- Add getDatabases(), which list all databases the user owns or has been shared with.


## [4.12]

### Fixed

- addDatabaseUser() should respect roleResources argument

## [4.13]

### Added
- addForm() to add a new form to an existing database
- Started tools for importing large datasets. Not yet 

### Fixed
- Updated cuid() to include a random component.

## [4.14]

### Added
- includeBlanks parameter for getQuantityTable()

## [4.15]

### Fixed
- cuid() fails with error

## [4.16]

### Added 
- Add 'referencedFormId' to data frame version of getFormSchema()

## [4.17]

### Added
- Add `queryReportResults()` function to get a pivot table as a data frame. (#12)

### Fixed
- If there is no credentials file, authentication is now anonymous instead of failing unexpectedly. (#3)
- `getResource()` (internal) now correctly encodes query parameters. (#10)
- Updating records no longer has the `verbose` option enabled to remove excessive logging. (#11)

## [4.18]

### Fixed
- Incorrect empty return values when performing POST and PUT requests. (#14)

## [4.19]

### Added
- Formula column in as.data.frame.formSchema for calculated fields


## [4.20]

### Added
- New funtion `queryAuditLog()` which returns events from a database audit log in the form of a data frame. (#16)
- The result of `as.data.frame.formSchema()` now includes a `key` column to indicate if the key property is enabled on a field. (#17)

### Fixed
- S3 method name consistency (#15)

## [4.21]
- Fixed regression in postResource() affecting updateRecords()
- Fixed regression caused by addition of dataEntryVisible and tableVisible properties to form schema (#20)

## [4.22]
- Improved display of error messages from the API
- Added updateGrant() and permissions() functions

## [4.23]
- Added getRecord() to fetch an individual record
- Added getAttachment() to fetch an attached file

## [4.24]
- Added relocateForm() to move a form from one database to another
- Added submitPending() to submit rescued offline records to the server

