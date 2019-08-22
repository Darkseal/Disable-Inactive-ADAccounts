# Disable-Inactive-ADAccounts
A small Powershell script that disables all the Active Directory user accounts inactive for more than X days (and/or deletes those that have been disabled more than Y days ago).

## Usage
To disable all AD users that has been inactive for 180 days or more (without deleting them):

    > powershell .\Disable-Invalid-ADAccounts.ps1 -days 180

Same thing as before, plus creating a `logFile.csv` file containing a list of all disabled users:

    > powershell .\Disable-Invalid-ADAccounts.ps1 -days 180

To disable all AD users that has been inactive for 180 days or more and also delete those that have been previously disabled more than 180 days ago.

    > powershell .\Disable-Invalid-ADAccounts.ps1 -days 180 -deleteDays 180

Same thing as before, plus creating a `logFile.csv` file containing a list of all disabled users and a `deleteLogFile.csv` file containing a list of all deleted users:

    > powershell .\Disable-Invalid-ADAccounts.ps1 -days 180

## License
Licensed under GNU - General Public License, v3.0 - https://www.gnu.org/licenses/gpl-3.0.en.html

## Credits
 - Darkseal/Ryadel, https://www.ryadel.com/



-deleteDays 0 -deleteLogFile deleteLog.csv

## License
Licensed under GNU - General Public License, v3.0 - https://www.gnu.org/licenses/gpl-3.0.en.html

## Credits
 - Darkseal, https://www.ryadel.com/
