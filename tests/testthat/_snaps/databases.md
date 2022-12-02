# getDatabases() works

    list(list(databaseId = "<id value>", label = "My first database", 
        description = "", ownerId = "<id value>", billingAccountId = "<id value>", 
        suspended = FALSE, publishedTemplate = FALSE), list(databaseId = "<id value>", 
        label = "My second database", description = "", ownerId = "<id value>", 
        billingAccountId = "<id value>", suspended = FALSE, publishedTemplate = FALSE))

# getDatabaseTree() works

    structure(list(databaseId = "<id value>", userId = "<id value>", 
        version = "3", label = "My first database", description = "", 
        ownerRef = list(id = "<id value>", name = "Bob", email = "<id value>"), 
        billingAccountId = "<id value>", language = "", originalLanguage = "", 
        continuousTranslation = FALSE, translationFromDbMemory = FALSE, 
        thirdPartyTranslation = FALSE, languages = list(), role = list(
            id = "<id value>", parameters = list(), resources = list()), 
        suspended = FALSE, storage = "", publishedTemplate = FALSE, 
        resources = list("Empty resources until we can ensure a sort order in the API."), 
        grants = list(), locks = list(), roles = list(list(id = "<id value>", 
            label = "Data Entry", permissions = list(list(operation = "VIEW", 
                filter = NULL, securityCategories = list()), list(
                operation = "EDIT_RECORD", filter = NULL, securityCategories = list()), 
                list(operation = "ADD_RECORD", filter = NULL, securityCategories = list()), 
                list(operation = "DELETE_RECORD", filter = NULL, 
                    securityCategories = list()), list(operation = "EXPORT_RECORDS", 
                    filter = NULL, securityCategories = list())), 
            parameters = list(), filters = list(), grants = list(), 
            version = 0, grantBased = FALSE), list(id = "<id value>", 
            label = "Read only", permissions = list(list(operation = "VIEW", 
                filter = NULL, securityCategories = list())), parameters = list(), 
            filters = list(), grants = list(), version = 0, grantBased = FALSE), 
            list(id = "<id value>", label = "Administrator", permissions = list(
                list(operation = "VIEW", filter = NULL, securityCategories = list()), 
                list(operation = "ADD_RECORD", filter = NULL, securityCategories = list()), 
                list(operation = "EDIT_RECORD", filter = NULL, securityCategories = "reviewer"), 
                list(operation = "MANAGE_REFERENCE_DATA", filter = NULL, 
                    securityCategories = list()), list(operation = "DELETE_RECORD", 
                    filter = NULL, securityCategories = list()), 
                list(operation = "BULK_DELETE", filter = NULL, securityCategories = list()), 
                list(operation = "EXPORT_RECORDS", filter = NULL, 
                    securityCategories = list()), list(operation = "MANAGE_USERS", 
                    filter = NULL, securityCategories = list()), 
                list(operation = "LOCK_RECORDS", filter = NULL, securityCategories = list()), 
                list(operation = "ADD_RESOURCE", filter = NULL, securityCategories = list()), 
                list(operation = "EDIT_RESOURCE", filter = NULL, 
                    securityCategories = list()), list(operation = "DELETE_RESOURCE", 
                    filter = NULL, securityCategories = list()), 
                list(operation = "MANAGE_COLLECTION_LINKS", filter = NULL, 
                    securityCategories = list()), list(operation = "AUDIT", 
                    filter = NULL, securityCategories = list()), 
                list(operation = "SHARE_REPORTS", filter = NULL, 
                    securityCategories = list()), list(operation = "PUBLISH_REPORTS", 
                    filter = NULL, securityCategories = list()), 
                list(operation = "MANAGE_ROLES", filter = NULL, securityCategories = list()), 
                list(operation = "MANAGE_TRANSLATIONS", filter = NULL, 
                    securityCategories = list())), parameters = list(), 
                filters = list(), grants = list(), version = 0, grantBased = FALSE)), 
        securityCategories = list(list(id = "<id value>", label = "Reviewer only"))), class = "databaseTree")

# addDatabaseUser() and deleteDatabaseUser() and getDatabaseUsers() and getDatabaseUser() and getDatabaseUser2() work

    list(list(added = TRUE, user = list(databaseId = "<id value>", 
        userId = "<id value>", version = 1, email = "<id value>", 
        name = "Test database user", inviteTime = "<date or time value>", 
        activationStatus = "PENDING", deliveryStatus = "UNKNOWN", 
        lastLoginTime = "<date or time value>", role = list(id = "<id value>", 
            parameters = list(), resources = "Empty resources until we can ensure a sort order in the API."), 
        grants = list())), list(added = TRUE, user = list(databaseId = "<id value>", 
        userId = "<id value>", version = 1, email = "<id value>", 
        name = "Test database user", inviteTime = "<date or time value>", 
        activationStatus = "PENDING", deliveryStatus = "UNKNOWN", 
        lastLoginTime = "<date or time value>", role = list(id = "<id value>", 
            parameters = list(), resources = "Empty resources until we can ensure a sort order in the API."), 
        grants = list())))

---

    list(list(databaseId = "<id value>", userId = "<id value>", name = "Test database user", 
        email = "<id value>", role = list(id = "<id value>", parameters = list(), 
            resources = "Empty resources until we can ensure a sort order in the API."), 
        version = 1, inviteDate = "<date or time value>", deliveryStatus = "UNKNOWN", 
        inviteAccepted = FALSE), list(databaseId = "<id value>", 
        userId = "<id value>", name = "Test database user", email = "<id value>", 
        role = list(id = "<id value>", parameters = list(), resources = "Empty resources until we can ensure a sort order in the API."), 
        version = 1, inviteDate = "<date or time value>", deliveryStatus = "UNKNOWN", 
        inviteAccepted = FALSE))

