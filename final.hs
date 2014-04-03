type Arr exp a b = exp a -> exp b

class Expr exp where
  lam :: (exp a -> exp b) -> exp (Arr exp a b)
  app :: exp (Arr exp a b) -> exp a -> exp b
  lit :: a -> exp a

id :: Expr rep => rep (a -> a)
id = (lam (\x -> x))

tr ::  Expr rep => rep (a -> b -> a)
tr = lam (\x -> lam (\y -> x))

fl ::  Expr rep => rep (a -> b -> b)
fl = lam (\x -> lam (\y -> x))

newtype Interpret a = R { interpret :: a }

instance Expr Interpret where
  lam f   = R $ interpret . f . R
  app f a = R $ interpret f $ interpret a
  lit     = R