
# Changelog

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