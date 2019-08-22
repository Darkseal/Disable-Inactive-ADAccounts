# Disable-Inactive-ADAccounts
A small Powershell script that disables all the Active Directory user accounts inactive for more than X days (and/or deletes those that have been disabled more than Y days ago).

## Why should we do that?
As a matter of fact, being able to automatically disable AD accounts after X days of inactivity is a good security practice. If you don't have such process up, your Active Directory could grant "permanent" access to many user accounts that should no longer be active, such as those of ex-employees or collaborators who are no longer active at your company.

Unfortunately, such feature is not (yet) supported by any version of Windows or Windows Server, at least up to Windows 10 and Windows Server 2019. That's why I ended up to develop this Powershell script.

## Usage
To disable all AD users that has been inactive for 180 days or more (without deleting them):

    > powershell .\Disable-Invalid-ADAccounts.ps1 -days 180

Same thing as before, plus creating a `logFile.csv` file containing a list of all disabled users:

    > powershell .\Disable-Invalid-ADAccounts.ps1 -days 180

To disable all AD users that has been inactive for 180 days or more and also delete those that have been previously disabled more than 180 days ago.

    > powershell .\Disable-Invalid-ADAccounts.ps1 -days 180 -deleteDays 180

Same thing as before, plus creating a `logFile.csv` file containing a list of all disabled users and a `deleteLogFile.csv` file containing a list of all deleted users:

    > powershell .\Disable-Invalid-ADAccounts.ps1 -days 180
    
In case you get permissions issues when disabling/deleting AD users, you can bypass them using the Bypass Execution Policy Flag in the following way:

    > powershell -ExecutionPolicy Bypass -File Disable-Invalid-ADAccounts.ps1

## License
Licensed under GNU - General Public License, v3.0 - https://www.gnu.org/licenses/gpl-3.0.en.html

## Credits
 - Darkseal/Ryadel, https://www.ryadel.com/

## References
 - [https://www.ryadel.com/en/disable-inactive-ad-accounts-active-directory-users-windows-powershell/](https://www.ryadel.com/en/disable-inactive-ad-accounts-active-directory-users-windows-powershell/) A post that explains how this script works and explains the underlying logics.
