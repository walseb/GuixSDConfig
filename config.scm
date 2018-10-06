(use-modules (gnu) (gnu system nss) (gnu packages admin) (gnu packages multiprecision) (gnu packages mpd) (gnu packages gnupg) (gnu packages pdf) (gnu packages compression) (gnu packages xdisorg) (gnu 
packages fonts) (gnu packages xorg) (gnu packages imagemagick) (gnu packages code))

(use-service-modules networking ssh)

(use-package-modules 
                     certs
                     version-control
                     xorg
                     emacs
                     aspell
                     wget
                     ssh
                     pulseaudio
                     )

(operating-system
 (host-name "guix-VM")
 (timezone "Europe/Stockholm")
 (locale "en_US.utf8")

 ;; Use UEFI
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (target "/boot/efi")))

 ;; Use BIOS
 ;;(bootloader (bootloader-configuration
 ;;              (bootloader grub-bootloader)
 ;;              ;; VM disk
 ;;              (target "/dev/sda")))

 ;; VM support
 (initrd-modules (append (list "virtio_blk" "virtio_pci" "shpchp")
                         %base-initrd-modules))

 ;; Mount disk
 (file-systems (cons (file-system
                      (device (file-system-label "my-root"))
                      (mount-point "/")
                      (type "ext4"))
                     %base-file-systems))

 ;; Setup user
 (users (cons (user-account
               (name "admin")
               (comment "")
               (group "users")
               (supplementary-groups '("wheel" "netdev"
                                       "audio" "video"))
               (home-directory "/home/admin"))
              %base-user-accounts))

 ;; This is where we specify system-wide packages.
 (packages (cons* nss-certs         ;for HTTPS access
		  xorg-server
		  xinit
		  xrandr
		  xf86-input-evdev
                  setxkbmap
                  pulseaudio
                  pavucontrol
                  emacs
		  openssh
		  imagemagick
		  the-silver-searcher
		  ;;mono
		 ;; sensors
		  poppler
		  gnupg
		  pinentry
		  redshift
		  mpd
		  mpc
;;		  amixer
		  atool
		  htop
                  git
                  wget
                  aspell
                  aspell
                  aspell-dict-en
                  aspell-dict-sv
                  unzip
                  rxvt-unicode
		  ;; Xorg needs this
		  xterm
		  ;; Fonts
                  font-inconsolata
                  font-gnu-freefont-ttf
                  %base-packages))
 
 ;; Use the "desktop" services, which
 ;; include the X11 log-in service, networking with
 ;; NetworkManager, and more.
 ;; (services (cons* (gnome-desktop-service)
 ;;                  (xfce-desktop-service)
 ;;                  %desktop-services))
;; (services (cons*
;;            (dhcp-client-service)
  ;;          %desktop-services))

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))

