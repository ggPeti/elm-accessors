module Color.Palette.Accessors exposing (hexA, solid, transparent)

{-| Color.Palette.Accessors

@docs hexA, solid, transparent

-}

import Base exposing (Iso, Prism)
import Color exposing (Color)
import Color.Round as Round
import SolidColor exposing (SolidColor)
import TransparentColor exposing (TransparentColor)


{-| transparent: This accessor lets you convert between avh4/elm-color & tesk9/palette TransparentColor

    import Accessors exposing (get, new)
    import Color


    new transparent <| get transparent Color.red
    --> Color.red

-}
transparent : Iso fd vw st rv Color TransparentColor x y
transparent =
    Base.iso "color_transparent"
        paletteFromColor
        (TransparentColor.toRGBA
            >> Round.mapAlpha TransparentColor.opacityToFloat
            >> Round.rgba255ToDecimal
            >> Color.fromRgba
        )


{-| solid: This accessor lets you convert between tesk9/palette TransparentColor && SolidColor

    import Accessors exposing (get, new)
    import Color


    new (transparent << solid) <| get (transparent << solid) Color.red
    --> Color.red

-}
solid : Iso fd vw st rv TransparentColor SolidColor x y
solid =
    Base.iso "color_solid" TransparentColor.toColor (TransparentColor.fromColor TransparentColor.opaque)


{-| hex: This accessor lets you convert between tesk9/palette TransparentColor && SolidColor

    import Accessors exposing (from, new, try)
    import Color


    new (hexA << from transparent) Color.red
    -->  "#CC0000"
    try (hexA << from transparent) "#C00F" -- with alpha channel
    --> Just Color.red

-}
hexA : Prism fd st rv String TransparentColor x y
hexA =
    Base.prism "color_hexa"
        TransparentColor.toHexA
        TransparentColor.fromHexA


paletteFromColor : Color -> TransparentColor
paletteFromColor =
    Color.toRgba
        >> Round.decimalTo255
        >> Round.mapAlpha TransparentColor.customOpacity
        >> TransparentColor.fromRGBA
