# Active Directory Script
# Search specific groups that begins with the name "APP-NAME" across the forest and output the CSV file
# Output : Group Name, Domain Name, Scope and Distringuished Name

# Define the output path
$outputPath = "C:\Temp\Groups_Forest_Wide.csv"

# Identify the Forest and a Global Catalog server
$forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
$gcServer = ($forest.GlobalCatalogs[0].Name + ":3268")

Write-Host "Connecting to Global Catalog: $gcServer" -ForegroundColor Cyan

# Define the LDAP filter for groups starting with APP-NAME
$filter = "(&(objectClass=group)(name=APP-NAME*))"

# Query the Global Catalog
$results = Get-ADGroup -LDAPFilter $filter -Server $gcServer | ForEach-Object {
    # Extract the Domain name from the Distinguished Name
    # Example: CN=Group,OU=Apps,DC=corp,DC=fabrikam,DC=com -> corp.fabrikam.com
    $dn = $_.DistinguishedName
    $domainDN = $dn.Substring($dn.IndexOf("DC="))
    $domainName = $domainDN.Replace("DC=", "").Replace(",", ".")

    [PSCustomObject]@{
        Domain      = $domainName
        GroupName   = $_.Name
        GroupScope  = $_.GroupScope
        DN          = $_.DistinguishedName
    }
}

# Export results to CSV
if ($results) {
    $results | Export-Csv -Path $outputPath -NoTypeInformation
    Write-Host "Success! Results exported to $outputPath" -ForegroundColor Green
} else {
    Write-Host "No groups found with that naming convention in the forest." -ForegroundColor Yellow
}
