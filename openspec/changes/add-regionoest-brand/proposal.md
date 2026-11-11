# Region Østdanmark som valgfri brandprofil

**Status:** Proposed
**Created:** 2026-11-11

## Why

Region Hovedstaden indgår i Region Østdanmark, som har en ny visuel identitet
(farver, varme gråtoner, nyt logo). BFHtheme og de pakker der bygger på den
(BFHcharts, SPCify) skal på et tidspunkt over på det nye design, men det
nuværende Region H/BFH-design skal være standard indtil overgangen besluttes.

Vi vil derfor kunne:

1. bruge Region Østdanmark-farverne allerede nu, uden at ændre eksisterende
   output (fase 1), og
2. skifte hele pakken til Region Østdanmark med én linje, så downstream kan
   afprøve det nye udseende uden kodeændringer (fase 2).

Kilde: "Region Øst Brevdesign V5 Guide" (PDF) og tre farveark
(primærfarver, varme gråtoner, sekundær palet), modtaget 2026-11-11.

## What Changes

**Fase 1 – additivt (ingen ændring af eksisterende output):**

- 28 nye farver i `bfh_colors` med præfiks `roe_`: 4 primærfarver,
  6 varme gråtoner og 18 sekundærfarver.
- Nye paletter i `bfh_palettes`: `roe_main`, `roe_blues`, `roe_blues_seq`,
  `roe_warm`, `roe_warm_seq`, `roe_infographic`, `roe_categorical`.
- `get_bfh_logo()` får et nyt sidste argument `brand`, så Region
  Østdanmark-logoer kan hentes. Logofilerne leveres af kommunikation.

**Fase 2 – opt-in brandkontakt:**

- Nye eksporterede funktioner `set_bfh_brand()` og `get_bfh_brand()`, bakket
  af `options(BFHtheme.brand = "regionh" | "regionoest")`. Standard er
  `"regionh"`.
- Når brand er `"regionoest"`:
  - de generiske palettenavne (`main`, `blues`, `blues_sequential`, `greys`,
    `infographic`) i `bfh_pal()` og `scale_*_bfh*()` peger på `roe_*`-paletterne
  - `theme_bfh()` bruger varme gråtoner i stedet for neutrale `grey*`
  - `set_bfh_defaults()` bruger den brand-resolverede palette
  - standardlogoet i `get_bfh_logo()` / `add_bfh_logo()` er Region Østdanmark

**Ikke omfattet:** fonte (Mari → Roboto → Arial passer allerede),
`add_bfh_footer()` (tekst afhænger af logo/navnebeslutning), statuspaletten,
skift af standardbrand (fase 3), samt brev-/rapportlayout (hører til
downstream-skabeloner, ikke BFHtheme).

## Impact

- **Affected specs:** `brand-profile` (ny), `regionoest-colors` (ny),
  `branding-api` (MODIFIED: Default Logo Asset)
- **Affected files:** `R/colors.R`, `R/themes.R`, `R/logo_helpers.R`,
  `R/defaults.R`, ny `R/brand.R`, `inst/logo/`, tests, `NEWS.md`,
  `PALETTE_OVERVIEW.md`, `DESCRIPTION`, `NAMESPACE`, `man/`
- **Breaking:** Nej. Standard er uændret, og eksisterende funktionssignaturer
  bevares (kun nyt sidste argument i `get_bfh_logo()`). Visuelle snapshots
  for standardbrand skal være uændrede.
- **Downstream:** BFHcharts og SPCify kan afprøve med
  `set_bfh_brand("regionoest")`. Hårdkodede farvenavne (fx
  `bfh_cols("hospital_primary")`) følger ikke kontakten – se design.md.

## Open Questions

1. **Logo:** Skal BFH have et hospitalslogo med Region Øst-mærket (som
   "Sjællands Universitetshospital" i guiden) eller bruge Region
   Østdanmark-logoet? Filer skal leveres af kommunikation.
2. **Toner uden HEX:** Tabelrækker og beige forsidebokse i guiden bruger lyse
   toner, som ikke står i paletten. Udeladt indtil værdier foreligger.
3. **Godkendelse:** Er farvearkene tilstrækkelig godkendelse af de nye
   hex-værdier (jf. "Color hex values kræver godkendelse")?
4. **Førstefarve i `roe_main`:** Se design.md – foreslået Primær Mørk pga.
   kontrast.

## Related

- GitHub Issue: (oprettes ved godkendelse)
