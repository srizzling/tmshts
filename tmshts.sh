#!/bin/bash

DAYS_OF_WEEK=("Monday" "Tuesday" "Wednesday" "Thursday" "Friday")
JIRA_TO_LOG_AGAINST=RECO-410

echo "Is this timesheet for last week or this week?"
WEEK=$(gum choose --item.foreground 250 "last" "this")

echo "Were there any public holidays $WEEK week?"
PUBLIC_HOLIDAYS=$(gum choose --item.foreground 250 "Yes" "No")

if [[ "$PUBLIC_HOLIDAYS" == "Yes" ]]
then
    echo "What days of the week were public holidays"
    PUBLIC_HOLIDAYS=$(gum choose --item.foreground 250 --no-limit ${DAYS_OF_WEEK[@]})

    for del in ${PUBLIC_HOLIDAYS[@]}
    do
        echo $del
        DAYS_OF_WEEK=("${DAYS_OF_WEEK[@]/$del}")
    done

    for day in ${DAYS_OF_WEEK[@]}
    do
        echo $day
    done
    echo $DAYS_OF_WEEK
fi

if [[ $WEEK == "this" ]]
then
    echo "hi"
    # This a hack - basically I'm assuming i'm doing timesheets on friday
    # can fix this if I start doing my timesheets in a timely manner lol
    if [[ $(date +%u) -ne 5 ]]
    then
        echo "Today is not friday - why are you doing your timesheets this week not on a friday??!?!"
        exit 1
    fi

    for i in "${!DAYS_OF_WEEK[@]}"; do
        week=this
        if [[ ${DAYS_OF_WEEK[$i]} != "Friday" ]]; then
            week=last
        fi
        day=${DAYS_OF_WEEK[$i]}
        DAYS_OF_WEEK[$i]="$week-$day"
    done
fi

if [[ $WEEK == "last" ]]
then
    # error if today is friday
    if [[ $(date +%u) -eq 5 ]]
    then
        echo "Today is friday - why are you doing your timesheets for last week on a friday??!?!"
        exit 1
    fi

    for i in "${!DAYS_OF_WEEK[@]}"; do
        day=${DAYS_OF_WEEK[$i]}
        DAYS_OF_WEEK[$i]="$WEEK-$day"
    done
fi


echo "Did you have any leave $WEEK week?"
CHOICE=$(gum choose --item.foreground 250 "Yes" "No")

if [[ "$CHOICE" == "Yes" ]]
then
    echo "What days did you have leave?"
    LEAVE_DAYS=$(gum choose --item.foreground 250 --no-limit ${DAYS_OF_WEEK[@]})

    for del in ${LEAVE_DAYS[@]}
    do
        DAYS_OF_WEEK=("${DAYS_OF_WEEK[@]/$del}")
    done

    for leave in ${LEAVE_DAYS[@]}
    do
        TIMESHEET_DATE=$(date -d "$day" +"%Y-%m-%d")
        echo "logging leave for $day ($TIMESHEET_DATE)"
        tempo l ADMIN-12 8h $TIMESHEET_DATE
    done
fi

for day in ${DAYS_OF_WEEK[@]}
do
    TIMESHEET_DATE=$(date -d "$day" +"%Y-%m-%d")
    echo "logging timesheet for $day ($TIMESHEET_DATE)"
    tempo l $JIRA_TO_LOG_AGAINST 8h $TIMESHEET_DATE
done
