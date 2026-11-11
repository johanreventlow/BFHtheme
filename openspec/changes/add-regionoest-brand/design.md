# Design: add-regionoest-brand

## Context

BFHtheme har i dag én visuel identitet (BFH/Region H) bygget ind som statiske
objekter: `bfh_colors` (navngiven vektor), `bfh_palettes` (navngiven liste),
hårdkodede `grey*`-farver i `theme_bfh()` og BFH-logofiler i
`get_bfh_logo()`. Downstream (BFHcharts, SPCify) kalder typisk
`theme_bfh()`, `scale_*_bfh(palette = "main")` og `add_bfh_logo()`.

## Goals / Non-Goals

**Goals**
- Region Østdanmark-farver og -paletter tilgængelige nu, uden at ændre
  eksisterende output.
- Ét sted at skifte brand, så downstream kan afprøve det nye design uden
  kodeændringer.
- Overgangen (fase 3) bliver en ændring af én standardværdi.

**Non-Goals**
- Skifte standardbrand nu.
- Brev-/rapportlayout (grid, rubrikker, forsider) – det hører til
  downstream-skabeloner.
- Gøre de eksporterede objekter `bfh_colors`/`bfh_palettes` dynamiske.

## Decisions

### 1. Farver tilføjes til `bfh_colors` med præfiks `roe_`

Navne følger guidens danske farvenavne (ASCII-translittereret), så de kan
spores direkte til farvearket – samme princip som `status_overskredet`.

| Gruppe | Navn | HEX |
|---|---|---|
| Primær | `roe_primaer_lys` | `#9fd4f6` |
| | `roe_blaa` (Region Østdanmark Blå) | `#77b8d9` |
| | `roe_primaer_moerk` | `#1d394b` |
| | `roe_tekst` (Primær Tekst) | `#191815` |
| Varme gråtoner | `roe_varm_10` / `_30` / `_40` / `_50` / `_70` / `_80` | `#191815` / `#4d4a42` / `#666152` / `#928e7e` / `#bebbac` / `#dbd7c8` |
| Sekundær | `roe_moerkegroen`, `roe_olivengroen`, `roe_lysegroen` | `#2f3f15`, `#7d8931`, `#bbc772` |
| | `roe_kastanjebrun`, `roe_brun`, `roe_sand` | `#613216`, `#8f5831`, `#c7a48a` |
| | `roe_bordeaux`, `roe_rosa`, `roe_lyseroed` | `#8c2547`, `#ef709a`, `#fdb0ca` |
| | `roe_moerkeblaa`, `roe_himmelblaa`, `roe_lyseblaa` | `#07397e`, `#007bc2`, `#62b5e5` |
| | `roe_roed`, `roe_orange`, `roe_amber` | `#cd0d13`, `#f8851c`, `#ffc72e` |
| | `roe_blomme`, `roe_violet`, `roe_lavendel` | `#70396d`, `#b273b2`, `#e2b1e3` |

`roe_tekst` og `roe_varm_10` har samme værdi; begge bevares, fordi guiden
navngiver dem separat.

Alternativ overvejet: separat objekt `roe_colors`. Fravalgt, fordi
`bfh_cols()`, `bfh_pal()` og validering så skulle kende to kilder.

### 2. Paletter

| Palette | Farver |
|---|---|
| `roe_main` | primaer_moerk, blaa, varm_50, varm_30 |
| `roe_blues` | primaer_moerk, blaa, primaer_lys |
| `roe_blues_seq` | primaer_moerk, blaa, primaer_lys, white |
| `roe_warm` | varm_10, varm_30, varm_50, varm_70, varm_80 |
| `roe_warm_seq` | varm_10, varm_30, varm_50, varm_70, varm_80, white |
| `roe_infographic` | primaer_moerk, blaa, primaer_lys, varm_50, varm_30 |
| `roe_categorical` | moerkeblaa, orange, olivengroen, bordeaux, himmelblaa, amber, blomme, brun |

**Førstefarve:** Første farve i `main` bruges som geom-default i
`set_bfh_defaults()`. Region Østdanmark Blå `#77b8d9` har kun ca. 2,1:1
kontrast mod hvid (under WCAG's 3:1 for grafiske elementer), mens Primær Mørk
`#1d394b` har ca. 12:1. Derfor står Primær Mørk først. Skal bekræftes.

`roe_categorical` er et forslag ud fra sekundærpaletten (skiftevis
mørk/lys og forskellige farvefamilier) og bør farveblindhedstjekkes inden
den anbefales.

### 3. Brandkontakt via option

- `getOption("BFHtheme.brand", "regionh")` er sandhedskilden. En option kan
  sættes i `.Rprofile`, i en Shiny-app eller i en test uden at kalde pakken.
- `get_bfh_brand()` læser og validerer (ukendt værdi → fejl med gyldige
  værdier).
- `set_bfh_brand(brand)` validerer, sætter optionen, rydder palettecachen og
  returnerer forrige brand usynligt (så `on.exit(set_bfh_brand(old))` virker).
- Gyldige værdier: `"regionh"`, `"regionoest"`.

### 4. Brand-resolvering af palettenavne

Intern tabel `.bfh_brand_palettes`:

| Generisk navn | regionh | regionoest |
|---|---|---|
| `main` | `main` | `roe_main` |
| `blues` | `blues` | `roe_blues` |
| `blues_sequential` | `blues_sequential` | `roe_blues_seq` |
| `greys` | `greys` | `roe_warm` |
| `infographic` | `infographic` | `roe_infographic` |

Øvrige navne (`hospital_*`, `regionh_*`, `roe_*`, `status`, `primary`,
`contrast`) resolveres ikke – eksplicitte navne betyder altid det samme.

`bfh_pal()` resolverer navnet før opslag, og cachenøglen inkluderer brand.
`.create_bfh_scale()` går gennem `bfh_pal()` og følger derfor automatisk med.
`set_bfh_defaults()` ændres til at bruge den resolverede palette.

**Bevidst konsekvens:** `bfh_palettes$main` (det statiske objekt) er altid
Region H. Det dokumenteres; anbefalet adgang er `bfh_pal()`.

### 5. Neutrale farver i `theme_bfh()`

Intern `.bfh_neutrals(brand)` returnerer de farver, temaet i dag hardkoder.
For `"regionh"` returneres præcis de nuværende værdier, så output er
uændret.

| Rolle | Brug i temaet | regionh | regionoest |
|---|---|---|---|
| `text` | akseetiketter og aksetitler | `grey30` | `roe_varm_30` |
| `caption` | plot.caption | `grey50` | `roe_varm_50` |
| `line` | aksestreg, ticks | `grey70` | `roe_varm_70` |
| `line_minor` | minor ticks | `grey80` | `roe_varm_70` |
| `strip_fill` | facet-baggrund | `grey95` | `roe_varm_80` |

Titler/undertitler arver basistekstfarven; for `"regionoest"` sættes
`text = element_text(colour = roe_tekst)`. Funktionssignaturen ændres ikke –
brand læses ved kald.

### 6. Logo

`get_bfh_logo(size = "web", variant = "color", brand = get_bfh_brand())`.
Region Østdanmark-filer navngives `roe_logo.png`, `roe_logo_web.png`,
`roe_logo_small.png`, `roe_logo_grey.png`, `roe_logo_grey_web.png`,
`roe_mark.png`, `roe_mark_web.png` – samme mønster som BFH. Mangler en fil,
gælder den eksisterende adfærd (warning + `NULL`).

`add_bfh_logo()` ændres ikke; den kalder `get_bfh_logo()` og følger brand.

## Risks / Trade-offs

- **Hårdkodede farvenavne downstream følger ikke kontakten.** Fx
  `bfh_cols("hospital_primary")`. Afbødning: audit af BFHcharts/SPCify før
  fase 3; evt. senere rollebaserede navne (fx `bfh_role_cols("primary")`)
  som separat forslag.
- **Global option = skjult tilstand.** Afbødning: `get_bfh_brand()` gør den
  synlig, og `set_bfh_brand()` returnerer forrige værdi til gendannelse.
- **Logofiler mangler.** Logodelen kan først færdiggøres, når kommunikation
  leverer filer; farver og brandkontakt kan leveres uafhængigt.

## Migration Plan

1. Fase 1+2 i en minor version (dette forslag).
2. Downstream afprøver med `set_bfh_brand("regionoest")`.
3. Fase 3 (separat forslag): standard skifter til `"regionoest"`; Region H
   fortsat tilgængelig via `set_bfh_brand("regionh")`, derefter deprecation
   efter pakkens breaking change-politik.
