
# This code is tested on CentOS 7.x. It has been considered you know basic of Linux operations.

#!/bin/bash
#!/bin/sh
#
##########################################################################################
#               Automated backup Repository (Bitbucket {Mercurial, GIT) + TFS)
#               File/version: bitbucket-backup.sh
#               Author: Alok Kumar Singh [aks82info@gmail.com]
##########################################################################################
#
#
#Global variables
CHECKOUT_DIR=/bitbucketlocal/backups/checkouts
GIT_REPOS_DIR=/bitbucketlocal/backups/checkouts/git_repos
MERCURIAL_REPOS_DIR=/bitbucketlocal/backups/checkouts/mercurial_repos
TFS_GIT_REPOS_DIR=/bitbucketlocal/backups/checkouts/tfs_git_repos
BITBUCKET_USER="Your_BitBucket_Login_UserName"
BITBUCKET_PASS="Your_BitBucket_Login_Password"

# Log maintenance
/usr/bin/rm -rf /tmp/RepositorySyncLog.txt
/usr/bin/touch /tmp/RepositorySyncLog.txt
LOG="/tmp/RepositorySyncLog.txt"
echo -e "\t\tThis log file is based on last execution time of Repository backup script\n\n" > $LOG

# List of mercurial based repo name
MERCURIAL_REPOS="MERCURIALRepoName1 MERCURIALRepoName2 MERCURIALRepoName3"

# List of GIT based repo name
GIT_REPOS="GITRepoName1 GITRepoName2 GITRepoName3"

# List of TFS based repo name
TFS_GIT_REPOS="TFSRepoName1 TFSRepoName2 TFSRepoName3"

# Function to clone or update git repo to local
function git_clone_or_fetch {
        cd $GIT_REPOS_DIR
        if [ -d $1 ]; then
                echo "$(date +%Y-%m-%d_%H:%M) -- Updating GIT repo $1" >> $LOG
                cd $1
                git fetch origin >> $LOG
        #       echo "..............Changeset Details for repo $1" >> $LOG
        #       git log >> $LOG
                echo "..........................................." >> $LOG
        else
                echo "$(date +%Y-%m-%d_%H:%M) -- Cloning GIT repo $1" >> $LOG
                git clone https://$BITBUCKET_USER:$BITBUCKET_PASS@bitbucket.org/YourBitbucketURL/${1}.git >> $LOG
        #       echo "..............Changeset Details for repo $1" >> $LOG
        #       git log >> $LOG
                echo "..........................................." >> $LOG
        fi
}

# Fetch (update) or clone (checkout) each git_repo
echo "=====================================================================" >> $LOG
echo "$(date +%Y-%m-%d_%H:%M) Starting GIT Repo Clone / Update" >> $LOG
echo "=====================================================================" >> $LOG
for git_repos in $GIT_REPOS
        do
                git_clone_or_fetch $git_repos >> $LOG
        done
echo "=====================================================================" >> $LOG
echo "$(date +%Y-%m-%d_%H:%M) GIT Repo Clone / Update Completed" >> $LOG
echo "=====================================================================" >> $LOG

# Function to clone or update mercurial repo to local
function mercurial_clone_or_fetch {
        cd $MERCURIAL_REPOS_DIR
        if [ -d $1 ]; then
                echo "$(date +%Y-%m-%d_%H:%M) -- Updating MERCURIAL repo $1" >> $LOG
                cd $1
                hg pull https://$BITBUCKET_USER:$BITBUCKET_PASS@bitbucket.org/YourBitbucketURL/${1} >> $LOG
                hg update  >> $LOG
                hg check
                hg verify
                echo "..........................................." >> $LOG
        else
                echo "$(date +%Y-%m-%d_%H:%M) -- Cloning MERCURIAL repo $1" >> $LOG
                hg clone https://$BITBUCKET_USER:$BITBUCKET_PASS@bitbucket.org/YourBitbucketURL/${1} >> $LOG
                hg update
                hg check
                hg verify
                echo "..........................................." >> $LOG
        fi
}

# Fetch (update) or clone (checkout) each mercurial_repo
echo "=====================================================================" >> $LOG
echo "$(date +%Y-%m-%d_%H:%M) Starting MERCURIAL Repo Clone / Update" >> $LOG
echo "=====================================================================" >> $LOG
for mercurial_repos in $MERCURIAL_REPOS
        do
                mercurial_clone_or_fetch $mercurial_repos  >> $LOG
        done
echo "=====================================================================" >> $LOG
echo "$(date +%Y-%m-%d_%H:%M) MERCURIAL Repo Clone / Update Completed" >> $LOG
echo "=====================================================================" >> $LOG


# Function to clone or update TFS git repo to local
function tfs_git_clone_or_fetch {
        cd $TFS_GIT_REPOS_DIR
        if [ -d $1 ]; then
                echo "$(date +%Y-%m-%d_%H:%M) -- Updating TFS repo $1" >> $LOG
                cd $1
                git fetch origin >> $LOG
                echo "..........................................." >> $LOG
        else
                echo "$(date +%Y-%m-%d_%H:%M) -- Cloning TFS repo $1" >> $LOG
                git clone ssh://YourTFSUserName@vs-ssh.visualstudio.com:22/_ssh/${1} >> $LOG
                echo "..........................................." >> $LOG
        fi
}

# Fetch (update) or clone (checkout) each git_repo
echo "=====================================================================" >> $LOG
echo "$(date +%Y-%m-%d_%H:%M) Starting TFS Repo Clone / Update" >> $LOG
echo "=====================================================================" >> $LOG
for tfs_git_repos in $TFS_GIT_REPOS
        do
                tfs_git_clone_or_fetch $tfs_git_repos >> $LOG
        done
echo "=====================================================================" >> $LOG
echo "$(date +%Y-%m-%d_%H:%M) TFS Repo Clone / Update Completed" >> $LOG
echo "=====================================================================" >> $LOG

echo "$(date +%Y-%m-%d_%H:%M)>>>>>>>>>All repo backup completed. Sending transaction log  $LOG  " >> $LOG

# Optional mail notification
echo "Hi, This is an auto generated mail. Please find the attached log file which shows repo backup status." | mail -v -s "Repository backup status (Bitbucket + TFS)" -r "Repository-Backup-Status<YouruserName@YourDomainName.com>" -a $LOG YouruserName@YourDomainName.com
