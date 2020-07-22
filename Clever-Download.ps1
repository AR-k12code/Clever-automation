#Clever Download Generic
#Directory cleanup
Get-ChildItem -Recurse -Path C:\scripts\clever\upload -Include *.csv | Remove-Item
#Variables
$OutputDirectory = "c:\scripts\Clever"
#Output folder
c:\scripts\CognosDownload.ps1 -report "enrollments" -savepath "$OutputDirectory\upload\" -ReportStudio -Cognosfolder "Clever Files"
c:\scripts\CognosDownload.ps1 -report "schools" -savepath "$OutputDirectory\upload\" -ReportStudio -Cognosfolder "Clever Files"
c:\scripts\CognosDownload.ps1 -report "students" -savepath $OutputDirectory\ -ReportStudio -Cognosfolder "Clever Files"
c:\scripts\CognosDownload.ps1 -report "sections" -savepath "$OutputDirectory\upload\" -ReportStudio -Cognosfolder "Clever Files"
c:\scripts\CognosDownload.ps1 -report "teachers" -savepath "$OutputDirectory\upload\" -ReportStudio -Cognosfolder "Clever Files"
#Populate student email addresses from AD, not required but is generally a good idea if you populate student email addresses in AD otherwise other scripting is required.
#the Students file in clever pulls from the Students contactID email address.
#Processing would be faster as an array, but that has eluded me thus far.
$students = Import-Csv "c:\scripts\clever\students.csv"
foreach($student in $students){
    $id = $student.student_id
$email = Get-aduser -filter {EmployeeID -eq $id} -Properties EmailAddress | Select-Object -ExpandProperty EmailAddress
$student.Student_email = $email
#Write-Host $email -ForegroundColor Green
$students | Export-Csv -NoTypeInformation 'C:\scripts\clever\upload\students.csv'
}

#Upload to Clever #-l is your clever username -pw is your clever SFTP password
c:\scripts\psftp.exe  sftp.clever.com -P 22 -l  -pw  -b "$OutputDirectory\Upload\Clever-SFTP.Bat" -v -bc -batch
#Manually run this FIRST!!! This will prompt to save the SSH key to your registry so the script can be automated! Remove the #
# c:\scripts\psftp.exe  sftp.clever.com -P 22 -l  -pw  -b "c:\scripts\clever\Upload\Clever-SFTP.Bat" -v -bc 

#.Bat file
#lcd "C:\scripts\Clever\Upload"
#mput *.csv
#quit
