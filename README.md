# Linux script
Here are some scripts thats i'm writing in my job. I don't think that there will be many of them, because I'm mostly working with Windows.

## 1C_bak
Script which generating bakcup of 1C: Enterprise file database. Works very simple:
1. Checking for working processes in database directory and then closing them;
2. Copying database folder to the backup folder;
3. Checking amount of backups in directory, if numbers of backup more then requsted deleting the oldest one

Before using enter $backup_path and $base_path, and number of backups.