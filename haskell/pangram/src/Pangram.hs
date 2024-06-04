module Pangram (isPangram) where

import Data.Char as Char (isAlpha, isAscii, toLower)
import Data.Function ((&))
import Data.Set as Set (fromList, size)

isPangram :: String -> Bool
isPangram text =
  text
    & filter Char.isAscii
    & filter Char.isAlpha
    & map Char.toLower
    & Set.fromList
    & Set.size
    & (==) alphabetLen
  where
    alphabetLen = length ['a', 'b' .. 'z']
