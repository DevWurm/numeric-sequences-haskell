module Sequences.General (
    Sequence,
    recSequence,
    expSequence,
    sumUntil,
    partialSumSequence,
    limit
) where

type Sequence a = [a]

recSequence :: (Real a) =>  a -> (a -> a) -> Sequence a
recSequence a0 f = a0 : map f (recSequence a0 f)

expSequence :: (Real a) => (Integer -> a) -> Sequence a
expSequence f = map f [1 .. ]

sumUntil :: (Real a) => Int -> Sequence a -> a
sumUntil n = sum . take n

partialSumSequence :: (Real a) => Sequence a -> Sequence a
partialSumSequence seq = let
                              {- Creating an infinite list of functions which sum the first n elements of a list,
                                 with n starting by 1. -}
                              sumFunctions = map sumUntil [1 .. ]
                         in
                              {- Creating the infinite list of results of the sumFunctions functions applied to the
                                 provided sequence. This list is equivalent to the partial sum sequence of the provided
                                 sequence. -}
                              map ($ seq) sumFunctions

limit :: (Real a) => Sequence a -> Double -> Int -> Int -> Maybe Double
limit seq eps nf nmax = let
                            {- Take the last nf elements of seq in the range until nmax-}
                            testList = take nf . drop (nmax - nf) $ seq
                        in
                            if listDiff testList < eps then
                                Just . average $ testList
                            else
                                Nothing
                        where
                            listDiff :: (Real a) => [a] -> Double
                            listDiff ns = realToFrac $ maximum ns - minimum ns

average :: (Real a) => [a] -> Double
average xs = (realToFrac . sum $ xs) / (fromIntegral . length $ xs)
