Add-Type -AssemblyName System.Web  # For encoding the filename into URL format
$ErrorActionPreference = "Stop"    # Ask PowerShell to stop on errors
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# The location of the file you would like to import
$filePath = "/users/hermannniesewand/downloads/ida mapping jan 22.xlsx"

# The MIME type of the file you are uploading. (Only available in .NET Framework 4.5+). Microsoft Windows Only.
# $mimeType = [System.Web.MimeMapping]::GetMimeMapping($filePath)
# Write-Output $mimeType

# Your token, generated by visiting:
#  https://<customer-name>.apfnxg.com/settings/global/access-token
$token = ""

# FINSYS.IO server (always ends with a trailing forward slash "/")
$baseUrl = "https://wbrv9jr47mcmqhz-finsysio.adb.uk-london-1.oraclecloudapps.com/ords/api/"

# Module
# - The module of the API you want to upload to
$module = "clink/ap/interfaces"

# File type
#  - "APT" if sending an AP transactions file
#  - "Suppliers" if sending a suppliers file
#  - "Employees" if sending an employees file
$fileType = "APT"

# Content type
#  - "text/csv" for if sending csv interface files
#  - "application/xml" if sending xml interface files
#  - "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" if sending xlsx interface files

$contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

# Extract the filename from the path, and encode it suitably for inclusion in a URL
$fileName = [System.Web.HttpUtility]::UrlEncode([System.IO.Path]::GetFileName($filePath))

# Read the file contents
$fileData = [IO.File]::ReadAllBytes($filePath)

#  - $result = Invoke-RestMethod -Uri "$baseUrl/customers/$customer/units/$unit/Uploads/upload/$fileType/$fileName" `

# Alternative method to add Headers
# $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
# $headers.Add("Content-Type", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")

# $result = Invoke-RestMethod -Uri "$baseUrl/$module" `
#    -ContentType $contentType `
#    -Method POST `
#    -Headers @{ "Authorization" = "Bearer $token" } `
#    -Body $fileData


 $result = Invoke-RestMethod -Uri "$baseUrl/$module" `
    -ContentType $contentType `
    -Method POST `
    -Headers @{ "Authorization" = "Bearer $token" } `
    -Body $fileData

# Display the response from the API
Write-Output $result
Write-Debug $result

$result | ConvertTo-Json
Write-Output $filename
Write-Output $result

Get-ChildItem "C:\Users\gerhardl\Documents\My Received Files" -Filter *.log | 
Foreach-Object {
    $content = Get-Content $_.FullName

    #filter and save content to the original file
    $content | Where-Object {$_ -match 'step[49]'} | Set-Content $_.FullName

    #filter and save content to a new file 
    $content | Where-Object {$_ -match 'step[49]'} | Set-Content ($_.BaseName + '_out.log')
}