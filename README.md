# Jellyfin-Trickplay-Script

A small Bash script that can create Trickplay Images for Jellyfin on a different device.


## Why?
My Jellyfin server is somewhat underpowered (old laptop) but is still enough to stream videos. I really like Trickplay as a concept, but creating these files on the server is slowing it down significantly. That's why I created this little script to create those files on my main PC and then just put them on the server.

## How to use
1. Download the script.
2. Take a look at it yourself.
3. Make it executable: `chmod +x trickplay.sh`
4. Use it on a file/directory: `./trickplay <file or directory>`
5. Make sure that your Jellyfin library has "Enable trickplay image extraction" and "Save trickplay images next to media" enabled, and run the scheduled task to create them (it will only run briefly to "discover" the created files).

## How it works
This script uses FFMPEG to first create stills and then an image grid. This script automates that process and creates the correct folder structure. If the folders already exist, the script will not override anything. If you want to create new Trickplay files, delete the old folder and run the script again.

## Disclaimer
Use at your own risk; no warranty whatsoever.
Might break in future releases of Jellyfin.
Probably not the most efficient way to do this, but I am no FFMPEG expert, and this works

## Credits
Pretty much all the credit belongs to the FFMPEG team. Thank you for your incredible work and dedication!
