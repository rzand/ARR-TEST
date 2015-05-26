<#
.SYNOPSIS
Searches a string in the event viewer.
.DESCRIPTION
The Find-Event Function gets the Event viever events that contain the string passed as parameter.
.PARAMETER wtf
what to find: the string to search in the event viewer message.
.EXAMPLE 
Find-Event 
When the Function is called without specifying the parameters' values they will be asked 
.EXAMPLE 
Find-Event -logname application -wtf previous 
Searches the Application Event Viewer events for the string "previous"
.EXAMPLE 
Find-Event application "Update service" 
Searches the Application Event Viewer events for the string "Update service".
Write the string between the quotation signs "" if it contains spaces.
#>
function Find-Event {

[CmdletBinding(SupportsPaging=$true,
               PositionalBinding=$true,
               DefaultParameterSetName="log")]

param (
    [parameter(Position=0,
    Mandatory=$true,
    #ParameterSetName="log",
    #ValueFromRemainingArguments=$true,
    #ValueFromPipeline=$true,
    HelpMessage="Please Enter The Event Viewer Log To Search"
    )]
    [ValidateSet("System", "Application", "Security")]
    [String]
    $logname, #Which log to check

    [parameter(Mandatory=$true,
    #ParameterSetName="cosa",
    Position=1,
    HelpMessage="Please Enter The String to Find"
    #ValueFromRemainingArguments=$true,
    #ValueFromPipeline=$true
    )]
    [String]
    $wtf #What to find
    )



begin {}
process {
    $command = {ForEach-Object {if ($_.Message -match $wtf) {write-host -NoNewline "Time Generated:" $_.TimeGenerated "EventID:" $_.EventID `
               "Source:" $_.Source "Entrytype:" $_.Entrytype "MachineName:" $_.MachineName "`nMessage:" $_.Message "`n`n"}}}
    Get-EventLog $logname | Invoke-Command $command
}
end {}
}