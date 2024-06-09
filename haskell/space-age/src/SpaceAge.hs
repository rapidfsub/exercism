module SpaceAge (Planet (..), ageOn) where

data Planet
  = Mercury
  | Venus
  | Earth
  | Mars
  | Jupiter
  | Saturn
  | Uranus
  | Neptune

ageOn :: Planet -> Float -> Float
ageOn planet seconds = seconds / (secondsPerEarthYear * periodRatio planet)

periodRatio :: (Fractional a) => Planet -> a
periodRatio Mercury = 0.2408467
periodRatio Venus = 0.61519726
periodRatio Earth = 1.0
periodRatio Mars = 1.8808158
periodRatio Jupiter = 11.862615
periodRatio Saturn = 29.447498
periodRatio Uranus = 84.016846
periodRatio Neptune = 164.79132

secondsPerEarthYear :: Float
secondsPerEarthYear = 365.25 * 24 * 60 * 60
