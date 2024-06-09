module CollatzConjecture (collatz) where

collatz :: Integer -> Maybe Integer
collatz n
  | n > 0 = Just $ go n 0
  | otherwise = Nothing
  where
    go 1 result = result
    go x result = go next (result + 1)
      where
        next = if even x then div x 2 else 3 * x + 1
