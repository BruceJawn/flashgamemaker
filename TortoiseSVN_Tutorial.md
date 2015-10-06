Learn how to grab the latest release of FlashGameMaker from an SVN repository using TortoiseSVN

# Introduction #
This tutorial is a copy made from [CJ's blog](http://cjcat.blogspot.com/2009/06/using-tortoisesvn-to-check-out-files.html). Thanks to visit his blog for more details.

Alright.
I believe there are still many people out there who don't know how to obtain source codes from a Google Code project homepage if the project owner does not provide a download link in the download list.
Project owners may decide to pack a stable release of source codes in a compressed file and upload it to the download list, or provide related files in the list as well. But in some cases, they somehow choose to keep the source files in the SVN repository, without providing the files in the download list.

What's an SVN repository? SVN stands for Subversion, which is a version control system. SVN repositories are places project owners put there source files in, and these repositories are "version controlled". An project owner can "commit" source files to a repository, "check out" the files to another computer, modify the files in that computer, and "commit" the modified files back to the repository. The complete process is overseen by the SVN system. The system keeps track of every single modification to the source files, and completely backups every older versions after a modification. So it's possible for the owner if he or she wants to "revert" the repository back to an earlier version, or revision.

Google Code provides two different version control systems: SVN and Mercurial. I only use SVN, so I'm not very familiar with Mercurial. Here I'll just talk about the SVN system.

A Google Code project owner has a password to the project's SVN repository, which allows the owner to modify the repository. Others can only "check out" files from the repository. But how to check out the files?

You can either use the commandline method to communicate with the SVN repository (which I certainly do not prefer), or use graphical-interface tools like TortoiseSVN. I use TortoiseSVN to commit and check out files.

You can get TortoiseSVN here.

Ok, here's how you check out files from an SVN repository.
(I use Windows XP)

1. Download, install TortoiseSVN, and restart your computer.

2. Create a new folder for checking out files.

3. Go to the project's SVN repository.
If a Google Code project page's URL is http://code.google.com/p/NAME (http://code.google.com/p/flashgammaker),
then the repository's root directory URL is http://NAME.googlecode.com/svn (https://flashgamemaker.googlecode.com/svn/trunk/flashgamemaker)
You may want to navigate several layers down in the hierarchy (usually to the "trunk" directory).

http://3.bp.blogspot.com/_4-LtXwX7Yuo/SkZEDF0e68I/AAAAAAAAAWc/HHnm_ajAn3g/s320/1.PNG

4. Copy the directory's URL.

5. Right click on the new folder you created in step 2, and select SVN Checkout.

http://1.bp.blogspot.com/_4-LtXwX7Yuo/SkZEDR1nOlI/AAAAAAAAAWk/I1WpmQE7x0M/s320/2.PNG

6. Paste the directory's URL and click OK.

http://4.bp.blogspot.com/_4-LtXwX7Yuo/SkZEDr6JwFI/AAAAAAAAAWs/Gl1eJr6kRn0/s320/3.PNG

7. Wait for the files to be checked out.

http://3.bp.blogspot.com/_4-LtXwX7Yuo/SkZED94Tt3I/AAAAAAAAAW0/pWJJQ1j3BYU/s320/4.PNG

8. You're done!! Whenever you want to update the files to the latest revision,
right click on the folder and select SVN Update.

http://2.bp.blogspot.com/_4-LtXwX7Yuo/SkZEEKCxUAI/AAAAAAAAAW8/n9gPSwaE8tM/s320/5.PNG