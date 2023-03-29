## [4.33]
- getRecords() added to represent remote records on the server with helper functions to set column name styles, e.g. prettyColumnStyle(), minimalColumnStyle()
- Eager fetching of remote records and conversion to data.frame when required for dplyr verbs. filter(), arrange(), slice_head, and slice_tail() can be used on remote records before downloading and converting to a data.frame.
- Support for all dplyr verbs and tidy selection of columns of remote records, including 
- migrateFieldData() added to migrate data from a field to another and supply a conversion function
- createFormSchemaFromData() added to automatically guess a form field schema from a data.frame
- copySchema() added to copy a schema from a remote records object (getRecords()) based on selected columns, including those from reference tables.
- Deprecation of importTable() in favour of importRecords()
- getDatabases() always returns a data.frame

## [4.32]
- Helper functions to create ActivityInfo form and field schemas (#32)
- Improve documentation and examples in package website (#35)
- getDatabaseResources() to get database resources as a table (#61)
- addField(), deleteField() (#62)
- FIXED: importTable() cannot handle updates to fields of type "user" (#50)
- FIXED: Support narrative (multi-line) text fields in importTable() #63

## [4.31]
- Fixed error in messaging stack (#52)
- Improved messaging in queryAuditLog() (#41)

## [4.30]
- Adding testing suite (#21)
- Enhancing messaging of all functions and the handling of errors and warnings (#30, #28)
- Deprecation of the user/password authentication and addition of personal token based authentication (#22)
- Fixing Rmarkdown chunks (#29)
- Overall improvement in code quality and consistency

## [4.29]
- Fix for roleAssignment() function

## [4.28]
- Improvements to importTable() function

## [4.27]
- Added recoverRecord() to recover deleted records

## [4.26]
- Fix for queryAuditLog() when collection links are involved
- Fix for converting a sub form schema into a data.frame (#25)

## [4.25]
- Fixed and improved queryAuditLog()

## [4.24]
- Added relocateForm() to move a form from one database to another
- Added submitPending() to submit rescued offline records to the server

## [4.23]
- Added getRecord() to fetch an individual record
- Added getAttachment() to fetch an attached file

## [4.22]
- Improved display of error messages from the API
- Added updateGrant() and permissions() functions

## [4.21]
- Fixed regression in postResource() affecting updateRecords()
- Fixed regression caused by addition of dataEntryVisible and tableVisible properties to form schema (#20)

## [4.20]

### Added
- New funtion `queryAuditLog()` which returns events from a database audit log in the form of a data frame. (#16)
- The result of `as.data.frame.formSchema()` now includes a `key` column to indicate if the key property is enabled on a field. (#17)

### Fixed
- S3 method name consistency (#15)

## [4.19]

### Added
- Formula column in as.data.frame.formSchema for calculated fields

## [4.18]

### Fixed
- Incorrect empty return values when performing POST and PUT requests. (#14)

## [4.17]

### Added
- Add `queryReportResults()` function to get a pivot table as a data frame. (#12)

### Fixed
- If there is no credentials file, authentication is now anonymous instead of failing unexpectedly. (#3)
- `getResource()` (internal) now correctly encodes query parameters. (#10)
- Updating records no longer has the `verbose` option enabled to remove excessive logging. (#11)

## [4.16]

### Added 
- Add 'referencedFormId' to data frame version of getFormSchema()

## [4.15]

### Fixed
- cuid() fails with error

## [4.14]

### Added
- includeBlanks parameter for getQuantityTable()

## [4.13]

### Added
- addForm() to add a new form to an existing database
- Started tools for importing large datasets. Not yet 

### Fixed
- Updated cuid() to include a random component.

## [4.12]

### Fixed

- addDatabaseUser() should respect roleResources argument

## [4.11]

### Added

- Add getDatabases(), which list all databases the user owns or has been shared with.

## [4.10]

### Added

- Add updateRole(), which allows updating the definition of a role within a database.

## [4.9]

### Fixed

- Ensure `queryTable()` functions correctly if column names include spaces

## [4.8]

### Added

- Add getDatabaseUser(), updateUserRole()

## [4.7]

### Fixed
- updated getQuantityTable() to match updated Export Jobs API
- fixed deleteDatabaseUser()

## [4.6]

### Fixed
- queryTable() fails in some cases with missing values

## [4.5] - 2020-03-02

### Added
- Add getDatabaseUsers(), addDatabaseUser(), and deleteDatabaseUser() for managing users

## [4.3] - 2020-02-04

- Replace getDatabaseRecordTable() with getQuantityTable(databaseId, folderId)

## [4.2] - 2020-01-23

### Fixed
- queryTable() will fail with error for empty boolean columns
