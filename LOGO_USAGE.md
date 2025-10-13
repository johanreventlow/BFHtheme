# BFH Logo Anvendelse

Dette dokument forklarer hvordan man bruger BFH logoet i BFHtheme pakken.

## Logo Filer

Pakken inkluderer Bispebjerg og Frederiksberg Hospital logo i flere varianter:

### Logo Varianter

1. **Color** (Farve) - Fuld farve RGB logo med hospitalnavn
2. **Grey** (Gråtonet) - Gråtonet version til monokrom print
3. **Mark** (Mærke) - Kun hospital-symbolet uden tekst (kompakt)

### Størrelser

| Størrelse | Opløsning | Anvendelse |
|-----------|-----------|------------|
| `full` | 300 DPI | Print og høj kvalitet publikationer |
| `web` | 800px bredde | Standard brug i plots og web |
| `small` | 400px bredde | Små plots eller UI elementer |

## Grundlæggende Brug

### Enkel Metode (Anbefalet)

```r
library(BFHtheme)
library(ggplot2)

# Lav et plot
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_bfh()

# Tilføj farve logo (standard)
p_with_logo <- add_logo(p)
print(p_with_logo)

# Tilføj gråtonet logo
p_with_grey <- add_logo(p, variant = "grey")

# Tilføj kun mærket (kompakt)
p_with_mark <- add_logo(p, variant = "mark", size = 0.08)
```

### Specificer Position

```r
# Logo i top højre hjørne
add_logo(p, position = "topright")

# Logo i top venstre hjørne
add_logo(p, position = "topleft")

# Logo i bund venstre hjørne
add_logo(p, position = "bottomleft")

# Logo i bund højre hjørne (standard)
add_logo(p, position = "bottomright")
```

### Juster Logo Størrelse

```r
# Større logo (20% af plot bredde)
add_logo(p, size = 0.20)

# Mindre logo (10% af plot bredde)
add_logo(p, size = 0.10)

# Standard er 15%
add_logo(p, size = 0.15)
```

### Vælg Logo Variant og Opløsning

```r
# Farve logo (standard)
add_logo(p, variant = "color", logo_size = "web")

# Gråtonet logo til monokrom print
add_logo(p, variant = "grey", logo_size = "full")

# Kun hospital-mærke (kompakt)
add_logo(p, variant = "mark", logo_size = "web", size = 0.08)
```

### Anvendelsesscenarier for Logo-varianter

**Color (Farve)**
- Standard til alle farve-plots
- Præsentationer og web
- Farve publikationer

**Grey (Gråtonet)**
- Monokrom / sort-hvid print
- Når farvelogo ikke passer visuelt
- Professionelle dokumenter i gråtoner

**Mark (Mærke)**
- Når der er begrænset plads
- Små plots eller thumbnails
- Som diskret branding element
- Når logo-tekst er for lille til at læse

### Juster Gennemsigtighed

```r
# Delvis transparent logo (70% synlighed)
add_logo(p, alpha = 0.7)

# Fuldt synligt logo (standard)
add_logo(p, alpha = 0.9)

# Meget gennemsigtigt vandmærke
add_logo(p, alpha = 0.3)
```

## Avanceret Brug

### Manuel Logo Sti

Hvis du vil bruge logoet direkte:

```r
# Få sti til logo fil
logo_path <- get_bfh_logo("web")
print(logo_path)

# Brug med add_bfh_logo()
add_bfh_logo(p, logo_path, position = "topright", size = 0.15)
```

### Kombination med Andre Branding Elementer

```r
library(magrittr)  # For %>% pipe operator

p_fully_branded <- p %>%
  add_bfh_color_bar(position = "top") %>%
  add_logo(position = "bottomright") %>%
  add_bfh_footer(text = "Bispebjerg og Frederiksberg Hospital - 2024")

print(p_fully_branded)
```

### For Print Publikationer

```r
# Lav plot med højopløsnings logo
p_print <- ggplot(data, aes(x, y)) +
  geom_point() +
  theme_bfh_print()

# Tilføj logo i høj kvalitet
p_print_branded <- add_logo(
  p_print,
  position = "bottomright",
  size = 0.18,
  logo_size = "full",
  alpha = 0.95
)

# Gem med høj opløsning
bfh_save(
  "figure_for_publication.png",
  p_print_branded,
  preset = "report_full",
  dpi = 600
)
```

### For Præsentationer

```r
# Lav præsentations plot
p_presentation <- ggplot(data, aes(x, y, color = group)) +
  geom_point(size = 4) +
  theme_bfh_presentation() +
  scale_color_bfh(palette = "hospital")

# Tilføj større logo
p_pres_branded <- add_logo(
  p_presentation,
  position = "bottomright",
  size = 0.20,
  logo_size = "web"
)

# Gem til præsentation
bfh_save(
  "slide_figure.png",
  p_pres_branded,
  preset = "presentation_wide",
  dpi = 150
)
```

## Fejlfinding

### Logo Vises Ikke

Hvis logoet ikke vises, check følgende:

```r
# Verificer at logo findes
logo_path <- get_bfh_logo()
cat("Logo path:", logo_path, "\n")
cat("Logo exists:", file.exists(logo_path), "\n")

# Hvis FALSE, geninstaller pakken
devtools::install_local("path/to/BFHtheme")
```

### Logo Er For Stort/Lille

Juster `size` parameteren:

```r
# Prøv forskellige størrelser
add_logo(p, size = 0.08)  # Meget lille
add_logo(p, size = 0.12)  # Lille
add_logo(p, size = 0.15)  # Standard
add_logo(p, size = 0.20)  # Stor
add_logo(p, size = 0.25)  # Meget stor
```

### Logo Blokerer Data

Flyt logo til en anden position eller gør det mere transparent:

```r
# Anden position
add_logo(p, position = "topleft")

# Mere transparent
add_logo(p, position = "bottomright", alpha = 0.6)

# Mindre størrelse
add_logo(p, position = "bottomright", size = 0.10)
```

## Best Practices

1. **Standard brug**: Brug `add_logo()` uden parametre for standard placering
2. **Print**: Brug `logo_size = "full"` for publikationer
3. **Web/skærm**: Brug `logo_size = "web"` (standard)
4. **Præsentationer**: Brug større `size` (0.18-0.25) for synlighed
5. **Komplekse plots**: Placer logo hvor det ikke blokerer data
6. **Gennemsigtighed**: Hold `alpha` mellem 0.8-0.95 for god synlighed

## Eksempler

Se `inst/examples/logo_demo.R` for komplette eksempler på logo anvendelse.

## Source Files

Original logo fil: `Logo_Bispebjerg_og Frederiksberg_RGB.eps`
Konverterede filer: `inst/logo/*.png`
