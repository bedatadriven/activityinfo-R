
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

## Added

- Add updateRole(), which allows updating the definition of a role within a database.

## [4.11]

## Added

- Add getDatabases(), which list all databases the user owns or has been shared with.


## [4.12]

## Fixed

- addDatabaseUser() should respect roleResources argument