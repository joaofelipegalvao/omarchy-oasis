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

### Method 1: Interactive Installer (Recommended)

```bash
# Clone the repository
git clone https://github.com/joaofelipegalvao/omarchy-oasis.git
cd omarchy-oasis

# Make the installer executable
chmod +x install.sh

# Run the installer
./install.sh
```

The installer will present an interactive menu where you can:

- Choose specific themes to install

- Install all themes at once

- View which themes are available

### Method 2: Install a Specific Theme

```bash
# Install only the Abyss theme
./install.sh abyss

# Install only the Starlight theme
./install.sh starlight
```

### Method 3: Manual Installation

```bash
# Clone the repository
git clone https://github.com/joaofelipegalvao/omarchy-oasis.git

# Copy the desired theme
cp -r omarchy-oasis/themes/abyss ~/.config/omarchy/themes/oasis-abyss

# Apply the theme
omarchy-theme-set oasis-abyss
```

## 🔄 Switching Themes

After installation, switch between themes using:

```bash
omarchy-theme-set oasis-abyss
omarchy-theme-set oasis-starlight
```

## 🌙 Dark Themes

Click any card below to view the full preview and screenshots. [↓ Or click here to view all full previews](#view-all-theme-styles)

### Dark Previews

<table>
  <tr>
    <td align="center"><a href="#abyss-dark"><img src="./assets/screenshots/abyss-dark-preview.png" alt="Abyss (dark)" width="auto"></a><br><strong>Abyss</strong><br><em>Black</em></td>
    <td align="center"><a href="#starlight-dark"><img src="./assets/screenshots/starlight-preview.png" alt="Starlight (dark)" width="auto"></a><br><strong>Starlight</strong><br><em>Black Vivid</em></td>
  </tr>
</table>

## ☀️ Light Themes

_Light theme variants coming soon!_

## 🎯 About

These themes are ports of the excellent [oasis](https://github.com/uhs-robert/oasis.nvim) colorscheme collection by uhs-robert. The original themes follow a warm/cool color split philosophy where:

- **Warm colors** = action/flow
- **Cool colors** = structure/data

All themes maintain WCAG AAA compliance standards for optimal readability.

## 📝 Repository Structure

This repository uses git branches to organize theme variations:

- Each branch contains a complete theme variation
- This keeps the repo organized without creating multiple repositories
- Easy to maintain and add new variations

# 👀 View All Theme Styles

<a id="view-all-theme-styles"></a>

<details open>
  <summary><b>All themes (click to collapse)</b></summary>
  <br/>
  <a id="dark-previews"></a>
  <details open>
    <summary><b>🌕️ Dark Themes</b></summary>
    <a id="abyss-dark"></a>
    <h3>Abyss (Dark · Black)</h3>
    <p>Pure black background with vivid desert-inspired colors. Perfect for OLED displays and late-night coding sessions.</p>
    <img src="./assets/screenshots/abyss-dark-preview.png"</img>
    <img src="./assets/screenshots/abyss-dark.png"></img>
    <p align="center">
      <a href="#dark-previews">↑ Back to Dark Themes</a>
    </p>
    <a id="starlight-dark"></a>
    <h3>Starlight (Dark · Black Vivid)</h3>
    <p>Black background with enhanced color vibrancy for maximum contrast and visual impact.</p>
    <img src="./assets/screenshots/starlight-preview.png"></img>
    <img src="./assets/screenshots/oasis-starlight.png"></img>
    <p align="center">
      <a href="#dark-previews">↑ Back to Dark Themes</a>
    </p>
  </details>
  <a id="light-previews"></a>
  <details>
    <summary><b>🌞 Light Themes</b></summary>
    <p><em>Light theme variants coming soon! Stay tuned for bright, readable themes perfect for daytime coding.</em></p>
  </details>
</details>

## 🙏 Acknowledgments

- Thanks to [dhh](https://github.com/DHH) for Omarchy
- Thanks to [uhs-robert](https://github.com/uhs-robert) for the original colorscheme [oasis](https://github.com/uhs-robert/oasis.nvim)
