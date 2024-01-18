This is a wrapper script which wraps the very useful script over at https://github.com/olejorgenb/ColorNote-backup-decryptor.
This script can decrypt and extract a ColorNote backup.

# Installation/User Guide
If you want to use the ColorNote Backup Decryptor to decrypt a ColorNote backup, please follow these steps.

### Prerequisites
To use this, you will need an Android phone with the ColorNote app, and a PC or Laptop running Windows or Linux (Macs may work if you know how, but are untested).

If you have any locked notes (notes that require your master password in order to read them), then you will need to unlock them first (long-press the note, select "more", select "Unlock"). Locked notes have a second layer of encryption that this wrapper does not decrypt, and so the easiest way to export any locked notes is just to unlock them before taking the backup, and re-lock them afterwards.

## 1. Getting the Backup from ColorNote
In ColorNote, go to the "More" menu by tapping the three lines at the bottom:  
![img3](https://github.com/CrazySqueak/ColorNote-backup-decryptor.sh/assets/49409835/9a4c80fe-07bc-455d-8231-fb2a8d87dd0b)

Then, select "Settings" and scroll down to "Backup". Select the "Backup" option.  
![img4](https://github.com/CrazySqueak/ColorNote-backup-decryptor.sh/assets/49409835/ac88dfca-434a-4495-9d58-b15bd9149160)

Tap "BACKUP NOTES", and enter your master password if asked.
Tap the new backup that appears, then select "Send".  
![img5](https://github.com/CrazySqueak/ColorNote-backup-decryptor.sh/assets/49409835/d59989a4-017f-4f5d-9074-f311066e0cd4)

Select an option that allows you to upload the file, and then download it on your computer. 
For this example I'll use Google Drive, but anything of that sort works.
Then, upload the file, and wait for the upload to complete.  
![img6](https://github.com/CrazySqueak/ColorNote-backup-decryptor.sh/assets/49409835/890954f6-083c-41cd-acbf-cc5ea5fc8f13)

Once you're on your computer, download the file from wherever you upoaded it (e.g. If you're using Google Drive, you'd download it from [drive.google.com](drive.google.com)). Save it somewhere where you'll remember it.   
![img7](https://github.com/CrazySqueak/ColorNote-backup-decryptor.sh/assets/49409835/2c3cc474-0c94-4f81-8ef4-54cd015c47bc)

Now that you've downloaded your backup, you're ready to install and use this program in order to decrypt it. Go to step 2.

## 2. Install Dependencies

### On Linux
If on linux, you will need to install the following dependencies. The majority of these should come pre-installed. The command below is for the apt package manager (Debian/Ubuntu). If you use a different package manager, please adjust the command to use the correct one.
```
$ sudo apt update && sudo apt install default-jre python3 perl sed bash git grep
```

### On Windows
If on Windows, installation is a bit more difficult. There is currently no windows-friendly version of the script, however you can run the Linux version on Windows using [Git Bash](https://git-scm.com/download/win).

1. Download Git Bash / Git for Windows from [this link](https://git-scm.com/download/win). Download and run the relevant installer and leave the settings set to the defaults.
2. If you want the output file to be prettified (human-readable), download a copy of Python 3 from [this link](https://www.python.org/downloads/windows/) and run the installer. Leave the installer settings set to the defaults **EXCEPT** for "Add Python 3 to PATH", a checkbox which must be selected if it isn't already. If you don't care, skip this step.
3. If you do not have java, or aren't sure if you do, download a copy of Java from [this link](https://learn.microsoft.com/en-us/java/openjdk/download#openjdk-17), selecting the "Windows x64 msi" option from the list. Run the installer and leave the settings set to the defaults.


## 3. Download and run colornote-backup-decryptor.sh

Open your terminal (on Linux) or Git Bash (on Windows) and type in the following commands to download and run the script:
```
$ git clone https://github.com/CrazySqueak/ColorNote-backup-decryptor.sh.git
$ cd ColorNote-backup-decryptor.sh
$ bash colornote-backup-decryptor.sh
```

This script will automatically download olejorgenb's ColorNote backup decryptor, perform a few checks, and run the commands for you as needed. The output should look something like this (some lines may be different depending on your Java version and Operating System):
![img1](https://github.com/CrazySqueak/ColorNote-backup-decryptor.sh/assets/49409835/2ed1864e-0f8a-49bc-8c77-7d7a97064def)

After the download is completed and the checks have been run, you should be greeted with a prompt that looks like this:
```
Enter path to backup (input) file (.backup, .dat, .doc):
```
There, enter the path pointing to where the colornote backup file was saved to in Step 1. If you're on Windows, you can simply copy the backup file (in windows explorer: right click and select "Copy"), and paste it into Git Bash (right click and select "Paste"), which will fill out the path for you. Then, press ENTER.

Next, you'll see the next question:
```
Enter path to output to (.json):
```
This is where you type in the path that you'd like the output file to be saved to. If you're unsure, simply copy-and-paste the path you entered for the previous question, but add ".json" to the end. Then, press ENTER.

Finally, you'll be asked for your ColorNote master password:
```
Enter ColorNote master password (0000 is the colornote default): 
```
If you did not set a master password in ColorNote, enter "0000".  
If you did set a master password in ColorNote, enter the password here. It is required in order to decrypt your notes.  
Then, press ENTER.

The script will then begin trying different encryption methods to decrypt the backup. Don't worry if you see any errors as long as the script keeps running - ColorNote has a couple different formats for encrypting backup,s and trial-and-error is used to figure out which format the backup is in. You'll see something that looks like this:
![img2](https://github.com/CrazySqueak/ColorNote-backup-decryptor.sh/assets/49409835/7d273544-cff8-4647-a3a8-f471100544f1)
 
Once the decryption has completed, you should see these two lines:
```
Success.
Your ColorNote backup has been successfully decrypted and exported!
```
These lines signify that your backup has been successfully decrypted.

## 4. Viewing your decrypted backup
 - todo
