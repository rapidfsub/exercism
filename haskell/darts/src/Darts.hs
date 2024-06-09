module Darts (score) where

score :: Float -> Float -> Int
score x y
  | r2 > 100 = 0
  | r2 > 25 = 1
  | r2 > 1 = 5
  | otherwise = 10
  where
    r2 = x * x + y * y
