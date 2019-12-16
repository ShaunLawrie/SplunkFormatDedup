param (
    [Parameter(Mandatory=$true)]
    [string] $DashboardXmlPath
)

# Make xml pretty. Why is this not built-in...
function Format-Xml {
    param(
        [Parameter(ValueFromPipeline)]
        [xml]$Xml,
        $Indent=2
    )
    $StringWriter = New-Object System.IO.StringWriter
    $XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter
    $xmlWriter.Formatting = “indented”
    $xmlWriter.Indentation = $Indent
    $Xml.WriteContentTo($XmlWriter)
    $XmlWriter.Flush()
    $StringWriter.Flush()
    Write-Output $StringWriter.ToString()
}

Write-Host "Deduplicating all <format> tags in $($DashboardXmlPath)"

# Load the dashboard as an xml doc for parsing
[xml]$dashboard = (Get-Content -Path $DashboardXmlPath)

# Collect all of the nodes to remove by deduping on the "type" and "field" properties then "select-object skiplast" to get them all excluding the latest format node of each group
$nodesToRemove = $dashboard.SelectNodes("//format") | Group-Object -Property type,field  | Foreach-Object { $_.Group | Select-Object -SkipLast 1 }

# Remove all the dups from the document
$nodesToRemove | Foreach-Object {
    $_.ParentNode.RemoveChild($_) | Out-Null
}

# Save it to a new file 
$dashboard.OuterXml | Format-Xml | Out-File "$DashboardXmlPath.dedup.xml"

Write-Host "Removed $($nodesToRemove.Count) <format> tags and saved at $DashboardXmlPath.dedup.xml"
