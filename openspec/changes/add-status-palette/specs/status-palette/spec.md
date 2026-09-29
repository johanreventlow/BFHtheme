# Status Palette Specification

**Capability:** status-palette

## ADDED Requirements

### Requirement: Semantiske statusgrupper

BFHtheme SHALL levere farver til tre statusgrupper: `overholdt` (blå),
`ikke_afgjort` (grå) og `overskredet` (accent `#c0392b`).

#### Scenario: Nuancer inden for en gruppe

- **GIVEN** `bfh_status_cols("overholdt", 5)`
- **THEN** resultatet SHALL være 5 hex-farver
- **AND** den første SHALL være `#007dbb`
- **AND** den sidste SHALL være `#d8eef9`

#### Scenario: Ukendt gruppe

- **GIVEN** `bfh_status_cols("groen", 2)`
- **THEN** funktionen SHALL fejle med en besked der nævner de gyldige grupper

### Requirement: Farver til en kategoriliste

`bfh_status_values(grupper, rang)` SHALL returnere én farve pr. element i
`grupper`, hvor elementer i samme gruppe får forskellige nuancer.

#### Scenario: Rang styrer intensitet

- **GIVEN** `bfh_status_values(c("overholdt", "overholdt"), rang = c(2, 1))`
- **THEN** det andet element SHALL få `#007dbb`
