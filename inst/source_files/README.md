# Source Files

Dette directory indeholder kilde-filer til BFHtheme pakken.

**Bemærk:** Disse filer inkluderes IKKE i den byggede R-pakke (se `.Rbuildignore`).

## Color Guidelines (PDF)

- `RegionH_hospital_farver_infografik.pdf` - Officielle hospital farver (BFH)
- `RegionH_koncern_farver_infografik.pdf` - Officielle Region Hovedstaden farver

Disse PDF'er dokumenterer de officielle farvepaletter brugt i pakken.

## Logo Source Files (EPS)

- `Logo_Bispebjerg_og Frederiksberg_RGB.eps` - Fuld farve logo (RGB)
- `Logo_Bispebjerg_og Frederiksberg_Grey.eps` - Gråtonet logo
- `Hospital_Maerke_RGB.eps` - Hospital mærke/symbol (RGB)

Disse EPS-filer er vektor source files der er konverteret til PNG format.

## Konvertering

Logoer blev konverteret med følgende kommando (1200 DPI, høj kvalitet):

```bash
gs -dNOPAUSE -dBATCH -sDEVICE=pngalpha -r1200 \
   -dTextAlphaBits=4 -dGraphicsAlphaBits=4 \
   -sOutputFile=output.png input.eps
```

Derefter trimmet for gennemsigtig baggrund:

```bash
magick input.png -trim +repage output.png
```

## Brug i Udvikling

Hvis du vil regenerere logo-filerne:

1. Kør konverteringskommandoerne ovenfor
2. Trim gennemsigtig baggrund
3. Opret web og small versioner med resize
4. Kopier til `inst/logo/` directory

Se `inst/logo/` for de færdige PNG-filer der bruges i pakken.
