# Automate tempo sheets so gui doesn't have to be annoyed at me on mondays

This is how I do my timesheets

![timesheets](tmshts.gif)

## Notes/Caveats

- This script is brittle and hacky - but see relevant XKCD comic on [automation](https://xkcd.com/1319/) - as why I don't want to spend too much time on it
- This script assumes you do your timesheets on friday of the week you are submitting your timesheets or you do your timesheets on monday the week after (if gui msgs you for example), if you do your timesheets everyday this script isn't for you
- All time is logged against one Jira entry (defined with JIRA_TO_LOG_AGAINST at the top of tmsht.sh)
- You spent 100% at shell (8 hours all day all week)
- leave is submitted to admin-12
- this script relies on the following utilities to be available in your path
  - [gum](https://github.com/charmbracelet/gum)
  - [tempo](https://github.com/szymonkozak/tempomat)
