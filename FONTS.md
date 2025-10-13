# BFH Font Håndtering

BFHtheme pakken understøtter intelligent font-valg med automatisk fallback.

## Font Prioritering

Pakken prøver følgende skrifttyper i prioriteret rækkefølge:

1. **Mari Office** (Primær) - BFH's officielle skrifttype
2. **Mari** (Alternativ) - Alternativt navn
3. **Roboto** (Fallback) - Open source Google font
4. **Arial** (Backup) - Universal fallback
5. **sans** (System) - System default

## Automatisk Font Valg

Alle temaer vælger automatisk den bedste tilgængelige font:

```r
library(BFHtheme)
library(ggplot2)

# Automatisk font-valg
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh()  # Vælger automatisk bedste font
```

## Manuel Font Valg

Du kan også specificere font manuelt:

```r
# Brug specifik font
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh(base_family = "Mari Office")

# Eller via get_bfh_font()
font <- get_bfh_font()
theme_bfh(base_family = font)
```

## Tjek Tilgængelige Fonts

```r
# Check hvilke BFH fonts er installeret
check_bfh_fonts()
```

Output:
```
=== BFH Font Availability ===

Mari Office    : ✓ Available
Mari           : ✗ Not found
Roboto         : ✓ Available
Arial          : ✓ Available

Recommended font: Mari Office
```

## Mari Office Font

**For BFH Medarbejdere:**

Mari/Mari Office er BFH's officielle corporate font og er pre-installeret på alle medarbejder-computere. Ingen handling nødvendig - pakken vil automatisk bruge den.

**For Eksterne Brugere:**

Mari Office er en copyrighted font og kan ikke distribueres med pakken. Brug i stedet Roboto som fallback.

## Roboto Font (Open Source)

Roboto er en gratis, open-source font fra Google (Apache License 2.0).

### Installation med showtext (Anbefalet)

```r
# Install showtext pakken
install.packages("showtext")

# Load Roboto automatisk fra Google Fonts
library(showtext)
font_add_google("Roboto", "Roboto")
showtext_auto()

# Brug i plots
library(BFHtheme)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh(base_family = "Roboto")
```

### Manuel Installation

**macOS:**
```bash
# Via Homebrew
brew install --cask font-roboto

# Eller download fra: https://fonts.google.com/specimen/Roboto
# og dobbeltklik .ttf filer for at installere
```

**Windows:**
1. Download fra: https://fonts.google.com/specimen/Roboto
2. Højreklik på .ttf filer
3. Vælg "Install"

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get install fonts-roboto

# Fedora
sudo dnf install google-roboto-fonts
```

### Helper Funktion

```r
# Få installations-instruktioner
install_roboto_font()
```

## Font Setup Workflow

### Option 1: Automatisk (Anbefalet)

Lad pakken vælge bedste font automatisk:

```r
library(BFHtheme)
library(ggplot2)

# Intet setup nødvendigt
ggplot(data, aes(x, y)) +
  geom_point() +
  theme_bfh()  # Bruger automatisk bedste font
```

### Option 2: Med showtext (For Roboto)

```r
library(showtext)
font_add_google("Roboto", "Roboto")
showtext_auto()

library(BFHtheme)
library(ggplot2)

ggplot(data, aes(x, y)) +
  geom_point() +
  theme_bfh(base_family = "Roboto")
```

### Option 3: Setup Global Font

```r
library(BFHtheme)

# Setup BFH fonts globally
font <- setup_bfh_fonts()

# Eller med showtext
font <- setup_bfh_fonts(use_showtext = TRUE)

# Nu bruger alle plots denne font automatisk
library(ggplot2)
ggplot(data, aes(x, y)) +
  geom_point() +
  theme_bfh()
```

### Option 4: Set as Default for Session

```r
library(BFHtheme)

# Set BFH fonts som default for hele session
set_bfh_fonts()

# Nu bruger ALLE plots (selv uden theme_bfh) BFH fonts
library(ggplot2)
ggplot(data, aes(x, y)) +
  geom_point() +
  theme_minimal()  # Bruger også BFH font
```

## Font Tjek Pakker

Pakken kan bruge flere pakker til at tjekke fonts:

**systemfonts** (Anbefalet):
```r
install.packages("systemfonts")
```

**extrafont** (Alternativ):
```r
install.packages("extrafont")

# Første gang: Import alle system fonts
library(extrafont)
font_import()  # Kan tage flere minutter
```

**showtext** (For Google Fonts):
```r
install.packages("showtext")
```

## Eksempler

### Basis Plot med Auto Font

```r
library(BFHtheme)
library(ggplot2)

ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  theme_bfh() +  # Auto-vælger Mari Office/Roboto/Arial
  labs(title = "Automatisk Font Valg")
```

### Specificer Font Manuelt

```r
# Brug Mari Office (hvis tilgængelig)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh(base_family = "Mari Office") +
  labs(title = "Med Mari Office Font")

# Brug Roboto
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh(base_family = "Roboto") +
  labs(title = "Med Roboto Font")
```

### Med showtext for Roboto

```r
library(showtext)
font_add_google("Roboto", "Roboto")
showtext_auto()

library(BFHtheme)
library(ggplot2)

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh(base_family = "Roboto") +
  labs(title = "Roboto via Google Fonts")
```

## Fejlfinding

### Font vises ikke korrekt

1. Check tilgængelige fonts:
```r
check_bfh_fonts()
```

2. Genstart R session efter font installation

3. For Roboto via showtext, sikr `showtext_auto()` er kaldt

### Font findes ikke

```r
# Check hvad pakken bruger
font <- get_bfh_font()
print(font)

# Prøv med showtext
library(showtext)
font_add_google("Roboto", "Roboto")
showtext_auto()
```

### Font ser anderledes ud

Nogle fonts renderer forskelligt afhængigt af:
- Output device (screen vs PDF vs PNG)
- DPI indstillinger
- OS (macOS vs Windows vs Linux)

For konsistent output, brug showtext:
```r
library(showtext)
showtext_opts(dpi = 300)  # Match din save DPI
```

## Best Practices

1. **For BFH Medarbejdere**: Ingen handling nødvendig, Mari Office bruges automatisk

2. **For Eksterne**: Installer Roboto for bedste resultater

3. **For Publikationer**: Brug showtext for konsistent font-rendering på tværs af platforme

4. **For Præsentationer**: Standard fonts (Arial/sans) fungerer ofte fint

5. **Font Størrelse**: Juster via `base_size` parameter:
   - Standard: 12
   - Print: 14
   - Præsentation: 16

```r
theme_bfh(base_size = 14)  # Større tekst
```

## License Information

- **Mari Office**: Copyright BFH - Kun til BFH medarbejdere
- **Roboto**: Apache License 2.0 (Open Source)
- **Arial**: Proprietary (Pre-installed på de fleste systemer)
- **sans**: System dependent

## Resourcer

- Roboto Font: https://fonts.google.com/specimen/Roboto
- showtext pakke: https://github.com/yixuan/showtext
- systemfonts pakke: https://github.com/r-lib/systemfonts
