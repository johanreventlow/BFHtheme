## ADDED Requirements

### Requirement: Valg af brand

BFHtheme SHALL have et aktivt brand, læst fra
`getOption("BFHtheme.brand")`, med gyldige værdier `"regionh"` og
`"regionoest"`. Er optionen ikke sat, SHALL brandet være `"regionh"`.

#### Scenario: Standardbrand

- **GIVEN** optionen `BFHtheme.brand` ikke er sat
- **WHEN** `get_bfh_brand()` kaldes
- **THEN** resultatet SHALL være `"regionh"`

#### Scenario: Skift brand

- **GIVEN** aktivt brand er `"regionh"`
- **WHEN** `old <- set_bfh_brand("regionoest")` kaldes
- **THEN** `get_bfh_brand()` SHALL returnere `"regionoest"`
- **AND** `old` SHALL være `"regionh"`

#### Scenario: Ukendt brand

- **WHEN** `set_bfh_brand("regionx")` kaldes, eller optionen er sat til `"regionx"` og `get_bfh_brand()` kaldes
- **THEN** funktionen SHALL fejle med en besked der nævner de gyldige værdier

### Requirement: Palettenavne følger brand

`bfh_pal()` og alle `scale_*_bfh*()`-funktioner SHALL resolvere de generiske
palettenavne `main`, `blues`, `blues_sequential`, `greys` og `infographic` til
henholdsvis `roe_main`, `roe_blues`, `roe_blues_seq`, `roe_warm` og
`roe_infographic`, når aktivt brand er `"regionoest"`. Andre palettenavne
SHALL ikke resolveres.

#### Scenario: main under regionoest

- **GIVEN** aktivt brand er `"regionoest"`
- **WHEN** `bfh_pal("main")(4)` kaldes
- **THEN** resultatet SHALL være farverne i `roe_main`

#### Scenario: main under regionh er uændret

- **GIVEN** aktivt brand er `"regionh"`
- **WHEN** `bfh_pal("main")(4)` kaldes
- **THEN** resultatet SHALL være farverne i den eksisterende `main`-palette

#### Scenario: Eksplicit palettenavn resolveres ikke

- **GIVEN** aktivt brand er `"regionoest"`
- **WHEN** `bfh_pal("hospital_blues")` kaldes
- **THEN** resultatet SHALL være baseret på `hospital_blues`

#### Scenario: Cache blandes ikke mellem brands

- **GIVEN** `bfh_pal("main")` er kaldt under `"regionh"`
- **WHEN** brand skiftes til `"regionoest"` og `bfh_pal("main")` kaldes igen
- **THEN** resultatet SHALL være baseret på `roe_main`

### Requirement: Tema og defaults følger brand

`theme_bfh()` SHALL bruge Region Østdanmarks varme gråtoner til tekst, linjer
og facet-baggrund, når aktivt brand er `"regionoest"`, og SHALL give uændret
output under `"regionh"`. `set_bfh_defaults()` SHALL bruge den
brand-resolverede palette til geom-defaults.

#### Scenario: Varme gråtoner i temaet

- **GIVEN** aktivt brand er `"regionoest"`
- **WHEN** `theme_bfh()` kaldes
- **THEN** `axis.text`'s farve SHALL være `#4d4a42`
- **AND** `strip.background`'s fyld SHALL være `#dbd7c8`

#### Scenario: Standardtema uændret

- **GIVEN** aktivt brand er `"regionh"`
- **WHEN** `theme_bfh()` kaldes
- **THEN** de eksisterende visuelle snapshots SHALL være uændrede

#### Scenario: Geom-defaults under regionoest

- **GIVEN** aktivt brand er `"regionoest"`
- **WHEN** `set_bfh_defaults()` kaldes
- **THEN** standardfarven for `geom_point` SHALL være `#1d394b`
