module Pangram (isPangram) where

import Data.Char as Char (toLower)
import Data.Set as Set (fromList, member)

isPangram :: String -> Bool
isPangram text =
  let letters = Set.fromList $ map Char.toLower text
   in all (\x -> Set.member x letters) ['a', 'b' .. 'z']
