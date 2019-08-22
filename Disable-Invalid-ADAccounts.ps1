#########################################################
#
# ---------------------------------------------
# Disable-Inactive-ADAccounts
# ---------------------------------------------
# A small Powershell script that disables all the Active Directory user accounts inactive for more than X days
# (and/or deletes those that have been disabled more than Y days ago).
#
# by Darkseal - https://www.ryadel.com/
#
# Licensed under GNU - General Public License, v3.0
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Fork me on GitHub!
# https://github.com/Darkseal/Disable-Inactive-ADAccounts
#
#########################################################

param(
# - days : disable all inactive accounts for X days or more.
#          If set is -1, it won't disable anything. Default is 180.
[Parameter(Mandatory=$false)] [int] $days = 180,

# -deleteDays : delete all previously disabled users since X days or more.
#               If set to -1, it won't delete anything. Default is -1.
[Parameter(Mandatory=$false)] [int] $deleteDays = -1,

# -logFile : if set to a valid PATH, it will output a CSV files containing the disabled users.
#            If set to null (default) it won't create a logFile.
[Parameter(Mandatory=$false)] [string] $logFile = $null,

# -deleteLogFile : if set to a valid PATH, it will output a CSV files containing the deleted users.
#            If set to null (default) it won't create a logFile.
[Parameter(Mandatory=$false)] [string] $deleteLogFile = $null
)


#Search all inactive accounts
[Datetime]$ts = (Get-Date).AddDays(-$days)
# (Search-ADAccount -UsersOnly -AccountInactive -TimeSpan $ts.Day | Select-Object DistinguishedName).count
# Search-ADAccount -UsersOnly -AccountInactive -TimeSpan $ts.Day | Select-Object DistinguishedName,sAMAccountName
# $users = {(Search-ADAccount -UsersOnly -AccountInactive | ? { $_.LastLogonDate -lt (get-date).AddDays(-$days)}) | Select-Object DistinguishedName,sAMAccountName,Enabled }
$users = Search-ADAccount -UsersOnly -AccountInactive -TimeSpan $ts.Day | Select-Object DistinguishedName,sAMAccountName, Enabled
Write-Host "$($users.Count)"

# Adding the time of account disabled in the extentionAttribute10 for all accounts. 
# This will help while deleting the accounts if [deleteDays] parameter is set.
[string]$t = ((Get-Date).Datetime)
$disabled = 0;
$alreadyDisabled = 0;
$deleted = 0;

# Disable the inactive accounts found
if ($days -gt -1) {
  Foreach ($user in $users)
  {
    If ($user.Enabled) {
      $disabled++
      Set-ADUser $user.DistinguishedName -add @{extensionAttribute10="$t"}
      Disable-ADAccount -Identity $user.DistinguishedName
    }
    Else {
      $alreadyDisabled++
    }
  }
  # Export the disabled accounts
  If ($logFile) { $users | Export-Csv "$logFile" }
}


# if $deleteDays is set, delete the already-disabled accounts found
If ($deleteDays -gt -1) {
  $tsD = (Get-Date).AddDays(-$deleteDays)
  $usersD = Get-ADUser -Filter {enabled -eq $false} -Properties * | Where-Object{"extensionAttribute10" -in $_.PSobject.Properties.Name} | Where-Object{$tsD -ge $_.extensionAttribute10}
  Foreach($user in $usersD) {
    $deleted++
    Remove-ADUser $user
  }

  # Export the deleted accounts
  If ($deletedLogFile) { $usersD | Export-Csv "$deletedLogFile" }
}



Write-Host ""
Write-Host "Operation complete:"
If ($days -gt -1) {
  Write-Host " - $($disabled) accounts has been disabled ($($alreadyDisabled) already disabled)."
  If ($logFile) { 
    Write-Host "   Disabled accounts logged to $($logFile) file."
  }
}
If ($deleteDays -gt -1) {
  Write-Host " - $($deleted) accounts has been deleted."
  If ($deleteLogFile) { 
    Write-Host "   Deleted accounts logged to $($deleteLogFile) file."
  }
}
