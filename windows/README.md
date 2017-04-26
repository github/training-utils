# GitHub Training Setup Scripts
When doing training one of the distracting things that can happen is that you will receive a **popup** message from your email client, Slack Notification, or other program running in the background.  This script is intended to help shutdown those programs that might interrupt your training session.  

The possible disctration is that your **Daily Browser** may have a lot of tool bar entries that may disctrct the audience.  In my environment I use Chrome as my primary browswer, so I have chosen to launch a **Clean FireFox** browser instead for training.


*This initial version works for Windows 7, but the concept should be easy to port to MAC or Linux*

| Script FIle | Description |
|-------------|-------------|
| killprogs.bat | Simple script that runs through a list of programs to terminate.  The `/f` switch forces the program to terminate |
| launch_ff.bat | Launches the **FireFox** browswer from the standard installation location with a few **starting** webpages for training | 
| setalias.bat | A quick way to setup my normal development git alias'.  It is a bit annoying when you keep using your alias' and the people your training don't have them setup as well. |
| start_training.bat | Launch the killprogs.bat, unsetalias.bat, and launch_ff.bat scripts | 
| unsetalias.bat | Quickly unset some of my common git alias' so I am forced to use the long hand command for training.|

## Customization 
If you need to add more programs to the `killprogs.bat` file you can simply run `tasklist` from a Windows command line to see the full name of the program to kill.

If you have any suggestions/comments please feel free to leave issues on this repository, if you would like to help with other platforms I look forward to working with you.
