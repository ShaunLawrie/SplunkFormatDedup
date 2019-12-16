# SplunkFormatDedup
This Powershell script deduplicates &lt;format> tags in a Splunk dashboard. It keeps the last of each unique &lt;format> tag.  
I'm using it to clean up dashboard xml when I end up with hundreds/thousands of extra format tags from this issue: https://answers.splunk.com/answers/780896/after-upgrading-to-splunk80-when-i-re-change-colum-1.html

Requires Powershell https://github.com/PowerShell/PowerShell

This comes with no warranty, always back up your dashboard xml before making major changes 😁  

## Example:

Input in a powershell terminal:  
`./SplunkFormatDedup.ps1 ./dashboardexample.xml`  

Input in other terminals with Powershell installed:  
`pwsh ./SplunkFormatDedup.ps1 ./dashboardexample.xml`

Output:
```
Deduplicating all <format> tags in ./dashboardexample.xml
Removed 24 <format> tags and saved at ./dashboardexample.xml.dedup.xml
```