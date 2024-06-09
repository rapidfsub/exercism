{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}

module Bob (responseFor) where

import Data.Text qualified as T

responseFor :: String -> String
responseFor xs
  | isShouting && isAsking = "Calm down, I know what I'm doing!"
  | isShouting = "Whoa, chill out!"
  | isAsking = "Sure."
  | isSilent = "Fine. Be that way!"
  | otherwise = "Whatever."
  where
    ys = T.strip $ T.pack $ xs
    isShouting = ys == T.toUpper ys && ys /= T.toLower ys
    isAsking = T.isSuffixOf "?" ys
    isSilent = ys == T.empty
