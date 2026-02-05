https://github.com/user-attachments/assets/71aa6ee6-f85d-46b6-973c-30b0cab162bf

[YT link if mp4 fails to load](https://youtu.be/6Y_h98mP450)

For wallpaper management: Using "AWWW Switcher" from [vicinae](https://github.com/vicinaehq/vicinae) extension store. For this to work, `awww-daemon` must be running. This is setup for auto-exec in my hyprland.conf. Install from AUR with `yay -S awww-git`

> [!NOTE]
> if you're using awww --> disable hyprpaper. 

### Media viewer
`mpv` package is what i use for viewing videos; install it with pacman if you want.<br />
By default, `mpv` auto-closes when the video ends; prevent this by adding `keep-open=yes` in `~/.config/mpv/mpv.conf`<br />
If you're using thunar or any file manager, you can set mpv as default for specific file types, e.g.: .mp4 .mkv .avi

> [!TIP]
> Thunar: right click file --> Open with --> Set default application --> mpv media player

### Screen Recording (custom selector)
Start a screen-recording with bind `SUPER+SHIFT+R` from hyprland.conf. It references a bashscript that utilizes the following dependencies:<br />
[gpu-screen-recorder](https://aur.archlinux.org/packages/gpu-screen-recorder), [kitty](https://sw.kovidgoyal.net/kitty/binary/), [fzf](https://wiki.archlinux.org/title/Fzf), [slurp](https://man.archlinux.org/man/extra/slurp/slurp.1.en), [coreutils](https://www.gnu.org/software/coreutils/), [libnotify](https://archlinux.org/packages/extra/x86_64/libnotify/), [waybar](https://wiki.archlinux.org/title/Waybar)<br />

> [!NOTE]
> The bind acts as a `toggle`; use it to start/stop the recording.<br /> Notifications are currently disabled since we'll be using an additional bash script to track the recording's duration via waybar module.

If you want the screen-recording notifications to display from your notification daemon, uncomment the notify-send lines in the bash file. I prefer the waybar module, it looks cleaner and gives you a headsup that you're recording in case you forget!

waybar recording_status module:<br />
![recording_status module](/docs/images/image-4.png)<br />
<details>
    <summary>screen-rec-selector previews (click to view)</summary>

![alt text](/docs/images/image-8.png)
![alt text](/docs/images/image-9.png)
</details>
<video controls src="/home/doccia/.config/hypr/docs/videos/2026-02-04_20-39-48.mp4" title="preview"></video>

Using your own dots? Follow the README instructions [here](https://github.com/conditionull/screen-rec-selector)