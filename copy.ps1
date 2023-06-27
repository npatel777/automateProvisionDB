$hermesServer = "\\vistar-len-hermes.symplr.com\S$"
$installFolders = "Production Releases\eVIPs 5 (HTML)\Installation Packages\"

$usernameHermes = "npatel-admin"
$passwordHermes = ConvertTo-SecureString "Jobsymplr@1234" -AsPlainText -Force
$mycredsHermes = New-Object System.Management.Automation.PSCredential($usernameHermes, $passwordHermes)

New-PSDrive -Name K -PSProvider FileSystem -Root $hermesServer -Credential $mycreds -Persist

Write-Host "Created Drive K"

$folderName = Get-ChildItem -Path "K:\$installFolders" -Directory | Sort-Object -Property {$_.Name} -Descending | Select Name | Select-Object -First 1 | Select -ExpandProperty "Name"

Write-Host "Retrieved Folder: $folderName"

$backupsSource = "Production Releases\eVIPs 5 (HTML)\Installation Packages\$folderName\Databases"
$certSource = "Deployment\SaaS Release\"
$certName = "star_payer_symplr_com.pfx"
$certPassword = ConvertTo-SecureString "X35&jHE$%bEM!mD" -AsPlainText -Force
$Dest   = "\\D97PAY600DB01.symplrpayer.com\D$\symplr\install"

$usernameDB = "spayer\npatel-admin"
$passwordDB = ConvertTo-SecureString "n7JYx6s3RHe5" -AsPlainText -Force
$mycredsDB = New-Object System.Management.Automation.PSCredential($usernameDB, $passwordDB)

New-PSDrive -Name J -PSProvider FileSystem -Root $Dest -Credential $mycredsDB -Persist
Write-Host "Created Drive J"

$files = Get-ChildItem -Path "K:\$backupsSource" -Recurse | Where-Object {$_.PSIsContainer -eq $false}
Write-Host "Retreived all files from K:\$backupsSource"

foreach($file in $files) {
    Write-Host "Copying... $file"
    Copy-Item -Path "K:\$backupsSource\$file" -Destination "J:\$file"
}
Copy-Item -Path "K:\$certSource\$certName" -Destination "J:\$certName"
Write-Host "COMPLETED: Copying Done"