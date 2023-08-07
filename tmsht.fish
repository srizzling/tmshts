#!/usr/bin/env fish

set -l JIRA_TO_LOG_AGAINST "RECO-576"
set -l working_week "Monday" "Tuesday" "Wednesday" "Thursday" "Friday"

# Parse the options
argparse 'd/dry-run' 'o/offset=' 'n/non-interactive' 'h/holidays=' -- $argv

set -l week_offset $_flag_offset
set -l dry_run $_flag_dry_run

# Set default week_offset if not set
if test -z "$week_offset"
    set week_offset 0
end

# Decide how to get the selected holidays
if test -n "$_flag_non_interactive"
    if test -n "$_flag_holidays"
        set selected_holidays (string split ',' $_flag_holidays)
    else
        set selected_holidays
    end
else
    echo "Select holidays from the list (use space to select, enter to confirm, esc to skip):"
    set selected_holidays (gum choose --item.foreground 250 --no-limit $working_week)
end

set -l working_days
for day in $working_week
    if not contains -- $day $selected_holidays
        set working_days $working_days $day
    end
end

echo "Selected Holidays: " $selected_holidays
echo "Working Days: " $working_days

for holiday in $selected_holidays
    set -l holiday "$holiday $week_offset week"
    set -l timesheetDate (date -d "$holiday" +"%Y-%m-%d")
    echo "Processing holiday: $holiday ($timesheetDate)"
    if test -z "$dry_run"
        tempo l ADMIN-12 8h $timesheetDate
    end
end

for day in $working_days
    set -l day "$day $week_offset week"
    set -l timesheetDate (date -d "$day" +"%Y-%m-%d")
    echo "Processing day: $day ($timesheetDate)"
    if test -z "$dry_run"
        tempo l $JIRA_TO_LOG_AGAINST 8h $timesheetDate
    end
end
