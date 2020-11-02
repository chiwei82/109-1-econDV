.ghToken="cef19342f50cc7fc4cc56e685f1543d99f88d70b"
install.packages("devtools")
install.packages("remotes")
remotes::install_github(
  "tpemartin/econDV",
  auth_token = .ghToken
)
