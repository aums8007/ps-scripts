<#

Find immediate Manager details and store in C:\scripts\Chain.Csv. Output is redirected to CSV file. All output is shown on single column in excel

Input = C:\scripts\user.csv. Input file should look as below - 

useraccount10

Output will be stored in Chain.csv file which will be extracted in first column only.Output will be as below - 

David.White
Senior Technical Architect I&S
Brian.Carter
Delivery Manager TTS

Use Excel to rearrange output.

#>

$Users = Get-Content "C:\scripts\user.csv"
$users

foreach($user in $Users)
{
    $bool=0
    $ChainArray = @()
    $ChainArray += " "
    do
    {
        $UserProperties=get-aduser -filter{SamAccountName -eq $User} -server domain1.com -properties  *
        $ManagerProperties = $UserProperties.manager  | get-aduser –server domain1.com -Properties * -ErrorAction SilentlyContinue
        $ChainArray += $UserProperties.Displayname
        $ChainArray += $UserProperties.Title
        if(($ManagerProperties.Manager -ne $Null) -and ($ManagerProperties.Manager -notmatch "VP"))
        {
            $ChainArray += $ManagerProperties.displayname
            $ChainArray += $ManagerProperties.Title
            $User = (get-aduser -server domain1.com $ManagerProperties.Manager -properties * | select displayname).displayname
        }
        else
        {
            $ChainArray += $ManagerProperties.Displayname
            $ChainArray += $ManagerProperties.Title
            $bool = 1
        }
    } while( $bool -eq 0)
    Add-Content -Path "C:\scripts\Chain.Csv" -Value $ChainArray
}
