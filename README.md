# BFHtheme

<!-- badges: start -->
[![R-CMD-check](https://github.com/johanreventlow/BFHtheme/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/johanreventlow/BFHtheme/actions/workflows/R-CMD-check.yaml)
[![lint](https://github.com/johanreventlow/BFHtheme/actions/workflows/lint.yaml/badge.svg)](https://github.com/johanreventlow/BFHtheme/actions/workflows/lint.yaml)
[![test-coverage](https://github.com/johanreventlow/BFHtheme/actions/workflows/test-coverage.yml/badge.svg)](https://github.com/johanreventlow/BFHtheme/actions/workflows/test-coverage.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.5.2-blue.svg)](DESCRIPTION)
<!-- badges: end -->

> ggplot2-tema og farvepaletter for Bispebjerg og Frederiksberg Hospital samt Region Hovedstaden

**BFHtheme** giver publikationsklar theming til ggplot2-grafik, der følger
den visuelle identitet for Bispebjerg og Frederiksberg Hospital (BFH) og
Region Hovedstaden. Pakken leverer pæne standardindstillinger, officielle
farvepaletter, robust font-detektion og hjælpeværktøjer til logo og branding.

Pakken bruges som theming-fundament for downstream-pakkerne **BFHcharts**
(SPC-visualisering) og **SPCify** (Shiny-applikation).

## Indhold

- [Funktioner](#funktioner)
- [Installation](#installation)
- [Kom godt i gang](#kom-godt-i-gang)
- [Brug](#brug)
- [Farver](#farver)
- [Typografi og fonts](#typografi-og-fonts)
- [Logo og branding](#logo-og-branding)
- [Dokumentation (vignetter)](#dokumentation-vignetter)
- [Pakke-struktur](#pakke-struktur)
- [Udvikling](#udvikling)
- [Bidrag](#bidrag)
- [Licens](#licens)

## Funktioner

- **Farvepaletter** – officielle paletter for både hospital og Region H,
  inkl. sekventielle og infografik-varianter
- **Tema** – `theme_bfh()` bygget på `theme_minimal()` med marquee-titler
- **Scale-funktioner** – farve-/fyld-scales (diskret + kontinuert) samt
  akse-scales med BFH-stilformatering
- **Hjælpeværktøjer** – gemning med presets, plot-kombination, knitr-defaults
- **Branding** – logo, footer og titelblokke
- **Globale defaults** – sæt BFH-styling som standard for hele R-sessionen
- **Robust font-detektion** – via `systemfonts` med graceful fallback

## Installation

```r
# Fra GitHub (kræver remotes eller devtools)
# install.packages("remotes")
remotes::install_github("johanreventlow/BFHtheme")
```

Pakken bruger to branches: `develop` er integrationsbranch for løbende
arbejde, mens `main` er release-branch. Installér en specifik branch med:

```r
remotes::install_github("johanreventlow/BFHtheme", ref = "develop")
```

**Bemærk:** Enkelte funktioner kræver Suggests-pakker, der ikke installeres
automatisk:

- `add_bfh_logo()` kræver `cowplot`
- `use_bfh_knitr_defaults()` udnytter `ragg` (anbefalet til knitr/Quarto)
- `showtext`-baseret font-embedding kræver `showtext` + `sysfonts`

```r
install.packages(c("cowplot", "ragg", "svglite"))
```

## Kom godt i gang

```r
library(BFHtheme)
library(ggplot2)

# Sæt BFH-defaults for alle plots i sessionen
set_bfh_defaults()

# Plots bruger nu automatisk BFH-tema og -farver
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  bfh_labs(
    title = "Vægt vs. brændstoføkonomi",  # Titel i naturlig case
    x = "vægt (1000 lbs)",                # Akseetiketter sættes til VERSALER
    y = "miles per gallon"
  )

# Gendan ggplot2's oprindelige defaults igen
reset_bfh_defaults()
```

## Brug

### Tema

```r
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh()

# Justerbar via base_size / base_family og efterfølgende theme()-kald
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh(base_size = 14) +
  theme(legend.position = "bottom")
```

`theme_bfh()` har signaturen
`theme_bfh(base_size = 12, base_family = NULL, base_line_size = base_size/22, base_rect_size = base_size/22)`.
Når `base_family = NULL` (default) auto-detekteres den bedste tilgængelige
font (se [Typografi og fonts](#typografi-og-fonts)).

### Farve- og fyld-scales

```r
# Diskrete farver
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_bfh(palette = "main") +
  theme_bfh()

# Kontinuerte farver
ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  scale_fill_bfh_continuous(palette = "blues") +
  theme_bfh()
```

Tilgængelige scales:

| Type | Funktioner |
|------|------------|
| Diskret farve/fyld | `scale_color_bfh()`, `scale_fill_bfh()` (samt `scale_colour_bfh()`) |
| Eksplicit diskret | `scale_color_bfh_discrete()`, `scale_fill_bfh_discrete()` |
| Kontinuert | `scale_color_bfh_continuous()`, `scale_fill_bfh_continuous()` |

`scale_color_bfh()` tager `palette = "main"`, `discrete = TRUE` og
`reverse = FALSE`. De kontinuerte og eksplicit-diskrete varianter defaulter
til palette `"blues"` hhv. `"main"`.

### Akse-scales (BFH-stil)

Akse-scales sætter som standard etiketter til VERSALER, hvilket matcher
BFH's visuelle retningslinjer:

```r
ggplot(economics, aes(date, unemploy)) +
  geom_line() +
  theme_bfh() +
  scale_x_date_bfh() +
  scale_y_continuous_bfh()
```

Familien dækker: `scale_x_continuous_bfh()`, `scale_y_continuous_bfh()`,
`scale_x_discrete_bfh()`, `scale_y_discrete_bfh()`, `scale_x_date_bfh()`,
`scale_y_date_bfh()`, `scale_x_datetime_bfh()`, `scale_y_datetime_bfh()`.

### Etiketter med `bfh_labs()`

`bfh_labs()` følger BFH-konventionen: hovedtitlen bevares i naturlig case,
mens undertitel, caption, akseetiketter og legend-titler sættes til VERSALER.

```r
ggplot(data, aes(date, value, color = group)) +
  geom_line() +
  theme_bfh() +
  bfh_labs(
    title    = "Patientforløb over tid",   # → uændret
    subtitle = "2020-2024",                # → "2020-2024"
    x        = "dato",                     # → "DATO"
    y        = "antal patienter",          # → "ANTAL PATIENTER"
    color    = "afdeling"                  # → "AFDELING"
  )
```

Du kan altid bruge ggplot2's standard `labs()`, hvis du foretrækker anden
formatering.

### Gemning af plots

`bfh_save()` understøtter navngivne størrelse-presets eller egne dimensioner:

```r
p <- ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_bfh()

# Presets: report_full (7x5"), report_half (3.5x3"), presentation (10x6"),
#          presentation_wide (12x6.75"), square (6x6"), poster (12x9")
bfh_save("rapport.png", p, preset = "report_full")
bfh_save("praesentation.png", p, preset = "presentation")

# Egne dimensioner (overskriver preset)
bfh_save("custom.png", p, width = 10, height = 6, dpi = 600)
```

### Kombination af plots

```r
p1 <- ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_bfh()
p2 <- ggplot(mtcars, aes(hp, qsec)) + geom_point() + theme_bfh()

bfh_combine_plots(list(p1, p2), ncol = 2, legend_position = "bottom")
```

### knitr / Quarto

```r
# I et setup-chunk: aktivér anbefalede grafik-devices og dpi
use_bfh_knitr_defaults(dpi = 300)
```

## Farver

Pakken eksporterer den navngivne vektor `bfh_colors` samt accessoren
`bfh_cols()`.

**Hospital-farver (Bispebjerg og Frederiksberg Hospital):**

| Navn | Hex | Beskrivelse |
|------|-----|-------------|
| `hospital_primary` | `#007dbb` | Primær identitetsfarve |
| `hospital_blue` | `#009ce8` | Sekundær blå |
| `hospital_light_blue1` | `#99d8f6` | Lys blå |
| `hospital_light_blue2` | `#d8eef9` | Meget lys blå |

**Region Hovedstaden-farver (koncern):**

| Navn | Hex | Beskrivelse |
|------|-----|-------------|
| `regionh_primary` | `#002555` | Primær identitetsfarve (navy) |
| `regionh_blue` | `#007dbb` | Sekundær blå |
| `regionh_light_grey1` | `#ccd3dd` | Lys grå 1 |
| `regionh_light_grey2` | `#e5e9ee` | Lys grå 2 |

**Neutrale + UI-hjælpefarver:**
`regionh_grey` (`#646c6f`), `regionh_dark` (`#333333`), `regionh_white`
(`#ffffff`) samt `ui_grey_light/soft/mid/dark`. Korte aliaser findes også
(`primary`, `blue`, `light_blue`, `grey`, `dark_grey`, `white`, `navy` m.fl.).

```r
# Hele vektoren
bfh_colors

# Udtræk specifikke farver (officielle navne eller aliaser)
bfh_cols("hospital_primary", "hospital_blue")
bfh_cols("blue", "grey")
```

### Paletter

Paletterne er defineret i `bfh_palettes` og bruges af `bfh_pal()` og
`scale_*_bfh*()`-funktionerne.

**Hospital:** `main` / `hospital`, `hospital_blues`, `hospital_blues_seq`,
`hospital_infographic`

**Region H:** `regionh`, `regionh_main`, `regionh_blues`,
`regionh_blues_seq`, `regionh_infographic`

**Generiske/kompatibilitet:** `primary`, `blues`, `blues_sequential`,
`greys`, `contrast`, `infographic`

```r
# Vis alle paletter
show_bfh_palettes()

# Interpolér en palette til n farver
bfh_pal("main")(5)
bfh_pal("blues", reverse = TRUE)(3)
```

### Egne paletter

```r
# Byg en palette af eksisterende BFH-farver
mine_farver <- bfh_cols("hospital_primary", "hospital_blue",
                        "regionh_grey", "dark_grey")

ggplot(data, aes(x, y, color = group)) +
  geom_point() +
  scale_color_manual(values = mine_farver)
```

## Typografi og fonts

BFHtheme vælger automatisk den bedste tilgængelige font via `systemfonts`
(matcher både OS-installerede og runtime-registrerede fonts). Prioritet:

1. **Mari** – BFH's officielle font (proprietær, kun på BFH-computere)
2. **Mari Office** – alternativt navn på nogle systemer
3. **Roboto** – fri open source-erstatning (Apache 2.0)
4. **Arial** – system-fallback
5. **sans** – universel fallback

```r
# Returnér valgt font (caches efter første kald)
get_bfh_font()

# Tving genskanning efter installation af nye fonts
get_bfh_font(force_refresh = TRUE)
```

### Eksterne brugere uden Mari

Installér **Roboto** på systemet for visuel kompatibilitet med BFH-output.
Hent fra [Google Fonts](https://fonts.google.com/specimen/Roboto), eller på
macOS via `brew install --cask font-roboto`. Genstart R-sessionen efter
installation, så `systemfonts` kan opdage fonten.

> **Bemærk om `showtext`:** Roboto bliver **ikke** indlæst automatisk blot
> ved at installere `showtext`. Embedding via showtext er en avanceret,
> opt-in mekanisme. De fleste brugere bør i stedet bruge system-fonts med
> moderne grafik-devices (`ragg`, `svglite`, `cairo_pdf`). Se vignetten
> *fonts-and-typography* for detaljer.

```r
# Brug en valgfri font eksplicit
theme_bfh(base_family = "Roboto")
```

## Logo og branding

```r
p <- ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_bfh()

# Tilføj BFH-logo (default: BFH-mærke, nederst til venstre). Kræver cowplot.
p_logo <- add_bfh_logo(p)

# Eget logo eller justeret gennemsigtighed
p_logo <- add_bfh_logo(p, logo_path = get_bfh_logo(size = "web"), alpha = 0.8)

# Tilføj branded footer
p_footer <- add_bfh_footer(p, text = "Bispebjerg og Frederiksberg Hospital")

# Branded titelblok
bfh_title_block(
  title    = "Rapporttitel",
  subtitle = "Undertitel",
  caption  = "Datakilde"
)
```

`add_bfh_logo()` har signaturen `add_bfh_logo(plot, logo_path = NULL,
alpha = 1)` og placerer som standard BFH-mærket nederst til venstre.
Hent logo-stier med `get_bfh_logo(size, variant)`:

- `size`: `"full"`, `"web"` (default), `"small"`
- `variant`: `"color"` (default), `"grey"`, `"mark"`

Logo-filer leveres i `inst/logo/`.

## Dokumentation (vignetter)

Pakken indeholder uddybende vignetter:

| Vignet | Emne |
|--------|------|
| `getting-started` | Introduktion og første plot |
| `theming` | `theme_bfh()` i dybden |
| `palette-overview` | Alle farver og paletter |
| `customization` | Egne paletter og tilpasninger |
| `fonts-and-typography` | Font-detektion, Roboto, showtext |
| `logo-and-branding` | Logo, footer, titelblokke |
| `troubleshooting` | Fejlsøgning af fonts og devices |

```r
vignette(package = "BFHtheme")
vignette("getting-started", package = "BFHtheme")
```

## Pakke-struktur

```
BFHtheme/
├── R/
│   ├── themes.R            # theme_bfh()
│   ├── colors.R            # bfh_colors, bfh_cols(), bfh_palettes, bfh_pal()
│   ├── scales.R            # farve-, fyld- og akse-scales
│   ├── fonts.R             # font-detektion med session-caching
│   ├── helpers.R           # bfh_save(), bfh_combine_plots(), bfh_labs()
│   ├── branding.R          # add_bfh_logo(), add_bfh_footer(), bfh_title_block()
│   ├── logo_helpers.R      # get_bfh_logo()
│   ├── defaults.R          # set_bfh_defaults(), reset_bfh_defaults()
│   ├── knitr_setup.R       # use_bfh_knitr_defaults()
│   ├── utils_operators.R   # %||%
│   ├── utils_validation.R  # validate_* hjælpere
│   └── BFHtheme-package.R  # pakke-dokumentation
├── inst/
│   ├── logo/               # hospital- og Region H-logoer
│   └── examples/           # kørbare eksempler
├── vignettes/              # uddybende dokumentation
├── tests/testthat/         # unit-tests
├── man/                    # auto-genereret dokumentation
├── DESCRIPTION
├── NAMESPACE
└── README.md
```

## Udvikling

```r
devtools::load_all()    # Indlæs pakken til test
devtools::document()    # Generér docs + NAMESPACE
devtools::test()        # Kør tests
devtools::check()       # Fuldt pakke-tjek

# Kodekvalitet
styler::style_pkg()
lintr::lint_package()
covr::package_coverage()
```

**Branch- og CI-workflow:** `develop` er integrationsbranch; `main` er
release-branch og opdateres kun via PR fra `develop`. CI (R-CMD-check, lint,
test-coverage) kører på push og PR mod begge branches.

## Bidrag

Bidrag er velkomne. Se [CONTRIBUTING.md](CONTRIBUTING.md) for retningslinjer
om pakke-arkitektur, hjælpekonventioner (`%||%`, `validate_*()`),
caching-strategi, kodestil og test-krav.

Kort tjekliste:

1. Tjek eksisterende issues før du opretter et nyt
2. Brug validation-hjælpere og `%||%`-operatoren
3. Følg kodestil (snake_case, input-validering, `call. = FALSE` i fejl)
4. Skriv tests for ny funktionalitet (mål: ≥90% coverage)
5. Kør `devtools::document()` ved ændrede roxygen-kommentarer

Breaking changes kræver major version bump, deprecation-warnings i en minor
først samt notifikation til downstream-pakkerne BFHcharts og SPCify.

## Licens

MIT – se [LICENSE](LICENSE).

## Kontakt

Bispebjerg og Frederiksberg Hospital.

---

*Farver er baseret på Region Hovedstadens officielle visuelle
identitetsretningslinjer.*
