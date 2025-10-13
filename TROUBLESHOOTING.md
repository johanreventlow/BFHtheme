# Fejlfinding (Troubleshooting)

Denne guide hjælper med at løse almindelige problemer med BFHtheme pakken.

## Installation Fejl

### Problem: Pakke kan ikke installeres

**Symptomer:**
```r
Error in install.packages: installation of package had non-zero exit status
```

**Løsning:**
1. Sikr at alle dependencies er installeret:
```r
install.packages(c("ggplot2", "grid", "grDevices", "scales"))
```

2. Geninstaller pakken:
```r
# Fjern gammel version først
remove.packages("BFHtheme")

# Installer på ny
install.packages("BFHtheme_0.1.0.tar.gz", repos = NULL, type = "source")
```

3. Genstart R session

## Farve/Scale Fejl

### Problem: "need at least two non-NA values to interpolate"

**Symptomer:**
```r
Error in interpolate(x, colors[, 1L]) :
  need at least two non-NA values to interpolate
```

**Løsning:**
Dette skyldes typisk en gammel cached version af pakken.

1. Genstart R sessionen fuldstændigt
2. Geninstaller pakken:
```r
remove.packages("BFHtheme")
install.packages("BFHtheme_0.1.0.tar.gz", repos = NULL, type = "source")
```

3. Load pakken på ny:
```r
library(BFHtheme)
library(ggplot2)
```

4. Test at paletten virker:
```r
# Check palette
print(bfh_palettes[["hospital"]])

# Test plot
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point() +
  scale_color_bfh(palette = "hospital")
```

### Problem: Farver ser ikke korrekte ud

**Løsning:**
Tjek at du bruger den rigtige palette:

```r
# Vis alle tilgængelige paletter
names(bfh_palettes)

# Vis farver i en specifik palette
print(bfh_palettes[["hospital"]])

# Visualiser alle paletter
show_bfh_palettes()
```

## Logo Fejl

### Problem: Logo vises ikke

**Symptomer:**
```r
Warning: BFH logo file not found in package
```

**Løsning:**
1. Verificer at logo er installeret:
```r
logo_path <- get_bfh_logo()
cat("Logo path:", logo_path, "\n")
cat("File exists:", file.exists(logo_path), "\n")
```

2. Hvis `FALSE`, geninstaller pakken:
```r
remove.packages("BFHtheme")
install.packages("BFHtheme_0.1.0.tar.gz", repos = NULL, type = "source")
```

### Problem: Logo kvalitet er dårlig

**Løsning:**
Brug højere opløsning version:

```r
# For print - brug "full" version
add_logo(plot, logo_size = "full")

# For web - brug "web" version (default)
add_logo(plot, logo_size = "web")
```

### Problem: Logo er for stort/lille

**Løsning:**
Juster `size` parameteren:

```r
# Mindre logo (8% af plot bredde)
add_logo(plot, size = 0.08)

# Større logo (20% af plot bredde)
add_logo(plot, size = 0.20)
```

## Tema Fejl

### Problem: Tekst vises ikke korrekt

**Løsning:**
Tjek font indstillinger:

```r
# Brug standard sans font
p + theme_bfh(base_family = "sans")

# Eller specificer custom font hvis installeret
p + theme_bfh(base_family = "Helvetica")
```

### Problem: Tema ikke anvendt

**Løsning:**
Sikr at tema er tilføjet til plottet:

```r
# FORKERT - tema mangler
ggplot(data, aes(x, y)) + geom_point()

# KORREKT - tema tilføjet
ggplot(data, aes(x, y)) + geom_point() + theme_bfh()
```

## Gem Plot Fejl

### Problem: `bfh_save()` fejler

**Symptomer:**
```r
Error in ggsave: filename cannot be found
```

**Løsning:**
Sikr at directory eksisterer:

```r
# Opret directory hvis nødvendigt
dir.create("output", showWarnings = FALSE)

# Gem plot
bfh_save("output/plot.png", plot)
```

## Performance Problemer

### Problem: Langsom rendering

**Løsning:**
1. Reducer plot størrelse:
```r
bfh_save("plot.png", plot, preset = "report_half")
```

2. Reducer DPI for preview:
```r
bfh_save("plot.png", plot, dpi = 150)  # Hurtigere
```

3. Brug simpelt tema:
```r
p + theme_bfh_minimal()  # Færre elementer = hurtigere
```

## R Session Problemer

### Problem: Ændringer vises ikke

**Løsning:**
Genstart R session helt:

**RStudio:**
- Session → Restart R (Ctrl/Cmd + Shift + F10)

**R Console:**
```r
.rs.restartR()  # RStudio
# eller quit og genstart R
```

## Få Hjælp

Hvis problemet fortsætter:

1. Check pakke version:
```r
packageVersion("BFHtheme")
```

2. Check R version:
```r
R.version.string
```

3. Check session info:
```r
sessionInfo()
```

4. Opret en issue på GitHub med:
   - Fejlbesked
   - Din kode
   - Session info
   - Forventet vs faktisk resultat

## Common Workflow

**Anbefalet arbejdsgang for at undgå problemer:**

```r
# 1. Start med ren session
# Restart R session

# 2. Load pakker
library(BFHtheme)
library(ggplot2)

# 3. Verificer pakke virker
print(names(bfh_palettes))

# 4. Lav dit plot
p <- ggplot(data, aes(x, y, color = group)) +
  geom_point() +
  theme_bfh() +
  scale_color_bfh(palette = "hospital")

# 5. Tilføj branding
p_final <- add_logo(p)

# 6. Gem
bfh_save("output.png", p_final, preset = "report_full")
```

## Debug Tips

Aktivér verbose output for at se hvad der sker:

```r
# Check at alle farver eksisterer
sapply(c("hospital_primary", "hospital_blue"), function(x) {
  cat(x, ":", bfh_cols(x), "\n")
})

# Check palette indhold
str(bfh_palettes[["hospital"]])

# Test scale funktion direkte
test_pal <- bfh_pal("hospital")
print(test_pal(5))  # Should return 5 colors
```
