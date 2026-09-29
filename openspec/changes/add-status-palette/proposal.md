# Semantisk statuspalette

**Status:** Proposed
**Created:** 2026-09-29

## Why

Udredningsret-figurerne (og senere andre ikke-SPC-figurer i BFHddl) bruger
farven til at sige godt/skidt: udredt inden frist, overskredet frist,
ikke afgjort endnu. I dag sker det med ColorBrewer PRGn (grøn/lilla), som
ikke passer til BFH's visuelle identitet og BFHcharts' typst-skabelon.
BFHtheme har kun identitetsfarver (blå og grå) og ingen semantisk akse.

Accentfarven er valgt af brugeren på et prøveark (2026-09-29):
rust/rød `#c0392b` til "overskredet".

## What Changes

- Ny farve `status_overskredet = "#c0392b"` i `bfh_colors`.
- Ny palette `status` i `bfh_palettes`: overholdt (hospitalsblå),
  ikke afgjort (koncern-grå), overskredet (accent).
- Ny eksporteret `bfh_status_cols(gruppe, n)`: `n` nuancer inden for én
  gruppe, kraftigst først.
  - overholdt: `#007dbb`, derefter lyseblå fra `#99d8f6` til `#d8eef9`
  - ikke_afgjort: `#333333` → `#b8b8b8`
  - overskredet: accent, derefter accent blandet med op til 60 % hvid
- Ny eksporteret `bfh_status_values(grupper, rang = NULL)`: farver til en
  hel kategoriliste (fx fra BFHddl's kategoritabel), så hver gruppe får sine
  egne nuancer. `rang` angiver intensitet inden for gruppen (1 = kraftigst);
  default er rækkefølgen i `grupper`.

## Impact

- **Affected specs:** `status-palette` (ny capability)
- **Affected files:** `R/colors.R`, `tests/testthat/test-colors.R`, `NEWS.md`,
  `DESCRIPTION`, `NAMESPACE`, `man/`
- **Breaking:** Nej. Kun tilføjelser.
- **Downstream:** BFHddl's figurtyper og udredningsret-figurerne.
