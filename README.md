# Clever-automation
Version 1.0 7/22/2020:

Generic automatic download and upload for Clever

Reports can be found in Cognos created by Joe Rapert
SMS Shared Content->Shared Between District-> _SMS Staff-Built Reports->Joe rapert->Clever Files
Copy the folder to your My Folders

You will need PSFTP:
https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
Default location for the script to call PSFTP from is: c:\scripts\
Save the file there or edit the script to match where you store PSFTP.

You will also need the CognosDownload for the latest version check here:
https://github.com/AR-k12code/CognosDownloader/

You will need a bat file too, code for the bat is in the PS code and here:
Default name for .bat file: Clever-SFTP.Bat
lcd "C:\scripts\Clever\Upload"
mput *.csv
quit

To save the SSH key you will need to manually run this command and tell the console to save the key to your registry:
c:\scripts\psftp.exe  sftp.clever.com -P 22 -l <username> -pw <password>  -b "c:\scripts\clever\Upload\Clever-SFTP.Bat"

The Students file in clever pulls from the Students contactID email address, if you populate and trust these comment out this section with # or delete it.
$students = Import-Csv "c:\scripts\clever\students.csv"
foreach($student in $students){
    $id = $student.student_id
$email = Get-aduser -filter {EmployeeID -eq $id} -Properties EmailAddress | Select-Object -ExpandProperty EmailAddress
$student.Student_email = $email
#Write-Host $email -ForegroundColor Green
$students | Export-Csv -NoTypeInformation 'C:\scripts\clever\upload\students.csv'
}

Otherwise you need a script to re-create the student file by pulling students from your AD. This is predicated on you having your students ID as their employeeID or another field in AD.
