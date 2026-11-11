# Tasks

## 1. Fase 1 – farver og paletter (additivt)
- [ ] 1.1 Tilføj de 28 `roe_*`-farver til `bfh_colors` (`R/colors.R`)
- [ ] 1.2 Tilføj `roe_*`-paletterne til `bfh_palettes`
- [ ] 1.3 Tests: alle `roe_*` er gyldige hex og matcher farvearket;
      paletterne findes og har forventet længde
- [ ] 1.4 Opdatér `PALETTE_OVERVIEW.md` med Region Østdanmark-sektion

## 2. Fase 2 – brandkontakt
- [ ] 2.1 Ny `R/brand.R`: `get_bfh_brand()`, `set_bfh_brand()`,
      `.bfh_brand_palettes`, validering
- [ ] 2.2 `bfh_pal()`: resolvér generiske palettenavne efter brand;
      cachenøgle inkluderer brand
- [ ] 2.3 `set_bfh_defaults()`: brug resolveret palette
- [ ] 2.4 `theme_bfh()`: neutrale farver via `.bfh_neutrals(brand)`
- [ ] 2.5 Tests: standardbrand er `"regionh"`; ukendt brand fejler;
      `set_bfh_brand()` returnerer forrige værdi; `bfh_pal("main")` skifter
      med brand; eksplicitte navne skifter ikke; cache blandes ikke mellem brands
- [ ] 2.6 Tests: `theme_bfh()` under `"regionoest"` bruger varme gråtoner;
      eksisterende visuelle snapshots for `"regionh"` er uændrede
- [ ] 2.7 Nye vdiffr-snapshots for `theme_bfh()` + `scale_color_bfh()` under
      `"regionoest"`

## 3. Logo (afhænger af filer fra kommunikation)
- [ ] 3.1 Modtag Region Østdanmark-logofiler (farve, grå, mærke; full/web/small)
- [ ] 3.2 Læg filer i `inst/logo/` som `roe_*.png`
- [ ] 3.3 `get_bfh_logo()`: nyt sidste argument `brand = get_bfh_brand()`
- [ ] 3.4 Tests: `get_bfh_logo(brand = "regionoest")` finder filerne;
      `add_bfh_logo()` uden sti bruger Region Øst-mærket under `"regionoest"`

## 4. Afslutning
- [ ] 4.1 roxygen-dokumentation, `devtools::document()`
- [ ] 4.2 `NEWS.md`, minor version bump i `DESCRIPTION`
- [ ] 4.3 `devtools::test()` og `devtools::check()` grønne
- [ ] 4.4 Notér downstream (BFHcharts, SPCify) om muligheden for at afprøve
