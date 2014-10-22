\name{updateUserPermission}
\alias{updateUserPermission}
\title{Updates a user's permission to access a database. If the user identified by the
given email address does not yet have an ActivityInfo account, they will receive
an email inviting them to create a new account and choose a password.}
\usage{
updateUserPermission(databaseId, userEmail, userName, partner,
  allowView = TRUE, allowViewAll = FALSE, allowEdit = FALSE,
  allowEditAll = FALSE, allowDesign = FALSE, allowManageUsers = FALSE,
  allowManageAllUsers = FALSE)
}
\arguments{
  \item{databaseId}{the id of the database}

  \item{userEmail}{the user's email address}

  \item{userName}{the user's full name. Only used if there
  is not yet a user with the given email address}

  \item{partner}{the id or name of the partner to which the
  user will be added.}

  \item{allowView}{if TRUE, the user can view sites
  belonging to their partner}

  \item{allowViewAll}{if TRUE, the user can view sites
  belonging to all partners}

  \item{allowEdit}{if TRUE, the user can create and edit
  sites belonging to their partner}

  \item{allowEditAll}{if TRUE, the user can create and edit
  sites belonging to all partners}

  \item{allowDesign}{if TRUE, the user can create and
  modify the structure of the database}

  \item{allowManageUsers}{if TRUE, the user can change the
  permission of users for the database within their own
  partner}

  \item{allowManageUsers}{if TRUE, the user can change the
  permission of all users within the database}
}
\description{
Updates a user's permission to access a database. If the
user identified by the given email address does not yet
have an ActivityInfo account, they will receive an email
inviting them to create a new account and choose a
password.
}

