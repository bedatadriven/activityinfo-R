## [4.38]
- New vignettes on grant-based roles, advanced user management (bulk actions), and advanced role use-cases (#122, #133)
- Improved metadata on getRecords() to include last time modified (#26, #39)
- Improved getDatabaseUsers() to include recent metadata fields (locked, userLicenseType, activitationStatus etc.) (#128, #130)
- Improved testthat snapshot functions and removing snapshots that depend on the server

## [4.37]
- Legacy roles are no longer supported from 4.37 onwards
- Potential breaking change: the maxDepth parameter in column styles is now set to two by default; parent and reference columns no longer expand indefinitely
- New functions for new role and permissions system (#114)
- Added ability to update sub-forms (#119)
- Addressed cyclic structures in reference columns and parent forms and added maxDepth parameter to column styles. (#132)

## [4.36.1]
- Fix for `importRecords()` when the form has a serial number (#124)

## [4.36]
- API tokens are now stored per root URL of the server. The token will need to be added again using activityInfoToken(token). The location of the token file has changed from "~/.activityinfo.credentials" to "~/.activityinfo.server.credentials" to avoid accidentally overwriting and losing the old tokens. (#101)
- Column name de-duplication in getRecords() (#118)
- Updated GitHub Action checks (#116)
- Snapshot tests allow new properties
- Allow custom IDs in addRecord (#111, #104)
- Billing account info functions (#97)
- API Token now stored per root URL (#101)
- Only add parent columns to query if there are fields defined on parentVarNames (#103)

## [4.35.1]
- Fix for `getQuantityTable()` (#115)

## [4.35]
- addForm() now respects folderId argument (#93)
- Add "bulk_delete", "manage_translations", and "reviewer_only" arguments to permissions (#91)
- createFormSchemaFromData() now returns formSchema object rather than list with formSchema and data
- updateRecord() fails if the record does not exist, rather than adding it (#43)
- Dependency on rjson removed

## [4.34]
- `dplyr` is loaded onto the search path when `activityinfo` is loaded
- documentation improvements

## [4.33]
- getRecords() added to represent remote records on the server with helper functions to set column name styles, e.g. prettyColumnStyle(), minimalColumnStyle()
- Support for tidy selection and renaming of columns of remote records
- Eager collection of remote records and conversion to data.frame when required for dplyr verbs. filter(), arrange(), slice_head, and slice_tail() can be used on remote records before downloading and converting to a data.frame.
- migrateFieldData() added to migrate data from a field to another using a user-supplied conversion function
- createFormSchemaFromData() added to automatically guess a form field schema from a data.frame
- extractSchemaFromFields() added to extract form fields into a new form schema using the selected columns of a remote records object (getRecords()), including those from reference form fields.
- Deprecation of importTable() in favour of importRecords().
- getDatabases(), getDatabaseUsers(), getRecordHistory() now returns a data.frame by default.

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
