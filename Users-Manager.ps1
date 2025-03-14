<#

Find immediate Manager details and store in C:\scripts\Chain.Csv. Output is redirected to CSV file. All output is shown on single column in excel

Input = C:\scripts\user.csv. Input file should look as below - 

z083250
SPMTC0

Output will be stored in Chain.csv file which will be extracted in first column only.Output will be as below - 

Prashant.Khaire
Senior Technical Architect I&S
Venkata.Korupolu
Delivery Manager TTS

Mike.Cossette
Engineering Consultant
Jeff.Holschuh
Manager TTS

Use Excel commands to rearrange output.

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
        $UserProperties=get-aduser -filter{SamAccountName -eq $User} -server corp.target.com -properties  *
        $ManagerProperties = $UserProperties.manager  | get-aduser –server corp.target.com -Properties * -ErrorAction SilentlyContinue
        $ChainArray += $UserProperties.Displayname
        $ChainArray += $UserProperties.Title
        if(($ManagerProperties.Manager -ne $Null) -and ($ManagerProperties.Manager -notmatch "VP"))
        {
            $ChainArray += $ManagerProperties.displayname
            $ChainArray += $ManagerProperties.Title
            $User = (get-aduser -server corp.target.com $ManagerProperties.Manager -properties * | select displayname).displayname
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