# BFHtheme Farvepalette Oversigt

Dette dokument giver en komplet oversigt over alle farvepaletter i BFHtheme pakken.

## Officielle Farver

### Hospital Farver (Bispebjerg og Frederiksberg Hospital)

| Navn | Hex | RGB | Beskrivelse |
|------|-----|-----|-------------|
| `hospital_primary` | `#007dbb` | 0,125,187 | Primær identitetsfarve |
| `hospital_blue` | `#009ce8` | 0,156,232 | Sekundær blå |
| `hospital_light_blue1` | `#cce5f1` | 204,211,221 | Lys blå 1 |
| `hospital_light_blue2` | `#e5f2f8` | 229,242,248 | Lys blå 2 |
| `hospital_grey` | `#646c6f` | 100,108,111 | Hospital grå |
| `hospital_dark_grey` | `#333333` | 51,51,51 | Mørk grå |
| `hospital_white` | `#ffffff` | 255,255,255 | Hvid |

### Region Hovedstaden Farver (Koncern)

| Navn | Hex | RGB | Beskrivelse |
|------|-----|-----|-------------|
| `regionh_primary` | `#002555` | 0,37,85 | Primær identitetsfarve (Navy) |
| `regionh_blue` | `#007dbb` | 0,125,187 | Sekundær blå |
| `regionh_light_grey1` | `#ccd3dd` | 204,211,221 | Lys grå 1 |
| `regionh_light_grey2` | `#e5e9ee` | 229,233,238 | Lys grå 2 |
| `regionh_grey` | `#646c6f` | 100,108,111 | Region H grå |
| `regionh_dark_grey` | `#333333` | 51,51,51 | Mørk grå |
| `regionh_white` | `#ffffff` | 255,255,255 | Hvid |

## Farvepaletter

### Hospital Paletter

#### `hospital` / `main`
**Brug:** Primær palette til generel brug
**Farver:** `hospital_primary`, `hospital_blue`, `hospital_grey`, `dark_grey`
**Eksempel:**
```r
scale_color_bfh(palette = "hospital")
```

#### `hospital_blues`
**Brug:** Blå gradient, diskrete kategorier
**Farver:** `hospital_primary`, `hospital_blue`, `light_blue`, `very_light_blue`
**Eksempel:**
```r
scale_color_bfh(palette = "hospital_blues")
```

#### `hospital_blues_seq`
**Brug:** Sekventiel blå palette til kontinuerlige data
**Farver:** `hospital_primary` → `hospital_blue` → `light_blue` → `very_light_blue` → `white`
**Eksempel:**
```r
scale_fill_bfh_continuous(palette = "hospital_blues_seq")
```

#### `hospital_infographic`
**Brug:** Optimeret til infografik og datavisualisering
**Farver:** `hospital_primary`, `hospital_blue`, `light_blue`, `hospital_grey`, `dark_grey`
**Eksempel:**
```r
scale_fill_bfh(palette = "hospital_infographic")
```

### Region Hovedstaden Paletter

#### `regionh`
**Brug:** Primær Region H palette
**Farver:** `regionh_primary`, `regionh_blue`, `regionh_grey`, `dark_grey`
**Eksempel:**
```r
scale_color_bfh(palette = "regionh")
```

#### `regionh_main`
**Brug:** Hoved Region H palette
**Farver:** `regionh_primary`, `regionh_blue`, `regionh_light_grey1`, `regionh_grey`
**Eksempel:**
```r
scale_fill_bfh(palette = "regionh_main")
```

#### `regionh_blues`
**Brug:** Region H blå gradient
**Farver:** `regionh_primary`, `regionh_blue`, `regionh_light_grey1`, `regionh_light_grey2`
**Eksempel:**
```r
scale_color_bfh(palette = "regionh_blues")
```

#### `regionh_blues_seq`
**Brug:** Sekventiel Region H palette til kontinuerlige data
**Farver:** `regionh_primary` → `regionh_blue` → `regionh_light_grey1` → `regionh_light_grey2` → `white`
**Eksempel:**
```r
scale_fill_bfh_continuous(palette = "regionh_blues_seq")
```

#### `regionh_infographic`
**Brug:** Optimeret til Region H infografik
**Farver:** `regionh_primary`, `regionh_blue`, `regionh_light_grey1`, `regionh_grey`, `dark_grey`
**Eksempel:**
```r
scale_fill_bfh(palette = "regionh_infographic")
```

### Legacy/Kompatibilitet Paletter

Disse paletter er inkluderet for bagudkompatibilitet:

- `primary` - Bruger hospital primærfarver
- `blues` - Hospital blå gradient
- `blues_sequential` - Sekventiel hospital blå
- `greys` - Grå til lys blå
- `contrast` - Høj kontrast farver
- `infographic` - Generel infografik palette

## Anvendelseseksempler

### Hospital Branding
```r
library(BFHtheme)
library(ggplot2)

# Sæt hospital som standard
set_bfh_defaults(palette = "hospital")

# Lav et plot
ggplot(data, aes(x, y, color = gruppe)) +
  geom_point() +
  labs(title = "Bispebjerg og Frederiksberg Hospital")
```

### Region Hovedstaden Branding
```r
library(BFHtheme)
library(ggplot2)

# Sæt Region H som standard
set_bfh_defaults(palette = "regionh")

# Lav et plot
ggplot(data, aes(x, y, color = gruppe)) +
  geom_point() +
  labs(title = "Region Hovedstaden")
```

### Manuel Farvevælger
```r
# Hospital farver
bfh_cols("hospital_primary", "hospital_blue")

# Region H farver
bfh_cols("regionh_primary", "regionh_blue")

# Brug i plots
ggplot(data, aes(x, y, color = type)) +
  geom_point() +
  scale_color_manual(
    values = c(
      "Hospital" = bfh_cols("hospital_primary"),
      "Region H" = bfh_cols("regionh_primary")
    )
  )
```

## Visualisering af Paletter

For at se alle tilgængelige paletter visuelt:

```r
library(BFHtheme)

# Vis alle paletter
show_bfh_palettes()

# Vis med specifikt antal farver
show_bfh_palettes(n = 5)
```

## Reference

- Hospital farver: `RegionH_hospital_farver_infografik.pdf`
- Region Hovedstaden farver: `RegionH_koncern_farver_infografik.pdf`
- Opdateret: 2024

## Total Oversigt

**Antal farver:** 22 (inkl. aliases)
**Antal paletter:** 16
- Hospital paletter: 4
- Region H paletter: 5
- Legacy/kompatibilitet: 7
