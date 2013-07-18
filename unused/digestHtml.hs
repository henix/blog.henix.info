import qualified Data.Text as T
import Text.Regex

import System.Environment
import System.Exit

infixl 9 |>
(|>) = flip (.)

infixl 0 ||>
(||>) = flip ($)

main :: IO ()
main = do {
  args <- getArgs;
  all <- getContents;
  case args of
    [maxCountStr] ->
      let
        maxCount = read maxCountStr :: Int
      in
       all ||> T.pack |> (
         T.replace (T.pack "</p>") (T.pack "\127")
         ) |> (
         T.replace (T.pack "<br />") (T.pack "\127")
         ) |> (
         \s -> subRegex (mkRegex "<[^>]*>") (T.unpack s) ""
         ) |> (
         \s ->
         let
           truncateHtml :: String -> String -> Int -> String
           truncateHtml as cur cnt = case cur of
             [] -> as
             '&' : xs ->
               let
                 (ent, other) = break (== ';') xs
               in
                case other of
                  [] -> truncateHtml (as ++ ['&']) xs (cnt + 1)
                  ';' : other2 -> truncateHtml (as ++ ['&'] ++ ent ++ [';']) other2 (cnt + 1)
             x : xs ->
               if cnt < maxCount
               then truncateHtml (as ++ [x]) xs (cnt + 1)
               else as
         in
          truncateHtml "" s 0
         ) |> T.pack |> (
         T.replace (T.pack "\127") (T.pack "<br />")
         ) |> T.unpack |> putStr
    _ -> do {
      putStrLn "Usage: digest maxCount < html";
      exitWith (ExitFailure 1)
      }
  }
