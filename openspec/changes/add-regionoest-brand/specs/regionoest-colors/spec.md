## ADDED Requirements

### Requirement: Region Østdanmark-farver

`bfh_colors` SHALL indeholde Region Østdanmarks 28 officielle farver med
præfikset `roe_`: 4 primærfarver, 6 varme gråtoner og 18 sekundærfarver,
med hex-værdier som angivet i farvearkene.

#### Scenario: Primærfarve kan hentes

- **WHEN** `bfh_cols("roe_blaa")` kaldes
- **THEN** resultatet SHALL være `#77b8d9`

#### Scenario: Varm gråtone kan hentes

- **WHEN** `bfh_cols("roe_varm_30")` kaldes
- **THEN** resultatet SHALL være `#4d4a42`

#### Scenario: Eksisterende farver er uændrede

- **WHEN** en eksisterende farve, fx `bfh_cols("hospital_primary")`, kaldes
- **THEN** resultatet SHALL være det samme som før ændringen (`#007dbb`)

### Requirement: Region Østdanmark-paletter

`bfh_palettes` SHALL indeholde paletterne `roe_main`, `roe_blues`,
`roe_blues_seq`, `roe_warm`, `roe_warm_seq`, `roe_infographic` og
`roe_categorical`, udelukkende bygget af `roe_*`-farver og `white`.

#### Scenario: Palette bruges i en skala

- **WHEN** `scale_color_bfh(palette = "roe_main")` lægges på et plot
- **THEN** plottet SHALL bruge farverne fra `roe_main`
- **AND** førstefarven SHALL være `#1d394b` (Primær Mørk)

#### Scenario: Sekventiel palette ender i hvid

- **WHEN** `bfh_palettes$roe_blues_seq` læses
- **THEN** sidste farve SHALL være `#ffffff`
