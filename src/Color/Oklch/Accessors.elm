module Color.Oklch.Accessors exposing (color, oklab)

{-| Color.Oklch.Accessors

@docs color, oklab

-}

import Base exposing (Iso)
import Color exposing (Color)
import Color.Oklab exposing (Oklab)
import Color.Oklch
    exposing
        ( Oklch
        , fromColor
        , fromOklab
        , toColor
        , toOklab
        )
import Color.Round as Round


{-| color: This accessor lets you convert between oklch & avh4/elm-color

    import Accessors exposing (..)
    import Color.Oklch.Accessors exposing (..)
    import Color


    new color <| get color Color.red
    --> Color.red

-}
color : Iso fd vw st rv Color Oklch x y
color =
    Base.iso "color_oklch" fromColor (toColor >> Round.rgb)


{-| oklab: This accessor lets you convert between oklch & avh4/elm-color

    import Accessors exposing (get, new)
    import Color


    new (color << oklab) <| get (color << oklab) Color.red
    --> Color.red

-}
oklab : Iso fd vw st rv Oklch Oklab x y
oklab =
    Base.iso "oklch_oklab" toOklab fromOklab
