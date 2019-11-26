#!/bin/bash
#!/bin/sh

# GLOBAL VARIABLE & ARRAY INITIALIZATION

AzureRecommendationList="/tmp/AzureRecommendationList-$(date +%Y-%m-%d_%H:%M).txt"
AzureSubscriptionList=($(az account list --output table | awk '{print $3}'))
AzureSubscriptionList[0]=""
AzureSubscriptionList[1]=""
rm -rf /tmp/AzureRecommendation*.csv
touch $AzureRecommendationList

# FUNCTION DEF
function FetchRecommendation {
        az advisor recommendation list -r -c Cost  --output table >> $AzureRecommendationList
}

# FUNCTION CALL
for subscription in ${AzureSubscriptionList[*]}
        do
                :
                az account set -s $subscription
                echo $subscription
                FetchRecommendation $subscription >> $AzureRecommendationList
        done
echo "Hi, Please find the attached log file which shows Azure Advisory" | mail -v -s "Azure Advisory Status" -r "Azure-Advisory-Status<YourMailID@YourDomain.com>" -a $AzureRecommendationList  <YourMailID@YourDomain.com>
