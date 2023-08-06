#!/usr/bin/env fish

set -l JIRA_TO_LOG_AGAINST "RECO-576"

# Defining the working week days
set -l working_week "Monday" "Tuesday" "Wednesday" "Thursday" "Friday"

# Parse the options
argparse 'd/dry-run' 'o/offset=' -- $argv

set -l week_offset $_flag_offset
set -l dry_run $_flag_dry_run

# Set default week_offset if not set
if test -z "$week_offset"
    set week_offset 0
end

echo "Select holidays from the list (use space to select, enter to confirm, esc to skip):"
set -l selected_holidays (gum choose --item.foreground 250 --no-limit $working_week)

# Removing holidays from the working week
set -l working_days
for day in $working_week
    if not contains -- $day $selected_holidays
        set working_days $working_days $day
    end
end

# Printing the selected holidays and working days
echo "Selected Holidays: " $selected_holidays
echo "Working Days: " $working_days

# Iterate over the selected holidays and perform some action
for holiday in $selected_holidays
    set -l holiday "$holiday $week_offset week"
    set -l timesheetDate (date -d "$holiday" +"%Y-%m-%d")
    echo "Processing holiday: $holiday ($timesheetDate)"
    if test -z "$dry_run"
        tempo l ADMIN-12 8h $timesheetDate
    end
end

# Iterate over the working days and perform some action
for day in $working_days
    set -l day "$day $week_offset week"
    set -l timesheetDate (date -d "$day" +"%Y-%m-%d")
    echo "Processing day: $day ($timesheetDate)"
    if test -z "$dry_run"
        tempo l $JIRA_TO_LOG_AGAINST 8h $timesheetDate
    end
end
