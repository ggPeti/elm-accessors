module Base exposing
    ( Optic
    , Iso, Lens, Prism, Traversal
    , Fold, Getter, Setter, Review, Blind, Case, Injector
    , iso, lens, prism, traversal
    , get, all, try, has, map, set, new, name, to, from
    , ixd
    , Iso_, Lens_, Prism_, Traversal_
    , Fold_, Getter_, Setter_, Review_, Blind_
    , Case_, Injector_
    , An_Optic, An_Iso, A_Lens, A_Prism
    , An_Optic_, An_Iso_, A_Lens_, A_Prism_
    , A_Fold, A_Getter, A_Setter, A_Review, A_Case, An_Injector
    , A_Fold_, A_Getter_, A_Setter_, A_Review_, A_Case_, An_Injector_
    )

{-|


# Optics

@docs Optic
@docs Iso, Lens, Prism, Traversal
@docs Fold, Getter, Setter, Review, Blind, Case, Injector


# Build your own accessors

Accessors are built using these functions:

@docs iso, lens, prism, traversal


# Actions

@docs get, all, try, has, map, set, new, name, to, from, over


# Accessor Lifters for Indexed operations

@docs ixd


## Type aliases for custom and action functions

@docs Iso_, Lens_, Prism_, Traversal_
@docs Fold_, Getter_, Setter_, Review_, Blind_
@docs Case_, Injector_
@docs An_Optic, An_Iso, A_Lens, A_Prism
@docs An_Optic_, An_Iso_, A_Lens_, A_Prism_
@docs A_Fold, A_Getter, A_Setter, A_Review, A_Case, An_Injector
@docs A_Fold_, A_Getter_, A_Setter_, A_Review_, A_Case_, An_Injector_

-}


{-| A `Optic value view over` is a type describing how to interact with a
`sub` data when given a `super` data.

The `wrap` exists because some types can't ensure that `get` will return a
`sub`. For instance, `Maybe sub` may not actually contain a `sub`. Therefore,
`get` returns a `wrap` which, in that example, will be `Maybe sub`

Implementation: A relation is a banal record storing a `get` function and an
`over` function.

-}
type Optic_ fd vw st rv s t a b
    = Optic (Internal s t a b)


type alias Internal s t a b =
    { view : s -> a
    , make : b -> t
    , over : (a -> b) -> s -> t
    , list : s -> List a
    , name : String
    }


internal : Optic_ fd vw st rv s t a b -> Internal s t a b
internal (Optic i) =
    i


{-| Any Optic.
-}
type alias Optic fd vw st rv s t a b x y =
    Optic_ fd vw st rv a b x y -> Optic_ fd vw st rv s t x y


{-| Any Optic that cannot change types.
-}
type alias An_Optic fd vw st rv s a =
    An_Optic_ fd vw st rv s s a a


{-| Any Optic.
-}
type alias An_Optic_ fd vw st rv s t a b =
    Optic fd vw st rv s t a b a b


{-| The isomorphism preserves fold, view, set, and review capabilities.
-}
type alias Iso fd vw st rv s a x y =
    Iso_ fd vw st rv s s a a x y


{-| The isomorphism preserves fold, view, set, and review capabilities.
-}
type alias Iso_ fd vw st rv s t a b x y =
    Optic fd vw st rv s t a b x y


{-| This MUST be an Iso.
-}
type alias An_Iso s a =
    An_Iso_ s s a a


{-| This MUST be an Iso.
-}
type alias An_Iso_ s t a b =
    Optic () () () () s t a b a b


{-| `Lens` that cannot change type of the object.
-}
type alias Lens fd st vw s a x y =
    Lens_ fd st vw s s a a x y


{-| The lens preserves fold, set, and view capabilities.
-}
type alias Lens_ fd st vw s t a b x y =
    Optic fd vw st Never s t a b x y


{-| This MUST be a non-type changing Lens, Iso, or equivalent optic with fold, view, and set capabilities.
-}
type alias A_Lens rv s a =
    A_Lens_ rv s s a a


{-| This MUST be a Lens, Iso, or equivalent optic with fold, view, and set capabilities.
-}
type alias A_Lens_ rv s t a b =
    Optic () () () rv s t a b a b


{-| `Prism` that cannot change the type of the object.
-}
type alias Prism fd st rv s a x y =
    Prism_ fd st rv s s a a x y


{-| The prism can fold, set, and review.
-}
type alias Prism_ fd st rv s t a b x y =
    Optic fd Never st rv s t a b x y


{-| This MUST be a non-type changing Prism, Iso, or equivalent optic with fold and review capabilities.
-}
type alias A_Prism vw st s a =
    A_Prism_ vw st s s a a


{-| This MUST be a Prism, Iso, or equivalent optic with fold and review capabilities.
-}
type alias A_Prism_ vw st s t a b =
    Optic () vw st () s t a b a b


{-| `Traversal` that cannot change the type of the object.
-}
type alias Traversal fd st s a x y =
    Traversal_ fd st s s a a x y


{-| The traversal can fold and set.
-}
type alias Traversal_ fd st s t a b x y =
    Optic fd Never st Never s t a b x y


{-| `Fold` that cannot change the type of the object.
-}
type alias Fold fd s a x y =
    Fold_ fd s s a a x y


{-| The fold can fold.
-}
type alias Fold_ fd s t a b x y =
    Optic fd Never Never Never s t a b x y


{-| `Getter` that cannot change the type of the object.
-}
type alias Getter vw fd s a x y =
    Getter_ vw fd s s a a x y


{-| The getter preserves view and fold capabilities.
-}
type alias Getter_ vw fd s t a b x y =
    Optic fd vw Never Never s t a b x y


{-| `Setter` that cannot change the type of the object.
-}
type alias Setter st s a x y =
    Setter_ st s s a a x y


{-| The setter can set.
-}
type alias Setter_ st s t a b x y =
    Optic Never Never st Never s t a b x y


{-| `Review` that cannot change the type of the object.
-}
type alias Review rv s a x y =
    Review_ rv s s a a x y


{-| The review can review.
-}
type alias Review_ rv s t a b x y =
    Optic Never Never Never rv s t a b x y


{-| `Blind` optic that cannot fold, view, set, or review.
-}
type alias Blind s a x y =
    Blind_ s s a a x y


{-| The blind optic has no action capabilities.
-}
type alias Blind_ s t a b x y =
    Optic Never Never Never Never s t a b x y


{-| `Case` that cannot change the type of the object.
-}
type alias Case fd rv s a x y =
    Case_ fd rv s s a a x y


{-| The case can fold and review.
-}
type alias Case_ fd rv s t a b x y =
    Optic fd Never Never rv s t a b x y


{-| `Injector` that cannot change the type of the object.
-}
type alias Injector st rv s a x y =
    Injector_ st rv s s a a x y


{-| The injector can set and review.
-}
type alias Injector_ st rv s t a b x y =
    Optic Never Never st rv s t a b x y


{-| This MUST be a non-type changing optic with a fold capability.
-}
type alias A_Fold vw st rv s a =
    A_Fold_ vw st rv s s a a


{-| This MUST be an optic with a fold capability.
-}
type alias A_Fold_ vw st rv s t a b =
    Optic () vw st rv s t a b a b


{-| This MUST be a non-type changing optic with a view capability.
-}
type alias A_Getter st rv s a =
    A_Getter_ st rv s s a a


{-| This MUST be an optic with a view capability.
-}
type alias A_Getter_ st rv s t a b =
    Optic () () st rv s t a b a b


{-| This MUST be a non-type changing optic with a set capability.
-}
type alias A_Setter fd vw rv s a =
    A_Setter_ fd vw rv s s a a


{-| This MUST be an optic with a set capability.
-}
type alias A_Setter_ fd vw rv s t a b =
    Optic fd vw () rv s t a b a b


{-| This MUST be a non-type changing optic with a review capability.
-}
type alias A_Review fd vw st s a =
    A_Review_ fd vw st s s a a


{-| This MUST be an optic with a review capability.
-}
type alias A_Review_ fd vw st s t a b =
    Optic fd vw st () s t a b a b


{-| This MUST be a non-type changing optic with fold and review capabilities.
-}
type alias A_Case vw st s a =
    A_Case_ vw st s s a a


{-| This MUST be an optic with fold and review capabilities.
-}
type alias A_Case_ vw st s t a b =
    Optic () vw st () s t a b a b


{-| This MUST be a non-type changing optic with set and review capabilities.
-}
type alias An_Injector fd vw s a =
    An_Injector_ fd vw s s a a


{-| This MUST be an optic with set and review capabilities.
-}
type alias An_Injector_ fd vw s t a b =
    Optic fd vw () () s t a b a b


type alias A_Traversal_ vw rv s t a b =
    Optic () vw () rv s t a b a b


{-| This exposes a description field that's necessary for use with the name function
for getting unique names out of compositions of accessors. This is useful when you
want type safe keys for a Dictionary but you still want to use elm/core implementation.

    foo : Optic attr attrView attrOver -> Optic { rec | foo : attr } view over
    foo =
        Accessors.lens ".foo" .foo (\rec new -> { rec | foo = new })

-}
lens :
    String
    -> (s -> a)
    -> (s -> b -> t)
    -- Any optic composed with a Lens becomes "at least a Lens".
    -> Lens_ fd st vw s t a b x y
lens n sa sbt sub =
    let
        over_ : (a -> b) -> s -> t
        over_ f s =
            s |> sa |> f |> sbt s
    in
    Optic
        { list = sa >> List.singleton
        , view = sa
        , make = void "Can't call `make` with a Lens"
        , over = over_
        , name = n
        }
        |> dot sub


{-| A prism constructor.

Parameters are: reconstructor and a splitter.

Reconstructor takes a final value and constructs a final object.

The splitter turns initial object either to final object directly (if initial object is of wrong variant),
or spits out `a`.

-}
prism :
    String
    -> (b -> t)
    -> (s -> Result t a)
    -> Prism_ fd st rv s t a b x y
prism n bt sta sub =
    let
        over_ : (a -> b) -> s -> t
        over_ f =
            sta >> Result.map (f >> bt) >> mergeResult
    in
    Optic
        { view = void "Can't call `view` with a Prism"
        , list =
            sta
                >> Result.map (\a -> [ a ])
                >> Result.withDefault []
        , make = bt
        , over = over_
        , name = n
        }
        |> dot sub


mergeResult : Result a a -> a
mergeResult r =
    case r of
        Ok a ->
            a

        Err a ->
            a


traversal :
    String
    -> (s -> List a)
    -> ((a -> b) -> s -> t)
    -> Traversal_ fd st s t a b x y
traversal n sa abst sub =
    Optic
        { view = void "Can't call `view` with a Traversal"
        , make = void "Can't call `make` with a Traversal"
        , list = sa
        , over = abst
        , name = n
        }
        |> dot sub


{-| An isomorphism constructor.
-}
iso :
    String
    -> (s -> a)
    -> (b -> t)
    -> Iso_ fd vw st rv s t a b x y
iso n sa bt sub =
    let
        over_ : (a -> b) -> s -> t
        over_ f =
            bt << f << sa
    in
    Optic
        { view = sa
        , list = sa >> List.singleton
        , make = bt
        , over = over_
        , name = n
        }
        |> dot sub


dot : Optic_ fd vw st rv u v a b -> Optic_ fd vw st rv s t u v -> Optic_ fd vw st rv s t a b
dot (Optic attribute) (Optic structure) =
    Optic
        { list = structure.list >> List.concatMap attribute.list
        , view = structure.view >> attribute.view
        , make = structure.make << attribute.make
        , over = structure.over << attribute.over
        , name = structure.name ++ attribute.name
        }


ixd : A_Traversal_ vw rv s t a b -> Traversal_ fd st ( ix, s ) t a b x y
ixd p =
    traversal (name p)
        (\( _, b ) -> all p b)
        (\fn -> Tuple.mapSecond (map p fn) >> Tuple.second)



-- {-| Get the inverse of an isomorphism
-- -}


from : An_Iso_ s t a b -> b -> t
from =
    get << swap


swap : An_Iso_ s t a b -> An_Iso_ b a t s
swap accessor =
    let
        i =
            id
                |> accessor
                |> internal
    in
    iso (String.reverse i.name)
        i.make
        i.view


{-| Alias of `get` for isomorphisms
-}
to : An_Iso_ s t a b -> s -> a
to =
    get


id : Optic_ fd vw st rv a b a b
id =
    Optic
        { view = identity
        , make = identity
        , over = identity
        , list = List.singleton
        , name = ""
        }



-- Actions


{-| Used with a Prism, think of `!!` boolean coercion in Javascript except type safe.

    Just 1234
        |> has try
    --> True

    Nothing
        |> has try
    --> False

    ["Stuff", "things"]
        |> has (at 2)
    --> False

    ["Stuff", "things"]
        |> has (at 0)
    --> True

-}
get : A_Getter_ st rv s t a b -> s -> a
get accessor =
    (id |> accessor |> internal).view


{-| Used with a Prism, think of `!!` boolean coercion in Javascript except type safe.

    Just 1234
        |> has try
    --> True

    Nothing
        |> has try
    --> False

    ["Stuff", "things"]
        |> has (at 2)
    --> False

    ["Stuff", "things"]
        |> has (at 0)
    --> True

-}
has : A_Fold_ vw st rv s t a b -> s -> Bool
has accessor s =
    try accessor s /= Nothing


{-| Used with a Prism, think of `!!` boolean coercion in Javascript except type safe.

    ["Stuff", "things"]
        |> try (at 2)
    --> Nothing

    ["Stuff", "things"]
        |> try (at 0)
    --> Just "Stuff"

-}
try : A_Fold_ vw st rv s t a b -> s -> Maybe a
try accessor =
    (id |> accessor |> internal).list >> List.head


{-| Used with a Prism, think of `!!` boolean coercion in Javascript except type safe.

    Just "Stuff"
        |> all just
    --> ["Stuff"]

    Nothing
        |> all just
    --> []

-}
all : A_Fold_ vw st rv s t a b -> s -> List a
all accessor =
    (id |> accessor |> internal).list


set : A_Setter_ fd vw rv s t a b -> b -> (s -> t)
set accessor =
    map accessor << always


map : A_Setter_ fd vw rv s t a b -> (a -> b) -> s -> t
map accessor =
    (id |> accessor |> internal).over


{-| Use prism to reconstruct.
-}
new : A_Review_ fd vw st s t a b -> b -> t
new accessor =
    (id |> accessor |> internal).make


{-| -}
name : An_Optic_ fd vw st rv s t a b -> String
name accessor =
    (id |> accessor |> internal).name



-- Helper


void : String -> any -> runTimeError
void s _ =
    let
        unoptimizedRecursion : String -> runTimeError
        unoptimizedRecursion str =
            unoptimizedRecursion str
    in
    unoptimizedRecursion s
