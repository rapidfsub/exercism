module ReverseString (reverseString) where

reverseString :: String -> String
reverseString str = go str []
  where
    go (x : xs) result = go xs (x : result)
    go [] result = result
