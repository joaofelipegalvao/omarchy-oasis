<p align="center">
  <img
    src="./assets/logo.png"
    width="auto" height="128" alt="logo" />
</p>

# Omarchy Oasis Themes

A collection of desert-inspired Omarchy themes ported from [oasis](https://github.com/uhs-robert/oasis.nvim). Each theme variation is maintained in its own branch for easy installation and management.

## 🎨 Available Themes

- **abyss** - Dark · Black
- **starlight** - Dark · Black Vivid

_More themes coming soon as I port them from the original collection._

## 📦 Installation

Since each theme variation lives in its own git branch, install them manually:

### Abyss
```bash
git clone -b abyss https://github.com/joaofelipegalvao/omarchy-oasis.git ~/.config/omarchy/themes/oasis-abyss
omarchy-theme-set oasis-abyss
```

### Starlight
```bash
git clone -b starlight https://github.com/joaofelipegalvao/omarchy-oasis.git ~/.config/omarchy/themes/oasis-starlight

omarchy-theme-set oasis-starlight
```

## 🔄 Switching Themes

After installation, switch between themes using:

```bash
omarchy-theme-set oasis-abyss
omarchy-theme-set oasis-starlight
```

## 🌙 Theme Previews

<table>
  <tr>
    <td align="center">
      <img src="./assets/screenshots/abyss-preview.png" alt="Abyss" width="400">
      <br>
      <strong>Abyss</strong>
      <br>
      <em>Dark · Black</em>
    </td>
    <td align="center">
      <img src="./assets/screenshots/starlight-preview.png" alt="Starlight" width="400">
      <br>
      <strong>Starlight</strong>
      <br>
      <em>Dark · Black Vivid</em>
    </td>
  </tr>
</table>

### Abyss (Dark · Black)
Pure black background with vivid desert-inspired colors. Perfect for OLED displays and late-night coding sessions.

<details>
<summary>📸 View full screenshot</summary>
<br>

![Abyss Full](./assets/screenshots/oasis-abyss.png)

</details>

### Starlight (Dark · Black Vivid)
Black background with enhanced color vibrancy for maximum contrast and visual impact.

<details>
<summary>📸 View full screenshot</summary>
<br>

![Starlight Full](./assets/screenshots/oasis-starlight.png)

</details>

## 🎯 About

These themes are ports of the excellent [oasis.nvim](https://github.com/uhs-robert/oasis.nvim) colorscheme collection by uhs-robert. The original themes follow a warm/cool color split philosophy where:

- **Warm colors** = action/flow
- **Cool colors** = structure/data

All themes maintain WCAG AAA compliance standards for optimal readability.

## 📝 Repository Structure

This repository uses git branches to organize theme variations:
- Each branch contains a complete theme variation
- This keeps the repo organized without creating multiple repositories
- Easy to maintain and add new variations

## 🙏 Acknowledgments 

- Thanks to @dhh for Omarchy
- Thanks to @uhs-robert for the original colorscheme [oasis](https://github.com/uhs-robert/oasis.nvim)
