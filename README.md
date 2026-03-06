# Ricing Dotfiles

Kumpulan config ricing pribadi untuk Linux desktop.

## Isi

- hypr
- kitty
- swaync
- waybar
- rofi
- wlogout
- gtk-3.0
- gtk-4.0
- nwg-look
- xsettingsd
- htop
- dolphinrc
- mimeapps.list
- user-dirs.dirs
- user-dirs.locale

## Pakai cepat

Clone ke home, lalu symlink sesuai kebutuhan (contoh):

```bash
ln -sfn ~/dotfiles-ricing/hypr ~/.config/hypr
ln -sfn ~/dotfiles-ricing/kitty ~/.config/kitty
ln -sfn ~/dotfiles-ricing/swaync ~/.config/swaync
ln -sfn ~/dotfiles-ricing/waybar ~/.config/waybar
```

> Cek isi sebelum dipakai agar tidak menimpa setup yang tidak diinginkan.

## Restore semua config

Jalankan script berikut dari root repo untuk restore semua config ke versi dotfiles ini:

```bash
./restore.sh
```

Cek dulu tanpa mengubah file:

```bash
./restore.sh --dry-run
```
